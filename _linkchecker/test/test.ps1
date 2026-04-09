#Requires -Version 7.5

$StartUrl = 'https://set-outlooksignatures.com'
$SitemapUrl = 'https://set-outlooksignatures.com/sitemap.xml'
$ParallelJobs = ([int]$env:NUMBER_OF_PROCESSORS) * 1

Clear-Host

if ($psISE) {
    Write-Host 'PowerShell ISE not supported.' -ForegroundColor Red
    exit 1
}

if ($ExecutionContext.SessionState.LanguageMode -ne 'FullLanguage') {
    Write-Host 'FullLanguage mode required.' -ForegroundColor Red
    exit 1
}

$OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Set-Location -Path ($PSScriptRoot ?? (Get-Location).ProviderPath)

function LowerCaseUrl([string]$url, [bool]$includeFragment = $true) {
    if ([uri]::IsWellFormedUriString($url, 'Absolute')) {
        $uri = [uri]$url
        $uri = [uri]([System.Web.HttpUtility]::UrlDecode($uri.AbsoluteUri))
        $uri = [uri]('{0}://{1}{2}{3}' -f $uri.Scheme.ToLower(), $uri.Host.ToLower(), $uri.PathAndQuery, $(if ($includeFragment) { $uri.Fragment } else { '' }))
        return $uri.AbsoluteUri.ToString()
    } else {
        Write-Host 'Not a wellformed uri string: $url'
        return $url
    }
}

$LowerCaseUrlSBString = (Get-Item Function:\LowerCaseUrl).ScriptBlock.ToString()


$tempDir = (New-Item -ItemType Directory -Path (Join-Path -Path $env:temp -ChildPath (New-Guid).Guid)).FullName

Invoke-WebRequest 'https://www.nuget.org/api/v2/package/HtmlAgilityPack' -OutFile (Join-Path $tempDir 'hap.zip') -UseBasicParsing
Expand-Archive -Path (Join-Path $tempDir 'hap.zip') -DestinationPath (Join-Path $tempDir 'hap') -Force
$HtmlAgilityPackDllPath = (Join-Path $tempDir 'hap\lib\netstandard2.0\HtmlAgilityPack.dll')


Invoke-WebRequest -Uri 'https://www.powershellgallery.com/api/v2/package/PSPlaywright' -OutFile (Join-Path $tempDir 'PSPlaywright.zip') -UseBasicParsing
Expand-Archive -Path (Join-Path $tempDir 'PSPlaywright.zip') -DestinationPath (Join-Path $tempDir 'PlaywrightModule') -Force
$PSPlaywrightModulePath = Join-Path (Join-Path $tempDir 'PlaywrightModule') 'PSPlaywright.psm1'
Import-Module $PSPlaywrightModulePath
Install-Playwright

$ParallelJobsStatus = [System.Collections.Concurrent.ConcurrentDictionary[int, bool]]::new()
$Queue = [System.Collections.Concurrent.ConcurrentQueue[string]]::new()
$Visited = [System.Collections.Concurrent.ConcurrentDictionary[string, byte]]::new([System.StringComparer]::Ordinal)
$PageData = [System.Collections.Concurrent.ConcurrentDictionary[string, object]]::new()
$ReferenceMap = [System.Collections.Concurrent.ConcurrentDictionary[string, [System.Collections.Generic.List[object]]]]::new()


$Queue.Enqueue((LowerCaseUrl -url $StartUrl -includeFragment $false))

if ($SitemapUrl) {
    try {
        $response = Invoke-WebRequest -Uri $SitemapUrl -UseBasicParsing -Timeout 10
        [xml]$Sitemap = $response.Content

        $ns = New-Object System.Xml.XmlNamespaceManager($Sitemap.NameTable)
        $ns.AddNamespace('ns', 'http://www.sitemaps.org/schemas/sitemap/0.9')
        $ns.AddNamespace('xhtml', 'http://www.w3.org/1999/xhtml')

        $locLinks = $Sitemap.SelectNodes('//ns:loc', $ns) | Select-Object -ExpandProperty '#text'
        $xhtmlLinks = $Sitemap.SelectNodes('//xhtml:link', $ns) | ForEach-Object { $_.getAttribute('href') }

        (@($locLinks + $xhtmlLinks) | ForEach-Object { LowerCaseUrl -url $_ -includeFragment $false }) | Select-Object -Unique | ForEach-Object {
            $Queue.Enqueue(([uri]$_).AbsoluteUri)
        }
    } catch {
        Write-Host "Failed to download or parse sitemap: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

if ($StartUrl) {
    $StartDomain = ([uri]$StartUrl).Host
} elseif ($SitemapUrl) {
    $StartDomain = ([uri]$SitemapUrl).Host
} else {
    Write-Host 'You must specify at least a SitemapUrl or a StartUrl.' -ForegroundColor Red
    exit 1
}

1..$ParallelJobs | ForEach-Object { $ParallelJobsStatus[$_] = $true }

1..$ParallelJobs | ForEach-Object -Parallel {
    try {
        $WorkerId = $_

        ($using:ParallelJobsStatus)[$WorkerId] = $true

        Write-Host "Worker $($WorkerId): Started."

        Set-Item -Path 'function:LowerCaseUrl' -Value ($using:LowerCaseUrlSBString)

        Add-Type -Path $using:HtmlAgilityPackDllPath

        Import-Module $using:PSPlaywrightModulePath
        Start-Playwright

        $PlaywrightBrowser = Start-PlaywrightBrowser -BrowserType Chromium -Headless
        $PlaywrightBrowserPage = Open-PlaywrightPage -Browser $PlaywrightBrowser

        Set-PlaywrightPageViewportSize -Page $PlaywrightBrowserPage -Width 1920 -Height 1080

        while ($true) {
            try {
                # Try to get work
                $url = $null
                $StatusCode = 0
                $StatusMessage = ''
                $CurrentPageIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)


                if (($using:Queue).TryDequeue([ref]$url)) {
                    ($using:ParallelJobsStatus)[$WorkerId] = $true

                    $urlAlreadyVisisted = -not $(($using:Visited).TryAdd(((LowerCaseUrl -url $url -includeFragment $false)), 0))

                    if ($urlAlreadyVisisted) {
                        continue
                    }

                    Write-Host "Worker $($WorkerId), '$($url)': Start processing."

                    $urlIsInternal = $((([uri]$url).Host -ieq $using:StartDomain) -or (([uri]$url).Host -ilike "*.$($using:StartDomain)"))

                    try {
                        if ((Invoke-WebRequest -Method Head -Uri $url -UseBasicParsing).Headers.'Content-Type' -notlike 'text/html*') {
                            Write-Verbose "Worker $($WorkerId), '$($url)': Is not text/html."

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
                        $StatusCode = 0
                        $StatusMessage = $_.Exception.Message
                    }

                    if ($StatusCode -ne 200) {
                        Write-Host "Worker $($WorkerId): Failed '$url' - $StatusMessage" -ForegroundColor Yellow

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

                    Write-Verbose "Worker $($WorkerId), '$($url)': Wait for DOM stability."
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

                    Write-Verbose "Worker $($WorkerId), '$($url)': Get full HTML (incl. shadow DOM)."
                    #$html = Get-PlaywrightPageContent -Page $PlaywrightBrowserPage
                    $html = Invoke-PlaywrightPageJavascript -Page $PlaywrightBrowserPage -Expression @'
(async () => {
  const serializer = new XMLSerializer();
  const visited = new WeakSet();
  let result = '';

  // Serialize light DOM
  result += serializer.serializeToString(document.documentElement);

  // Queue of nodes to scan for shadow roots
  const queue = Array.from(document.querySelectorAll('*'));

  const YIELD_EVERY = 200; // prevent blocking
  let i = 0;

  while (queue.length) {
    const el = queue.shift();
    if (!el || visited.has(el)) continue;
    visited.add(el);

    if (el.shadowRoot) {
      result += '\n<!-- shadow-root: ' + el.tagName + ' -->\n';
      result += serializer.serializeToString(el.shadowRoot);

      // Add shadow DOM children to queue
      queue.push(...el.shadowRoot.querySelectorAll('*'));
    }

    // Yield back to the event loop
    if (++i % YIELD_EVERY === 0) {
      await new Promise(r => setTimeout(r, 0));
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
                            ) | Where-Object { $_ } | Select-Object -Unique
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
                            ) | Where-Object { $_ } | Select-Object -Unique
                        )
                    } else {
                        $IdsAndNames = @()
                    }

                    $htmldoc = $null


                    if ($urlIsInternal) {
                        foreach ($href in $hrefs) {
                            Write-Verbose "Worker $($WorkerId), '$($url)': Found href '$($href)'."

                            try {
                                if ([uri]::IsWellFormedUriString($href, 'Absolute')) {
                                    $hrefAbsolute = LowerCaseUrl -url $href -includeFragment $true
                                } else {
                                    $hrefAbsolute = LowerCaseUrl -url ([System.Uri]::new($url, $href)).AbsoluteUri -includeFragment $true
                                }
                            } catch {
                                Write-Verbose "Worker $($WorkerId), '$($url)': href '$($href)' not convertible to AbsoluteUri: '$($_)'."

                                $hrefAbsolute = $null
                            }

                            if (
                                $hrefAbsolute -and
                                (([uri]$hrefAbsolute).Scheme -iin @('http', 'https'))
                            ) {
                                Write-Verbose "Worker $($WorkerId), '$($url)': Enqueue '$($href)' as '$(LowerCaseUrl -url $hrefAbsolute -includeFragment $false)'."

                                ($using:Queue).Enqueue((LowerCaseUrl -url $hrefAbsolute -includeFragment $false))
                            } else {
                                Write-Verbose "Worker $($WorkerId), '$($url)': Do not enqueue '$($href)' ('$($hrefAbsolute)')."
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
                        Write-Verbose "Worker $($WorkerId), '$($url)': Found IdOrName '$($IdOrName)'."

                        try {
                            $IdOrNameAbsolute = LowerCaseUrl -url $([System.UriBuilder]::new($url) | ForEach-Object { $_.Fragment = $IdOrName; $_.Uri.ToString() }) -includeFragment $true
                        } catch {
                            Write-Verbose "Worker $($WorkerId), '$($url)': IdOrName '$($IdOrName)' not convertible to AbsoluteUri: '$($_)'."

                            $IdOrNameAbsolute = $null
                        }

                        if (
                            $IdOrNameAbsolute -and
                            (([uri]$IdOrNameAbsolute).Scheme -iin @('http', 'https'))
                        ) {
                            $CurrentPageIds.Add($IdOrNameAbsolute) | Out-Null
                        } else {
                            Write-Verbose "Worker $($WorkerId), '$($url)': Do not enqueue '$($href)' ('$($hrefAbsolute)')."
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

                    Write-Verbose "Worker $($WorkerId), '$($url)': End processing."
                } else {
                    # QUEUE IS EMPTY - WORKER IS IDLE
                    ($using:ParallelJobsStatus)[$WorkerId] = $false

                    # CHECK: Is everyone else idle too?
                    $activeWorkers = ($using:ParallelJobsStatus).Values | Where-Object { $_ -eq $true }

                    if (-not $activeWorkers) {
                        # Total silence. No items in queue and nobody is working.
                        Write-Host "Worker $($WorkerId): System idle. Exiting."

                        break
                    }

                    # Someone is still working; they might add more to the queue.
                    # Wait a bit so we don't hammer the CPU checking the dictionary.
                    Start-Sleep -Milliseconds 500
                }
            } catch {
                Write-Host "Worker $($WorkerId), '$($url)': Unexpected error within the loop: '$($_ | Format-List * | Out-String)'" -ForegroundColor Red
            }
        }
    } catch {
        ($using:ParallelJobsStatus)[$WorkerId] = $false

        Write-Host "Worker $($WorkerId), '$($url)': Unexpected error affecting the whole worker: '$($_ | Format-List * | Out-String)'" -ForegroundColor Red
    } finally {
        ($using:ParallelJobsStatus)[$WorkerId] = $false

        if ($PlaywrightBrowserPage) {
            Close-PlaywrightPage -Page $PlaywrightBrowserPage
        }

        if ($PlaywrightBrowser) {
            Stop-PlaywrightBrowser -Browser $PlaywrightBrowser
        }

        Stop-Playwright
    }
} -ThrottleLimit $ParallelJobs


$Report = foreach ($target in $ReferenceMap.Keys) {
    $uri = [uri]$target

    $baseUrl = LowerCaseUrl -url $target -includeFragment $false

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
                SourcePage   = $occurrence.SourcePage
                OriginalHref = $occurrence.OriginalHref
                TargetFull   = $target
                Issue        = $reason
            }
        }
    }
}

$Report = $Report | Sort-Object -Property TargetFull, OriginalHref, SourcePage, Issue -Unique

foreach ($TargetFull in @($Report.TargetFull | Where-Object { try { [uri]$_.TargetFull -iin @('http', 'https') } catch { $false } } )) {
    Write-Host $TargetFull -ForegroundColor Yellow
    foreach ($entry in @($Report | Where-Object { $_.TargetFull -eq $TargetFull })) {
        Write-Host "  $($entry.SourcePage): '$($entry.OriginalHref)'"
        Write-Host "    $($entry.Issue)"
    }
}