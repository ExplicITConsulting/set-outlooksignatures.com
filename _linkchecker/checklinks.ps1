#Requires -Version 7.5

[CmdletBinding()]

param (
    # On which URL should the search begin?
    # At least one of StartUrl or SitemapUrl must be defined
    [string]$StartUrl = 'https://set-outlooksignatures.com',

    # Add all URLs from a sitemap.xml to the search
    # At least one of StartUrl or SitemapUrl must be defined
    [string]$SitemapUrl = 'https://set-outlooksignatures.com/sitemap.xml',

    # Which browser should be used for the tests?
    [ValidateSet('Chromium', 'Firefox', 'WebKit')]
    [string]$BrowserType = 'Chromium',

    # Should the browsers be visible or headless?
    [bool]$BrowserHeadless = $true,

    # Should href fragments be checked?
    # If true, a link to https://example.com/test.html#fragment is valid only when https://example.com/test.html has an element with its id or name attribute matching the fragment
    #   This slows down the process, as each site needs to be analyzed in detail
    # If false, a link to https://example.com/test.html#fragment is valid when https://example.com/test.html is reachable, not matter of there is an element with a matching id or name attribute
    [bool]$CheckFragments = $true,

    # Should hrefs only be checked for fragments when they point to an internal page?
    # If true and StartUrl = https://set-outlooksignatures.com:
    #   All hrefs pointing to set-outlooksignatures or one of its subdomains are checked for fragments.
    #   All hrefs pointing to other domains are deemed valied when the page is reached, no matter it the fragment exists or not.
    [bool]$CheckFragmentsInternalOnly = $false,

    # How many parallel works should analyze the pages?
    [ValidateRange(1, [int]::MaxValue)]
    [int]$ParallelWorkers = ([int]$env:NUMBER_OF_PROCESSORS * 1)
)


#
# Do not change anything from here on
#


Write-Host 'Start script'
Write-Host '  Initial checks and basic setup'

$StartTime = Get-Date

# Remove unnecessary ETS type data associated with arrays in Windows PowerShell
Remove-TypeData System.Array -ErrorAction SilentlyContinue

if ($psISE) {
    Write-Host '    PowerShell ISE detected. Use PowerShell in console or terminal instead.' -ForegroundColor Red
    Write-Host '    Required features are not available in ISE. Exit.' -ForegroundColor Red
    exit 1
}

if (($ExecutionContext.SessionState.LanguageMode) -ine 'FullLanguage') {
    Write-Host "    This PowerShell session runs in $($ExecutionContext.SessionState.LanguageMode) mode, not FullLanguage mode." -ForegroundColor Red
    Write-Host '    Required features are only available in FullLanguage mode. Exit.' -ForegroundColor Red
    exit 1
}

$OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Set-Location -Path ($PSScriptRoot ?? (Get-Location).ProviderPath)


function StandardizeAbsoluteUrl {
    [CmdletBinding()]

    param(
        [string]$InputString, [bool]$IncludeFragment = $true
    )

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
        if ($WorkerIDString) {
            Write-Verbose "  $($WorkerIdString) $($url) Not an absolute URL: '$($url)'"
        } else {
            Write-Verbose "  Not an absolute URL: '$($url)'"
        }

        return $InputString
    }

    if ($uri.Scheme -iin @('http', 'https')) {
        $uri = [uri]('{0}://{1}{2}{3}' -f $uri.Scheme.ToLower(), $uri.Host.ToLower(), $uri.PathAndQuery, $(if ($IncludeFragment) { $uri.Fragment } else { '' }))
    }

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

if (
    ($CheckFragments -eq $false) -and
    ($CheckFragmentsInternalOnly -eq $true)
) {
    Write-Host '    CheckFragments is false. Setting CheckFragmentsInternalOnly to false, too.' -ForegroundColor Yellow
    $CheckFragmentsInternalOnly = $false
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
$ReferenceMap = [System.Collections.Concurrent.ConcurrentDictionary[string, [System.Collections.Concurrent.ConcurrentBag[object]]]]::new()

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
1..$ParallelWorkers | ForEach-Object {
    $ParallelWorkersStatus[$_] = $true
}

$CurrentVerbose = $VerbosePreference

1..$ParallelWorkers | ForEach-Object -Parallel {
    try {
        $WorkerId = $_
        $WorkerIdString = "W$($($WorkerId).ToString().PadLeft(($using:ParallelWorkers).ToString().Length, '0'))"

        $VerbosePreference = $using:CurrentVerbose

        Write-Host "  $($WorkerIdString) Started"

        Set-Item -Path 'function:StandardizeAbsoluteUrl' -Value ($using:StandardizeAbsoluteUrlSBString)

        Add-Type -Path $using:HtmlAgilityPackDllPath

        Import-Module $using:PSPlaywrightModulePath
        Start-Playwright

        $PlaywrightBrowser = Start-PlaywrightBrowser -BrowserType $using:BrowserType -Headless:($using:BrowserHeadless)

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

                    Write-Host "  $($WorkerIdString) $($url)"

                    $urlIsInternal = $((([uri]$url).Host -ieq $using:StartDomain) -or (([uri]$url).Host -ilike "*.$($using:StartDomain)"))

                    $isThrottled = $false

                    try {
                        $response = Invoke-WebRequest -Method Head -Uri $url -UseBasicParsing -Timeout 10 -ErrorAction Stop
                        $StatusCode = $response.StatusCode
                        $StatusMessage = $response.StatusDescription
                    } catch {
                        # Check if this specific error is a Throttling (429) error
                        if ($_.Exception.Response.StatusCode -eq 429 -or $_.ToString() -ilike '*Too many requests*') {
                            $isThrottled = $true
                        } else {
                            # If not throttled, try the GET fallback
                            try {
                                $response = Invoke-WebRequest -Method Get -Uri $url -UseBasicParsing -Timeout 10 -ErrorAction Stop
                                $StatusCode = $response.StatusCode
                                $StatusMessage = $response.StatusDescription
                            } catch {
                                # Final check: if GET is also throttled, we don't throw; we let the full browser handle it
                                if ($_.Exception.Response.StatusCode -eq 429 -or $_.ToString() -ilike '*Too many requests*') {
                                    $isThrottled = $true
                                } elseif (($_.Exception.Response.StatusCode -ieq 'forbidden') -or [string]::IsNullOrWhitespace($_.Exception.Response.StatusCode)) {
                                    $isThrottled = $true
                                } else {
                                    ## Real error (404, DNS, etc.) - but we dont throw here, so the full browser can try to load the page
                                }
                            }
                        }
                    }

                    # Only check headers if we actually got a response and weren't throttled
                    if (-not $isThrottled -and $null -ne $response) {
                        if (@($response.Headers['Content-Type'] -split ';').Trim() -inotcontains 'text/html') {
                            Write-Verbose "  $($WorkerIdString) $($url) Is not text/html"

                            $null = ($using:PageData).TryAdd(
                                $url,
                                @{
                                    IdsAndNames   = $CurrentPageIds
                                    StatusCode    = $StatusCode
                                    StatusMessage = 'Is not text/html.'
                                }
                            )

                            continue
                        } elseif ($urlIsInternal -eq $false) {
                            # External, not throttled, we got a response, the answer is HTML, fragements are not to check
                            # We already know that the Url works and can stop here
                            if (
                                ($using:CheckFragments -eq $false) -or
                                (
                                    ($using:CheckFragments -eq $true) -and
                                    ($using:CheckFragmentsInternalOnly -eq $true) -and
                                    ($urlIsInternal -eq $false)
                                )
                            ) {
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
                        }
                    }

                    # If throttled or it IS HTML, we try with a full browser
                    if ($PlaywrightBrowserPage) {
                        Close-PlaywrightPage -Page $PlaywrightBrowserPage
                        $PlaywrightBrowserPage = $null
                    }
                    $PlaywrightBrowserPage = Open-PlaywrightPage -Browser $PlaywrightBrowser
                    # Set-PlaywrightPageViewportSize -Page $PlaywrightBrowserPage -Width 1920 -Height 1200

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
                        Write-Host "  $($WorkerIdString) $($url) Error: $(@($StatusMessage -split '\r?\n')[0])" -ForegroundColor Yellow

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

                    Write-Verbose "  $($WorkerIdString) $($url) Wait for DOM stability"
                    #$null = Wait-PlaywrightPageEvent -Page $PlaywrightBrowserPage -EventType 'LoadState' -State ([Microsoft.Playwright.LoadState]::Load)
                    $start = Get-Date
                    $last = 0
                    $stable = 0

                    while (((Get-Date) - $start) -lt [TimeSpan]::FromSeconds(30)) {
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

                    Write-Verbose "  $($WorkerIdString) $($url) Get full HTML (incl. shadow DOM)"
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


                    if ($PlaywrightBrowserPage) {
                        Close-PlaywrightPage -Page $PlaywrightBrowserPage
                        $PlaywrightBrowserPage = $null
                    }


                    $htmldoc = New-Object HtmlAgilityPack.HtmlDocument
                    $htmldoc.LoadHtml($html)


                    $nodes = $htmldoc.DocumentNode.SelectNodes('//*[@href or @src or @data-href or @srcset or @data-src or @data-srcset or @action or @poster or @cite or @content]')

                    if ($null -ne $nodes) {
                        # HashSet ensures uniqueness at the point of insertion
                        $allLinks = New-Object System.Collections.Generic.HashSet[string]

                        foreach ($node in $nodes) {
                            # 1. Process Single-URL Attributes
                            $singleAttrs = @('href', 'src', 'data-href', 'data-src', 'action', 'poster', 'cite', 'content')
                            foreach ($attr in $singleAttrs) {
                                [void]$allLinks.Add($node.GetAttributeValue($attr, ''))
                            }

                            # 2. Process Multi-URL Set Attributes (srcset and data-srcset)
                            $setAttrs = @('srcset', 'data-srcset')
                            foreach ($setAttr in $setAttrs) {
                                $srcsetValue = $node.GetAttributeValue($setAttr, '').Trim()
                                if ($srcsetValue) {
                                    # Split entries by comma, then split by space to isolate the URL from descriptors
                                    $entries = $srcsetValue.Split(',')
                                    foreach ($entry in $entries) {
                                        [void]$allLinks.Add($entry.Trim().Split(' ')[0])
                                    }
                                }
                            }
                        }

                        $hrefs = @(@($allLinks) | Where-Object { $_ }) | Sort-Object -Culture 127 -Unique
                    } else {
                        $hrefs = @()
                    }

                    if (
                        ($using:CheckFragments -eq $false) -or
                        (
                            ($using:CheckFragments -eq $true) -and
                            ($using:CheckFragmentsInternalOnly -eq $true) -and
                            ($urlIsInternal -eq $false)
                        )
                    ) {
                        $nodes = $null
                    } else {
                        $nodes = $htmldoc.DocumentNode.SelectNodes('//*[@id or @name]')
                    }

                    if ($null -ne $nodes) {
                        $IdsAndNames = @(
                            @(
                                $nodes | ForEach-Object { $_.GetAttributeValue('id', '') }
                                $nodes | ForEach-Object { $_.GetAttributeValue('name', '') }
                            ) | Where-Object { $_ } | Sort-Object -Culture 127 -Unique
                        )
                    } else {
                        $IdsAndNames = @()
                    }

                    $htmldoc = $null

                    if ($urlIsInternal) {
                        foreach ($href in $hrefs) {
                            Write-Verbose "  $($WorkerIdString) $($url) Found href '$($href)'"

                            try {
                                $hrefAbsolute = StandardizeAbsoluteUrl -InputString ([System.Uri]::new([uri]$url, $href)).AbsoluteUri -IncludeFragment $true
                            } catch {
                                Write-Verbose "  $($WorkerIdString) $($url) href '$($href)' not convertible to AbsoluteUri: $($_)"

                                $hrefAbsolute = $null
                            }

                            if (
                                $hrefAbsolute -and
                                (([uri]$hrefAbsolute).Scheme -iin @('http', 'https'))
                            ) {
                                Write-Verbose "  $($WorkerIdString) $($url) Enqueue '$($href)' as '$(StandardizeAbsoluteUrl -InputString $hrefAbsolute -IncludeFragment $false)'"

                                ($using:Queue).Enqueue((StandardizeAbsoluteUrl -InputString $hrefAbsolute -IncludeFragment $false))
                            } else {
                                Write-Verbose "  $($WorkerIdString) $($url) Do not enqueue '$($href)' as '$($hrefAbsolute)'"
                            }


                            # Add to the global map: Key is the target, Value is a list of where it's used
                            ($using:ReferenceMap).GetOrAdd(
                                $(if (-not [string]::IsNullOrWhiteSpace($hrefAbsolute)) { $hrefAbsolute } else { $href }),
                                [System.Collections.Concurrent.ConcurrentBag[object]]::new()
                            ).Add(
                                @{
                                    SourcePage   = $url
                                    OriginalHref = $href
                                }
                            )
                        }
                    }

                    if ($IdsAndNames) {
                        foreach ($IdOrName in $IdsAndNames) {
                            Write-Verbose "  $($WorkerIdString) $($url) Found IdOrName '$($IdOrName)'"

                            try {
                                $IdOrNameAbsolute = StandardizeAbsoluteUrl -InputString ([System.Uri]::new([uri]$url, "#$($IdOrName)")).AbsoluteUri -IncludeFragment $true
                            } catch {
                                Write-Verbose "  $($WorkerIdString) $($url) IdOrName '$($IdOrName)' not convertible to AbsoluteUri: $($_)"

                                $IdOrNameAbsolute = $null
                            }

                            if (
                                $IdOrNameAbsolute -and
                                (([uri]$IdOrNameAbsolute).Scheme -iin @('http', 'https'))
                            ) {
                                $CurrentPageIds.Add($IdOrNameAbsolute) | Out-Null
                            } else {
                                Write-Verbose "  $($WorkerIdString) $($url) Do not add '$($IdOrName)' as '$($IdOrNameAbsolute)'"
                            }
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

                    Write-Verbose "  $($WorkerIdString) $($url) Done"
                } else {
                    # QUEUE IS EMPTY - WORKER IS IDLE
                    ($using:ParallelWorkersStatus)[$WorkerId] = $false

                    # CHECK: Is everyone else idle too?
                    $activeWorkers = @(($using:ParallelWorkersStatus).Values | Where-Object { $_ -eq $true })

                    if ($activeWorkers.Count -eq 0) {
                        # Total silence. No items in queue and nobody is working.
                        Write-Host "  $($WorkerIdString) Queue empty, all workers idle, exit"

                        break
                    }

                    # Someone is still working; they might add more to the queue.
                    # Wait a bit so we don't hammer the CPU checking the dictionary.
                    Start-Sleep -Seconds 1
                }
            } catch {
                Write-Host "  $($WorkerIdString) $($url) Unexpected error within the loop: $($_ | Format-List * | Out-String)" -ForegroundColor Red

                ($using:ParallelWorkersStatus)[$WorkerId] = $false
            }
        }
    } catch {
        Write-Host "  $($WorkerIdString) $($url) Unexpected error affecting the whole worker: $($_ | Format-List * | Out-String)" -ForegroundColor Red

        ($using:ParallelWorkersStatus)[$WorkerId] = $false
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
Write-Host 'Statistics'
$timespan = (Get-Date) - $StartTime
Write-Host "  Total execution time                   : $('{0} hours, {1} minutes, {2} seconds' -f $timespan.Hours, $timespan.Minutes, $timespan.Seconds)"
Write-Host "  Hosts visited                          : $(@(@(@($PageData.Keys) | ForEach-Object { $tempX = $_; try { ([uri]$tempX).Host } catch { $tempX } }) | Select-Object -Unique).Count)"
Write-Host "  Pages visited                          : $($PageData.Count)"
Write-Host "  IDs and Names found on pages           : $(@($PageData.Values | ForEach-Object { @($_.IdsAndNames) }).Count)"
Write-Host "  Hrefs found                            : $(@($ReferenceMap.Values.ForEach({ $_.OriginalHref })).Count)"
Write-Host "  Unique absolute href URLs              : $($ReferenceMap.Count)"
Write-Host "  Unique absolute href URLs w/o fragment : $(@(@($ReferenceMap.Keys | ForEach-Object { try { $tempX = $_; StandardizeAbsoluteUrl -InputString $tempX -IncludeFragment $false } catch { $tempX } }) | Select-Object -Unique).Count)"


Write-Host
Write-Host 'Report: Non-working links'
$Report = foreach ($target in $ReferenceMap.Keys) {
    try {
        $uri = [uri]$target
    } catch {
        $uri = $target
    }

    $baseUrl = StandardizeAbsoluteUrl -InputString $target -IncludeFragment $false

    try {
        $baseUrlIsInternal = $((([uri]$baseUrl).Host -ieq $StartDomain) -or (([uri]$baseUrl).Host -ilike "*.$($StartDomain)"))
    } catch {
        $baseUrlIsInternal = $false
    }

    $targetPageExists = $PageData.ContainsKey($baseUrl)
    $pageInfo = if ($targetPageExists) { $PageData[$baseUrl] } else { $null }

    foreach ($occurrence in $ReferenceMap[$target]) {
        $reason = $null

        if (-not $targetPageExists) {
            $reason = 'Page never crawled (External or Out of Scope)'
        } elseif ($pageInfo.StatusCode -ne 200) {
            $reason = "Target page error (Status: $($pageInfo.StatusCode) $($pageInfo.StatusMessage))"
        } elseif (
            $uri.Fragment -and
            $CheckFragments -and
            (
                ($CheckFragmentsInternalOnly -and $baseUrlIsInternal) -or
                (-not $CheckFragmentsInternalOnly)
            ) -and
            (-not $pageInfo.IdsAndNames.Contains($target))
        ) {
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
