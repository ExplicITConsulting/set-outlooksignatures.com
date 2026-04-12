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
    [int]$ParallelWorkers = ([int]$env:NUMBER_OF_PROCESSORS * 1),

    # Export the scan results as CliXml to this file for later use.
    [string]$ExportFile = ''
)


#
# Do not change anything from here on
#

try {
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


    ### BlockSleep initiation code below
    ##
    #
    # Place this code in your main script, as early in the code as possible
    #
    # Call BlockSleep wherever you want the current process to block sleep
    #   BlockSleep
    #
    # On Windows, you can set three parameters:
    #   -RequireAwaymode: Allows Away mode (defaults to true when not set)
    #   -RequireDisplay: Requires the display to be on (defaults to false when not set)
    #   -RequireSystem: Requires the system to be on (default to true when not set)
    # On Linux, systemd-inhibit is required (should be available on most distributions)
    # On macOS, caffeinate is required (should be available built-in)
    #
    # To allow sleep again, call BlockSleep with the AllowSleep parameter:
    #   BlockSleep -AllowSleep
    #
    function BlockSleep {
        param (
            [switch]$AllowSleep,
            [switch]$RequireAwayMode,
            [switch]$RequireDisplay,
            [switch]$RequireSystem
        )

        if ($AllowSleep) {
            $RequireAwayMode = $false
            $RequireDisplay = $false
            $RequireSystem = $false
        } else {
            if (-not $PSBoundParameters.ContainsKey('RequireAwayMode')) {
                $RequireAwayMode = $true
            }

            if (-not $PSBoundParameters.ContainsKey('RequireDisplay')) {
                $RequireDisplay = $false
            }

            if (-not $PSBoundParameters.ContainsKey('RequireSystem')) {
                $RequireSystem = $true
            }

            if (
                ($RequireAwayMode -eq $false) -and
                ($RequireDisplay -eq $false) -and
                ($RequireSystem -eq $false)
            ) {
                $AllowSleep = $true
            }
        }

        if ((-not (Test-Path -LiteralPath 'variable:IsWindows')) -or $IsWindows) {
            $code = @'
[DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
public static extern void SetThreadExecutionState(uint esFlags);
'@

            $ste = Add-Type -MemberDefinition $code -Name System -Namespace Win32 -PassThru
            $ES_CONTINUOUS = [uint32]'0x80000000'
            $ES_AWAYMODE_REQUIRED = [uint32]'0x00000040'
            $ES_DISPLAY_REQUIRED = [uint32]'0x00000002'
            $ES_SYSTEM_REQUIRED = [uint32]'0x00000001'

            $flags = $ES_CONTINUOUS

            if (-not $AllowSleep) {
                if ($RequireAwayMode) { $flags = $flags -bor $ES_AWAYMODE_REQUIRED }
                if ($RequireDisplay) { $flags = $flags -bor $ES_DISPLAY_REQUIRED }
                if ($RequireSystem) { $flags = $flags -bor $ES_SYSTEM_REQUIRED }
            }

            $ste::SetThreadExecutionState($flags)
        } elseif ((Test-Path -LiteralPath 'variable:IsLinux') -and $IsLinux) {
            if (Get-Command systemd-inhibit -ErrorAction SilentlyContinue) {
                if ($script:BlockSleepInhibitPID) {
                    Stop-Process -Id $script:BlockSleepInhibitPID -Force
                    Remove-Variable -Name BlockSleepInhibitPID -Scope script
                }

                if (-not $AllowSleep) {
                    $script:BlockSleepInhibitPID = Start-Process systemd-inhibit -ArgumentList "--what=idle --why=""Set-OutlookSignatures"" --who=""Set-OutlookSignatures"" tail --pid=$($PID) --follow /dev/null" -PassThru | Select-Object -ExpandProperty Id
                }
            } else {
                Write-Host "  'systemd-inhibit' is not available."
            }
        } elseif ((Test-Path -LiteralPath 'variable:IsMacOS') -and $IsMacOS) {
            if (Get-Command caffeinate -ErrorAction SilentlyContinue) {
                if ($script:BlockSleepInhibitPID) {
                    Stop-Process -Id $script:BlockSleepInhibitPID -Force
                    Remove-Variable -Name BlockSleepInhibitPID -Scope script
                }

                if (-not $AllowSleep) {
                    $script:BlockSleepInhibitPID = Start-Process caffeinate -ArgumentList "-ims -w $($PID)" -PassThru | Select-Object -ExpandProperty Id
                }
            } else {
                Write-Host "  'caffeinate' is not available."
            }
        }
    }
    #
    ##
    ### BlockSleep initiation code above


    BlockSleep


    Write-Host '  Install dependencies'
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

            Import-Module $using:PSPlaywrightModulePath

            Start-Playwright

            $Locale = 'de-AT'
            $TimeZone = 'Europe/Vienna'
            $Lat, $Lon = 48.2082, 16.3738

            $userAgent = [Microsoft.Playwright.Playwright]::CreateAsync().GetAwaiter().GetResult().Devices[@{
                chromium = 'Desktop Chrome'
                firefox  = 'Desktop Firefox'
                webkit   = 'Desktop Safari'
            }[($using:BrowserType)]].UserAgent

            $launchOptions = [Microsoft.Playwright.BrowserTypeLaunchOptions]@{
                Headless = $(if ($using:BrowserType -ieq 'chromium') { $false }else { $using:BrowserHeadless }) # We use --headless=new in Args for better stealth
                Args     = [string[]]@(
                    $(if ($using:BrowserType -ieq 'chromium') { '--headless=new' }else { '' }),
                    '--disable-blink-features=AutomationControlled', # Hides webdriver for Chromium
                    '--disable-breakpad',
                    '--disable-client-side-phishing-detection',
                    '--disable-component-update',
                    '--disable-default-apps',
                    '--disable-dev-shm-usage',
                    '--disable-features=IsolateOrigins,site-per-process',
                    '--disable-hang-monitor',
                    '--disable-infobars',
                    '--disable-setuid-sandbox',
                    '--disable-web-security',
                    '--metrics-recording-only',
                    '--no-default-browser-check',
                    '--no-first-run',
                    '--no-sandbox'
                )
            }

            $Playwright = [Microsoft.Playwright.Playwright]::CreateAsync().GetAwaiter().GetResult()
            $PlaywrightBrowser = $Playwright.($using:BrowserType).LaunchAsync($launchOptions).GetAwaiter().GetResult()

            $contextOptions = [Microsoft.Playwright.BrowserNewContextOptions]@{
                acceptDownloads   = $true
                javaScriptEnabled = $true
                ignoreHTTPSErrors = $false
                UserAgent         = $userAgent
                Locale            = $Locale
                TimezoneId        = $TimeZone
                Geolocation       = @{ Latitude = $Lat; Longitude = $Lon }
                Permissions       = [string[]]@('geolocation')
                ViewportSize      = @{ Width = 1920; Height = 1080 }
                DeviceScaleFactor = 1
            }

            $context = $PlaywrightBrowser.NewContextAsync($contextOptions).GetAwaiter().GetResult()

            $stealthScript = @'
(function () {
    ;
    const opts = { "webgl_vendor": "Intel Inc.", "webgl_renderer": "Intel Iris OpenGL Engine", "navigator_vendor": "Google Inc.", "navigator_platform": null, "navigator_user_agent": null, "languages": ["en-US", "en"], "runOnInsecureOrigins": null, "navigator_hardware_concurrency": 4, "ua_patch_prefix": "Headless", "ua_patch_suffix": "/", "navigator_device_memory": 8, "max_touch_points": 1 };
    ;
    /**
     * A set of shared utility functions specifically for the purpose of modifying native browser APIs without leaving traces.
     *
     * Meant to be passed down in puppeteer and used in the context of the page (everything in here runs in NodeJS as well as a browser).
     *
     * Note: If for whatever reason you need to use this outside of `puppeteer-extra`:
     * Just remove the `module.exports` statement at the very bottom, the rest can be copy pasted into any browser context.
     *
     * Alternatively take a look at the `extract-stealth-evasions` package to create a finished bundle which includes these utilities.
     *
     */
    const utils = {}

    /**
     * Wraps a JS Proxy Handler and strips it's presence from error stacks, in case the traps throw.
     *
     * The presence of a JS Proxy can be revealed as it shows up in error stack traces.
     *
     * @param {object} handler - The JS Proxy handler to wrap
     */
    utils.stripProxyFromErrors = (handler = {}) => {
        const newHandler = {}
        // We wrap each trap in the handler in a try/catch and modify the error stack if they throw
        const traps = Object.getOwnPropertyNames(handler)
        traps.forEach(trap => {
            newHandler[trap] = function () {
                try {
                    // Forward the call to the defined proxy handler
                    return handler[trap].apply(this, arguments || [])
                } catch (err) {
                    // Stack traces differ per browser, we only support chromium based ones currently
                    if (!err || !err.stack || !err.stack.includes(`at `)) {
                        throw err
                    }

                    // When something throws within one of our traps the Proxy will show up in error stacks
                    // An earlier implementation of this code would simply strip lines with a blacklist,
                    // but it makes sense to be more surgical here and only remove lines related to our Proxy.
                    // We try to use a known "anchor" line for that and strip it with everything above it.
                    // If the anchor line cannot be found for some reason we fall back to our blacklist approach.

                    const stripWithBlacklist = stack => {
                        const blacklist = [
                            `at Reflect.${trap} `, // e.g. Reflect.get or Reflect.apply
                            `at Object.${trap} `, // e.g. Object.get or Object.apply
                            `at Object.newHandler.<computed> [as ${trap}] ` // caused by this very wrapper :-)
                        ]
                        return (
                            err.stack
                                .split('\n')
                                // Always remove the first (file) line in the stack (guaranteed to be our proxy)
                                .filter((line, index) => index !== 1)
                                // Check if the line starts with one of our blacklisted strings
                                .filter(line => !blacklist.some(bl => line.trim().startsWith(bl)))
                                .join('\n')
                        )
                    }

                    const stripWithAnchor = stack => {
                        const stackArr = stack.split('\n')
                        const anchor = `at Object.newHandler.<computed> [as ${trap}] ` // Known first Proxy line in chromium
                        const anchorIndex = stackArr.findIndex(line =>
                            line.trim().startsWith(anchor)
                        )
                        if (anchorIndex === -1) {
                            return false // 404, anchor not found
                        }
                        // Strip everything from the top until we reach the anchor line
                        // Note: We're keeping the 1st line (zero index) as it's unrelated (e.g. `TypeError`)
                        stackArr.splice(1, anchorIndex)
                        return stackArr.join('\n')
                    }

                    // Try using the anchor method, fallback to blacklist if necessary
                    err.stack = stripWithAnchor(err.stack) || stripWithBlacklist(err.stack)

                    throw err // Re-throw our now sanitized error
                }
            }
        })
        return newHandler
    }

    /**
     * Strip error lines from stack traces until (and including) a known line the stack.
     *
     * @param {object} err - The error to sanitize
     * @param {string} anchor - The string the anchor line starts with
     */
    utils.stripErrorWithAnchor = (err, anchor) => {
        const stackArr = err.stack.split('\n')
        const anchorIndex = stackArr.findIndex(line => line.trim().startsWith(anchor))
        if (anchorIndex === -1) {
            return err // 404, anchor not found
        }
        // Strip everything from the top until we reach the anchor line (remove anchor line as well)
        // Note: We're keeping the 1st line (zero index) as it's unrelated (e.g. `TypeError`)
        stackArr.splice(1, anchorIndex)
        err.stack = stackArr.join('\n')
        return err
    }

    /**
     * Replace the property of an object in a stealthy way.
     *
     * Note: You also want to work on the prototype of an object most often,
     * as you'd otherwise leave traces (e.g. showing up in Object.getOwnPropertyNames(obj)).
     *
     * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty
     *
     * @example
     * replaceProperty(WebGLRenderingContext.prototype, 'getParameter', { value: "alice" })
     * // or
     * replaceProperty(Object.getPrototypeOf(navigator), 'languages', { get: () => ['en-US', 'en'] })
     *
     * @param {object} obj - The object which has the property to replace
     * @param {string} propName - The property name to replace
     * @param {object} descriptorOverrides - e.g. { value: "alice" }
     */
    utils.replaceProperty = (obj, propName, descriptorOverrides = {}) => {
        return Object.defineProperty(obj, propName, {
            // Copy over the existing descriptors (writable, enumerable, configurable, etc)
            ...(Object.getOwnPropertyDescriptor(obj, propName) || {}),
            // Add our overrides (e.g. value, get())
            ...descriptorOverrides
        })
    }

    /**
     * Preload a cache of function copies and data.
     *
     * For a determined enough observer it would be possible to overwrite and sniff usage of functions
     * we use in our internal Proxies, to combat that we use a cached copy of those functions.
     *
     * This is evaluated once per execution context (e.g. window)
     */
    utils.preloadCache = () => {
        if (utils.cache) {
            return
        }
        utils.cache = {
            // Used in our proxies
            Reflect: {
                get: Reflect.get.bind(Reflect),
                apply: Reflect.apply.bind(Reflect)
            },
            // Used in `makeNativeString`
            nativeToStringStr: Function.toString + '' // => `function toString() { [native code] }`
        }
    }

    /**
     * Utility function to generate a cross-browser `toString` result representing native code.
     *
     * There's small differences: Chromium uses a single line, whereas FF & Webkit uses multiline strings.
     * To future-proof this we use an existing native toString result as the basis.
     *
     * The only advantage we have over the other team is that our JS runs first, hence we cache the result
     * of the native toString result once, so they cannot spoof it afterwards and reveal that we're using it.
     *
     * Note: Whenever we add a `Function.prototype.toString` proxy we should preload the cache before,
     * by executing `utils.preloadCache()` before the proxy is applied (so we don't cause recursive lookups).
     *
     * @example
     * makeNativeString('foobar') // => `function foobar() { [native code] }`
     *
     * @param {string} [name] - Optional function name
     */
    utils.makeNativeString = (name = '') => {
        // Cache (per-window) the original native toString or use that if available
        utils.preloadCache()
        return utils.cache.nativeToStringStr.replace('toString', name || '')
    }

    /**
     * Helper function to modify the `toString()` result of the provided object.
     *
     * Note: Use `utils.redirectToString` instead when possible.
     *
     * There's a quirk in JS Proxies that will cause the `toString()` result to differ from the vanilla Object.
     * If no string is provided we will generate a `[native code]` thing based on the name of the property object.
     *
     * @example
     * patchToString(WebGLRenderingContext.prototype.getParameter, 'function getParameter() { [native code] }')
     *
     * @param {object} obj - The object for which to modify the `toString()` representation
     * @param {string} str - Optional string used as a return value
     */
    utils.patchToString = (obj, str = '') => {
        utils.preloadCache()

        const toStringProxy = new Proxy(Function.prototype.toString, {
            apply: function (target, ctx) {
                // This fixes e.g. `HTMLMediaElement.prototype.canPlayType.toString + ""`
                if (ctx === Function.prototype.toString) {
                    return utils.makeNativeString('toString')
                }
                // `toString` targeted at our proxied Object detected
                if (ctx === obj) {
                    // We either return the optional string verbatim or derive the most desired result automatically
                    return str || utils.makeNativeString(obj.name)
                }
                // Check if the toString protype of the context is the same as the global prototype,
                // if not indicates that we are doing a check across different windows., e.g. the iframeWithdirect` test case
                const hasSameProto = Object.getPrototypeOf(
                    Function.prototype.toString
                ).isPrototypeOf(ctx.toString) // eslint-disable-line no-prototype-builtins
                if (!hasSameProto) {
                    // Pass the call on to the local Function.prototype.toString instead
                    return ctx.toString()
                }
                return target.call(ctx)
            }
        })
        utils.replaceProperty(Function.prototype, 'toString', {
            value: toStringProxy
        })
    }

    /**
     * Make all nested functions of an object native.
     *
     * @param {object} obj
     */
    utils.patchToStringNested = (obj = {}) => {
        return utils.execRecursively(obj, ['function'], utils.patchToString)
    }

    /**
     * Redirect toString requests from one object to another.
     *
     * @param {object} proxyObj - The object that toString will be called on
     * @param {object} originalObj - The object which toString result we wan to return
     */
    utils.redirectToString = (proxyObj, originalObj) => {
        utils.preloadCache()

        const toStringProxy = new Proxy(Function.prototype.toString, {
            apply: function (target, ctx) {
                // This fixes e.g. `HTMLMediaElement.prototype.canPlayType.toString + ""`
                if (ctx === Function.prototype.toString) {
                    return utils.makeNativeString('toString')
                }

                // `toString` targeted at our proxied Object detected
                if (ctx === proxyObj) {
                    const fallback = () =>
                        originalObj && originalObj.name
                            ? utils.makeNativeString(originalObj.name)
                            : utils.makeNativeString(proxyObj.name)

                    // Return the toString representation of our original object if possible
                    return originalObj + '' || fallback()
                }

                // Check if the toString protype of the context is the same as the global prototype,
                // if not indicates that we are doing a check across different windows., e.g. the iframeWithdirect` test case
                const hasSameProto = Object.getPrototypeOf(
                    Function.prototype.toString
                ).isPrototypeOf(ctx.toString) // eslint-disable-line no-prototype-builtins
                if (!hasSameProto) {
                    // Pass the call on to the local Function.prototype.toString instead
                    return ctx.toString()
                }

                return target.call(ctx)
            }
        })
        utils.replaceProperty(Function.prototype, 'toString', {
            value: toStringProxy
        })
    }

    /**
     * All-in-one method to replace a property with a JS Proxy using the provided Proxy handler with traps.
     *
     * Will stealthify these aspects (strip error stack traces, redirect toString, etc).
     * Note: This is meant to modify native Browser APIs and works best with prototype objects.
     *
     * @example
     * replaceWithProxy(WebGLRenderingContext.prototype, 'getParameter', proxyHandler)
     *
     * @param {object} obj - The object which has the property to replace
     * @param {string} propName - The name of the property to replace
     * @param {object} handler - The JS Proxy handler to use
     */
    utils.replaceWithProxy = (obj, propName, handler) => {
        utils.preloadCache()
        const originalObj = obj[propName]
        const proxyObj = new Proxy(obj[propName], utils.stripProxyFromErrors(handler))

        utils.replaceProperty(obj, propName, { value: proxyObj })
        utils.redirectToString(proxyObj, originalObj)

        return true
    }

    /**
     * All-in-one method to mock a non-existing property with a JS Proxy using the provided Proxy handler with traps.
     *
     * Will stealthify these aspects (strip error stack traces, redirect toString, etc).
     *
     * @example
     * mockWithProxy(chrome.runtime, 'sendMessage', function sendMessage() {}, proxyHandler)
     *
     * @param {object} obj - The object which has the property to replace
     * @param {string} propName - The name of the property to replace or create
     * @param {object} pseudoTarget - The JS Proxy target to use as a basis
     * @param {object} handler - The JS Proxy handler to use
     */
    utils.mockWithProxy = (obj, propName, pseudoTarget, handler) => {
        utils.preloadCache()
        const proxyObj = new Proxy(pseudoTarget, utils.stripProxyFromErrors(handler))

        utils.replaceProperty(obj, propName, { value: proxyObj })
        utils.patchToString(proxyObj)

        return true
    }

    /**
     * All-in-one method to create a new JS Proxy with stealth tweaks.
     *
     * This is meant to be used whenever we need a JS Proxy but don't want to replace or mock an existing known property.
     *
     * Will stealthify certain aspects of the Proxy (strip error stack traces, redirect toString, etc).
     *
     * @example
     * createProxy(navigator.mimeTypes.__proto__.namedItem, proxyHandler) // => Proxy
     *
     * @param {object} pseudoTarget - The JS Proxy target to use as a basis
     * @param {object} handler - The JS Proxy handler to use
     */
    utils.createProxy = (pseudoTarget, handler) => {
        utils.preloadCache()
        const proxyObj = new Proxy(pseudoTarget, utils.stripProxyFromErrors(handler))
        utils.patchToString(proxyObj)

        return proxyObj
    }

    /**
     * Helper function to split a full path to an Object into the first part and property.
     *
     * @example
     * splitObjPath(`HTMLMediaElement.prototype.canPlayType`)
     * // => {objName: "HTMLMediaElement.prototype", propName: "canPlayType"}
     *
     * @param {string} objPath - The full path to an object as dot notation string
     */
    utils.splitObjPath = objPath => ({
        // Remove last dot entry (property) ==> `HTMLMediaElement.prototype`
        objName: objPath
            .split('.')
            .slice(0, -1)
            .join('.'),
        // Extract last dot entry ==> `canPlayType`
        propName: objPath.split('.').slice(-1)[0]
    })

    /**
     * Convenience method to replace a property with a JS Proxy using the provided objPath.
     *
     * Supports a full path (dot notation) to the object as string here, in case that makes it easier.
     *
     * @example
     * replaceObjPathWithProxy('WebGLRenderingContext.prototype.getParameter', proxyHandler)
     *
     * @param {string} objPath - The full path to an object (dot notation string) to replace
     * @param {object} handler - The JS Proxy handler to use
     */
    utils.replaceObjPathWithProxy = (objPath, handler) => {
        const { objName, propName } = utils.splitObjPath(objPath)
        const obj = eval(objName) // eslint-disable-line no-eval
        return utils.replaceWithProxy(obj, propName, handler)
    }

    /**
     * Traverse nested properties of an object recursively and apply the given function on a whitelist of value types.
     *
     * @param {object} obj
     * @param {array} typeFilter - e.g. `['function']`
     * @param {Function} fn - e.g. `utils.patchToString`
     */
    utils.execRecursively = (obj = {}, typeFilter = [], fn) => {
        function recurse(obj) {
            for (const key in obj) {
                if (obj[key] === undefined) {
                    continue
                }
                if (obj[key] && typeof obj[key] === 'object') {
                    recurse(obj[key])
                } else {
                    if (obj[key] && typeFilter.includes(typeof obj[key])) {
                        fn.call(this, obj[key])
                    }
                }
            }
        }
        recurse(obj)
        return obj
    }

    /**
     * Everything we run through e.g. `page.evaluate` runs in the browser context, not the NodeJS one.
     * That means we cannot just use reference variables and functions from outside code, we need to pass everything as a parameter.
     *
     * Unfortunately the data we can pass is only allowed to be of primitive types, regular functions don't survive the built-in serialization process.
     * This utility function will take an object with functions and stringify them, so we can pass them down unharmed as strings.
     *
     * We use this to pass down our utility functions as well as any other functions (to be able to split up code better).
     *
     * @see utils.materializeFns
     *
     * @param {object} fnObj - An object containing functions as properties
     */
    utils.stringifyFns = (fnObj = { hello: () => 'world' }) => {
        // Object.fromEntries() ponyfill (in 6 lines) - supported only in Node v12+, modern browsers are fine
        // https://github.com/feross/fromentries
        function fromEntries(iterable) {
            return [...iterable].reduce((obj, [key, val]) => {
                obj[key] = val
                return obj
            }, {})
        }
        return (Object.fromEntries || fromEntries)(
            Object.entries(fnObj)
                .filter(([key, value]) => typeof value === 'function')
                .map(([key, value]) => [key, value.toString()]) // eslint-disable-line no-eval
        )
    }

    /**
     * Utility function to reverse the process of `utils.stringifyFns`.
     * Will materialize an object with stringified functions (supports classic and fat arrow functions).
     *
     * @param {object} fnStrObj - An object containing stringified functions as properties
     */
    utils.materializeFns = (fnStrObj = { hello: "() => 'world'" }) => {
        return Object.fromEntries(
            Object.entries(fnStrObj).map(([key, value]) => {
                if (value.startsWith('function')) {
                    // some trickery is needed to make oldschool functions work :-)
                    return [key, eval(`() => ${value}`)()] // eslint-disable-line no-eval
                } else {
                    // arrow functions just work
                    return [key, eval(value)] // eslint-disable-line no-eval
                }
            })
        )
    }

        // --
        // Stuff starting below this line is NodeJS specific.
        // --
        // module.exports = utils
        ;
    const generateFunctionMocks = (
        proto,
        itemMainProp,
        dataArray
    ) => ({
        item: utils.createProxy(proto.item, {
            apply(target, ctx, args) {
                if (!args.length) {
                    throw new TypeError(
                        `Failed to execute 'item' on '${proto[Symbol.toStringTag]
                        }': 1 argument required, but only 0 present.`
                    )
                }
                // Special behavior alert:
                // - Vanilla tries to cast strings to Numbers (only integers!) and use them as property index lookup
                // - If anything else than an integer (including as string) is provided it will return the first entry
                const isInteger = args[0] && Number.isInteger(Number(args[0])) // Cast potential string to number first, then check for integer
                // Note: Vanilla never returns `undefined`
                return (isInteger ? dataArray[Number(args[0])] : dataArray[0]) || null
            }
        }),
        /** Returns the MimeType object with the specified name. */
        namedItem: utils.createProxy(proto.namedItem, {
            apply(target, ctx, args) {
                if (!args.length) {
                    throw new TypeError(
                        `Failed to execute 'namedItem' on '${proto[Symbol.toStringTag]
                        }': 1 argument required, but only 0 present.`
                    )
                }
                return dataArray.find(mt => mt[itemMainProp] === args[0]) || null // Not `undefined`!
            }
        }),
        /** Does nothing and shall return nothing */
        refresh: proto.refresh
            ? utils.createProxy(proto.refresh, {
                apply(target, ctx, args) {
                    return undefined
                }
            })
            : undefined
    })

    function generateMagicArray(
        dataArray = [],
        proto = MimeTypeArray.prototype,
        itemProto = MimeType.prototype,
        itemMainProp = 'type'
    ) {
        // Quick helper to set props with the same descriptors vanilla is using
        const defineProp = (obj, prop, value) =>
            Object.defineProperty(obj, prop, {
                value,
                writable: false,
                enumerable: false, // Important for mimeTypes & plugins: `JSON.stringify(navigator.mimeTypes)`
                configurable: false
            })

        // Loop over our fake data and construct items
        const makeItem = data => {
            const item = {}
            for (const prop of Object.keys(data)) {
                if (prop.startsWith('__')) {
                    continue
                }
                defineProp(item, prop, data[prop])
            }
            // navigator.plugins[i].length should always be 1
            if (itemProto === Plugin.prototype) {
                defineProp(item, 'length', 1)
            }
            // We need to spoof a specific `MimeType` or `Plugin` object
            return Object.create(itemProto, Object.getOwnPropertyDescriptors(item))
        }

        const magicArray = []

        // Loop through our fake data and use that to create convincing entities
        dataArray.forEach(data => {
            magicArray.push(makeItem(data))
        })

        // Add direct property access  based on types (e.g. `obj['application/pdf']`) afterwards
        magicArray.forEach(entry => {
            defineProp(magicArray, entry[itemMainProp], entry)
        })

        // This is the best way to fake the type to make sure this is false: `Array.isArray(navigator.mimeTypes)`
        const magicArrayObj = Object.create(proto, {
            ...Object.getOwnPropertyDescriptors(magicArray),

            // There's one ugly quirk we unfortunately need to take care of:
            // The `MimeTypeArray` prototype has an enumerable `length` property,
            // but headful Chrome will still skip it when running `Object.getOwnPropertyNames(navigator.mimeTypes)`.
            // To strip it we need to make it first `configurable` and can then overlay a Proxy with an `ownKeys` trap.
            length: {
                value: magicArray.length,
                writable: false,
                enumerable: false,
                configurable: true // Important to be able to use the ownKeys trap in a Proxy to strip `length`
            }
        })

        // Generate our functional function mocks :-)
        const functionMocks = generateFunctionMocks(
            proto,
            itemMainProp,
            magicArray
        )

        // Override custom object with proxy
        return new Proxy(magicArrayObj, {
            get(target, key = '') {
                // Redirect function calls to our custom proxied versions mocking the vanilla behavior
                if (key === 'item') {
                    return functionMocks.item
                }
                if (key === 'namedItem') {
                    return functionMocks.namedItem
                }
                if (proto === PluginArray.prototype && key === 'refresh') {
                    return functionMocks.refresh
                }
                // Everything else can pass through as normal
                return utils.cache.Reflect.get(...arguments)
            },
            ownKeys(target) {
                // There are a couple of quirks where the original property demonstrates "magical" behavior that makes no sense
                // This can be witnessed when calling `Object.getOwnPropertyNames(navigator.mimeTypes)` and the absense of `length`
                // My guess is that it has to do with the recent change of not allowing data enumeration and this being implemented weirdly
                // For that reason we just completely fake the available property names based on our data to match what regular Chrome is doing
                // Specific issues when not patching this: `length` property is available, direct `types` props (e.g. `obj['application/pdf']`) are missing
                const keys = []
                const typeProps = magicArray.map(mt => mt[itemMainProp])
                typeProps.forEach((_, i) => keys.push(`${i}`))
                typeProps.forEach(propName => keys.push(propName))
                return keys
            }
        })
    }

    ;
    (function () {
        if (!window.chrome) {
            // Use the exact property descriptor found in headful Chrome
            // fetch it via `Object.getOwnPropertyDescriptor(window, 'chrome')`
            Object.defineProperty(window, 'chrome', {
                writable: true,
                enumerable: true,
                configurable: false, // note!
                value: {} // We'll extend that later
            })
        }

        // app in window.chrome means we're running headful and don't need to mock anything
        if (!('app' in window.chrome)) {
            const makeError = {
                ErrorInInvocation: fn => {
                    const err = new TypeError(`Error in invocation of app.${fn}()`)
                    return utils.stripErrorWithAnchor(
                        err,
                        `at ${fn} (eval at <anonymous>`
                    )
                }
            }

            // There's a some static data in that property which doesn't seem to change,
            // we should periodically check for updates: `JSON.stringify(window.app, null, 2)`
            const APP_STATIC_DATA = JSON.parse(
                `
{
  "isInstalled": false,
  "InstallState": {
    "DISABLED": "disabled",
    "INSTALLED": "installed",
    "NOT_INSTALLED": "not_installed"
  },
  "RunningState": {
    "CANNOT_RUN": "cannot_run",
    "READY_TO_RUN": "ready_to_run",
    "RUNNING": "running"
  }
}
        `.trim()
            )

            window.chrome.app = {
                ...APP_STATIC_DATA,

                get isInstalled() {
                    return false
                },

                getDetails: function getDetails() {
                    if (arguments.length) {
                        throw makeError.ErrorInInvocation(`getDetails`)
                    }
                    return null
                },
                getIsInstalled: function getDetails() {
                    if (arguments.length) {
                        throw makeError.ErrorInInvocation(`getIsInstalled`)
                    }
                    return false
                },
                runningState: function getDetails() {
                    if (arguments.length) {
                        throw makeError.ErrorInInvocation(`runningState`)
                    }
                    return 'cannot_run'
                }
            }
            utils.patchToStringNested(window.chrome.app)
        }
    })();
    ;
    (function () {
        if (!window.chrome) {
            // Use the exact property descriptor found in headful Chrome
            // fetch it via `Object.getOwnPropertyDescriptor(window, 'chrome')`
            Object.defineProperty(window, 'chrome', {
                writable: true,
                enumerable: true,
                configurable: false, // note!
                value: {} // We'll extend that later
            })
        }

        // Check if we're running headful and don't need to mock anything
        // Check that the Navigation Timing API v1 is available, we need that
        if (!('csi' in window.chrome) && (window.performance || window.performance.timing)) {
            const { csi_timing } = window.performance

            window.chrome.csi = function () {
                return {
                    onloadT: csi_timing.domContentLoadedEventEnd,
                    startE: csi_timing.navigationStart,
                    pageT: Date.now() - csi_timing.navigationStart,
                    tran: 15 // Transition type or something
                }
            }
            utils.patchToString(window.chrome.csi)
        }

    })();
    ;
    (function () {
        // https://intoli.com/blog/making-chrome-headless-undetectable/
        // store the existing descriptor
        const elementDescriptor = Object.getOwnPropertyDescriptor(HTMLElement.prototype, 'offsetHeight');

        // redefine the property with a patched descriptor
        Object.defineProperty(HTMLDivElement.prototype, 'offsetHeight', {
            ...elementDescriptor,
            get: function () {
                if (this.id === 'modernizr') {
                    return 1;
                }
                return elementDescriptor.get.apply(this);
            },
        });
    })();
    ;
    (function () {
        if (!window.chrome) {
            // Use the exact property descriptor found in headful Chrome
            // fetch it via `Object.getOwnPropertyDescriptor(window, 'chrome')`
            Object.defineProperty(window, 'chrome', {
                writable: true,
                enumerable: true,
                configurable: false, // note!
                value: {} // We'll extend that later
            })
        }

        // That means we're running headful and don't need to mock anything
        if ('loadTimes' in window.chrome) {
            throw new Error('skipping chrome loadtimes update, running in headfull mode')
        }

        // Check that the Navigation Timing API v1 + v2 is available, we need that
        if (
            window.performance ||
            window.performance.timing ||
            window.PerformancePaintTiming
        ) {

            const { performance } = window

            // Some stuff is not available on about:blank as it requires a navigation to occur,
            // let's harden the code to not fail then:
            const ntEntryFallback = {
                nextHopProtocol: 'h2',
                type: 'other'
            }

            // The API exposes some funky info regarding the connection
            const protocolInfo = {
                get connectionInfo() {
                    const ntEntry =
                        performance.getEntriesByType('navigation')[0] || ntEntryFallback
                    return ntEntry.nextHopProtocol
                },
                get npnNegotiatedProtocol() {
                    // NPN is deprecated in favor of ALPN, but this implementation returns the
                    // HTTP/2 or HTTP2+QUIC/39 requests negotiated via ALPN.
                    const ntEntry =
                        performance.getEntriesByType('navigation')[0] || ntEntryFallback
                    return ['h2', 'hq'].includes(ntEntry.nextHopProtocol)
                        ? ntEntry.nextHopProtocol
                        : 'unknown'
                },
                get navigationType() {
                    const ntEntry =
                        performance.getEntriesByType('navigation')[0] || ntEntryFallback
                    return ntEntry.type
                },
                get wasAlternateProtocolAvailable() {
                    // The Alternate-Protocol header is deprecated in favor of Alt-Svc
                    // (https://www.mnot.net/blog/2016/03/09/alt-svc), so technically this
                    // should always return false.
                    return false
                },
                get wasFetchedViaSpdy() {
                    // SPDY is deprecated in favor of HTTP/2, but this implementation returns
                    // true for HTTP/2 or HTTP2+QUIC/39 as well.
                    const ntEntry =
                        performance.getEntriesByType('navigation')[0] || ntEntryFallback
                    return ['h2', 'hq'].includes(ntEntry.nextHopProtocol)
                },
                get wasNpnNegotiated() {
                    // NPN is deprecated in favor of ALPN, but this implementation returns true
                    // for HTTP/2 or HTTP2+QUIC/39 requests negotiated via ALPN.
                    const ntEntry =
                        performance.getEntriesByType('navigation')[0] || ntEntryFallback
                    return ['h2', 'hq'].includes(ntEntry.nextHopProtocol)
                }
            }

            const { timing } = window.performance

            // Truncate number to specific number of decimals, most of the `loadTimes` stuff has 3
            function toFixed(num, fixed) {
                var re = new RegExp('^-?\\d+(?:.\\d{0,' + (fixed || -1) + '})?')
                return num.toString().match(re)[0]
            }

            const timingInfo = {
                get firstPaintAfterLoadTime() {
                    // This was never actually implemented and always returns 0.
                    return 0
                },
                get requestTime() {
                    return timing.navigationStart / 1000
                },
                get startLoadTime() {
                    return timing.navigationStart / 1000
                },
                get commitLoadTime() {
                    return timing.responseStart / 1000
                },
                get finishDocumentLoadTime() {
                    return timing.domContentLoadedEventEnd / 1000
                },
                get finishLoadTime() {
                    return timing.loadEventEnd / 1000
                },
                get firstPaintTime() {
                    const fpEntry = performance.getEntriesByType('paint')[0] || {
                        startTime: timing.loadEventEnd / 1000 // Fallback if no navigation occured (`about:blank`)
                    }
                    return toFixed(
                        (fpEntry.startTime + performance.timeOrigin) / 1000,
                        3
                    )
                }
            }

            window.chrome.loadTimes = function () {
                return {
                    ...protocolInfo,
                    ...timingInfo
                }
            }
            utils.patchToString(window.chrome.loadTimes)
        }
    })();
    ;
    (function () {
        const STATIC_DATA = {
            "OnInstalledReason": {
                "CHROME_UPDATE": "chrome_update",
                "INSTALL": "install",
                "SHARED_MODULE_UPDATE": "shared_module_update",
                "UPDATE": "update"
            },
            "OnRestartRequiredReason": {
                "APP_UPDATE": "app_update",
                "OS_UPDATE": "os_update",
                "PERIODIC": "periodic"
            },
            "PlatformArch": {
                "ARM": "arm",
                "ARM64": "arm64",
                "MIPS": "mips",
                "MIPS64": "mips64",
                "X86_32": "x86-32",
                "X86_64": "x86-64"
            },
            "PlatformNaclArch": {
                "ARM": "arm",
                "MIPS": "mips",
                "MIPS64": "mips64",
                "X86_32": "x86-32",
                "X86_64": "x86-64"
            },
            "PlatformOs": {
                "ANDROID": "android",
                "CROS": "cros",
                "LINUX": "linux",
                "MAC": "mac",
                "OPENBSD": "openbsd",
                "WIN": "win"
            },
            "RequestUpdateCheckStatus": {
                "NO_UPDATE": "no_update",
                "THROTTLED": "throttled",
                "UPDATE_AVAILABLE": "update_available"
            }
        }

        if (!window.chrome) {
            // Use the exact property descriptor found in headful Chrome
            // fetch it via `Object.getOwnPropertyDescriptor(window, 'chrome')`
            Object.defineProperty(window, 'chrome', {
                writable: true,
                enumerable: true,
                configurable: false, // note!
                value: {} // We'll extend that later
            })
        }

        // That means we're running headfull and don't need to mock anything
        const existsAlready = 'runtime' in window.chrome
        // `chrome.runtime` is only exposed on secure origins
        const isNotSecure = !window.location.protocol.startsWith('https')
        if (!(existsAlready || (isNotSecure && !opts.runOnInsecureOrigins))) {
            window.chrome.runtime = {
                // There's a bunch of static data in that property which doesn't seem to change,
                // we should periodically check for updates: `JSON.stringify(window.chrome.runtime, null, 2)`
                ...STATIC_DATA,
                // `chrome.runtime.id` is extension related and returns undefined in Chrome
                get id() {
                    return undefined
                },
                // These two require more sophisticated mocks
                connect: null,
                sendMessage: null
            }

            const makeCustomRuntimeErrors = (preamble, method, extensionId) => ({
                NoMatchingSignature: new TypeError(
                    preamble + `No matching signature.`
                ),
                MustSpecifyExtensionID: new TypeError(
                    preamble +
                    `${method} called from a webpage must specify an Extension ID (string) for its first argument.`
                ),
                InvalidExtensionID: new TypeError(
                    preamble + `Invalid extension id: '${extensionId}'`
                )
            })

            // Valid Extension IDs are 32 characters in length and use the letter `a` to `p`:
            // https://source.chromium.org/chromium/chromium/src/+/master:components/crx_file/id_util.cc;drc=14a055ccb17e8c8d5d437fe080faba4c6f07beac;l=90
            const isValidExtensionID = str =>
                str.length === 32 && str.toLowerCase().match(/^[a-p]+$/)

            /** Mock `chrome.runtime.sendMessage` */
            const sendMessageHandler = {
                apply: function (target, ctx, args) {
                    const [extensionId, options, responseCallback] = args || []

                    // Define custom errors
                    const errorPreamble = `Error in invocation of runtime.sendMessage(optional string extensionId, any message, optional object options, optional function responseCallback): `
                    const Errors = makeCustomRuntimeErrors(
                        errorPreamble,
                        `chrome.runtime.sendMessage()`,
                        extensionId
                    )

                    // Check if the call signature looks ok
                    const noArguments = args.length === 0
                    const tooManyArguments = args.length > 4
                    const incorrectOptions = options && typeof options !== 'object'
                    const incorrectResponseCallback =
                        responseCallback && typeof responseCallback !== 'function'
                    if (
                        noArguments ||
                        tooManyArguments ||
                        incorrectOptions ||
                        incorrectResponseCallback
                    ) {
                        throw Errors.NoMatchingSignature
                    }

                    // At least 2 arguments are required before we even validate the extension ID
                    if (args.length < 2) {
                        throw Errors.MustSpecifyExtensionID
                    }

                    // Now let's make sure we got a string as extension ID
                    if (typeof extensionId !== 'string') {
                        throw Errors.NoMatchingSignature
                    }

                    if (!isValidExtensionID(extensionId)) {
                        throw Errors.InvalidExtensionID
                    }

                    return undefined // Normal behavior
                }
            }
            utils.mockWithProxy(
                window.chrome.runtime,
                'sendMessage',
                function sendMessage() {
                },
                sendMessageHandler
            )

            /**
             * Mock `chrome.runtime.connect`
             *
             * @see https://developer.chrome.com/apps/runtime#method-connect
             */
            const connectHandler = {
                apply: function (target, ctx, args) {
                    const [extensionId, connectInfo] = args || []

                    // Define custom errors
                    const errorPreamble = `Error in invocation of runtime.connect(optional string extensionId, optional object connectInfo): `
                    const Errors = makeCustomRuntimeErrors(
                        errorPreamble,
                        `chrome.runtime.connect()`,
                        extensionId
                    )

                    // Behavior differs a bit from sendMessage:
                    const noArguments = args.length === 0
                    const emptyStringArgument = args.length === 1 && extensionId === ''
                    if (noArguments || emptyStringArgument) {
                        throw Errors.MustSpecifyExtensionID
                    }

                    const tooManyArguments = args.length > 2
                    const incorrectConnectInfoType =
                        connectInfo && typeof connectInfo !== 'object'

                    if (tooManyArguments || incorrectConnectInfoType) {
                        throw Errors.NoMatchingSignature
                    }

                    const extensionIdIsString = typeof extensionId === 'string'
                    if (extensionIdIsString && extensionId === '') {
                        throw Errors.MustSpecifyExtensionID
                    }
                    if (extensionIdIsString && !isValidExtensionID(extensionId)) {
                        throw Errors.InvalidExtensionID
                    }

                    // There's another edge-case here: extensionId is optional so we might find a connectInfo object as first param, which we need to validate
                    const validateConnectInfo = ci => {
                        // More than a first param connectInfo as been provided
                        if (args.length > 1) {
                            throw Errors.NoMatchingSignature
                        }
                        // An empty connectInfo has been provided
                        if (Object.keys(ci).length === 0) {
                            throw Errors.MustSpecifyExtensionID
                        }
                        // Loop over all connectInfo props an check them
                        Object.entries(ci).forEach(([k, v]) => {
                            const isExpected = ['name', 'includeTlsChannelId'].includes(k)
                            if (!isExpected) {
                                throw new TypeError(
                                    errorPreamble + `Unexpected property: '${k}'.`
                                )
                            }
                            const MismatchError = (propName, expected, found) =>
                                TypeError(
                                    errorPreamble +
                                    `Error at property '${propName}': Invalid type: expected ${expected}, found ${found}.`
                                )
                            if (k === 'name' && typeof v !== 'string') {
                                throw MismatchError(k, 'string', typeof v)
                            }
                            if (k === 'includeTlsChannelId' && typeof v !== 'boolean') {
                                throw MismatchError(k, 'boolean', typeof v)
                            }
                        })
                    }
                    if (typeof extensionId === 'object') {
                        validateConnectInfo(extensionId)
                        throw Errors.MustSpecifyExtensionID
                    }

                    // Unfortunately even when the connect fails Chrome will return an object with methods we need to mock as well
                    return utils.patchToStringNested(makeConnectResponse())
                }
            }
            utils.mockWithProxy(
                window.chrome.runtime,
                'connect',
                function connect() {
                },
                connectHandler
            )

            function makeConnectResponse() {
                const onSomething = () => ({
                    addListener: function addListener() {
                    },
                    dispatch: function dispatch() {
                    },
                    hasListener: function hasListener() {
                    },
                    hasListeners: function hasListeners() {
                        return false
                    },
                    removeListener: function removeListener() {
                    }
                })

                const response = {
                    name: '',
                    sender: undefined,
                    disconnect: function disconnect() {
                    },
                    onDisconnect: onSomething(),
                    onMessage: onSomething(),
                    postMessage: function postMessage() {
                        if (!arguments.length) {
                            throw new TypeError(`Insufficient number of arguments.`)
                        }
                        throw new Error(`Attempting to use a disconnected port object`)
                    }
                }
                return response
            }
        }

    })();
    ;
    (function () {
        try {
            // Adds a contentWindow proxy to the provided iframe element
            const addContentWindowProxy = iframe => {
                const contentWindowProxy = {
                    get(target, key) {
                        // Now to the interesting part:
                        // We actually make this thing behave like a regular iframe window,
                        // by intercepting calls to e.g. `.self` and redirect it to the correct thing. :)
                        // That makes it possible for these assertions to be correct:
                        // iframe.contentWindow.self === window.top // must be false
                        if (key === 'self') {
                            return this
                        }
                        // iframe.contentWindow.frameElement === iframe // must be true
                        if (key === 'frameElement') {
                            return iframe
                        }
                        return Reflect.get(target, key)
                    }
                }

                if (!iframe.contentWindow) {
                    const proxy = new Proxy(window, contentWindowProxy)
                    Object.defineProperty(iframe, 'contentWindow', {
                        get() {
                            return proxy
                        },
                        set(newValue) {
                            return newValue // contentWindow is immutable
                        },
                        enumerable: true,
                        configurable: false
                    })
                }
            }

            // Handles iframe element creation, augments `srcdoc` property so we can intercept further
            const handleIframeCreation = (target, thisArg, args) => {
                const iframe = target.apply(thisArg, args)

                // We need to keep the originals around
                const _iframe = iframe
                const _srcdoc = _iframe.srcdoc

                // Add hook for the srcdoc property
                // We need to be very surgical here to not break other iframes by accident
                Object.defineProperty(iframe, 'srcdoc', {
                    configurable: true, // Important, so we can reset this later
                    get: function () {
                        return _iframe.srcdoc
                    },
                    set: function (newValue) {
                        addContentWindowProxy(this)
                        // Reset property, the hook is only needed once
                        Object.defineProperty(iframe, 'srcdoc', {
                            configurable: false,
                            writable: false,
                            value: _srcdoc
                        })
                        _iframe.srcdoc = newValue
                    }
                })
                return iframe
            }

            // Adds a hook to intercept iframe creation events
            const addIframeCreationSniffer = () => {
                /* global document */
                const createElementHandler = {
                    // Make toString() native
                    get(target, key) {
                        return Reflect.get(target, key)
                    },
                    apply: function (target, thisArg, args) {
                        const isIframe =
                            args && args.length && `${args[0]}`.toLowerCase() === 'iframe'
                        if (!isIframe) {
                            // Everything as usual
                            return target.apply(thisArg, args)
                        } else {
                            return handleIframeCreation(target, thisArg, args)
                        }
                    }
                }
                // All this just due to iframes with srcdoc bug
                utils.replaceWithProxy(
                    document,
                    'createElement',
                    createElementHandler
                )
            }

            // Let's go
            addIframeCreationSniffer()
        } catch (err) {
            // console.warn(err)
        }
    })();
    ;
    (function () {
        /**
         * Input might look funky, we need to normalize it so e.g. whitespace isn't an issue for our spoofing.
         *
         * @example
         * video/webm; codecs="vp8, vorbis"
         * video/mp4; codecs="avc1.42E01E"
         * audio/x-m4a;
         * audio/ogg; codecs="vorbis"
         * @param {String} arg
         */
        const parseInput = arg => {
            const [mime, codecStr] = arg.trim().split(';')
            let codecs = []
            if (codecStr && codecStr.includes('codecs="')) {
                codecs = codecStr
                    .trim()
                    .replace(`codecs="`, '')
                    .replace(`"`, '')
                    .trim()
                    .split(',')
                    .filter(x => !!x)
                    .map(x => x.trim())
            }
            return {
                mime,
                codecStr,
                codecs
            }
        }

        const canPlayType = {
            // Intercept certain requests
            apply: function (target, ctx, args) {
                if (!args || !args.length) {
                    return target.apply(ctx, args)
                }
                const { mime, codecs } = parseInput(args[0])
                // This specific mp4 codec is missing in Chromium
                if (mime === 'video/mp4') {
                    if (codecs.includes('avc1.42E01E')) {
                        return 'probably'
                    }
                }
                // This mimetype is only supported if no codecs are specified
                if (mime === 'audio/x-m4a' && !codecs.length) {
                    return 'maybe'
                }

                // This mimetype is only supported if no codecs are specified
                if (mime === 'audio/aac' && !codecs.length) {
                    return 'probably'
                }
                // Everything else as usual
                return target.apply(ctx, args)
            }
        }

        /* global HTMLMediaElement */
        utils.replaceWithProxy(
            HTMLMediaElement.prototype,
            'canPlayType',
            canPlayType
        )
    })();
    ;
    (function () {
        try {
            const proto = Object.getPrototypeOf(navigator)
            const descriptor = Object.getOwnPropertyDescriptor(proto, 'languages')

            if (descriptor && descriptor.configurable) {
                Object.defineProperty(proto, 'languages', {
                    get: () => opts.languages || ['en-US', 'en']
                })
            }
        } catch (err) {
        }

    })();
    ;
    (function () {
        const getNotificationPermission = () => {
            try {
                if (typeof Notification !== 'undefined' && Notification.permission) {
                    return Notification.permission
                }
            } catch (err) {
            }
            return 'default'
        }

        const normalizePermission = (permission) => permission === 'denied' ? 'default' : permission

        const normalizedPermission = normalizePermission(getNotificationPermission())

        try {
            if (typeof Notification !== 'undefined') {
                const descriptor = Object.getOwnPropertyDescriptor(Notification, 'permission')
                if (descriptor && descriptor.configurable) {
                    Object.defineProperty(Notification, 'permission', {
                        get: () => normalizedPermission
                    })
                }
            }
        } catch (err) {
        }

        const handler = {
            apply: function (target, ctx, args) {
                const param = (args || [])[0]

                if (param && param.name && param.name === 'notifications') {
                    const state = normalizedPermission === 'default' ? 'prompt' : normalizedPermission
                    const result = { state }
                    Object.setPrototypeOf(result, PermissionStatus.prototype)
                    return Promise.resolve(result)
                }

                return utils.cache.Reflect.apply(...arguments)
            }
        }

        utils.replaceWithProxy(
            window.navigator.permissions.__proto__, // eslint-disable-line no-proto
            'query',
            handler
        )

    })();
    ;
    (function () {
        try {
            if (opts.navigator_platform) {
                const proto = Object.getPrototypeOf(navigator)
                const descriptor = Object.getOwnPropertyDescriptor(proto, 'platform')

                if (descriptor && descriptor.configurable) {
                    Object.defineProperty(proto, 'platform', {
                        get: () => opts.navigator_platform,
                    })
                }
            }
        } catch (err) {
        }

    })();
    ;
    (function () {
        const data = {
            "mimeTypes": [
                {
                    "type": "application/pdf",
                    "suffixes": "pdf",
                    "description": "",
                    "__pluginName": "Chrome PDF Viewer"
                },
                {
                    "type": "application/x-google-chrome-pdf",
                    "suffixes": "pdf",
                    "description": "Portable Document Format",
                    "__pluginName": "Chrome PDF Plugin"
                },
                {
                    "type": "application/x-nacl",
                    "suffixes": "",
                    "description": "Native Client Executable",
                    "__pluginName": "Native Client"
                },
                {
                    "type": "application/x-pnacl",
                    "suffixes": "",
                    "description": "Portable Native Client Executable",
                    "__pluginName": "Native Client"
                }
            ],
            "plugins": [
                {
                    "name": "Chrome PDF Plugin",
                    "filename": "internal-pdf-viewer",
                    "description": "Portable Document Format",
                    "__mimeTypes": ["application/x-google-chrome-pdf"]
                },
                {
                    "name": "Chrome PDF Viewer",
                    "filename": "mhjfbmdgcfjbbpaeojofohoefgiehjai",
                    "description": "",
                    "__mimeTypes": ["application/pdf"]
                },
                {
                    "name": "Native Client",
                    "filename": "internal-nacl-plugin",
                    "description": "",
                    "__mimeTypes": ["application/x-nacl", "application/x-pnacl"]
                }
            ]
        }

        try {
            const mimeTypes = generateMagicArray(
                data.mimeTypes,
                MimeTypeArray.prototype,
                MimeType.prototype,
                'type'
            )
            const plugins = generateMagicArray(
                data.plugins,
                PluginArray.prototype,
                Plugin.prototype,
                'name'
            )

            // Plugin and MimeType cross-reference each other, let's do that now
            // Note: We're looping through `data.plugins` here, not the generated `plugins`
            for (const pluginData of data.plugins) {
                pluginData.__mimeTypes.forEach((type, index) => {
                    plugins[pluginData.name][index] = mimeTypes[type]
                    plugins[type] = mimeTypes[type]
                    Object.defineProperty(mimeTypes[type], 'enabledPlugin', {
                        value: JSON.parse(JSON.stringify(plugins[pluginData.name])),
                        writable: false,
                        enumerable: false, // Important: `JSON.stringify(navigator.plugins)`
                        configurable: false
                    })
                })
            }

            const patchNavigator = (name, value) => {
                try {
                    utils.replaceProperty(Object.getPrototypeOf(navigator), name, {
                        get() {
                            return value
                        }
                    })
                    return
                } catch (err) {
                }

                try {
                    Object.defineProperty(navigator, name, {
                        get() {
                            return value
                        }
                    })
                } catch (err) {
                }
            }

            patchNavigator('mimeTypes', mimeTypes)
            patchNavigator('plugins', plugins)
        } catch (err) {
        }

    })();
    ;
    (function () {
        // replace headless references in default useragent
        try {
            const current_ua = navigator.userAgent
            const current_app_version = navigator.appVersion
            const proto = Object.getPrototypeOf(navigator)
            const ua_descriptor = Object.getOwnPropertyDescriptor(proto, 'userAgent')
            const app_version_descriptor = Object.getOwnPropertyDescriptor(proto, 'appVersion')
            const prefix = opts.ua_patch_prefix || ''
            const suffix = opts.ua_patch_suffix || '/'
            const browser_name = String.fromCharCode(67, 104, 114, 111, 109, 101)
            const search_str = prefix + browser_name + suffix
            const replace_str = browser_name + suffix
            const patched_ua = opts.navigator_user_agent || current_ua.split(search_str).join(replace_str)
            const patched_app_version = opts.navigator_user_agent
                ? opts.navigator_user_agent.replace(/Mozilla\//, '')
                : current_app_version.split(search_str).join(replace_str)

            if (ua_descriptor && ua_descriptor.configurable) {
                Object.defineProperty(proto, 'userAgent', {
                    get: () => patched_ua
                })
            }

            if (app_version_descriptor && app_version_descriptor.configurable) {
                Object.defineProperty(proto, 'appVersion', {
                    get: () => patched_app_version
                })
            }
        } catch (err) {
        }

    })();
    ;
    (function () {
        try {
            const proto = Object.getPrototypeOf(navigator)
            const descriptor = Object.getOwnPropertyDescriptor(proto, 'vendor')

            if (descriptor && descriptor.configurable) {
                Object.defineProperty(proto, 'vendor', {
                    get: () => opts.navigator_vendor || 'Google Inc.',
                })
            }
        } catch (err) {
        }

    })();
    ;
    (function () {
        // this is close to the most accurate way to emulate this: https://stackoverflow.com/a/69533548
        Object.defineProperty(Object.getPrototypeOf(navigator), 'webdriver', {
            set: undefined,
            enumerable: true,
            configurable: true,
            get: new Proxy(
                Object.getOwnPropertyDescriptor(Object.getPrototypeOf(navigator), 'webdriver').get,
                {
                    apply: (target, thisArg, args) => {
                        // emulate getter call validation
                        Reflect.apply(target, thisArg, args);
                        return false;
                    }
                }
            )
        });
    })();
    ;
    (function () {
        'use strict'

        try {
            if (!window.outerWidth || !window.outerHeight) {
                const windowFrame = 85 // probably OS and WM dependent
                Object.defineProperty(window, 'outerWidth', {
                    get: () => window.innerWidth,
                    configurable: true
                })
                Object.defineProperty(window, 'outerHeight', {
                    get: () => window.innerHeight + windowFrame,
                    configurable: true
                })
            }
        } catch (err) {
        }

    })();
    ;
    (function () {
        const desiredVendor = opts.webgl_vendor || 'Intel Inc.'
        const desiredRenderer = opts.webgl_renderer || 'Intel Iris OpenGL Engine'

        const getParameterProxyHandler = {
            apply: function (target, ctx, args) {
                const param = (args || [])[0]
                // UNMASKED_VENDOR_WEBGL
                if (param === 37445) {
                    return desiredVendor
                }
                // UNMASKED_RENDERER_WEBGL
                if (param === 37446) {
                    return desiredRenderer
                }
                // VENDOR (7936) - may also leak GPU info
                if (param === 7936) {
                    const val = utils.cache.Reflect.apply(target, ctx, args)
                    if (val && typeof val === 'string' && /SwiftShader/i.test(val)) {
                        return desiredVendor
                    }
                    return val
                }
                // RENDERER (7937) - often contains ANGLE(...SwiftShader...) string
                if (param === 7937) {
                    const val = utils.cache.Reflect.apply(target, ctx, args)
                    if (val && typeof val === 'string' && /SwiftShader/i.test(val)) {
                        return desiredRenderer
                    }
                    return val
                }
                return utils.cache.Reflect.apply(target, ctx, args)
            }
        }

        // There's more than one WebGL rendering context
        // https://developer.mozilla.org/en-US/docs/Web/API/WebGL2RenderingContext#Browser_compatibility
        utils.replaceWithProxy(WebGLRenderingContext.prototype, 'getParameter', getParameterProxyHandler)
        utils.replaceWithProxy(WebGL2RenderingContext.prototype, 'getParameter', getParameterProxyHandler)

    })();
    ;
    (function () {
        const patchNavigator = (name, value) =>
            utils.replaceProperty(Object.getPrototypeOf(navigator), name, {
                get() {
                    return value
                }
            })

        patchNavigator('hardwareConcurrency', opts.navigator_hardware_concurrency || 4);

    })();
    ;
    (function () {
        // Fix broken image dimensions detection
        // Headless Chrome renders broken/missing images at 16x16 while real browsers use 0x0
        try {
            const originalDescNW = Object.getOwnPropertyDescriptor(HTMLImageElement.prototype, 'naturalWidth')
            const originalDescNH = Object.getOwnPropertyDescriptor(HTMLImageElement.prototype, 'naturalHeight')

            if (originalDescNW && originalDescNW.get && originalDescNW.configurable) {
                const originalGetNW = originalDescNW.get
                Object.defineProperty(HTMLImageElement.prototype, 'naturalWidth', {
                    get: function () {
                        const val = originalGetNW.call(this)
                        // If the image failed to load and shows the default broken icon (16x16),
                        // return 0 to match real browser behavior
                        if (val === 16 && !this.complete) return 0
                        if (val === 16 && this.complete && !this.naturalHeight) return 0
                        return val
                    },
                    configurable: true,
                    enumerable: true
                })
            }

            if (originalDescNH && originalDescNH.get && originalDescNH.configurable) {
                const originalGetNH = originalDescNH.get
                Object.defineProperty(HTMLImageElement.prototype, 'naturalHeight', {
                    get: function () {
                        const val = originalGetNH.call(this)
                        if (val === 16 && !this.complete) return 0
                        if (val === 16 && this.complete && !this.naturalWidth) return 0
                        return val
                    },
                    configurable: true,
                    enumerable: true
                })
            }

            // Also patch width and height getters for broken images
            const originalDescW = Object.getOwnPropertyDescriptor(HTMLImageElement.prototype, 'width')
            const originalDescH = Object.getOwnPropertyDescriptor(HTMLImageElement.prototype, 'height')

            if (originalDescW && originalDescW.get && originalDescW.configurable) {
                const originalGetW = originalDescW.get
                Object.defineProperty(HTMLImageElement.prototype, 'width', {
                    get: function () {
                        const val = originalGetW.call(this)
                        // Only patch when no explicit dimensions set and image is broken
                        if (val === 16 && !this.getAttribute('width') && !this.complete) return 0
                        return val
                    },
                    set: function (v) {
                        this.setAttribute('width', v)
                    },
                    configurable: true,
                    enumerable: true
                })
            }

            if (originalDescH && originalDescH.get && originalDescH.configurable) {
                const originalGetH = originalDescH.get
                Object.defineProperty(HTMLImageElement.prototype, 'height', {
                    get: function () {
                        const val = originalGetH.call(this)
                        if (val === 16 && !this.getAttribute('height') && !this.complete) return 0
                        return val
                    },
                    set: function (v) {
                        this.setAttribute('height', v)
                    },
                    configurable: true,
                    enumerable: true
                })
            }
        } catch (err) {
        }

    })();
    ;
    (function () {
        // Mock navigator.connection (NetworkInformation API)
        // Headless Chrome may expose missing or inconsistent connection info
        try {
            if (typeof navigator !== 'undefined') {
                const connectionData = {
                    effectiveType: '4g',
                    downlink: 10,
                    rtt: 50,
                    saveData: false,
                    type: 'wifi',
                    downlinkMax: Infinity,
                    ontypechange: null,
                    onchange: null
                }

                const connectionProto = {
                    get effectiveType() { return connectionData.effectiveType },
                    get downlink() { return connectionData.downlink },
                    get rtt() { return connectionData.rtt },
                    get saveData() { return connectionData.saveData },
                    get type() { return connectionData.type },
                    get downlinkMax() { return connectionData.downlinkMax },
                    get ontypechange() { return connectionData.ontypechange },
                    set ontypechange(v) { connectionData.ontypechange = v },
                    get onchange() { return connectionData.onchange },
                    set onchange(v) { connectionData.onchange = v },
                    addEventListener: function () { },
                    removeEventListener: function () { },
                    dispatchEvent: function () { return true }
                }

                // Make toString return [object NetworkInformation]
                const handler = {
                    get: function (target, prop) {
                        if (prop === Symbol.toStringTag) return 'NetworkInformation'
                        return target[prop]
                    }
                }

                const connection = new Proxy(connectionProto, handler)

                const proto = Object.getPrototypeOf(navigator)
                const existingDescriptor = Object.getOwnPropertyDescriptor(proto, 'connection')
                if (!existingDescriptor || existingDescriptor.configurable) {
                    Object.defineProperty(proto, 'connection', {
                        get: () => connection,
                        configurable: true,
                        enumerable: true
                    })
                }
            }
        } catch (err) {
        }

    })();
    ;
    (function () {
        // Mock navigator.deviceMemory
        // Headless Chrome may report unusual or missing device memory values
        try {
            const memoryValue = opts.navigator_device_memory || 8
            const proto = Object.getPrototypeOf(navigator)
            const descriptor = Object.getOwnPropertyDescriptor(proto, 'deviceMemory')
            if (!descriptor || descriptor.configurable) {
                Object.defineProperty(proto, 'deviceMemory', {
                    get: () => memoryValue,
                    configurable: true,
                    enumerable: true
                })
            }
        } catch (err) {
        }

    })();
    ;
    (function () {
        // Mock speechSynthesis.getVoices()
        // Headless Chrome returns empty voices array, real browsers have system voices
        try {
            if (typeof window !== 'undefined' && window.speechSynthesis) {
                const defaultVoices = [
                    { voiceURI: 'Alex', name: 'Alex', lang: 'en-US', localService: true, default: true },
                    { voiceURI: 'Samantha', name: 'Samantha', lang: 'en-US', localService: true, default: false },
                    { voiceURI: 'Daniel', name: 'Daniel', lang: 'en-GB', localService: true, default: false },
                    { voiceURI: 'Google US English', name: 'Google US English', lang: 'en-US', localService: false, default: false },
                    { voiceURI: 'Google UK English Female', name: 'Google UK English Female', lang: 'en-GB', localService: false, default: false }
                ]

                // Create proper SpeechSynthesisVoice-like objects
                const voices = defaultVoices.map(v => {
                    const voice = Object.create(null)
                    Object.defineProperties(voice, {
                        voiceURI: { get: () => v.voiceURI, enumerable: true },
                        name: { get: () => v.name, enumerable: true },
                        lang: { get: () => v.lang, enumerable: true },
                        localService: { get: () => v.localService, enumerable: true },
                        default: { get: () => v.default, enumerable: true }
                    })
                    return voice
                })

                const originalGetVoices = window.speechSynthesis.getVoices.bind(window.speechSynthesis)

                window.speechSynthesis.getVoices = function () {
                    const realVoices = originalGetVoices()
                    if (realVoices && realVoices.length > 0) {
                        return realVoices
                    }
                    return voices
                }

                // Ensure toString looks native
                try {
                    utils.patchToString(window.speechSynthesis.getVoices, 'function getVoices() { [native code] }')
                } catch (e) { }
            }
        } catch (err) {
        }

    })();
    ;
    (function () {
        // Ensure screen dimensions are consistent and realistic
        // Headless Chrome may report 0 or inconsistent screen values
        try {
            const screenWidth = opts.screen_width || window.innerWidth || 1920
            const screenHeight = opts.screen_height || window.innerHeight || 1080
            const colorDepth = opts.screen_color_depth || 24
            const pixelDepth = opts.screen_pixel_depth || 24

            const screenProps = {
                width: { value: screenWidth, writable: false },
                height: { value: screenHeight, writable: false },
                availWidth: { value: screenWidth, writable: false },
                availHeight: { value: screenHeight - 40, writable: false }, // taskbar offset
                colorDepth: { value: colorDepth, writable: false },
                pixelDepth: { value: pixelDepth, writable: false }
            }

            for (const [prop, config] of Object.entries(screenProps)) {
                const descriptor = Object.getOwnPropertyDescriptor(Screen.prototype, prop) ||
                    Object.getOwnPropertyDescriptor(screen, prop)
                if (!descriptor || descriptor.configurable || descriptor.writable) {
                    try {
                        Object.defineProperty(Screen.prototype, prop, {
                            get: () => config.value,
                            configurable: true,
                            enumerable: true
                        })
                    } catch (e) {
                        // Fallback: try setting on screen directly
                        try {
                            Object.defineProperty(screen, prop, {
                                get: () => config.value,
                                configurable: true,
                                enumerable: true
                            })
                        } catch (e2) { }
                    }
                }
            }
        } catch (err) {
        }

    })();
    ;
    (function () {
        // Mask Chrome DevTools Protocol (CDP) traces
        // Bot detectors check for CDP Runtime.enable, Debugger.enable and other fingerprints
        try {
            // Remove the Runtime.enable signature that CDP leaves behind
            // CDP injects a binding that can be detected
            const cdpBindings = [
                '__cdp_binding__',
                '__playwright_binding__',
                '__puppeteer_evaluation_script__'
            ]
            for (const binding of cdpBindings) {
                try {
                    if (typeof window[binding] !== 'undefined') {
                        delete window[binding]
                    }
                } catch (e) { }
            }

            // Mask the Debugger detection via Error stack traces
            // CDP leaves traces in error stack that mention DevTools protocol
            const originalError = Error
            const originalCaptureStackTrace = Error.captureStackTrace
            if (originalCaptureStackTrace) {
                Error.captureStackTrace = function (targetObject, constructorOpt) {
                    originalCaptureStackTrace.call(Error, targetObject, constructorOpt)
                    if (targetObject && targetObject.stack) {
                        // Remove any CDP/DevTools references from stack traces
                        targetObject.stack = targetObject.stack
                            .split('\n')
                            .filter(line => {
                                const lower = line.toLowerCase()
                                return !lower.includes('devtools') &&
                                    !lower.includes('__puppeteer') &&
                                    !lower.includes('__playwright') &&
                                    !lower.includes('__cdp')
                            })
                            .join('\n')
                    }
                }
                try {
                    utils.patchToString(Error.captureStackTrace, 'function captureStackTrace() { [native code] }')
                } catch (e) { }
            }

            // Prevent detection via console._commandLineAPI or console.__proto__
            // CDP exposes extra console methods
            try {
                if (console._commandLineAPI) {
                    delete console._commandLineAPI
                }
            } catch (e) { }

            // Mask window.Playwright detection
            try {
                if (typeof window.__playwright !== 'undefined') {
                    delete window.__playwright
                }
                if (typeof window.__pw_manual !== 'undefined') {
                    delete window.__pw_manual
                }
            } catch (e) { }

            // Override the prototype chain for Runtime.enable detection
            // Some detectors check if certain native functions have been modified by CDP
            try {
                const nativeFunctionStr = 'function () { [native code] }'
                const functionsToCheck = [
                    'console.log',
                    'console.warn',
                    'console.error',
                    'console.info',
                    'console.debug'
                ]
                // Ensure console functions look native
                for (const funcPath of functionsToCheck) {
                    const parts = funcPath.split('.')
                    const obj = parts[0] === 'console' ? console : window
                    const method = parts[1]
                    if (obj[method] && typeof obj[method] === 'function') {
                        try {
                            utils.patchToString(obj[method])
                        } catch (e) { }
                    }
                }
            } catch (e) { }
        } catch (err) {
        }

    })();
    ;
    (function () {
        // Remove automation-specific global properties
        // ChromeDriver, Puppeteer, Playwright and other tools leave detectable markers
        try {
            // ChromeDriver markers (cdc_ prefixed)
            const windowKeys = Object.getOwnPropertyNames(window)
            for (const key of windowKeys) {
                if (/^cdc_/.test(key) || /^__webdriver/.test(key) || /^__selenium/.test(key) ||
                    /^__fxdriver/.test(key) || /^__autonium/.test(key) ||
                    /^calledSelenium/.test(key) || /^_phantom/.test(key) ||
                    /^_WEBDRIVER_ELEM/.test(key) || /^webdriver/.test(key)) {
                    try {
                        delete window[key]
                    } catch (e) {
                        try {
                            Object.defineProperty(window, key, { value: undefined, configurable: true })
                        } catch (e2) { }
                    }
                }
            }

            // Document markers
            try {
                const docKeys = Object.getOwnPropertyNames(document)
                for (const key of docKeys) {
                    if (/^\$cdc_/.test(key) || /^__webdriver/.test(key) ||
                        /^__driver/.test(key) || /^__selenium/.test(key)) {
                        try {
                            delete document[key]
                        } catch (e) {
                            try {
                                Object.defineProperty(document, key, { value: undefined, configurable: true })
                            } catch (e2) { }
                        }
                    }
                }
            } catch (e) { }

            // Remove domAutomation and domAutomationController
            try {
                if (typeof window.domAutomation !== 'undefined') {
                    delete window.domAutomation
                }
                if (typeof window.domAutomationController !== 'undefined') {
                    delete window.domAutomationController
                }
            } catch (e) { }

            // Intercept future property additions (protect against runtime injection)
            const automationPatterns = /^(cdc_|\$cdc_|__webdriver|__selenium|__fxdriver|__playwright|__puppeteer|domAutomation)/

            // Use a MutationObserver to clean up dynamically added automation properties
            try {
                const cleanAutomationProps = () => {
                    const keys = Object.getOwnPropertyNames(window)
                    for (const key of keys) {
                        if (automationPatterns.test(key)) {
                            try { delete window[key] } catch (e) { }
                        }
                    }
                }
                // Run cleanup periodically during page load
                const cleanupInterval = setInterval(cleanAutomationProps, 50)
                setTimeout(() => clearInterval(cleanupInterval), 5000)
            } catch (e) { }
        } catch (err) {
        }

    })();
    ;
    (function () {
        // Mock navigator.maxTouchPoints
        // Headless Chrome returns 0 for maxTouchPoints, real desktop browsers return 0-1
        // but many detection scripts flag 0 as suspicious on platforms that should support touch
        try {
            const touchPoints = opts.max_touch_points !== undefined ? opts.max_touch_points : 1
            const proto = Object.getPrototypeOf(navigator)
            const descriptor = Object.getOwnPropertyDescriptor(proto, 'maxTouchPoints')
            if (!descriptor || descriptor.configurable) {
                Object.defineProperty(proto, 'maxTouchPoints', {
                    get: () => touchPoints,
                    configurable: true,
                    enumerable: true
                })
            }

            // Also ensure ontouchstart is not present on desktop (consistent with maxTouchPoints=1)
            // Desktop Chrome with touch support has maxTouchPoints >= 1 but no ontouchstart
        } catch (err) {
        }

    })();
    ;
    (function () {
        // Add subtle noise to canvas fingerprinting
        // Headless Chrome produces identical canvas fingerprints every time
        // Real browsers have slight variations due to GPU rendering differences
        try {
            const originalToDataURL = HTMLCanvasElement.prototype.toDataURL
            const originalToBlob = HTMLCanvasElement.prototype.toBlob
            const originalGetImageData = CanvasRenderingContext2D.prototype.getImageData

            // Generate a session-stable noise seed so fingerprint is consistent within session
            // but different across sessions (like a real browser)
            const noiseSeed = Math.floor(Math.random() * 256)

            // Simple hash function for deterministic noise based on pixel position
            const noise = (x, y, channel) => {
                const n = ((x * 374761393 + y * 668265263 + channel * 1274126177 + noiseSeed) & 0x7fffffff)
                return (n % 3) - 1 // returns -1, 0, or 1
            }

            CanvasRenderingContext2D.prototype.getImageData = function (sx, sy, sw, sh) {
                const imageData = originalGetImageData.call(this, sx, sy, sw, sh)
                // Only apply noise to canvases that look like fingerprint attempts
                // (small canvases used for fingerprinting, not large ones used for rendering)
                if (sw * sh < 500 * 500) {
                    const data = imageData.data
                    for (let i = 0; i < data.length; i += 4) {
                        const pixelIdx = i / 4
                        const x = pixelIdx % sw
                        const y = Math.floor(pixelIdx / sw)
                        // Apply tiny noise to RGB channels (not alpha)
                        data[i] = Math.max(0, Math.min(255, data[i] + noise(x, y, 0)))
                        data[i + 1] = Math.max(0, Math.min(255, data[i + 1] + noise(x, y, 1)))
                        data[i + 2] = Math.max(0, Math.min(255, data[i + 2] + noise(x, y, 2)))
                    }
                }
                return imageData
            }

            HTMLCanvasElement.prototype.toDataURL = function () {
                const ctx = this.getContext('2d')
                if (ctx && this.width * this.height < 500 * 500) {
                    // Trigger getImageData noise by reading and writing back
                    try {
                        const imageData = originalGetImageData.call(ctx, 0, 0, this.width, this.height)
                        const data = imageData.data
                        for (let i = 0; i < data.length; i += 4) {
                            const pixelIdx = i / 4
                            const x = pixelIdx % this.width
                            const y = Math.floor(pixelIdx / this.width)
                            data[i] = Math.max(0, Math.min(255, data[i] + noise(x, y, 0)))
                            data[i + 1] = Math.max(0, Math.min(255, data[i + 1] + noise(x, y, 1)))
                            data[i + 2] = Math.max(0, Math.min(255, data[i + 2] + noise(x, y, 2)))
                        }
                        ctx.putImageData(imageData, 0, 0)
                    } catch (e) { }
                }
                return originalToDataURL.apply(this, arguments)
            }

            HTMLCanvasElement.prototype.toBlob = function (callback, type, quality) {
                const ctx = this.getContext('2d')
                if (ctx && this.width * this.height < 500 * 500) {
                    try {
                        const imageData = originalGetImageData.call(ctx, 0, 0, this.width, this.height)
                        const data = imageData.data
                        for (let i = 0; i < data.length; i += 4) {
                            const pixelIdx = i / 4
                            const x = pixelIdx % this.width
                            const y = Math.floor(pixelIdx / this.width)
                            data[i] = Math.max(0, Math.min(255, data[i] + noise(x, y, 0)))
                            data[i + 1] = Math.max(0, Math.min(255, data[i + 1] + noise(x, y, 1)))
                            data[i + 2] = Math.max(0, Math.min(255, data[i + 2] + noise(x, y, 2)))
                        }
                        ctx.putImageData(imageData, 0, 0)
                    } catch (e) { }
                }
                return originalToBlob.call(this, callback, type, quality)
            }

            try {
                utils.patchToString(CanvasRenderingContext2D.prototype.getImageData)
                utils.patchToString(HTMLCanvasElement.prototype.toDataURL)
                utils.patchToString(HTMLCanvasElement.prototype.toBlob)
            } catch (e) { }
        } catch (err) {
        }

    })();
    ;
    (function () {
        // Add subtle jitter to performance.now() and Date.now()
        // Headless Chrome provides too-precise timing; real browsers have OS-level variance
        try {
            const originalPerformanceNow = Performance.prototype.now

            Performance.prototype.now = function () {
                const val = originalPerformanceNow.call(this)
                // Add ±0.1ms jitter (real browsers have this from OS scheduling)
                const jitter = (Math.random() - 0.5) * 0.2
                return val + jitter
            }

            try {
                utils.patchToString(Performance.prototype.now)
            } catch (e) { }

            // Also add jitter to requestAnimationFrame timestamps
            const originalRAF = window.requestAnimationFrame
            if (originalRAF) {
                window.requestAnimationFrame = function (callback) {
                    return originalRAF.call(window, function (timestamp) {
                        // Add ±0.5ms jitter to rAF timestamp
                        const jitter = (Math.random() - 0.5) * 1.0
                        callback(timestamp + jitter)
                    })
                }
                try {
                    utils.patchToString(window.requestAnimationFrame)
                } catch (e) { }
            }
        } catch (err) {
        }

    })();
    ;
    (function () {
        // Ensure navigator.pdfViewerEnabled returns true
        // Headless Chrome may report false or undefined for PDF viewer support
        try {
            const proto = Object.getPrototypeOf(navigator)
            const descriptor = Object.getOwnPropertyDescriptor(proto, 'pdfViewerEnabled')
            if (!descriptor || descriptor.configurable) {
                Object.defineProperty(proto, 'pdfViewerEnabled', {
                    get: () => true,
                    configurable: true,
                    enumerable: true
                })
            }
        } catch (err) {
        }

    })();
    ;
    (function () {
        // Add noise to AudioContext fingerprinting
        // Headless Chrome produces identical audio fingerprints across sessions
        try {
            if (typeof AudioContext !== 'undefined' || typeof webkitAudioContext !== 'undefined') {
                const AudioCtx = typeof AudioContext !== 'undefined' ? AudioContext : webkitAudioContext

                // Session-stable noise for consistent fingerprint within session
                const audioNoiseSeed = Math.random() * 0.0001

                const originalCreateAnalyser = AudioCtx.prototype.createAnalyser
                if (originalCreateAnalyser) {
                    AudioCtx.prototype.createAnalyser = function () {
                        const analyser = originalCreateAnalyser.call(this)
                        const originalGetFloatFrequencyData = analyser.getFloatFrequencyData.bind(analyser)
                        const originalGetByteFrequencyData = analyser.getByteFrequencyData.bind(analyser)

                        analyser.getFloatFrequencyData = function (array) {
                            originalGetFloatFrequencyData(array)
                            // Add tiny noise to frequency data
                            for (let i = 0; i < array.length; i++) {
                                array[i] = array[i] + (audioNoiseSeed * (i % 7))
                            }
                        }

                        analyser.getByteFrequencyData = function (array) {
                            originalGetByteFrequencyData(array)
                            for (let i = 0; i < array.length; i++) {
                                const n = Math.floor(audioNoiseSeed * 1000000 * (i % 13)) % 2
                                array[i] = Math.max(0, Math.min(255, array[i] + n))
                            }
                        }

                        return analyser
                    }
                    try {
                        utils.patchToString(AudioCtx.prototype.createAnalyser)
                    } catch (e) { }
                }

                // Patch getChannelData to add slight noise
                if (typeof AudioBuffer !== 'undefined') {
                    const originalGetChannelData = AudioBuffer.prototype.getChannelData
                    AudioBuffer.prototype.getChannelData = function (channel) {
                        const data = originalGetChannelData.call(this, channel)
                        // Only add noise to small buffers (fingerprinting uses short samples)
                        if (data.length < 50000) {
                            for (let i = 0; i < data.length; i++) {
                                data[i] = data[i] + (audioNoiseSeed * ((i * 7 + channel) % 11) * 0.00001)
                            }
                        }
                        return data
                    }
                    try {
                        utils.patchToString(AudioBuffer.prototype.getChannelData)
                    } catch (e) { }
                }
            }

            // Also handle OfflineAudioContext
            if (typeof OfflineAudioContext !== 'undefined') {
                const originalStartRendering = OfflineAudioContext.prototype.startRendering
                if (originalStartRendering) {
                    OfflineAudioContext.prototype.startRendering = function () {
                        return originalStartRendering.call(this).then(function (buffer) {
                            // The AudioBuffer.getChannelData patch above will handle noise
                            return buffer
                        })
                    }
                    try {
                        utils.patchToString(OfflineAudioContext.prototype.startRendering)
                    } catch (e) { }
                }
            }
        } catch (err) {
        }

    })();
    ;
})();
'@

            $context.AddInitScriptAsync($stealthScript).GetAwaiter().GetResult()

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
                            $StatusCode = [int]($response.StatusCode)
                            $StatusMessage = $response.StatusDescription
                        } catch {
                            # Check if this specific error is a Throttling (429) error
                            if ($_.Exception.Response.StatusCode -eq 429 -or $_.ToString() -ilike '*Too many requests*') {
                                $isThrottled = $true
                            } else {
                                # If not throttled, try the GET fallback
                                try {
                                    $response = Invoke-WebRequest -Method Get -Uri $url -UseBasicParsing -Timeout 10 -ErrorAction Stop
                                    $StatusCode = [int]($response.StatusCode)
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
                                Write-Verbose "  $($WorkerIdString) $($url) Content-Type '$($response.Headers['Content-Type'])' does not contain 'text/html'"

                                $null = ($using:PageData).TryAdd(
                                    $url,
                                    @{
                                        IdsAndNames   = $CurrentPageIds
                                        StatusCode    = [int]$StatusCode
                                        StatusMessage = "Content-Type '$($response.Headers['Content-Type'])' does not contain 'text/html'"
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
                                            StatusCode    = [int]$StatusCode
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

                        $PlaywrightBrowserPage = $context.NewPageAsync().GetAwaiter().GetResult()

                        try {
                            Open-PlaywrightPageUrl -Page $PlaywrightBrowserPage -Url $url

                            $StatusCode = [int](Invoke-PlaywrightPageJavascript -Page $PlaywrightBrowserPage -Expression "(performance.getEntriesByType('navigation')[0]?.responseStatus || 0) | 0")
                            $StatusMessage = [System.Net.HttpStatusCode]$StatusCode
                        } catch {
                            Start-Sleep -Seconds 5

                            try {
                                Open-PlaywrightPageUrl -Page $PlaywrightBrowserPage -Url $url

                                $StatusCode = [int](Invoke-PlaywrightPageJavascript -Page $PlaywrightBrowserPage -Expression "(performance.getEntriesByType('navigation')[0]?.responseStatus || 0) | 0")
                                $StatusMessage = [System.Net.HttpStatusCode]$StatusCode
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
                                    StatusCode    = [int]$StatusCode
                                    StatusMessage = $StatusMessage
                                }
                            )

                            continue
                        }

                        Write-Verbose "  $($WorkerIdString) $($url) Wait for DOM stability"
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

                            if ($stable -ge 2) { break }
                            $last = $count
                            Start-Sleep -Milliseconds 500
                        }

                        Write-Verbose "  $($WorkerIdString) $($url) Extracting Links and IDs via JavaScript"

                        # Determine if we need fragments based on your variables
                        $shouldFetchFragments = ($using:CheckFragments -eq $true) -and `
                            !(($using:CheckFragmentsInternalOnly -eq $true) -and ($urlIsInternal -eq $false))

                        # Pass the fragment requirement to JS
                        $jsExpression = @"
(() => {
    const results = {
        links: [],
        idsAndNames: []
    };

    const fetchFragments = $($shouldFetchFragments.ToString().ToLower());
    const visited = new WeakSet();

    function processTree(root) {
        // 1. Extract Attributes (Links/Resources)
        // CSS Selector uses [attr], NOT [@attr]
        const selector = '[href], [src], [data-href], [srcset], [data-src], [data-srcset], [action], [poster], [cite]';
        const nodes = root.querySelectorAll(selector);

        nodes.forEach(node => {
            // Single URL attributes
            ['href', 'src', 'data-href', 'data-src', 'action', 'poster', 'cite'].forEach(attr => {
                const val = node.getAttribute(attr);
                if (val) {
                    results.links.push([attr, val]);
                }
            });

            // Set attributes (srcset)
            ['srcset', 'data-srcset'].forEach(attr => {
                const val = node.getAttribute(attr);
                if (val) {
                    val.split(',').forEach(entry => {
                        const parts = entry.trim().split(/\s+/);
                        if (parts[0]) {
                            results.links.push([attr, parts[0]]);
                        }
                    });
                }
            });
        });

        // 2. Extract IDs and Names for fragment checking
        if (fetchFragments) {
            const fragNodes = root.querySelectorAll('[id], [name]');
            fragNodes.forEach(node => {
                if (node.id) results.idsAndNames.push(node.id);
                const name = node.getAttribute('name');
                if (name) results.idsAndNames.push(name);
            });
        }

        // 3. Recurse into Shadow DOM
        const allElements = root.querySelectorAll('*');
        allElements.forEach(el => {
            if (el.shadowRoot && !visited.has(el.shadowRoot)) {
                visited.add(el.shadowRoot);
                processTree(el.shadowRoot);
            }
        });
    }

    processTree(document);

    // Unique IDs to reduce payload size
    results.idsAndNames = [...new Set(results.idsAndNames)];

    return results;
})();
"@

                        # Execute the JS
                        $extractionResult = Invoke-PlaywrightPageJavascript -Page $PlaywrightBrowserPage -Expression $jsExpression

                        # Fill the PowerShell arrays
                        $hrefs = @()
                        if ($extractionResult.links) {
                            # Ensure nested arrays are treated correctly in PS
                            foreach ($linkPair in $extractionResult.links) {
                                $hrefs += , @($linkPair[0], $linkPair[1])
                            }
                        }

                        $IdsAndNames = @()
                        if ($extractionResult.idsAndNames) {
                            $IdsAndNames = $extractionResult.idsAndNames | Sort-Object -Culture 127 -Unique
                        }

                        # Cleanup
                        if ($PlaywrightBrowserPage) {
                            Close-PlaywrightPage -Page $PlaywrightBrowserPage
                            $PlaywrightBrowserPage = $null
                        }

                        if ($urlIsInternal) {
                            foreach ($href in $hrefs) {
                                Write-Verbose "  $($WorkerIdString) $($url) Found '$($href[0])' '$($href[1])'"

                                try {
                                    $hrefAbsolute = StandardizeAbsoluteUrl -InputString ([System.Uri]::new([uri]$url, $href[1])).AbsoluteUri -IncludeFragment $true
                                } catch {
                                    Write-Verbose "  $($WorkerIdString) $($url) href '$($href)' not convertible to AbsoluteUri: $($_)"

                                    $hrefAbsolute = $null
                                }

                                if (
                                    $hrefAbsolute -and
                                    (([uri]$hrefAbsolute).Scheme -iin @('http', 'https'))
                                ) {
                                    Write-Verbose "  $($WorkerIdString) $($url) Enqueue '$($href[1])' as '$(StandardizeAbsoluteUrl -InputString $hrefAbsolute -IncludeFragment $false)'"

                                    ($using:Queue).Enqueue((StandardizeAbsoluteUrl -InputString $hrefAbsolute -IncludeFragment $false))
                                } else {
                                    Write-Verbose "  $($WorkerIdString) $($url) Do not enqueue '$($href[1])' as '$($hrefAbsolute)'"
                                }


                                # Add to the global map: Key is the target, Value is a list of where it's used
                                ($using:ReferenceMap).GetOrAdd(
                                    $(if (-not [string]::IsNullOrWhiteSpace($hrefAbsolute)) { $hrefAbsolute } else { $href[1] }),
                                    [System.Collections.Concurrent.ConcurrentBag[object]]::new()
                                ).Add(
                                    @{
                                        SourcePage   = $url
                                        Attribute    = $href[0]
                                        OriginalHref = $href[1]
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
                                StatusCode    = [int]$StatusCode
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
} catch {
    Write-Host "Unexpected error affecting the whole script: $($_ | Format-List * | Out-String)" -ForegroundColor Red
} finally {
    Write-Host
    Write-Host 'Statistics'
    $timespan = (Get-Date) - $StartTime
    Write-Host "  Total execution time                         : $('{0} hours, {1} minutes, {2} seconds' -f $timespan.Hours, $timespan.Minutes, $timespan.Seconds)"
    Write-Host "  Hosts visited                                : $(@(@(@($PageData.Keys) | ForEach-Object { $tempX = $_; try { ([uri]$tempX).Host } catch { $tempX } }) | Select-Object -Unique).Count)"
    Write-Host "  Pages visited                                : $($PageData.Count)"
    Write-Host "  IDs and Names found on pages                 : $(@($PageData.Values | ForEach-Object { @($_.IdsAndNames) }).Count)"
    Write-Host "  References found                             : $(@($ReferenceMap.Values.ForEach({ $_.OriginalHref })).Count)"
    Write-Host "  Unique absolute URLs referenced              : $($ReferenceMap.Count)"
    Write-Host "  Unique absolute URLs referenced w/o fragment : $(@(@($ReferenceMap.Keys | ForEach-Object { try { $tempX = $_; StandardizeAbsoluteUrl -InputString $tempX -IncludeFragment $false } catch { $tempX } }) | Select-Object -Unique).Count)"


    Write-Host
    Write-Host 'Export scan results for later use'
    if (-not [String]::IsNullOrWhiteSpace($ExportFile)) {
        Write-Host "  '$($ExportFile)'"

        @{
            StartUrl     = $StartUrl
            SitemapUrl   = $Sitemapurl
            StartDomain  = $StartDomain
            PageData     = $PageData
            ReferenceMap = $ReferenceMap
        } | Export-Clixml -Path $ExportFile -Force
    } else {
        Write-Host '  No ExportFile defined'
    }


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


    # Allow sleep
    try { BlockSleep -AllowSleep } catch {}


    Write-Host
    Write-Host 'End script'
}