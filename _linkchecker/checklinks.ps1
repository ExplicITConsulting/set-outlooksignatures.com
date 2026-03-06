#Requires -Version 7.5

# --- 1. Configuration ---
$SitemapUrl = 'https://set-outlooksignatures.com/sitemap.xml'
$StartUrl = 'https://set-outlooksignatures.com'
$ParallelThreads = $env:NUMBER_OF_PROCESSORS
$userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0'

# --- 2. Setup ---
$SeleniumDir = Join-Path $env:TEMP "Selenium_$(Get-Random)"
New-Item -ItemType Directory -Path $SeleniumDir -Force | Out-Null

$edgeFiles = @('C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe', 'C:\Program Files\Microsoft\Edge\Application\msedge.exe')
$EdgePath = ($edgeFiles | Where-Object { Test-Path $_ } | Select-Object -First 1)
$EdgeVersion = (Get-Item $EdgePath).VersionInfo.ProductVersion
$DriverUrl = "https://msedgedriver.microsoft.com/$EdgeVersion/edgedriver_win64.zip"
Invoke-WebRequest -Uri $DriverUrl -OutFile "$SeleniumDir\driver.zip" -UseBasicParsing
Expand-Archive -Path "$SeleniumDir\driver.zip" -DestinationPath $SeleniumDir -Force

$NugetUrl = 'https://www.nuget.org/api/v2/package/Selenium.WebDriver'
Invoke-WebRequest -Uri $NugetUrl -OutFile "$SeleniumDir\selenium.zip" -UseBasicParsing
Expand-Archive -Path "$SeleniumDir\selenium.zip" -DestinationPath "$SeleniumDir\Package" -Force

$DllPath = Get-ChildItem -Path "$SeleniumDir\Package" -Filter 'WebDriver.dll' -Recurse | Where-Object { $_.FullName -match 'netstandard2.0|net6.0' } | Select-Object -First 1
Add-Type -Path $DllPath.FullName
Add-Type -AssemblyName System.Web

# --- 3. Shared State ---
$LinkSourceMap = [System.Collections.Concurrent.ConcurrentDictionary[string, System.Collections.Generic.HashSet[string]]]::new()
$PagesChecked = [System.Collections.Concurrent.ConcurrentDictionary[string, byte]]::new()
$Queue = [System.Collections.Concurrent.ConcurrentQueue[string]]::new()
$AnchorCache = [System.Collections.Concurrent.ConcurrentDictionary[string, string[]]]::new()
$StartDomain = ([uri]$StartUrl).Host

function Add-LinkMapping {
    param($Link, $SourcePage)
    $set = $LinkSourceMap.GetOrAdd($Link, { New-Object 'System.Collections.Generic.HashSet[string]' })
    $null = $set.Add($SourcePage)
}

# --- 4. Sitemap ---
if ($SitemapUrl) {
    try {
        $response = Invoke-WebRequest -Uri $SitemapUrl -UseBasicParsing
        [xml]$Sitemap = $response.Content
        $ns = New-Object System.Xml.XmlNamespaceManager($Sitemap.NameTable)
        $ns.AddNamespace('ns', 'http://www.sitemaps.org/schemas/sitemap/0.9')
        $locLinks = $Sitemap.SelectNodes('//ns:loc', $ns) | Select-Object -ExpandProperty '#text'
        $locLinks | Select-Object -Unique | ForEach-Object { $Queue.Enqueue($_); Add-LinkMapping -Link $_ -SourcePage 'Sitemap' }
    } catch { }
}
if ($StartUrl -and $Queue.IsEmpty) { $Queue.Enqueue($StartUrl) }

# --- 5. Optimized Crawl ---
Write-Host "Scanning $StartDomain with $ParallelThreads threads..."

$LinkResults = 1..$ParallelThreads | ForEach-Object -Parallel {
    Add-Type -Path ($using:DllPath).FullName

    $options = [OpenQA.Selenium.Edge.EdgeOptions]::new()
    $options.AddArgument('--headless=new')
    $options.AddArgument('--disable-gpu')
    $options.AddArgument('--no-sandbox')
    $options.AddArgument("--user-agent=$userAgent")

    $Service = [OpenQA.Selenium.Edge.EdgeDriverService]::CreateDefaultService($using:SeleniumDir)
    $Service.HideCommandPromptWindow = $true
    $Driver = [OpenQA.Selenium.Edge.EdgeDriver]::new($Service, $options)

    $CurrentUrl = $null
    try {
        while (($using:Queue).TryDequeue([ref]$CurrentUrl)) {
            $uriParts = @($CurrentUrl -split '#(?!/)', 2)
            $baseUrl = $uriParts[0]
            $targetAnchor = if ($uriParts.Count -gt 1) { [System.Web.HttpUtility]::UrlDecode($uriParts[1]) } else { $null }

            # Leak-proof check
            if (-not ($using:PagesChecked).TryAdd($CurrentUrl, 0)) { continue }

            if ($null -eq $targetAnchor) {
                Write-Host "  Page $($CurrentUrl)"
            }else{
                Write-Host "  Anchor $($CurrentUrl)"
            }

            $finalStatus = 'Unknown'
            $isPageValid = $false
            $anchorFound = $null

            try {
                # --- PRE-FLIGHT STATUS CHECK ---
                try {
                    $req = Invoke-WebRequest -Uri $baseUrl -Method Get -ErrorAction Stop -UserAgent $userAgent
                    $finalStatus = [int]$req.StatusCode
                    $isPageValid = ($finalStatus -ge 200 -and $finalStatus -lt 400)
                } catch {
                    if ($_.Exception.Response.StatusCode.value__) {
                        $finalStatus = [int]$_.Exception.Response.StatusCode.value__
                    } else {
                        $finalStatus = $_.Exception.Message
                    }
                    $isPageValid = $false
                }

                # --- SELENIUM PROCESSING (Only if page is valid) ---
                if ($isPageValid) {
                    if (-not ($using:AnchorCache).ContainsKey($baseUrl)) {
                        $Driver.Navigate().GoToUrl($baseUrl)

                        $timeout = [DateTime]::Now.AddSeconds(10)
                        while ($Driver.ExecuteScript('return document.readyState') -ne 'complete') {
                            if ([DateTime]::Now -gt $timeout) { break }
                            Start-Sleep -Milliseconds 100
                        }

                        $jsCode = @'
                        return {
                            anchors: Array.from(document.querySelectorAll('[id], [name]'))
                                          .map(el => el.id || el.name)
                                          .filter(Boolean)
                                          .map(val => String(val).toLowerCase()),
                            links: Array.from(document.querySelectorAll('a[href]'))
                                        .map(a => a.href)
                        };
'@
                        $pageData = $Driver.ExecuteScript($jsCode)
                        ($using:AnchorCache).TryAdd($baseUrl, [string[]]$pageData.anchors)

                        # Only scrape links if we are on the internal domain
                        if ($baseUrl.Contains($using:StartDomain)) {
                            foreach ($href in $pageData.links) {
                                if ([string]::IsNullOrWhiteSpace($href) -or $href -notmatch '^https?://') { continue }

                                # Map everything found (including microsoft.com)
                                $set = ($using:LinkSourceMap).GetOrAdd($href, { New-Object 'System.Collections.Generic.HashSet[string]' })
                                [void]$set.Add($baseUrl)

                                # Enqueue if not checked, regardless of domain
                                if (-not ($using:PagesChecked).ContainsKey($href)) {
                                    ($using:Queue).Enqueue($href)
                                }
                            }
                        }
                    }

                    if ($targetAnchor) {
                        $cachedIds = ($using:AnchorCache)[$baseUrl]
                        $anchorFound = $cachedIds -contains $targetAnchor.ToLower()
                    }
                }
            } catch {
                $isPageValid = $false
                $finalStatus = "Error: $($_.Exception.Message)"
            }

            [PSCustomObject]@{
                FullLink      = $CurrentUrl
                BasePageValid = $isPageValid
                AnchorFound   = $anchorFound
                StatusCode    = $finalStatus
                FoundOnPages  = ($using:LinkSourceMap)[$CurrentUrl]
            }
        }
    } finally { $Driver.Quit(); $Service.Dispose() }
} -ThrottleLimit $ParallelThreads

# Clean the result stream
$LinkResults = $LinkResults | Where-Object { $_ -is [PSCustomObject] }

# --- 6. Results ---
Write-Host
Write-Host "Total unique links checked: $($LinkResults.Count)"

Write-Host
Write-Host 'Broken links'
$Broken = $LinkResults | Where-Object { $_.BasePageValid -eq $false -or $_.AnchorFound -eq $false }

if ($Broken.Count -eq 0) {
    Write-Host '  None'
} else {
    $Broken | Sort-Object FullLink | ForEach-Object {
        Write-Host "  $($_.FullLink)" -ForegroundColor Yellow
        Write-Host "    Status code: $($_.StatusCode)"
        Write-Host "    BasePageValid: $($_.BasePageValid)"
        Write-Host "    AnchorFound: $(if($null -eq $_.AnchorFound){'N/A'}else{$_.AnchorFound})"
        Write-Host "    FoundOnPages: $($_.FoundOnPages.Count)"
        $_.FoundOnPages | Sort-Object | ForEach-Object { Write-Host "      $($_)" }
    }
}
