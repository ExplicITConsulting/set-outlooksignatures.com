$StartUrl = 'https://set-outlooksignatures.com'
$SitemapUrl = 'https://set-outlooksignatures.com/sitemap.xml'

$BrowserType = 'Chromium' # Chromium, Firefox, WebKit
$BrowserHeadless = $true # $true, $false

$ParallelWorkers = ([int]$env:NUMBER_OF_PROCESSORS) * 1


#
# Do not change anything from here on
#


Write-Host 'Start script'
Write-Host '  Initial checks and basic setup'

#Requires -Version 7.5

$StartTime = Get-Date

if ($psISE) {
    Write-Host '   PowerShell ISE not supported.' -ForegroundColor Red
    exit 1
}

if ($ExecutionContext.SessionState.LanguageMode -ne 'FullLanguage') {
    Write-Host '    FullLanguage mode required.' -ForegroundColor Red
    exit 1
}

$OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Set-Location -Path ($PSScriptRoot ?? (Get-Location).ProviderPath)


function StandardizeAbsoluteUrl([string]$InputString, [bool]$IncludeFragment = $true) {
    try {
        $uri = [uri]$InputString

        if (
            ($null -eq $uri) -or
            ([string]::IsNullOrWhiteSpace($uri.AbsoluteUri)) -or
            ($uri.IsAbsoluteUri -eq $false)
        ) {
            throw
        }
    } catch {
        if ($WorkerID) {
            Write-Verbose "  Worker $($WorkerId), '$($url)': Not an absolute URL: '$($url)'"
        } else {
            Write-Verbose "  Not an absolute URL: '$($url)'"
        }

        return $InputString
    }

    $uri = [uri]('{0}://{1}{2}{3}' -f $uri.Scheme.ToLower(), $uri.Host.ToLower(), $uri.PathAndQuery, $(if ($IncludeFragment) { $uri.Fragment } else { '' }))

    return $uri.AbsoluteUri.ToString()
}

$StandardizeAbsoluteUrlSBString = (Get-Item Function:\StandardizeAbsoluteUrl).ScriptBlock.ToString()

$tempDir = (New-Item -ItemType Directory -Path (Join-Path -Path $env:temp -ChildPath (New-Guid).Guid)).FullName

if ($StartUrl) {
    $StartDomain = ([uri]$StartUrl).Host
} elseif ($SitemapUrl) {
    $StartDomain = ([uri]$SitemapUrl).Host
} else {
    Write-Host '    You must specify at least a SitemapUrl or a StartUrl.' -ForegroundColor Red
    exit 1
}

Write-Host '  Install dependencies'
Write-Host '    HTML Agility Pack'
Invoke-WebRequest 'https://www.nuget.org/api/v2/package/HtmlAgilityPack' -OutFile (Join-Path $tempDir 'hap.zip') -UseBasicParsing
Expand-Archive -Path (Join-Path $tempDir 'hap.zip') -DestinationPath (Join-Path $tempDir 'hap') -Force
$HtmlAgilityPackDllPath = (Join-Path $tempDir 'hap\lib\netstandard2.0\HtmlAgilityPack.dll')

Write-Host '    PSPlaywright'
Invoke-WebRequest -Uri 'https://www.powershellgallery.com/api/v2/package/PSPlaywright' -OutFile (Join-Path $tempDir 'PSPlaywright.zip') -UseBasicParsing
Expand-Archive -Path (Join-Path $tempDir 'PSPlaywright.zip') -DestinationPath (Join-Path $tempDir 'PlaywrightModule') -Force
$PSPlaywrightModulePath = Join-Path (Join-Path $tempDir 'PlaywrightModule') 'PSPlaywright.psm1'
Import-Module $PSPlaywrightModulePath
Write-Host '    Playwright'
Install-Playwright


Write-Host
Write-Host 'Prepare worker threads'
Write-Host '  Thread-safe variables'
$ParallelWorkersStatus = [System.Collections.Concurrent.ConcurrentDictionary[int, bool]]::new()
$Queue = [System.Collections.Concurrent.ConcurrentQueue[string]]::new()
$Visited = [System.Collections.Concurrent.ConcurrentDictionary[string, byte]]::new([System.StringComparer]::Ordinal)
$PageData = [System.Collections.Concurrent.ConcurrentDictionary[string, object]]::new()
$ReferenceMap = [System.Collections.Concurrent.ConcurrentDictionary[string, [System.Collections.Generic.List[object]]]]::new()

if ($StartUrl) {
    Write-Host '  Add standardized StartUrl to initial queue'
    $StartUrlStandardized = $(StandardizeAbsoluteUrl -InputString $StartUrl -IncludeFragment $false)
    $Queue.Enqueue($StartUrlStandardized)
} else {
    $StartUrlStandardized = $null
}

if ($SitemapUrl) {
    Write-Host '  Analyze SitemapUrl and add standardized URL entries to initial queue'

    try {
        $response = Invoke-WebRequest -Uri $SitemapUrl -UseBasicParsing -Timeout 10
        [xml]$Sitemap = $response.Content

        $ns = New-Object System.Xml.XmlNamespaceManager($Sitemap.NameTable)
        $ns.AddNamespace('ns', 'http://www.sitemaps.org/schemas/sitemap/0.9')
        $ns.AddNamespace('xhtml', 'http://www.w3.org/1999/xhtml')

        $locLinks = $Sitemap.SelectNodes('//ns:loc', $ns) | Select-Object -ExpandProperty '#text'
        $xhtmlLinks = $Sitemap.SelectNodes('//xhtml:link', $ns) | ForEach-Object { $_.getAttribute('href') }

        (@($locLinks + $xhtmlLinks) | ForEach-Object { StandardizeAbsoluteUrl -InputString $_ -IncludeFragment $false }) | Sort-Object -Culture 127 -Unique | ForEach-Object {
            if (
                ($StartUrlStandardized -and ($StartUrlStandardized -ne $_)) -or
                (-not $StartUrlStandardized)
            ) {
                $Queue.Enqueue(([uri]$_).AbsoluteUri)
            }
        }
    } catch {
        Write-Host "    Failed to download or parse sitemap: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Host "  Queue count: $($Queue.Count)"


Write-Host
Write-Host 'Start parallel workers'
1..$ParallelWorkers | ForEach-Object { $ParallelWorkersStatus[$_] = $true }

1..$ParallelWorkers | ForEach-Object -Parallel {
    try {
        $WorkerId = $_

        ($using:ParallelWorkersStatus)[$WorkerId] = $true

        Write-Host "  Worker $($WorkerId): Started."

        Set-Item -Path 'function:StandardizeAbsoluteUrl' -Value ($using:StandardizeAbsoluteUrlSBString)

        Add-Type -Path $using:HtmlAgilityPackDllPath

        Import-Module $using:PSPlaywrightModulePath
        Start-Playwright

        $PlaywrightBrowser = Start-PlaywrightBrowser -BrowserType $using:BrowserType -Headless:($using:BrowserHeadless)
        $PlaywrightBrowserPage = Open-PlaywrightPage -Browser $PlaywrightBrowser

        Set-PlaywrightPageViewportSize -Page $PlaywrightBrowserPage -Width 1920 -Height 1200

        while ($true) {
            try {
                # Try to get work
                $url = $null
                $StatusCode = 0
                $StatusMessage = ''
                $CurrentPageIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)


                if (($using:Queue).TryDequeue([ref]$url)) {
                    ($using:ParallelWorkersStatus)[$WorkerId] = $true

                    $urlAlreadyVisisted = -not $(($using:Visited).TryAdd(((StandardizeAbsoluteUrl -InputString $url -IncludeFragment $false)), 0))

                    if ($urlAlreadyVisisted) {
                        continue
                    }

                    Write-Host "  Worker $($WorkerId), '$($url)'"

                    $urlIsInternal = $((([uri]$url).Host -ieq $using:StartDomain) -or (([uri]$url).Host -ilike "*.$($using:StartDomain)"))

                    try {
                        if ((Invoke-WebRequest -Method Head -Uri $url -UseBasicParsing).Headers.'Content-Type' -notlike 'text/html*') {
                            Write-Verbose "  Worker $($WorkerId), '$($url)': Is not text/html."

                            $null = ($using:PageData).TryAdd(
                                $url,
                                @{
                                    IdsAndNames   = $CurrentPageIds
                                    StatusCode    = 200
                                    StatusMessage = 'Is not text/html.'
                                }
                            )

                            continue
                        }
                    } catch {}

                    try {
                        Open-PlaywrightPageUrl -Page $PlaywrightBrowserPage -Url $url
                        $StatusCode = 200
                    } catch {
                        Start-Sleep -Seconds 5

                        try {
                            Open-PlaywrightPageUrl -Page $PlaywrightBrowserPage -Url $url
                            $StatusCode = 200
                        } catch {
                            $StatusCode = 0
                            $StatusMessage = $_.Exception.Message
                        }
                    }

                    if ($StatusCode -ne 200) {
                        Write-Host "  Worker $($WorkerId), '$($url)': Error: $(@($StatusMessage -split '\r?\n')[0])" -ForegroundColor Yellow

                        $null = ($using:PageData).TryAdd(
                            $url,
                            @{
                                IdsAndNames   = $CurrentPageIds
                                StatusCode    = $StatusCode
                                StatusMessage = $StatusMessage
                            }
                        )

                        continue
                    }

                    Write-Verbose "  Worker $($WorkerId), '$($url)': Wait for DOM stability."
                    #$null = Wait-PlaywrightPageEvent -Page $PlaywrightBrowserPage -EventType 'LoadState' -State ([Microsoft.Playwright.LoadState]::Load)
                    $start = Get-Date
                    $last = 0
                    $stable = 0

                    while ((Get-Date) - $start -lt [TimeSpan]::FromSeconds(30)) {
                        $count = Invoke-PlaywrightPageJavascript -Page $PlaywrightBrowserPage -Expression @'
(() => {
    let c = 0;
    (function walk(root){
        c += root.querySelectorAll("*").length;
        root.querySelectorAll("*").forEach(e => e.shadowRoot && walk(e.shadowRoot));
    })(document);
    return c;
})();
'@
                        if (($count -eq $last) -and ($count -gt 0)) {
                            $stable++
                        } else {
                            $stable = 0
                        }

                        if ($stable -ge 2) {
                            break
                        }

                        $last = $count
                        Start-Sleep -Milliseconds 500
                    }

                    Write-Verbose "  Worker $($WorkerId), '$($url)': Get full HTML (incl. shadow DOM)."
                    #$html = Get-PlaywrightPageContent -Page $PlaywrightBrowserPage
                    $html = Invoke-PlaywrightPageJavascript -Page $PlaywrightBrowserPage -Expression @'
(() => {
  const serializer = new XMLSerializer();
  const visited = new WeakSet();
  let result = '';

  // Serialize light DOM
  result += serializer.serializeToString(document.documentElement);

  // Queue of nodes to scan for shadow roots
  const queue = Array.from(document.querySelectorAll('*'));

  while (queue.length) {
    const el = queue.shift();

    if (!el || visited.has(el)) continue;
    visited.add(el);

    if (el.shadowRoot) {
      result += '\n\n';
      result += serializer.serializeToString(el.shadowRoot);

      // Add shadow DOM children to queue
      queue.push(...el.shadowRoot.querySelectorAll('*'));
    }
  }

  return result;
})();
'@

                    # We no longer need the site, so we navigate to about:blank to free resources and be prepared for the next run
                    # Close-PlaywrightPage is not an option, as it would close the browser (we only use one tab)
                    Open-PlaywrightPageUrl -Page $PlaywrightBrowserPage -Url 'about:blank'

                    $htmldoc = New-Object HtmlAgilityPack.HtmlDocument
                    $htmldoc.LoadHtml($html)

                    $hrefs = $htmldoc.DocumentNode.SelectNodes('//a[@href]')
                    if ($null -ne $hrefs) {
                        $hrefs = @(
                            @(
                                $hrefs | ForEach-Object {
                                    $_.GetAttributeValue('href', '')
                                }
                            ) | Where-Object { $_ } | Sort-Object -Culture 127 -Unique
                        )
                    } else {
                        $hrefs = @()
                    }

                    $IdsAndNames = $htmldoc.DocumentNode.SelectNodes('//*[@id or @name]')

                    if ($null -ne $IdsAndNames) {
                        $IdsAndNames = @(
                            @(
                                $IdsAndNames | ForEach-Object {
                                    @($_.GetAttributeValue('id', ''), $_.GetAttributeValue('name', ''))
                                }
                            ) | Where-Object { $_ } | Sort-Object -Culture 127 -Unique
                        )
                    } else {
                        $IdsAndNames = @()
                    }

                    $htmldoc = $null


                    if ($urlIsInternal) {
                        foreach ($href in $hrefs) {
                            Write-Verbose "  Worker $($WorkerId), '$($url)': Found href '$($href)'."

                            try {
                                if ([uri]::IsWellFormedUriString($href, 'Absolute')) {
                                    $hrefAbsolute = StandardizeAbsoluteUrl -InputString $href -IncludeFragment $true
                                } else {
                                    $hrefAbsolute = StandardizeAbsoluteUrl -InputString ([System.Uri]::new($url, $href)).AbsoluteUri -IncludeFragment $true
                                }
                            } catch {
                                Write-Verbose "  Worker $($WorkerId), '$($url)': href '$($href)' not convertible to AbsoluteUri: '$($_)'."

                                $hrefAbsolute = $null
                            }

                            if (
                                $hrefAbsolute -and
                                (([uri]$hrefAbsolute).Scheme -iin @('http', 'https'))
                            ) {
                                Write-Verbose "  Worker $($WorkerId), '$($url)': Enqueue '$($href)' as '$(StandardizeAbsoluteUrl -InputString $hrefAbsolute -IncludeFragment $false)'."

                                ($using:Queue).Enqueue((StandardizeAbsoluteUrl -InputString $hrefAbsolute -IncludeFragment $false))
                            } else {
                                Write-Verbose "  Worker $($WorkerId), '$($url)': Do not enqueue '$($href)' ('$($hrefAbsolute)')."
                            }


                            # Add to the global map: Key is the target, Value is a list of where it's used
                            ($using:ReferenceMap).GetOrAdd(
                                $hrefAbsolute,
                                [System.Collections.Generic.List[object]]::new()
                            ).Add(
                                @{
                                    SourcePage   = $url          # Where the link was found
                                    OriginalHref = $href         # The raw string for easy fixing
                                }
                            )
                        }
                    }


                    foreach ($IdOrName in $IdsAndNames) {
                        Write-Verbose "  Worker $($WorkerId), '$($url)': Found IdOrName '$($IdOrName)'."

                        try {
                            $IdOrNameAbsolute = StandardizeAbsoluteUrl -InputString $([System.UriBuilder]::new($url) | ForEach-Object { $_.Fragment = $IdOrName; $_.Uri.ToString() }) -IncludeFragment $true
                        } catch {
                            Write-Verbose "  Worker $($WorkerId), '$($url)': IdOrName '$($IdOrName)' not convertible to AbsoluteUri: '$($_)'."

                            $IdOrNameAbsolute = $null
                        }

                        if (
                            $IdOrNameAbsolute -and
                            (([uri]$IdOrNameAbsolute).Scheme -iin @('http', 'https'))
                        ) {
                            $CurrentPageIds.Add($IdOrNameAbsolute) | Out-Null
                        } else {
                            Write-Verbose "  Worker $($WorkerId), '$($url)': Do not enqueue '$($href)' ('$($hrefAbsolute)')."
                        }
                    }


                    $null = ($using:PageData).TryAdd(
                        $url,
                        @{
                            IdsAndNames   = $CurrentPageIds
                            StatusCode    = $StatusCode
                            StatusMessage = $StatusMessage
                        }
                    )

                    Write-Verbose "  Worker $($WorkerId), '$($url)': End processing."
                } else {
                    # QUEUE IS EMPTY - WORKER IS IDLE
                    ($using:ParallelWorkersStatus)[$WorkerId] = $false

                    # CHECK: Is everyone else idle too?
                    $activeWorkers = @(($using:ParallelWorkersStatus).Values | Where-Object { $_ -eq $true })

                    if ($activeWorkers.Count -eq 0) {
                        # Total silence. No items in queue and nobody is working.
                        Write-Host "  Worker $($WorkerId): System idle. Exiting."

                        break
                    }

                    # Someone is still working; they might add more to the queue.
                    # Wait a bit so we don't hammer the CPU checking the dictionary.
                    Start-Sleep -Milliseconds 500
                }
            } catch {
                ($using:ParallelWorkersStatus)[$WorkerId] = $false

                Write-Host "  Worker $($WorkerId), '$($url)': Unexpected error within the loop: '$($_ | Format-List * | Out-String)'" -ForegroundColor Red
            }
        }
    } catch {
        ($using:ParallelWorkersStatus)[$WorkerId] = $false

        Write-Host "  Worker $($WorkerId), '$($url)': Unexpected error affecting the whole worker: '$($_ | Format-List * | Out-String)'" -ForegroundColor Red
    } finally {
        ($using:ParallelWorkersStatus)[$WorkerId] = $false

        if ($PlaywrightBrowserPage) {
            Close-PlaywrightPage -Page $PlaywrightBrowserPage
        }

        if ($PlaywrightBrowser) {
            Stop-PlaywrightBrowser -Browser $PlaywrightBrowser
        }

        Stop-Playwright
    }
} -ThrottleLimit $ParallelWorkers


Write-Host
Write-Host 'Elapsed time'
$timespan = (Get-Date) - $StartTime
Write-Host "  $('{0} hours, {1} minutes, {2} seconds' -f $timespan.Hours, $timespan.Minutes, $timespan.Seconds)"


Write-Host
Write-Host 'Report: Non-working links'
$Report = foreach ($target in $ReferenceMap.Keys) {
    $uri = [uri]$target

    $baseUrl = StandardizeAbsoluteUrl -InputString $target -IncludeFragment $false

    $targetPageExists = $PageData.ContainsKey($baseUrl)
    $pageInfo = if ($targetPageExists) { $PageData[$baseUrl] } else { $null }

    foreach ($occurrence in $ReferenceMap[$target]) {
        $reason = $null

        if (-not $targetPageExists) {
            $reason = 'Page never crawled (External or Out of Scope)'
        } elseif ($pageInfo.StatusCode -ne 200) {
            $reason = "Target page error (Status: $($pageInfo.StatusCode) $($pageInfo.StatusMessage))"
        } elseif ($uri.Fragment -and -not $pageInfo.IdsAndNames.Contains($target)) {
            $reason = "Missing Fragment: $($uri.Fragment)"
        }

        if ($reason) {
            [PSCustomObject]@{
                TargetFull   = $target
                Issue        = $reason
                SourcePage   = $occurrence.SourcePage
                OriginalHref = $occurrence.OriginalHref
            }
        }
    }
}

$Report = $Report | Sort-Object -Property TargetFull, OriginalHref, SourcePage, Issue -Culture 127 -Unique

# As gridview
@(
    foreach ($TargetFull in @(@($Report | Where-Object { try { ([uri]($_.TargetFull)).Scheme -iin @('http', 'https') } catch { $false } } ).TargetFull | Sort-Object -Culture 127 -Unique)) {
        [PSCustomObject]@{
            TargetFull    = $TargetFull
            Issue         = (@(foreach ($entry in @(@($Report | Where-Object { $_.TargetFull -eq $TargetFull }) | Select-Object -First 1)) { $entry.Issue }) -join '')
            SourcePages   = (@(foreach ($entry in @($Report | Where-Object { $_.TargetFull -eq $TargetFull })) { $entry.SourcePage }) -join [System.Environment]::NewLine)
            OriginalHrefs = (@(foreach ($entry in @($Report | Where-Object { $_.TargetFull -eq $TargetFull })) { $entry.OriginalHref }) -join [System.Environment]::NewLine)
        }
    }
) | Out-GridView

# As Text
foreach ($TargetFull in @(@($Report | Where-Object { try { ([uri]($_.TargetFull)).Scheme -iin @('http', 'https') } catch { $false } } ).TargetFull | Sort-Object -Culture 127 -Unique)) {
    Write-Host "  $($TargetFull)" -ForegroundColor Yellow
    foreach ($entry in @(@($Report | Where-Object { $_.TargetFull -eq $TargetFull }) | Select-Object -First 1)) {
        $entry.Issue -split '\r?\n' | ForEach-Object {
            Write-Host "    $($_)"
        }
    }

    Write-Host

    foreach ($entry in @($Report | Where-Object { $_.TargetFull -eq $TargetFull })) {
        Write-Host "    $($entry.SourcePage): Original href '$($entry.OriginalHref)'"
    }
}


Write-Host
Write-Host 'End script'