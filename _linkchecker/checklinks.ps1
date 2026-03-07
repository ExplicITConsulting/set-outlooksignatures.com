#Requires -Version 7.5

# --- Configuration ---
$SitemapUrl = 'https://set-outlooksignatures.com/sitemap.xml'
$StartUrl = 'https://set-outlooksignatures.com'
$SeleniumBrowser = 'Edge' # Firefox, Edge
$SeleniumBrowserHeadless = $false
$SeleniumBrowserMinimize = $true


function GetLinksAndContent {
    param ([Parameter(Mandatory = $true)][string]$Url)

    try {
        $Url = ([uri]$Url).AbsoluteUri
        $absoluteLinks = New-Object 'System.Collections.Generic.HashSet[string]'
        $baseUri = [uri]$Url

        $isThrottled = $false

        try {
            $response = Invoke-WebRequest -Method Head -Uri $Url -UseBasicParsing -Timeout 10 -UserAgent $userAgent -ErrorAction Stop
        } catch {
            # Check if this specific error is a Throttling (429) error
            if ($_.Exception.Response.StatusCode -eq 429 -or $_.ToString() -ilike '*Too many requests*') {
                $isThrottled = $true
            } else {
                # If not throttled, try the GET fallback
                try {
                    $response = Invoke-WebRequest -Method Get -Uri $Url -UseBasicParsing -Timeout 10 -UserAgent $userAgent -ErrorAction Stop
                } catch {
                    # Final check: if GET is also throttled, we don't throw; we let Selenium handle it
                    if ($_.Exception.Response.StatusCode -eq 429 -or $_.ToString() -ilike '*Too many requests*') {
                        $isThrottled = $true
                    } elseif (($_.Exception.Response.StatusCode -ieq 'forbidden') -or [string]::IsNullOrWhitespace($_.Exception.Response.StatusCode)) {
                        $isThrottled = $true
                    } else {
                        # Real error (404, DNS, etc.) - we still throw here
                        throw "Invoke-WebRequest real availability error: $_"
                    }
                }
            }
        }

        # Only check headers if we actually got a response and weren't throttled
        if (-not $isThrottled -and $null -ne $response) {
            if ($response.Headers['Content-Type'] -inotmatch 'text/html') {
                $PageContentCache[$Url] = 'Non-HTML Content'
                return $absoluteLinks
            }
        }

        # If throttled or it IS HTML, Selenium takes over with the logged-in profile
        $Driver.Navigate().GoToUrl($Url)

        <#
        $timeout = [DateTime]::Now.AddSeconds(10)
        while ($Driver.ExecuteScript('return document.readyState') -ine 'complete') {
            if ([DateTime]::Now -gt $timeout) { break }
            Start-Sleep -Milliseconds 100
        }
        #>


        # Navigate
        $Driver.Navigate().GoToUrl($Url)

        # Generic Stability Wait
        $MaxWait = 10
        $CheckIntervalMs = 500
        $startTime = [DateTime]::Now
        $lastCount = 0
        $stableRounds = 0

        while (([DateTime]::Now - $startTime).TotalSeconds -lt $MaxWait) {
            # Count all elements in Light DOM + any accessible Shadow DOMs
            $currentCount = $Driver.ExecuteScript(@'
function countNodes(root) {
    let count = root.querySelectorAll('*').length;
    root.querySelectorAll('*').forEach(el => {
        if (el.shadowRoot) {
            count += countNodes(el.shadowRoot);
        }
    });
    return count;
}

return countNodes(document);
'@)

            if ($currentCount -eq $lastCount -and $currentCount -gt 0) {
                $stableRounds++
            } else {
                $stableRounds = 0 # Reset if page is still growing/changing
            }

            # If the element count is the same for 2 consecutive checks, it's likely ready
            if ($stableRounds -ge 2) { break }

            $lastCount = $currentCount
            Start-Sleep -Milliseconds $CheckIntervalMs
        }




        # Updated JavaScript to return the main HTML + all Shadow content as one giant string
        $jsScript = @'
    function getFullPageContent(root) {
        let combinedContent = root.outerHTML || "";

        // Find all elements with a shadowRoot
        const allElements = root.querySelectorAll('*');
        allElements.forEach(el => {
            if (el.shadowRoot) {
                // Append the shadow content to our search string
                combinedContent += "\n\n";
                combinedContent += el.shadowRoot.innerHTML;

                // Recurse to find nested shadows
                combinedContent += getFullPageContent(el.shadowRoot);
            }
        });
        return combinedContent;
    }
    return getFullPageContent(document.documentElement);
'@

        # Cache the full content (Main DOM + Shadow DOMs)
        $PageContentCache[$Url] = $Driver.ExecuteScript($jsScript)

        #$PageContentCache[$Url] = $Driver.PageSource




        if (([uri]$Url).Host -ieq $StartDomain -or ([uri]$Url).Host.EndsWith(".$($StartDomain)", [StringComparison]::InvariantCultureIgnoreCase)) {
            #foreach ($link in $response.Links.href) {
            foreach ($link in @($Driver.ExecuteScript("return Array.from(document.querySelectorAll('a[href]'), a => a.href);"))) {
                if ([string]::IsNullOrWhiteSpace($link)) { continue }

                try {
                    $transformedUri = [Uri]::new($link)
                } catch {
                    try {
                        $transformedUri = [Uri]::new($baseUri, $link)
                    } catch {
                        continue
                    }
                }

                if ($transformedUri.Scheme -iin @('http', 'https')) {
                    $null = $absoluteLinks.Add($transformedUri.AbsoluteUri)
                }
            }
        }

        return $absoluteLinks
    } catch {
        Write-Host "    Failed to retrieve links from $($Url): $($_)" -ForegroundColor Yellow

        $PageContentCache[$Url] = $null

        return $null
    }
}


# Helper function to track which page links to what
function Add-LinkMapping {
    param($Link, $SourcePage)
    if (-not $LinkSourceMap.ContainsKey($Link)) {
        $LinkSourceMap[$Link] = New-Object 'System.Collections.Generic.HashSet[string]'
    }
    $null = $LinkSourceMap[$Link].Add($SourcePage)
}

try {
    if (-not $IsWindows) {
        Write-Host 'This script is designed to run on Windows only' -ForegroundColor Red
        exit 1
    }

    Add-Type -AssemblyName System.Web

    if ($SeleniumBrowser -inotin @('Firefox', 'Edge')) {
        $SeleniumBrowser = 'Firefox'
    }

    Write-Host "Setting up Selenium for $($SeleniumBrowser)"
    $SeleniumDir = Join-Path $env:TEMP "Selenium_$((New-Guid).Guid))"
    New-Item -ItemType Directory -Path $SeleniumDir -Force | Out-Null


    if ($SeleniumBrowser -ieq 'Firefox') {
        if (@(Get-Process -Name 'firefox' -ErrorAction SilentlyContinue).count -gt 0) {
            Write-Host "Please close all instances of Firefox before running this script. $(@(Get-Process -Name 'firefox' -ErrorAction SilentlyContinue).count) instances found." -ForegroundColor Red
            exit 1
        }

        # 1. Get Geckodriver (Firefox Driver)
        Write-Host '  Fetching latest Geckodriver release info...'

        $RepoApiUrl = 'https://api.github.com/repos/mozilla/geckodriver/releases/latest'
        $ReleaseInfo = Invoke-RestMethod -Uri $RepoApiUrl -UseBasicParsing
        $GeckoUrl = $ReleaseInfo.assets |
            Where-Object { $_.name -ilike '*win64.zip' } |
            Select-Object -ExpandProperty browser_download_url

        Write-Host "  Downloading: $GeckoUrl"
        Invoke-WebRequest -Uri $GeckoUrl -OutFile "$SeleniumDir\driver.zip" -UseBasicParsing
        Invoke-WebRequest -Uri $GeckoUrl -OutFile "$SeleniumDir\driver.zip" -UseBasicParsing
        Expand-Archive -Path "$SeleniumDir\driver.zip" -DestinationPath $SeleniumDir -Force

        # 2. Get Selenium WebDriver DLLs (Same as your previous logic)
        $NugetUrl = 'https://www.nuget.org/api/v2/package/Selenium.WebDriver'
        Invoke-WebRequest -Uri $NugetUrl -OutFile "$SeleniumDir\selenium.zip" -UseBasicParsing
        Expand-Archive -Path "$SeleniumDir\selenium.zip" -DestinationPath "$SeleniumDir\Package" -Force

        $DllPath = Get-ChildItem -Path "$SeleniumDir\Package" -Filter 'WebDriver.dll' -Recurse |
            Where-Object { $_.FullName -imatch 'netstandard2.0|net6.0' } |
            Select-Object -First 1

        Add-Type -Path $DllPath.FullName

        # 3. Setup Firefox Specific Options
        $AppDataPath = "$env:APPDATA\Mozilla\Firefox"
        $ProfilesIni = Join-Path $AppDataPath 'profiles.ini'

        if (Test-Path $ProfilesIni) {
            # 2. Parse the INI to find the default-release profile path
            $IniContent = Get-Content $ProfilesIni
            $RelativePath = ($IniContent | Select-String 'Path=Profiles/.*\.default-release' | Select-Object -First 1).ToString().Split('=')[1]

            # 3. Convert relative path to absolute path
            $DefaultProfilePath = Join-Path $AppDataPath $RelativePath.Replace('/', '\')
            Write-Host "  Found Default Profile: $DefaultProfilePath"
        } else {
            Write-Host '  Could not find Firefox profiles.ini. Is Firefox installed?' -ForegroundColor Yellow
            return
        }

        $options = [OpenQA.Selenium.Firefox.FirefoxOptions]::new()
        $options.AddArgument('-profile')
        $options.AddArgument($DefaultProfilePath)
        $options.AddArgument('--width=1920')
        $options.AddArgument('--height=1080')

        $options.SetPreference('dom.webdriver.enabled', $false)
        $options.SetPreference('useAutomationExtension', $false)
        $options.SetPreference('general.buildID.override', '20100101')
        $options.SetPreference('browser.link.open_newwindow', 3)

        if ($SeleniumBrowserHeadless) {
            $options.AddArgument('--headless') # Standard headless flag for Firefox
        }

        Write-Host '  Start the service and driver'
        try {
            $Service = [OpenQA.Selenium.Firefox.FirefoxDriverService]::CreateDefaultService($SeleniumDir)
            $Service.HideCommandPromptWindow = $true

            $Driver = [OpenQA.Selenium.Firefox.FirefoxDriver]::new($Service, $options)
        } catch {
            Write-Host "Failed to start Firefox WebDriver: $_" -ForegroundColor Red

            Write-Host "Firefox must not be started. $(@(Get-Process -Name 'firefox' -ErrorAction SilentlyContinue).count) instances found."


            exit 1
        }
    } elseif ($SeleniumBrowser -ieq 'Edge') {
        if (@(Get-Process -Name 'msedge' -ErrorAction SilentlyContinue).count -gt 0) {
            Write-Host "Please close all instances of Edge before running this script. $(@(Get-Process -Name 'msedge' -ErrorAction SilentlyContinue).count) instances found." -ForegroundColor Red
            exit 1
        }

        Write-Host '  Detecting installed Microsoft Edge version...'
        # Define the standard x64 path for Microsoft Edge
        $edgePath = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"

        if (Test-Path $edgePath) {
            # Get-Item retrieves the file object, and VersionInfo contains the metadata
            $edgeVersion = (Get-Item $edgePath).VersionInfo.FileVersion
            Write-Host "  Microsoft Edge Version (from EXE): $edgeVersion"
        } else {
            Write-Host "Edge executable not found at $edgePath" -ForegroundColor Red
        }

        $edgeMajor = ($edgeVersion -split '\.')[0]
        Write-Host "  Edge detected: $edgeVersion (major $edgeMajor)"

        $base = 'https://msedgedriver.microsoft.com'  # <- fixed
        $edgeZip = Join-Path $SeleniumDir 'edgedriver.zip'

        # Build the exact URL from the browser version (most reliable)
        $driverUrl = "$base/$edgeVersion/edgedriver_win64.zip"
        Write-Host "  Downloading: $driverUrl"
        try {
            Invoke-WebRequest -Uri $driverUrl -OutFile $edgeZip -UseBasicParsing
        } catch {
            # Optional: fallback to “major-matched” latest if the exact build isn’t present
            $latestForMajorUrl = "$base/LATEST_RELEASE_$edgeMajor"
            Write-Host "  Exact build not found. Trying major-matched endpoint: $latestForMajorUrl"
            $driverVersionForMajor = ((Invoke-RestMethod -Uri https://msedgedriver.microsoft.com/LATEST_RELEASE_145 -UseBasicParsing) -split '\r?\n')[0] -replace '[^0-9.]', ''
            $driverUrl = "$base/$driverVersionForMajor/edgedriver_win64.zip"
            Write-Host "  Downloading: $driverUrl"
            Invoke-WebRequest -Uri $driverUrl -OutFile $edgeZip -UseBasicParsing
        }

        Expand-Archive -Path $edgeZip -DestinationPath $SeleniumDir -Force

        # Selenium.WebDriver DLL load (unchanged)
        $NugetUrl = 'https://www.nuget.org/api/v2/package/Selenium.WebDriver'
        Write-Host '  Downloading Selenium.WebDriver package...'
        Invoke-WebRequest -Uri $NugetUrl -OutFile "$SeleniumDir\selenium.zip" -UseBasicParsing
        Expand-Archive -Path "$SeleniumDir\selenium.zip" -DestinationPath "$SeleniumDir\Package" -Force

        $DllPath = Get-ChildItem -Path "$SeleniumDir\Package" -Filter 'WebDriver.dll' -Recurse |
            Where-Object { $_.FullName -imatch 'netstandard2.0|net6.0' } |
            Select-Object -First 1
        if (-not $DllPath) { Write-Host '  Could not locate WebDriver.dll' -ForegroundColor Yellow; return }
        Add-Type -Path $DllPath.FullName

        # Edge options (user profile + headless)
        $UserDataDir = Join-Path $env:LOCALAPPDATA 'Microsoft\Edge\User Data'
        $ProfileDirName = 'Default'
        $options = [OpenQA.Selenium.Edge.EdgeOptions]::new()
        $options.AddArgument("--user-data-dir=$UserDataDir")
        $options.AddArgument("--profile-directory=$ProfileDirName")
        $options.AddArgument('--disable-blink-features=AutomationControlled')
        $options.AddArgument('--window-size=1920,1080')
        $options.AddExcludedArgument('enable-automation')
        $options.AddAdditionalEdgeOption('useAutomationExtension', $false)

        if ($SeleniumBrowserHeadless) {
            $options.AddArgument('--headless=new')
        }

        Write-Host '  Start the service and driver for Edge'
        try {
            $Service = [OpenQA.Selenium.Edge.EdgeDriverService]::CreateDefaultService($SeleniumDir)
            $Service.HideCommandPromptWindow = $true
            $Driver = [OpenQA.Selenium.Edge.EdgeDriver]::new($Service, $options)
        } catch {
            Write-Host "Failed to start Edge WebDriver: $_" -ForegroundColor Red
            Write-Host "Edge must not be started. $(@(Get-Process -Name 'msedge' -ErrorAction SilentlyContinue).count) instances found."
            exit 1
        }
    }

    if ($SeleniumBrowserMinimize) {
        $Driver.Manage().Window.Minimize()
    }

    $userAgent = $driver.ExecuteScript('return navigator.userAgent')
    Write-Host "  User agent: $($userAgent)"

    Add-Type -AssemblyName System.Web


    # --- Initialization ---
    # This map stores: "Link" = @("Page1", "Page2")
    $LinkSourceMap = @{}
    $PagesChecked = New-Object 'System.Collections.Generic.HashSet[string]'
    $Queue = New-Object 'System.Collections.Generic.Queue[string]'
    $PageContentCache = @{}

    if ($StartUrl) {
        $StartDomain = ([uri]$StartUrl).Host
    } elseif ($SitemapUrl) {
        $StartDomain = ([uri]$SitemapUrl).Host
    } else {
        Write-Host 'You must specify at least a SitemapUrl or a StartUrl.' -ForegroundColor Red
        exit 1
    }


    if ($StartUrl) {
        $Queue.Enqueue(([uri]$StartUrl).AbsoluteUri)
    }


    # --- Sitemap Processing ---
    if ($SitemapUrl) {
        try {
            $response = Invoke-WebRequest -Uri $SitemapUrl -UseBasicParsing -Timeout 10 -UserAgent $userAgent
            [xml]$Sitemap = $response.Content

            $ns = New-Object System.Xml.XmlNamespaceManager($Sitemap.NameTable)
            $ns.AddNamespace('ns', 'http://www.sitemaps.org/schemas/sitemap/0.9')
            $ns.AddNamespace('xhtml', 'http://www.w3.org/1999/xhtml')

            $locLinks = $Sitemap.SelectNodes('//ns:loc', $ns) | Select-Object -ExpandProperty '#text'
            $xhtmlLinks = $Sitemap.SelectNodes('//xhtml:link', $ns) | ForEach-Object { $_.getAttribute('href') }

            ($locLinks + $xhtmlLinks) | Select-Object -Unique | ForEach-Object {
                $Queue.Enqueue(([uri]$_).AbsoluteUri)
                Add-LinkMapping -Link ([uri]$_).AbsoluteUri -SourcePage 'Sitemap'
            }
        } catch {
            Write-Host "Failed to download or parse sitemap: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }


    # --- Crawl Loop ---
    Write-Host
    Write-Host "Crawling $StartDomain..."
    while ($Queue.Count -gt 0) {
        $CurrentUrl = $Queue.Dequeue()
        $CurrentUrlClean = ([uri]@($CurrentUrl -split '#(?!/)', 2)[0]).AbsoluteUri

        if ($PagesChecked.Contains($CurrentUrlClean)) { continue }

        $null = $PagesChecked.Add($CurrentUrlClean)

        Write-Host "  $CurrentUrlClean"

        $LinksOnPage = GetLinksAndContent -Url $CurrentUrl

        if ($null -ne $LinksOnPage) {
            foreach ($link in $LinksOnPage) {
                # Map the link to the current page
                Add-LinkMapping -Link $link -SourcePage $CurrentUrlClean

                try {
                    $linkClean = ([uri]@($link -split '#(?!/)', 2)[0]).AbsoluteUri

                    # If link is from a site of an internal domain, add to queue for further crawling
                    if (-not $PagesChecked.Contains($linkClean)) {
                        $Queue.Enqueue($linkClean)
                    }
                } catch { continue }
            }
        }
    }


    $Driver.Quit()
    $Service.Dispose()


    # --- Validation Logic ---
    Write-Host
    Write-Host "Verifying $($LinkSourceMap.Count) unique links found"
    $LinkResults = New-Object 'System.Collections.Generic.List[PSObject]'

    foreach ($link in $LinkSourceMap.Keys) {
        $uriParts = @($link -split '#(?!/)', 2)
        $baseUrl = ([uri]$uriParts[0]).AbsoluteUri
        $rawAnchor = if ($uriParts.Count -gt 1) { $uriParts[1] } else { $null }
        $decodedAnchor = [System.Web.HttpUtility]::UrlDecode($rawAnchor)

        $pageExists = $false
        $anchorExists = $null

        if (-not $PageContentCache.ContainsKey($baseUrl)) {
            Write-Host " Not in PageContentCache: $baseUrl" -ForegroundColor Yellow
        } else {
            $pageExists = $null -ne $PageContentCache[$baseUrl]
        }

        if ($pageExists -and -not [string]::IsNullOrEmpty($rawAnchor)) {
            $html = $PageContentCache[$baseUrl]
            $pattern = "(id|name)=['""]$([regex]::Escape($decodedAnchor))['""]"
            $anchorExists = $html -match $pattern
        }

        $LinkResults.Add([PSCustomObject]@{
                FullLink      = $link
                BasePageValid = $pageExists
                AnchorFound   = $anchorExists
                FoundOnPages  = @($LinkSourceMap[$link]) # All pages containing this link
            })
    }


    # --- Final Results ---
    Write-Host
    Write-Host 'Broken links'
    $BrokenLinks = @($LinkResults | Where-Object { (-not $_.BasePageValid) -or ($_.AnchorFound -eq $false) } | Sort-Object -Property FullLink)

    if ($BrokenLinks.Count -eq 0) {
        Write-Host "  No broken links found! All $($LinkResults.Count) links are valid."
    } else {
        Write-Host "  $($BrokenLinks.Count) broken link(s) found" -ForegroundColor Red
        $BrokenLinks | ForEach-Object {
            Write-Host "    $($_.FullLink)" -ForegroundColor Yellow
            Write-Host "      BasePageValid: $($_.BasePageValid)"
            Write-Host "      AnchorFound: $($_.AnchorFound)"
            Write-Host "      FoundOnPages: $($_.FoundOnPages.Count)"
            if ($_.FoundOnPages) {
                $_.FoundOnPages | Sort-Object | ForEach-Object {
                    Write-Host "        $($_)"
                }
            }
        }
    }
} catch {
    Write-Host "An unexpected error occurred: $_" -ForegroundColor Red
} finally {
    if ($Driver) {
        $Driver.Quit()
    }
    if ($Service) {
        $Service.Dispose()
    }
}