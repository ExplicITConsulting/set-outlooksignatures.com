#Requires -Version 7.5

$StartUrl = 'https://set-outlooksignatures.com'
$SitemapUrl = 'https://set-outlooksignatures.com/sitemap.xml'
$ParallelJobs = 2 # $env:NUMBER_OF_PROCESSORS

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


$tempDir = (New-Item -ItemType Directory -Path (Join-Path -Path $env:temp -ChildPath (New-Guid).Guid)).FullName

Invoke-WebRequest 'https://www.nuget.org/api/v2/package/HtmlAgilityPack' -OutFile (Join-Path $tempDir 'hap.zip') -UseBasicParsing
Expand-Archive -Path (Join-Path $tempDir 'hap.zip') -DestinationPath (Join-Path $tempDir 'hap') -Force
$HtmlAgilityPackDllPath = (Join-Path $tempDir 'hap\lib\netstandard2.0\HtmlAgilityPack.dll')


Invoke-WebRequest -Uri 'https://www.powershellgallery.com/api/v2/package/PSPlaywright' -OutFile (Join-Path $tempDir 'PSPlaywright.zip') -UseBasicParsing
Expand-Archive -Path (Join-Path $tempDir 'PSPlaywright.zip') -DestinationPath (Join-Path $tempDir 'PlaywrightModule') -Force
$PSPlaywrightModulePath = Join-Path (Join-Path $tempDir 'PlaywrightModule') 'PSPlaywright.psm1'
Import-Module $PSPlaywrightModulePath
Install-Playwright


$Queue = [System.Collections.Concurrent.ConcurrentQueue[string]]::new()
$Visited = [System.Collections.Concurrent.ConcurrentDictionary[string, byte]]::new()
$PageHtmlCache = [System.Collections.Concurrent.ConcurrentDictionary[string, string]]::new()
$Broken = [System.Collections.Concurrent.ConcurrentDictionary[string, string]]::new()



$StartUrl = [uri]([uri]([string]$StartUrl)).GetLeftPart([System.UriPartial]::Query)
$StartUrl = [uri]([System.Web.HttpUtility]::UrlDecode($StartUrl.AbsoluteUri))
$StartUrl = [uri]('{0}://{1}{2}{3}{4}' -f $StartUrl.Scheme.ToLower(), $StartUrl.Host.ToLower(), $StartUrl.PathAndQuery, $StartUrl.Fragment, '')
$Queue.Enqueue($StartUrl.AbsoluteUri)

if ($SitemapUrl) {
    try {
        $response = Invoke-WebRequest -Uri $SitemapUrl -UseBasicParsing -Timeout 10
        [xml]$Sitemap = $response.Content

        $ns = New-Object System.Xml.XmlNamespaceManager($Sitemap.NameTable)
        $ns.AddNamespace('ns', 'http://www.sitemaps.org/schemas/sitemap/0.9')
        $ns.AddNamespace('xhtml', 'http://www.w3.org/1999/xhtml')

        $locLinks = $Sitemap.SelectNodes('//ns:loc', $ns) | Select-Object -ExpandProperty '#text'
        $xhtmlLinks = $Sitemap.SelectNodes('//xhtml:link', $ns) | ForEach-Object { $_.getAttribute('href') }

        ($locLinks + $xhtmlLinks) | Select-Object -Unique | ForEach-Object {
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


1..$ParallelJobs | ForEach-Object -Parallel {
    $WorkerId = $_
    $url = $null

    Add-Type -Path $using:HtmlAgilityPackDllPath

    Import-Module $using:PSPlaywrightModulePath
    Start-Playwright
    Start-PlaywrightBrowser -BrowserType Chromium -Headless -Enter | Out-Null

    function GetAndCacheHtml ($GetAndCacheHtmlUrl) {
        try {
            Write-Host "Worker $($WorkerId): GetAndCacheHtml '$($GetAndCacheHtmlUrl)' @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"

            $GetAndCacheHtmlUrl = [uri]"$($GetAndCacheHtmlUrl)"
            $GetAndCacheHtmlUrl = [uri]([System.Web.HttpUtility]::UrlDecode($GetAndCacheHtmlUrl.AbsoluteUri))
            $GetAndCacheHtmlUrl = [uri]('{0}://{1}{2}' -f $GetAndCacheHtmlUrl.Scheme.ToLower(), $GetAndCacheHtmlUrl.Host.ToLower(), $GetAndCacheHtmlUrl.PathAndQuery)

            $PageKey = $GetAndCacheHtmlUrl.GetLeftPart([System.UriPartial]::Query)
            $PageKeyIsInternal = ($GetAndCacheHtmlUrl.Host -ilike "*.$([regex]::escape($using:StartDomain))") -or ($GetAndCacheHtmlUrl.Host -ieq $using:StartDomain)
            $GetAndCacheHtmlUrl = $GetAndCacheHtmlUrl.AbsoluteUri

            if (-not ($using:Visited).TryAdd($PageKey, 0)) {
                return ($using:Visited)[$PageKey]
            }

            Write-Verbose "Worker $($WorkerId): Loading '$($PageKey)' @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"

            $Page = Open-PlaywrightPage -Url $PageKey

            Write-Verbose "Worker $($WorkerId): Wait for DOM stability @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
            $start = Get-Date
            $last = 0
            $stable = 0

            while ((Get-Date) - $start -lt [TimeSpan]::FromSeconds(30)) {
                $count = Invoke-PlaywrightPageJavascript -Page $Page -Expression @'
(() => {
    let c = 0;
    (function walk(root){
        c += root.querySelectorAll("*").length;
        root.querySelectorAll("*").forEach(e => e.shadowRoot && walk(e.shadowRoot));
    })(document);
    return c;
})();
'@
                if ($count -eq $last -and $count -gt 0) { $stable++ } else { $stable = 0 }
                if ($stable -ge 2) { break }
                $last = $count
                Start-Sleep -Milliseconds 500
            }

            Write-Verbose "Worker $($WorkerId): Cache full HTML (incl. shadow DOM) @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
            if (-not ($using:PageHtmlCache).ContainsKey($PageKey)) {
                $html = Invoke-PlaywrightPageJavascript -Page $Page -Expression @'
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

                ($using:PageHtmlCache).TryAdd($PageKey, $html) | Out-Null

                return $html
            }
        } catch {
            ($using:Broken).TryAdd($PageKey, $_.Exception.Message) | Out-Null

            Write-Host "Worker $($WorkerId): GetAndCacheHtml error '$($_ | Format-List * | Out-String)'. @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@" -ForegroundColor Red

            return ''
        }

    }

    try {
        while (($using:Queue).Count -gt 0) {
            try {
                if (-not ($using:Queue).TryDequeue([ref]$url)) {
                    Start-Sleep -Milliseconds 100
                    continue
                }

                if ([string]::IsNullOrWhiteSpace($url)) { continue }

                $url = [uri]([uri]($url)).GetLeftPart([System.UriPartial]::Query)
                $url = [uri]([System.Web.HttpUtility]::UrlDecode($url.AbsoluteUri))
                $url = [uri]('{0}://{1}{2}' -f $url.Scheme.ToLower(), $url.Host.ToLower(), $url.PathAndQuery)

                $PageKey = $url.GetLeftPart([System.UriPartial]::Query)
                $PageKeyIsInternal = ($url.Host -ilike "*.$($using:StartDomain)") -or ($url.Host -ieq $using:StartDomain)
                $url = $url.AbsoluteUri

                if (($using:Broken).ContainsKey($PageKey)) {
                    Write-Verbose "Worker $($WorkerId): PageKey '$($PageKey)' marked as broken, do not analyze further (checkpoint A). @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"

                    continue
                }

                $html = GetAndCacheHtml $url

                if (($using:Broken).ContainsKey($PageKey)) {
                    Write-Verbose "Worker $($WorkerId): PageKey '$($PageKey)' marked as broken, do not analyze further (checkpoint B). @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"

                    continue
                }

                Write-Verbose "Worker $($WorkerId): Extract hrefs @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
                $doc = New-Object HtmlAgilityPack.HtmlDocument
                $doc.LoadHtml($html)
                $hrefs = $doc.DocumentNode.SelectNodes('//a[@href]') | ForEach-Object { $_.GetAttributeValue('href', '') }

                foreach ($Href in $Hrefs) {
                    Write-Verbose "Worker $($WorkerId): Href '$($href)' @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"

                    if ([string]::IsNullOrWhiteSpace($Href)) { continue }

                    try {
                        $ResolvedUri = if ([uri]::IsWellFormedUriString($Href, 'Absolute')) {
                            [uri]$Href
                        } else {
                            [uri]::new($PageKey, $Href)
                        }
                    } catch {
                        Write-Verbose "Worker $($WorkerId): href to [uri] error '$($_ | Format-List * | Out-String)'. @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@" -ForegroundColor Red

                        ($using:Broken).TryAdd($Href, "Invalid URL on '$PageKey'") | Out-Null
                        continue
                    }

                    $ResolvedUri = [uri]([uri]($ResolvedUri.AbsoluteUri)).GetLeftPart([System.UriPartial]::Query)
                    $ResolvedUri = [uri]([System.Web.HttpUtility]::UrlDecode($ResolvedUri.AbsoluteUri))
                    $ResolvedUri = [uri]('{0}://{1}{2}{3}{4}' -f $ResolvedUri.Scheme.ToLower(), $ResolvedUri.Host.ToLower(), $ResolvedUri.PathAndQuery, $ResolvedUri.Fragment, '')

                    $Fragment = $ResolvedUri.Fragment.ToString() -replace '^#', ''
                    $ResolvedUrl = $ResolvedUri.AbsoluteUri
                    $HasFragment = -not [string]::IsNullOrEmpty($Fragment)
                    $IsInternal = ($ResolvedUri.Host -ilike "*.$($using:StartDomain)") -or ($ResolvedUri.Host -ieq $using:StartDomain)

                    Write-Verbose "Worker $($WorkerId): Href '$($href)' -> '$($ResolvedUrl)', HasFragment $($HasFragment), IsInternal $($IsInternal) @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"

                    if (-not ($using:Visited).ContainsKey($ResolvedUrl)) {
                        $TargetPageHtml = GetAndCacheHtml $ResolvedUrl
                    } else {
                        $TargetPageHtml = ($using:Visited)[$ResolvedUrl]
                    }

                    if (($using:Broken).ContainsKey($ResolvedUrl)) {
                        Write-Verbose "Worker $($WorkerId): href TargetPage '$($TargetPage)' marked as broken, do not analyze further (checkpoint C). @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"

                        ($using:Broken).TryAdd(
                            $ResolvedUrl,
                            "TargetPage '$($ResolvedUrl)' is broken, so is href '$($href)' used on '$($PageKey)'."
                        ) | Out-Null

                        continue
                    }

                    # Anchor validation (cache only)
                    if ($HasFragment) {
                        $Pattern = '(id|name)\s*=\s*["'']' + [Regex]::Escape($Fragment) + '["'']'

                        if ($TargetPageHtml -notmatch $Pattern) {
                            ($using:Broken).TryAdd(
                                $ResolvedUrl,
                                "Broken anchor '#$($Fragment)' used on '$($PageKey)'"
                            ) | Out-Null
                        }

                        continue
                    }
                }
            } catch {
                Write-Host "Worker $($WorkerId): Error '$($_ | Format-List * | Out-String)'. @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@" -ForegroundColor Red

                ($using:Broken).TryAdd($PageKey, $_.Exception.Message) | Out-Null
            }

            Write-Host "Worker $($WorkerId): Back to the start of the while loop @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
        }
    } catch {
        Write-Host "Worker $($WorkerId): Error '$($_ | Format-List * | Out-String)'. @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@" -ForegroundColor Red
    } finally {
        Exit-PlaywrightBrowser
        Stop-Playwright
        Write-Host "Worker $($WorkerId): Exiting. @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
    }

} -ThrottleLimit $ParallelJobs


# RESULTS
Write-Host "`n============================================================"
Write-Host 'SCAN RESULTS'
Write-Host '============================================================'

if ($Broken.Count -eq 0) {
    Write-Host 'No broken links found.'
} else {
    foreach ($Item in $Broken.GetEnumerator() | Sort-Object Key) {
        Write-Host "[X] $($Item.Key)"
        Write-Host "    $($Item.Value)"
    }
}