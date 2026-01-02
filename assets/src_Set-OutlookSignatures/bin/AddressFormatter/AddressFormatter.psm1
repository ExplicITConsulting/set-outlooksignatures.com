# This function is the new, exported entry point
function Format-PostalAddress {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][hashtable]$Components,

        # Optional individual options (will be merged with -Options if provided)
        [string]$Country,
        [switch]$Abbreviate,
        [string]$AddressTemplate,
        [Nullable[bool]]$OnlyAddress,

        # Perl-like options hashtable { country, abbreviate, address_template, only_address }
        [hashtable]$Options
    )

    # All logic is delegated to the internal, original function name for simplicity
    return (Format-PostalAddressInternal -Components $Components -Country $Country -Abbreviate:$Abbreviate -AddressTemplate $AddressTemplate -OnlyAddress $OnlyAddress -Options $Options)
}


# ---------------------------------------------------------------------------------
# Internal functions and variables (Not exported, only available within the module)
# ---------------------------------------------------------------------------------

# The original function is renamed to keep the module entry point clean
function Format-PostalAddressInternal {
    # Original Format-PostalAddress logic goes here...
    param(
        [Parameter(Mandatory, Position = 0)][hashtable]$Components,

        # Optional individual options (will be merged with -Options if provided)
        [string]$Country,
        [switch]$Abbreviate,
        [string]$AddressTemplate,
        [Nullable[bool]]$OnlyAddress,

        # Perl-like options hashtable { country, abbreviate, address_template, only_address }
        [hashtable]$Options
    )

    $rh_components = Clone-Deep $Components
    if (-not $rh_components) { return $null }

    # Reset final components at start
    $Script:AddrFmt.FinalComponents = $null

    # Merge options
    $opt = @{}
    if ($Options) { $opt = Clone-Deep $Options }
    if ($PSBoundParameters.ContainsKey('Country')) { $opt['country'] = $Country }
    if ($PSBoundParameters.ContainsKey('Abbreviate')) { $opt['abbreviate'] = [int][bool]$Abbreviate }
    if ($PSBoundParameters.ContainsKey('AddressTemplate')) { $opt['address_template'] = $AddressTemplate }
    if ($PSBoundParameters.ContainsKey('OnlyAddress')) { $opt['only_address'] = $OnlyAddress }

    # Determine country code
    $cc = $null
    if ($opt.ContainsKey('country') -and $opt['country']) {
        $cc = $opt['country']
        $rh_components['country_code'] = $cc
        Set-DistrictAlias -CountryCode $cc
    } else {
        $cc = Determine-CountryCode -Components $rh_components
        if ($cc) {
            $rh_components['country_code'] = $cc
            Set-DistrictAlias -CountryCode $cc
        }
    }

    # Abbreviate flag
    $abbrv = 0
    if ($opt.ContainsKey('abbreviate')) { $abbrv = [int]$opt['abbreviate'] }

    # OnlyAddress (call-level overrides object-level)
    $oa = $Script:AddrFmt.OnlyAddress
    if ($opt.ContainsKey('only_address')) { $oa = [bool]$opt['only_address'] }

    # 1) Sanity-cleaning
    Invoke-SanityCleaning -Components $rh_components

    # 2) Apply component aliases into primary types
    Resolve-PrimaryAliases -Components $rh_components

    # 3) Determine template (robust, with layered fallback; last-resort built-in)
    $templateText = $null
    $rh_config = $null
    $defaultConfig = $null
    if ($Script:AddrFmt.Templates.ContainsKey('default')) {
        $defaultConfig = $Script:AddrFmt.Templates['default']
    }

    if ($cc) {
        $rh_config = $Script:AddrFmt.Templates[$cc]
    }
    if (-not $rh_config) { $rh_config = $defaultConfig }

    if ($opt.ContainsKey('address_template') -and $opt['address_template']) {
        $templateText = [string]$opt['address_template']
    }
    if ([string]::IsNullOrWhiteSpace($templateText) -and $rh_config -and $rh_config.address_template) {
        $templateText = [string]$rh_config.address_template
    }
    # If still empty, try country fallback_template
    if ([string]::IsNullOrWhiteSpace($templateText) -and $rh_config -and $rh_config.fallback_template) {
        $templateText = [string]$rh_config.fallback_template
    }
    # If still empty, try default address_template
    if ([string]::IsNullOrWhiteSpace($templateText) -and $defaultConfig -and $defaultConfig.address_template) {
        $templateText = [string]$defaultConfig.address_template
    }
    # If still empty and minimal components are missing, try default fallback_template
    if ([string]::IsNullOrWhiteSpace($templateText) -and $defaultConfig -and $defaultConfig.fallback_template) {
        $templateText = [string]$defaultConfig.fallback_template
    }

    # Last-resort: keep the formatter functional even if the config is pathological
    if ([string]::IsNullOrWhiteSpace($templateText)) {
        $templateText = @'
{{#first}}
{{{attention}}}
{{/first}}
{{#first}}
{{{house}}}{{{house_number}}} {{{road}}}
{{/first}}
{{#first}}
{{{postcode}}} {{{city}}}
{{/first}}
{{#first}}
{{{state}}}
{{/first}}
{{#first}}
{{{country}}}
{{/first}}
'@
        Warn-If 'Using built-in last-resort template because config provided no address/fallback template.'
    }

    # Prefer configured fallback when minimal components are missing
    $haveMinimal = Test-MinimalComponents -Components $rh_components
    if (-not $haveMinimal -and $rh_config -and $rh_config.fallback_template) {
        $templateText = [string]$rh_config.fallback_template
    } elseif (-not $haveMinimal -and $defaultConfig -and $defaultConfig.fallback_template) {
        $templateText = [string]$defaultConfig.fallback_template
    }

    # 4) Fix country hacks
    Fix-Country -Components $rh_components

    # 5) Apply replacements (pre-render)
    if ($rh_config -and $rh_config.replace) {
        Apply-Replacements -Components $rh_components -Rules $rh_config.replace
    }

    # 6) Add state/county codes
    Add-StateCode -Components $rh_components | Out-Null
    Add-CountyCode -Components $rh_components | Out-Null

    # 7) Unknown components -> attention (unless only_address)
    if (-not $oa) {
        $unknown = Find-UnknownComponents -Components $rh_components
        if ($unknown.Count -gt 0) {
            $sorted = $unknown | Sort-Object
            $vals = foreach ($k in $sorted) { $rh_components[$k] }
            $rh_components['attention'] = ($vals -join ', ')
        }
    }

    # 8) Abbreviate if requested
    if ($abbrv) {
        $tmp = Invoke-Abbreviate -Components $rh_components
        if ($tmp) { $rh_components = $tmp }
    }

    # 9) Prepare template (replace lambda)
    $templateText = Replace-TemplateLambdas -TemplateText $templateText
    # 10) Render
    $rendered = Render-Mustache -Template $templateText -Context $rh_components
    $rendered = Evaluate-TemplateLambdas -Rendered $rendered

    # 11) Postformat replacements and duplicate removal
    $rendered = Invoke-Postformat -Text $rendered -Rules $rh_config.postformat_replace

    # 12) Line-by-line clean (using \s, no multiline \h)
    $rendered = Invoke-Clean -Text $rendered

    # 13) If empty and only one component exists, use that value (Perl behavior)
    if ($rendered.Length -eq 0) {
        $keys = $rh_components.Keys
        if ($keys.Count -eq 1) {
            $k = $keys | Select-Object -First 1
            $rendered = [string]$rh_components[$k]
        }
    }

    # 14) Set final components
    $Script:AddrFmt.FinalComponents = $rh_components

    return $rendered
}


$Script:AddrFmt = @{
    Templates         = @{}   # country templates + default
    ComponentAliases  = @{}   # primary -> [aliases]
    Component2Type    = @{}   # alias -> primary
    OrderedComponents = @()   # [ primary1, alias1a, alias1b, primary2, ... ]
    HKnown            = @{}   # set of known component keys
    State_Codes       = @{}   # country_code -> map
    County_Codes      = @{}   # country_code -> map
    Country2Lang      = @{}   # country_code -> "en,de"
    Abbreviations     = @{}   # lang -> component -> (long -> short)
    SetDistrictAlias  = @{}   # cache to avoid rework
    FinalComponents   = $null # set after successful Format-PostalAddress

    ShowWarnings      = $true
    OnlyAddress       = $false

    ConfPath          = $null
}

# Countries where plain "district" should be treated as "neighbourhood" (small district)
$Script:SmallDistrict = @{
    'BR' = 1; 'CR' = 1; 'ES' = 1; 'NI' = 1; 'PY' = 1; 'RO' = 1; 'TG' = 1; 'TM' = 1; 'XK' = 1
}

# ------------------------------
# Utility helpers
# ------------------------------

function Warn-If {
    param([string]$Message)
    if ($Script:AddrFmt.ShowWarnings) { Write-Warning $Message }
}

function Throw-IfNullOrMissingPath {
    param([string]$Path, [string]$What)
    if ([string]::IsNullOrWhiteSpace($Path) -or -not (Test-Path -LiteralPath $Path)) {
        throw "Missing $What at '$Path'."
    }
}

function Clone-Deep {
    param([Parameter(ValueFromPipeline)][object]$InputObject)
    process {
        if ($null -eq $InputObject) { return $null }
        if ($InputObject -is [hashtable]) {
            $clone = @{}
            foreach ($k in $InputObject.Keys) {
                $clone[$k] = Clone-Deep $InputObject[$k]
            }
            return $clone
        } elseif ($InputObject -is [System.Collections.IDictionary]) {
            $clone = @{}
            foreach ($k in $InputObject.Keys) {
                $clone[$k] = Clone-Deep $InputObject[$k]
            }
            return $clone
        } elseif ($InputObject -is [System.Collections.IEnumerable] -and
            $InputObject -isnot [string]) {
            $arr = @()
            foreach ($i in $InputObject) { $arr += , (Clone-Deep $i) }
            return , $arr
        } else {
            return $InputObject
        }
    }
}

# HTML escape for {{var}} (not used for {{{var}}} / {{& var}})
function ConvertTo-HtmlEscapedText {
    param([string]$Text)
    if ($null -eq $Text) { return '' }
    $t = $Text
    $t = $t -replace '&', '&amp;'
    $t = $t -replace '<', '&lt;'
    $t = $t -replace '>', '&gt;'
    $t = $t -replace '"', '&quot;'
    $t = $t -replace "'", '&#39;'
    return $t
}

# --- YAML helpers: merging + PSCustomObject -> hashtable conversion ---

function ConvertTo-Hashtable {
    param([Parameter(Mandatory)][object]$InputObject)
    if ($null -eq $InputObject) { return $null }

    if ($InputObject -is [hashtable]) {
        $h = @{}
        foreach ($k in $InputObject.Keys) {
            $h[$k] = ConvertTo-Hashtable -InputObject $InputObject[$k]
        }
        return $h
    } elseif ($InputObject -is [System.Collections.IDictionary]) {
        $h = @{}
        foreach ($k in $InputObject.Keys) {
            $h[$k] = ConvertTo-Hashtable -InputObject $InputObject[$k]
        }
        return $h
    } elseif ($InputObject -is [System.Management.Automation.PSCustomObject]) {
        $h = @{}
        foreach ($p in $InputObject.PSObject.Properties) {
            $h[$p.Name] = ConvertTo-Hashtable -InputObject $p.Value
        }
        return $h
    } elseif ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
        $arr = @()
        foreach ($i in $InputObject) { $arr += , (ConvertTo-Hashtable -InputObject $i) }
        return , $arr
    } else {
        return $InputObject
    }
}

function Merge-Hashtables {
    param(
        [Parameter(Mandatory)][hashtable]$Base,
        [Parameter(Mandatory)][hashtable]$Overlay
    )
    $result = @{}
    foreach ($k in $Base.Keys) { $result[$k] = Clone-Deep $Base[$k] }
    foreach ($k in $Overlay.Keys) {
        if ($result.ContainsKey($k) -and ($result[$k] -is [hashtable]) -and ($Overlay[$k] -is [hashtable])) {
            $result[$k] = Merge-Hashtables -Base $result[$k] -Overlay $Overlay[$k]
        } else {
            $result[$k] = Clone-Deep $Overlay[$k]
        }
    }
    return $result
}


# YAML loader
function Import-Yaml {
    param([Parameter(Mandatory)][string]$Path)

    Throw-IfNullOrMissingPath -Path $Path -What 'YAML file'
    # Use the nested powershell-yaml module's function
    return (ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath $path -Raw -Encoding UTF8) -UseMergingParser -AllDocuments)
}

# Resolve "a.b.c" in nested hashtables
function Get-ContextValue {
    param([hashtable]$Context, [string]$KeyPath)
    if ($null -eq $Context) { return $null }
    if ([string]::IsNullOrWhiteSpace($KeyPath)) { return $null }
    $node = $Context
    foreach ($part in $KeyPath.Split('.')) {
        if ($node -is [hashtable] -or $node -is [System.Collections.IDictionary]) {
            if ($node.ContainsKey($part)) {
                $node = $node[$part]
            } else { return $null }
        } else { return $null }
    }
    return $node
}

function Test-Truthy {
    param([object]$Value)
    if ($null -eq $Value) { return $false }
    if ($Value -is [string]) { return -not [string]::IsNullOrWhiteSpace($Value) }
    if ($Value -is [System.Collections.IEnumerable]) {
        foreach ($x in $Value) { return $true }
        return $false
    }
    return $true
}

# ------------------------------
# Mustache-like renderer (subset used by templates)
# ------------------------------
function Render-Mustache {
    param(
        [Parameter(Mandatory)][string]$Template,
        [Parameter(Mandatory)][hashtable]$Context
    )

    # Expand sections (nested same-name not supported; nested different names ok)
    $sectionPattern = [regex]'(?s){{\#\s*([\w\.\-]+)\s*}}(.*?){{/\s*\1\s*}}'
    $invertedPattern = [regex]'(?s){{\^\s*([\w\.\-]+)\s*}}(.*?){{/\s*\1\s*}}'

    $output = $Template

    # Expand regular sections
    $m = $sectionPattern.Match($output)
    while ($m.Success) {
        $key = $m.Groups[1].Value
        $inner = $m.Groups[2].Value
        $val = Get-ContextValue -Context $Context -KeyPath $key

        $replacement = ''
        if ($val -is [System.Collections.IEnumerable] -and $val -isnot [string]) {
            $acc = ''
            foreach ($item in $val) {
                if ($item -is [hashtable] -or $item -is [System.Collections.IDictionary]) {
                    $child = Clone-Deep $Context
                    foreach ($k in $item.Keys) { $child[$k] = $item[$k] }
                    $acc += Render-Mustache -Template $inner -Context $child
                } else {
                    $child = Clone-Deep $Context
                    $child['.'] = $item
                    $acc += Render-Mustache -Template $inner -Context $child
                }
            }
            $replacement = $acc
        } elseif (Test-Truthy $val) {
            $replacement = Render-Mustache -Template $inner -Context $Context
        }

        $output = $output.Substring(0, $m.Index) + $replacement + $output.Substring($m.Index + $m.Length)
        $m = $sectionPattern.Match($output)
    }

    # Expand inverted sections
    $m = $invertedPattern.Match($output)
    while ($m.Success) {
        $key = $m.Groups[1].Value
        $inner = $m.Groups[2].Value
        $val = Get-ContextValue -Context $Context -KeyPath $key
        $replacement = ''
        if (-not (Test-Truthy $val)) {
            $replacement = Render-Mustache -Template $inner -Context $Context
        }
        $output = $output.Substring(0, $m.Index) + $replacement + $output.Substring($m.Index + $m.Length)
        $m = $invertedPattern.Match($output)
    }

    # Variables
    $triple = [regex]'(?s){{{\s*([\w\.\-]+)\s*}}}'
    $amp = [regex]'(?s){{&\s*([\w\.\-]+)\s*}}'
    $simple = [regex]'(?s){{\s*([\w\.\-]+)\s*}}'

    $output = $triple.Replace($output, {
            param($match)
            $val = Get-ContextValue -Context $Context -KeyPath $match.Groups[1].Value
            if ($null -eq $val) { '' } else { [string]$val }
        })

    $output = $amp.Replace($output, {
            param($match)
            $val = Get-ContextValue -Context $Context -KeyPath $match.Groups[1].Value
            if ($null -eq $val) { '' } else { [string]$val }
        })

    $output = $simple.Replace($output, {
            param($match)
            $val = Get-ContextValue -Context $Context -KeyPath $match.Groups[1].Value
            if ($null -eq $val) { '' } else { ConvertTo-HtmlEscapedText ([string]$val) }
        })

    return $output
}

# Replace {{#first}}...{{/first}} with sentinel tags that we evaluate after render
function Replace-TemplateLambdas {
    param([string]$TemplateText)
    if ($null -eq $TemplateText) { return $TemplateText }
    $rx = [regex]'(?s){{\#first}}(.+?){{\/first}}'
    return $rx.Replace($TemplateText, { param($m) "FIRSTSTART$($m.Groups[1].Value)FIRSTEND" })
}

# Evaluate FIRSTSTART...FIRSTEND by selecting the first non-empty chunk (split on newline)
function Evaluate-TemplateLambdas {
    param([string]$Rendered)
    if ($null -eq $Rendered) { return '' }
    $rx = [regex]'(?s)FIRSTSTART\s*(.+?)\s*FIRSTEND'
    $m = $rx.Match($Rendered)
    while ($m.Success) {
        $replacement = Select-First -Text $m.Groups[1].Value
        $Rendered = $Rendered.Substring(0, $m.Index) + $replacement + $Rendered.Substring($m.Index + $m.Length)
        $m = $rx.Match($Rendered)
    }
    return $Rendered
}

function Select-First {
    param([string]$Text)
    if ($null -eq $Text) { return '' }

    # An '||' ODER an Zeilenumbrüchen trennen, je mit optionalen Spaces
    $parts = [regex]::Split($Text, '\s*(?:\|\||\r?\n)\s*')

    foreach ($p in $parts) {
        # Trimmen & leere Teile überspringen
        $candidate = $p -replace '^\s+', '' -replace '\s+$', ''
        if (-not [string]::IsNullOrWhiteSpace($candidate)) {
            return $candidate
        }
    }
    return ''
}

# ------------------------------
# Configuration loader
# ------------------------------
function New-AddressFormatter {
    param(
        [Parameter(Mandatory)][string]$ConfPath,
        [switch]$NoWarnings,
        [switch]$OnlyAddress
    )

    $Script:AddrFmt.ConfPath = $ConfPath
    $Script:AddrFmt.ShowWarnings = -not [bool]$NoWarnings
    $Script:AddrFmt.OnlyAddress = [bool]$OnlyAddress
    $Script:AddrFmt.FinalComponents = $null
    $Script:AddrFmt.SetDistrictAlias = @{}

    # Reset maps
    $Script:AddrFmt.Templates = @{}
    $Script:AddrFmt.ComponentAliases = @{}
    $Script:AddrFmt.Component2Type = @{}
    $Script:AddrFmt.OrderedComponents = @()
    $Script:AddrFmt.HKnown = @{}
    $Script:AddrFmt.State_Codes = @{}
    $Script:AddrFmt.County_Codes = @{}
    $Script:AddrFmt.Country2Lang = @{}
    $Script:AddrFmt.Abbreviations = @{}

    # components.yaml
    $componentsPath = Join-Path $ConfPath 'components.yaml'
    Throw-IfNullOrMissingPath $componentsPath 'components.yaml'
    $components = Import-Yaml -Path $componentsPath

    # worldwide.yaml (try countries/worldwide.yaml, then worldwide.yaml)
    $wwFile = Join-Path $ConfPath 'countries/worldwide.yaml'
    if (-not (Test-Path -LiteralPath $wwFile)) {
        $wwFile = Join-Path $ConfPath 'worldwide.yaml'
    }
    Throw-IfNullOrMissingPath $wwFile 'worldwide.yaml'
    $templatesRaw = Import-Yaml -Path $wwFile


    # Some forks wrap under 'countries:' or similar. Normalize to a flat map of countryCode -> config.
    $templatesMap = ConvertTo-Hashtable -InputObject $templatesRaw

    if ($templatesMap.ContainsKey('countries') -and ($templatesMap['countries'] -is [hashtable])) {
        $templatesMap = $templatesMap['countries']
    } elseif ($templatesMap.ContainsKey('worldwide') -and ($templatesMap['worldwide'] -is [hashtable])) {
        # Just in case a wrapper key is 'worldwide' instead of being the file name.
        $templatesMap = $templatesMap['worldwide']
    }


    # Fill Templates dictionary
    foreach ($k in $templatesMap.Keys) {
        $Script:AddrFmt.Templates[$k] = $templatesMap[$k]
    }

    # Build alias maps and ordered components
    foreach ($c in $components) {
        if ($c.name) {
            $Script:AddrFmt.ComponentAliases[$c.name] = @()
            if ($c.aliases) { $Script:AddrFmt.ComponentAliases[$c.name] = @($c.aliases) }
        }
    }
    foreach ($c in $components) {
        $name = $c.name
        $Script:AddrFmt.OrderedComponents += , $name
        $Script:AddrFmt.Component2Type[$name] = $name
        if ($c.aliases) {
            foreach ($a in $c.aliases) {
                $Script:AddrFmt.OrderedComponents += , $a
                $Script:AddrFmt.Component2Type[$a] = $name
            }
        }
    }
    $Script:AddrFmt.HKnown = @{}
    foreach ($k in $Script:AddrFmt.OrderedComponents) { $Script:AddrFmt.HKnown[$k] = 1 }

    # Load conf files: state_codes.yaml, county_codes.yaml, country2lang.yaml
    foreach ($fileBase in @('state_codes', 'county_codes', 'country2lang')) {
        $yf = Join-Path $ConfPath "$fileBase.yaml"
        if (Test-Path -LiteralPath $yf) {
            try {
                $y = Import-Yaml -Path $yf
                switch ($fileBase) {
                    'state_codes' { $Script:AddrFmt.State_Codes = $y }
                    'county_codes' { $Script:AddrFmt.County_Codes = $y }
                    'country2lang' { $Script:AddrFmt.Country2Lang = $y }
                }
            } catch {
                Warn-If "Error parsing $fileBase configuration: $($_.Exception.Message)"
            }
        }
    }

    # Abbreviations directory
    $abbrDir = Join-Path $ConfPath 'abbreviations'
    if (Test-Path -LiteralPath $abbrDir -PathType Container) {
        Get-ChildItem -LiteralPath $abbrDir -File -Filter '*.yaml' | ForEach-Object {
            if ($_.Name -match '^(\w\w)\.yaml$') {
                $lang = $Matches[1]
                try {
                    $Script:AddrFmt.Abbreviations[$lang] = Import-Yaml -Path $_.FullName
                } catch {
                    Warn-If "Error parsing abbreviations in '$($_.FullName)': $($_.Exception.Message)"
                }
            }
        }
    }
}

# ------------------------------
# Public: return final components after last Format-PostalAddress
# ------------------------------
function Get-FinalComponents {
    if ($null -ne $Script:AddrFmt.FinalComponents) { return $Script:AddrFmt.FinalComponents }
    Warn-If 'final_components not yet set'
    return $null
}

# ------------------------------
# Core formatting
# ------------------------------
# NOTE: The public function is Format-PostalAddress, which calls Format-PostalAddressInternal


# ------------------------------
# Internal helpers (behavioral parity)
# ------------------------------

function Invoke-Postformat {
    param([string]$Text, [object]$Rules)

    $Text = @(
        $Text -split '\r?\n' | Where-Object { $_ }
    ) -join "`n"

    $Text = @(
        $Text -split '\r?\n' | Where-Object { $_ } | ForEach-Object {
            (
                $_.Trim() `
                    -replace '^- ', '' `
                    -replace ',\s*,', ', ' `
                    -replace '\s+,\s+', ', ' `
                    -replace '\s\s+', ' ' `
                    -replace '^,', '' `
                    -replace ',,+', ',' `
                    -replace ',$', ''
            ).Trim()
        }
    ) -join "`n"

    $Text = @(
        $Text -split '\r?\n' | Where-Object { $_ }
    ) -join "`n"

    # Remove duplicates across comma-separated pieces (keep first; except "new york")
    $before = $Text -split ', '
    $seen = @{}
    $after = New-Object System.Collections.Generic.List[string]
    foreach ($p in $before) {
        $piece = ($p -replace '^\s+', '')
        $key = $piece
        if ($piece -ine 'new york') {
            if ($seen.ContainsKey($key)) { continue }
            $seen[$key] = 1
        }
        $after.Add($piece)
    }
    $Text = ($after -join ', ')


    # Country-specific regex replacements with $1/$2/$3 backrefs
    if ($Rules) {
        foreach ($rule in $Rules) {
            try {
                $from = [string]$rule[0]
                $to = [string]$rule[1]
                $rx = [regex]$from
                $Text = $rx.Replace($Text, $to)
            } catch {
                Warn-If ('invalid replacement: ' + ($rule -join ', '))
            }
        }
    }

    return $Text
}

function Invoke-SanityCleaning {
    param([hashtable]$Components)

    # Postcode sanity
    if ($Components.ContainsKey('postcode')) {
        $pc = [string]$Components['postcode']
        if ($pc.Length -gt 20) {
            $Components.Remove('postcode') | Out-Null
        } elseif ($pc -match '^\d+;\d+$') {
            $Components.Remove('postcode') | Out-Null
        } elseif ($pc -match '^(\d{5}),\d{5}') {
            $Components['postcode'] = $Matches[1]
        }
    }

    # Remove null/empty/no-word/URL values
    $keys = @($Components.Keys)
    foreach ($c in $keys) {
        $v = $Components[$c]
        if ($null -eq $v) { $Components.Remove($c) | Out-Null; continue }
        $sv = [string]$v
        if ($sv -notmatch '\w') { $Components.Remove($c) | Out-Null; continue }
        if ($sv -match '(?s)https?://') { $Components.Remove($c) | Out-Null; continue }
    }
}

function Test-MinimalComponents {
    param([hashtable]$Components)
    # Perl: required (road, postcode), threshold=2 => if both missing -> false
    $missing = 0
    foreach ($c in @('road', 'postcode')) {
        if (-not ($Components.ContainsKey($c))) { $missing++ }
        if ($missing -eq 2) { return $false }
    }
    return $true
}

# Build primary types from aliases according to ordering
function Resolve-PrimaryAliases {
    param([hashtable]$Components)

    # Collect primary types whose alias(es) exist but primary not set
    $p2aliases = @{}  # primary -> set of alias keys present in Components
    foreach ($c in @($Components.Keys)) {
        if ($Script:AddrFmt.ComponentAliases.ContainsKey($c)) { continue } # it's a primary type
        if ($Script:AddrFmt.Component2Type.ContainsKey($c)) {
            $ptype = $Script:AddrFmt.Component2Type[$c]
            if (-not $Components.ContainsKey($ptype)) {
                if (-not $p2aliases.ContainsKey($ptype)) { $p2aliases[$ptype] = @{} }
                $p2aliases[$ptype][$c] = 1
            }
        }
    }

    foreach ($ptype in $p2aliases.Keys) {
        $aliases = @($p2aliases[$ptype].Keys)
        if ($aliases.Count -eq 1) {
            $Components[$ptype] = $Components[$aliases[0]]
            continue
        }
        # multiple aliases => follow configured alias order for the primary
        foreach ($a in $Script:AddrFmt.ComponentAliases[$ptype]) {
            if ($Components.ContainsKey($a)) {
                $Components[$ptype] = $Components[$a]
                break
            }
        }
    }
}

# Country code determination + dependent-territory adjustments
function Determine-CountryCode {
    param([hashtable]$Components)

    if (-not $Components.ContainsKey('country_code')) { return $null }
    $cc = [string]$Components['country_code']
    if ([string]::IsNullOrWhiteSpace($cc)) { return $null }
    if ($cc.Length -ne 2) { return $null }
    if ($cc -ieq 'uk') { return 'GB' }

    # Dependent territory: use another country's configuration
    if ($Script:AddrFmt.Templates.ContainsKey($cc) -and
        $Script:AddrFmt.Templates[$cc].use_country) {

        $old_cc = $cc
        $cc = [string]$Script:AddrFmt.Templates[$old_cc].use_country

        # change_country string with $component substitution
        if ($Script:AddrFmt.Templates[$old_cc].change_country) {
            $newCountry = [string]$Script:AddrFmt.Templates[$old_cc].change_country
            $m = [regex]::Match($newCountry, '\$(\w*)')
            if ($m.Success) {
                $component = $m.Groups[1].Value
                if ($Components.ContainsKey($component)) {
                    $newCountry = $newCountry -replace "\`$$([regex]::escape($component))", [string]$Components[$component]
                } else {
                    $newCountry = $newCountry -replace "\`$$([regex]::escape($component))", ''
                }
            }
            $Components['country'] = $newCountry
        }
        if ($Script:AddrFmt.Templates[$old_cc].add_component) {
            $tmp = [string]$Script:AddrFmt.Templates[$old_cc].add_component
            $kv = $tmp.Split('=', 2)
            if ($kv.Count -eq 2) {
                $k, $v = $kv[0], $kv[1]
                if ($k -ieq 'state') { $Components['state'] = $v }
            }
        }
    }

    # NL special handling -> CW/SX/AW
    if ($cc -ieq 'NL') {
        if ($Components.ContainsKey('state')) {
            switch -regex ($Components['state']) {
                '^Cura[cç]ao' { $cc = 'CW'; $Components['country'] = 'Curaçao' }
                '^sint maarten' { $cc = 'SX'; $Components['country'] = 'Sint Maarten' }
                '^Aruba' { $cc = 'AW'; $Components['country'] = 'Aruba' }
            }
        }
    }

    return $cc
}

function Fix-Country {
    param([hashtable]$Components)
    if ($Components.ContainsKey('country') -and $Components.ContainsKey('state')) {
        $country = $Components['country']
        $state = $Components['state']
        $isNumber = $false
        try { [void][double]::Parse([string]$country); $isNumber = $true } catch { $isNumber = $false }
        if ($isNumber) {
            $Components['country'] = $state
            $Components.Remove('state') | Out-Null
        }
    }
}

function Add-StateCode {
    param([hashtable]$Components)
    if ($Components.ContainsKey('state')) { return Add-Code -KeyName 'state' -Components $Components }
    return $null
}

function Add-CountyCode {
    param([hashtable]$Components)
    if ($Components.ContainsKey('county')) { return Add-Code -KeyName 'county' -Components $Components }
    return $null
}

function Add-Code {
    param([string]$KeyName, [hashtable]$Components)

    if (-not $Components.ContainsKey('country_code')) { return $null }
    if (-not $Components.ContainsKey($KeyName)) { return $null }

    $codeKey = "${KeyName}_code"
    if ($Components.ContainsKey($codeKey)) {
        if ($Components[$codeKey] -ine $Components[$KeyName]) { return $Components[$codeKey] }
    }

    $cc = $Components['country_code'].ToString()
    $maps = if ($KeyName -ieq 'state') { $Script:AddrFmt.State_Codes } else { $Script:AddrFmt.County_Codes }
    if (-not $maps.ContainsKey($cc)) { return $null }
    $mapping = $maps[$cc]
    $name = [string]$Components[$KeyName]
    $uc_name = $name

    foreach ($abbrv in $mapping.Keys) {
        $confval = $mapping.$abbrv
        $confNames = @()
        if ($confval -is [System.Collections.IDictionary] -or $confval -is [hashtable]) {
            $confNames += $confval.Values
        } else {
            $confNames += , $confval
        }

        foreach ($confname in $confNames) {
            if ($uc_name -ieq ([string]$confname)) {
                $Components[$codeKey] = $abbrv
                break
            }
            if ($uc_name -ieq $abbrv) {
                $Components[$KeyName] = [string]$confname
                $Components[$codeKey] = $abbrv
                break
            }
        }
        if ($Components.ContainsKey($codeKey)) { break }
    }

    # US odd variants
    if ($cc -ieq 'US' -and $KeyName -ieq 'state' -and -not $Components.ContainsKey('state_code')) {
        $state = [string]$Components['state']
        if ($state -match '^united states') {
            $state2 = $state -replace '^United States', 'US'
            foreach ($k in $mapping.PSObject.Properties.Name) {
                if ($state2 -ieq $k) {
                    $Components['state_code'] = [string]$mapping.$k
                    break
                }
            }
        }
        if (-not $Components.ContainsKey('state_code') -and $state -match '^washington,?\s*d\.?c\.?' ) {
            $Components['state_code'] = 'DC'
            $Components['state'] = 'District of Columbia'
            $Components['city'] = 'Washington'
        }
    }

    return $Components[$codeKey]
}

function Apply-Replacements {
    param([hashtable]$Components, [object]$Rules)

    foreach ($component in @($Components.Keys)) {
        if ($component -in @('country_code', 'house_number')) { continue }
        foreach ($ra in $Rules) {
            $regexp = $null
            $from = [string]$ra[0]
            $to = [string]$ra[1]

            if ($from -match "^$([regex]::escape($component))=") {
                $keyFrom = $from.Substring($component.Length + 1)
                if ([string]$Components[$component] -ieq $keyFrom) {
                    $Components[$component] = $to
                } else {
                    $regexp = $keyFrom
                }
            } else {
                $regexp = $from
            }

            if ($regexp) {
                try {
                    $re = [regex]::new($regexp, 'IgnoreCase')
                    $Components[$component] = $re.Replace([string]$Components[$component], $to)
                } catch {
                    Warn-If ('invalid replacement: ' + ($ra -join ', '))
                }
            }
        }
    }
}

function Invoke-Abbreviate {
    param([hashtable]$Components)
    if (-not $Components.ContainsKey('country_code')) {
        $msg = 'no country_code, unable to abbreviate'
        if ($Components.ContainsKey('country')) { $msg += " - country: $($Components['country'])" }
        Warn-If $msg
        return $null
    }

    $cc = $Components['country_code'].ToString()
    if (-not $Script:AddrFmt.Country2Lang.ContainsKey($cc)) { return $Components }
    $langs = [string]$Script:AddrFmt.Country2Lang[$cc]
    foreach ($lang in $langs.Split(',')) {
        if ($Script:AddrFmt.Abbreviations.ContainsKey($lang)) {
            $rh_abbr = $Script:AddrFmt.Abbreviations[$lang]
            foreach ($compName in $rh_abbr.Keys) {
                if (-not $Components.ContainsKey($compName)) { continue }
                $map = $rh_abbr.$compName
                foreach ($long in $map.Keys) {
                    $short = [string]$map.$long
                    [string]$Components[$compName] = [string]$Components[$compName] -ireplace "(^|\s)$([regex]::escape($long))\b", "`$1$($short)"
                }
            }
        }
    }
    return $Components
}

# Line-by-line normalization with \s (no multiline \h usage)
function Invoke-Clean {
    param([string]$Text)
    if ($null -eq $Text) { return '' }

    # Convert HTML apostrophe back
    $Text = $Text -replace '&#39;', "'"

    # Split into lines (preserve logical lines)
    $rawLines = [regex]::Split($Text, '\r?\n')

    $normalizedLines = New-Object System.Collections.Generic.List[string]
    foreach ($line in $rawLines) {
        $l = $line

        # Remove stray leading/trailing bracket/comma blocks (best effort)
        $l = $l -replace '^[\[\{,\s]+', ''
        $l = $l -replace '[\}\],\s]+$', ''

        # Remove leading/trailing commas on the line
        $l = $l -replace '^\s*,+\s*', ''
        $l = $l -replace '\s*,+\s*$', ''

        # Reduce multiple commas to one, uniformly space around commas as ", "
        $l = $l -replace ',\s*,+', ','         # ",  ,," -> ","
        $l = $l -replace '\s*,\s*', ', '       # normalize spaces around commas

        # Collapse multiple spaces to one (within line)
        $l = $l -replace '\s{2,}', ' '

        # Trim leading/trailing whitespace
        $l = $l -replace '^\s+', ''
        $l = $l -replace '\s+$', ''

        $normalizedLines.Add($l)
    }

    # Final dedupe across and within lines
    $seenLines = @{}
    $afterLines = New-Object System.Collections.Generic.List[string]
    foreach ($line in $normalizedLines) {
        $l = $line
        if ([string]::IsNullOrWhiteSpace($l)) { continue }

        if ($seenLines.ContainsKey($l)) { continue }
        $seenLines[$l] = 1

        # Deduplicate comma-separated items in the line (except "New York")
        $words = $l -split ','
        $seenWords = @{}
        $afterWords = New-Object System.Collections.Generic.List[string]
        foreach ($w in $words) {
            $w2 = $w -replace '^\s+', '' -replace '\s+$', ''
            if ($w2 -ine 'new york') {
                if ($seenWords.ContainsKey($w2)) { continue }
                $seenWords[$w2] = 1
            }
            $afterWords.Add($w2)
        }
        $l2 = ($afterWords -join ', ')
        $afterLines.Add($l2)
    }

    $out = ($afterLines -join "`n")
    $out = $out -replace '^\s+', ''
    $out = $out -replace '\s+$', ''

    return $out
}

function Set-DistrictAlias {
    param([Parameter(Mandatory)][string]$CountryCode)

    $ucc = $CountryCode
    if ($Script:AddrFmt.SetDistrictAlias.ContainsKey($ucc)) { return }

    $Script:AddrFmt.SetDistrictAlias[$ucc] = 1
    $oldalias = $null

    if ($Script:SmallDistrict.ContainsKey($ucc)) {
        $Script:AddrFmt.Component2Type['district'] = 'neighbourhood'
        $oldalias = 'state_district'
        if (-not $Script:AddrFmt.ComponentAliases.ContainsKey('neighbourhood')) {
            $Script:AddrFmt.ComponentAliases['neighbourhood'] = @()
        }
        $Script:AddrFmt.ComponentAliases['neighbourhood'] += 'district'
    } else {
        $Script:AddrFmt.Component2Type['district'] = 'state_district'
        $oldalias = 'neighbourhood'
        if (-not $Script:AddrFmt.ComponentAliases.ContainsKey('state_district')) {
            $Script:AddrFmt.ComponentAliases['state_district'] = @()
        }
        $Script:AddrFmt.ComponentAliases['state_district'] += 'district'
    }

    if ($oldalias -and $Script:AddrFmt.ComponentAliases.ContainsKey($oldalias)) {
        $Script:AddrFmt.ComponentAliases[$oldalias] = @(
            $Script:AddrFmt.ComponentAliases[$oldalias] | Where-Object { $_ -ine 'district' }
        )
    }
}

function Find-UnknownComponents {
    param([hashtable]$Components)
    $unknown = @()
    foreach ($k in $Components.Keys) {
        if (-not $Script:AddrFmt.HKnown.ContainsKey($k)) {
            $unknown += , $k
        }
    }
    return , $unknown
}

# ------------------------------
# Module Initialization - Runs automatically on Import-Module
# ------------------------------

$OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# $PSScriptRoot is the path to the current module script (.psm1 file)
$confPath = Join-Path $PSScriptRoot 'address-formatting\conf'

# The path to your configuration data must be relative to the module root.
# Assuming 'conf' folder is a peer to the .psm1 file.
New-AddressFormatter -ConfPath $confPath

# SIG # Begin signature block
# MIIwaAYJKoZIhvcNAQcCoIIwWTCCMFUCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBAwC/jpWL7LlDw
# 44BBuw2OB/JdRxw1TEuGOrLXd9mKNqCCFCkwggWQMIIDeKADAgECAhAFmxtXno4h
# MuI5B72nd3VcMA0GCSqGSIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNV
# BAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDAeFw0xMzA4MDExMjAwMDBaFw0z
# ODAxMTUxMjAwMDBaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0
# IFRydXN0ZWQgUm9vdCBHNDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIB
# AL/mkHNo3rvkXUo8MCIwaTPswqclLskhPfKK2FnC4SmnPVirdprNrnsbhA3EMB/z
# G6Q4FutWxpdtHauyefLKEdLkX9YFPFIPUh/GnhWlfr6fqVcWWVVyr2iTcMKyunWZ
# anMylNEQRBAu34LzB4TmdDttceItDBvuINXJIB1jKS3O7F5OyJP4IWGbNOsFxl7s
# Wxq868nPzaw0QF+xembud8hIqGZXV59UWI4MK7dPpzDZVu7Ke13jrclPXuU15zHL
# 2pNe3I6PgNq2kZhAkHnDeMe2scS1ahg4AxCN2NQ3pC4FfYj1gj4QkXCrVYJBMtfb
# BHMqbpEBfCFM1LyuGwN1XXhm2ToxRJozQL8I11pJpMLmqaBn3aQnvKFPObURWBf3
# JFxGj2T3wWmIdph2PVldQnaHiZdpekjw4KISG2aadMreSx7nDmOu5tTvkpI6nj3c
# AORFJYm2mkQZK37AlLTSYW3rM9nF30sEAMx9HJXDj/chsrIRt7t/8tWMcCxBYKqx
# YxhElRp2Yn72gLD76GSmM9GJB+G9t+ZDpBi4pncB4Q+UDCEdslQpJYls5Q5SUUd0
# viastkF13nqsX40/ybzTQRESW+UQUOsxxcpyFiIJ33xMdT9j7CFfxCBRa2+xq4aL
# T8LWRV+dIPyhHsXAj6KxfgommfXkaS+YHS312amyHeUbAgMBAAGjQjBAMA8GA1Ud
# EwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgGGMB0GA1UdDgQWBBTs1+OC0nFdZEzf
# Lmc/57qYrhwPTzANBgkqhkiG9w0BAQwFAAOCAgEAu2HZfalsvhfEkRvDoaIAjeNk
# aA9Wz3eucPn9mkqZucl4XAwMX+TmFClWCzZJXURj4K2clhhmGyMNPXnpbWvWVPjS
# PMFDQK4dUPVS/JA7u5iZaWvHwaeoaKQn3J35J64whbn2Z006Po9ZOSJTROvIXQPK
# 7VB6fWIhCoDIc2bRoAVgX+iltKevqPdtNZx8WorWojiZ83iL9E3SIAveBO6Mm0eB
# cg3AFDLvMFkuruBx8lbkapdvklBtlo1oepqyNhR6BvIkuQkRUNcIsbiJeoQjYUIp
# 5aPNoiBB19GcZNnqJqGLFNdMGbJQQXE9P01wI4YMStyB0swylIQNCAmXHE/A7msg
# dDDS4Dk0EIUhFQEI6FUy3nFJ2SgXUE3mvk3RdazQyvtBuEOlqtPDBURPLDab4vri
# RbgjU2wGb2dVf0a1TD9uKFp5JtKkqGKX0h7i7UqLvBv9R0oN32dmfrJbQdA75PQ7
# 9ARj6e/CVABRoIoqyc54zNXqhwQYs86vSYiv85KZtrPmYQ/ShQDnUBrkG5WdGaG5
# nLGbsQAe79APT0JsyQq87kP6OnGlyE0mpTX9iV28hWIdMtKgK1TtmlfB2/oQzxm3
# i0objwG2J5VT6LaJbVu8aNQj6ItRolb58KaAoNYes7wPD1N1KarqE3fk3oyBIa0H
# EEcRrYc9B9F1vM/zZn4wggawMIIEmKADAgECAhAIrUCyYNKcTJ9ezam9k67ZMA0G
# CSqGSIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0
# IFRydXN0ZWQgUm9vdCBHNDAeFw0yMTA0MjkwMDAwMDBaFw0zNjA0MjgyMzU5NTla
# MGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UE
# AxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcgUlNBNDA5NiBTSEEz
# ODQgMjAyMSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDVtC9C
# 0CiteLdd1TlZG7GIQvUzjOs9gZdwxbvEhSYwn6SOaNhc9es0JAfhS0/TeEP0F9ce
# 2vnS1WcaUk8OoVf8iJnBkcyBAz5NcCRks43iCH00fUyAVxJrQ5qZ8sU7H/Lvy0da
# E6ZMswEgJfMQ04uy+wjwiuCdCcBlp/qYgEk1hz1RGeiQIXhFLqGfLOEYwhrMxe6T
# SXBCMo/7xuoc82VokaJNTIIRSFJo3hC9FFdd6BgTZcV/sk+FLEikVoQ11vkunKoA
# FdE3/hoGlMJ8yOobMubKwvSnowMOdKWvObarYBLj6Na59zHh3K3kGKDYwSNHR7Oh
# D26jq22YBoMbt2pnLdK9RBqSEIGPsDsJ18ebMlrC/2pgVItJwZPt4bRc4G/rJvmM
# 1bL5OBDm6s6R9b7T+2+TYTRcvJNFKIM2KmYoX7BzzosmJQayg9Rc9hUZTO1i4F4z
# 8ujo7AqnsAMrkbI2eb73rQgedaZlzLvjSFDzd5Ea/ttQokbIYViY9XwCFjyDKK05
# huzUtw1T0PhH5nUwjewwk3YUpltLXXRhTT8SkXbev1jLchApQfDVxW0mdmgRQRNY
# mtwmKwH0iU1Z23jPgUo+QEdfyYFQc4UQIyFZYIpkVMHMIRroOBl8ZhzNeDhFMJlP
# /2NPTLuqDQhTQXxYPUez+rbsjDIJAsxsPAxWEQIDAQABo4IBWTCCAVUwEgYDVR0T
# AQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUaDfg67Y7+F8Rhvv+YXsIiGX0TkIwHwYD
# VR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMG
# A1UdJQQMMAoGCCsGAQUFBwMDMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2Fj
# ZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNydDBDBgNV
# HR8EPDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRU
# cnVzdGVkUm9vdEc0LmNybDAcBgNVHSAEFTATMAcGBWeBDAEDMAgGBmeBDAEEATAN
# BgkqhkiG9w0BAQwFAAOCAgEAOiNEPY0Idu6PvDqZ01bgAhql+Eg08yy25nRm95Ry
# sQDKr2wwJxMSnpBEn0v9nqN8JtU3vDpdSG2V1T9J9Ce7FoFFUP2cvbaF4HZ+N3HL
# IvdaqpDP9ZNq4+sg0dVQeYiaiorBtr2hSBh+3NiAGhEZGM1hmYFW9snjdufE5Btf
# Q/g+lP92OT2e1JnPSt0o618moZVYSNUa/tcnP/2Q0XaG3RywYFzzDaju4ImhvTnh
# OE7abrs2nfvlIVNaw8rpavGiPttDuDPITzgUkpn13c5UbdldAhQfQDN8A+KVssIh
# dXNSy0bYxDQcoqVLjc1vdjcshT8azibpGL6QB7BDf5WIIIJw8MzK7/0pNVwfiThV
# 9zeKiwmhywvpMRr/LhlcOXHhvpynCgbWJme3kuZOX956rEnPLqR0kq3bPKSchh/j
# wVYbKyP/j7XqiHtwa+aguv06P0WmxOgWkVKLQcBIhEuWTatEQOON8BUozu3xGFYH
# Ki8QxAwIZDwzj64ojDzLj4gLDb879M4ee47vtevLt/B3E+bnKD+sEq6lLyJsQfmC
# XBVmzGwOysWGw/YmMwwHS6DTBwJqakAwSEs0qFEgu60bhQjiWQ1tygVQK+pKHJ6l
# /aCnHwZ05/LWUpD9r4VIIflXO7ScA+2GRfS0YW6/aOImYIbqyK+p/pQd52MbOoZW
# eE4wggfdMIIFxaADAgECAhAKaypbp7cyIFa+lR7OVPAvMA0GCSqGSIb3DQEBCwUA
# MGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UE
# AxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcgUlNBNDA5NiBTSEEz
# ODQgMjAyMSBDQTEwHhcNMjMwNzExMDAwMDAwWhcNMjYwNzEwMjM1OTU5WjCB5TET
# MBEGCysGAQQBgjc8AgEDEwJBVDEVMBMGCysGAQQBgjc8AgECEwRXaWVuMRUwEwYL
# KwYBBAGCNzwCAQETBFdpZW4xHTAbBgNVBA8MFFByaXZhdGUgT3JnYW5pemF0aW9u
# MRAwDgYDVQQFEwc2MDcwMTN0MQswCQYDVQQGEwJBVDENMAsGA1UECBMEV2llbjEN
# MAsGA1UEBxMEV2llbjEhMB8GA1UEChMYRXhwbGljSVQgQ29uc3VsdGluZyBHbWJI
# MSEwHwYDVQQDExhFeHBsaWNJVCBDb25zdWx0aW5nIEdtYkgwggIiMA0GCSqGSIb3
# DQEBAQUAA4ICDwAwggIKAoICAQDxdNfDY8ulBB2NIOYzd2mVQRhjMBAzNgvJEjXs
# VACQyjesfJfvXZ3gMnUT8M5HkohWjHvhftCFkL5cCck+4XuEGiLisV3hilLL4p8z
# 6L+tbvPnVSWML7VOV835/de+hM/mKdFhqRG+fYNQ1ceFlggiwqfHjIoXLweZACRD
# 3bLwRLYk7w5IEDCtHa0Hit+SpqbZ4MDcEhfS8krG5ha0FqOLkVLAhPfkZ4sOB32V
# dUfQPknxYnhWZVyGVH/ypTYnEY4oo3CFO0f8k4fNc8fGDwNAoxHJwGKYjxeEasgm
# a2EZMHKkZyJpwJKSdZ9FPp4qldYVt/NiCoXzdrLRta0M/Vg5E+XKVtC0EOhY2w6u
# lgFx0Qog/hfC3w2imATDt7Fv5R+ZQ8v3BXzn2pH2DZ1sGI7JZjH0NCxXdY8kaDuZ
# fCQRcDCej/5otpuDxu7l6bBUTBe2ao+ZwCBuN0PWdbyxunii1W/Q3t1bU2Hmu/97
# 4hQOWJNDBuWrPNOlr2qHVqFNCOpHtuddTHMGt9bGwr9FXXe5gTIrAk2CCX+vnDhw
# zgi8UuLWJy+H1b1Y2hUt2oX2izyAjDrXdA6wgGNr3YtIgUt+4BBRz0Zhw6/KQdpN
# wCTnofcgezhz0OS4WMB+ZARaMNK4DpzVwlGrg9NF/nCuQ0sJzt913ndIRl5FXJ71
# GwgCKwIDAQABo4ICAjCCAf4wHwYDVR0jBBgwFoAUaDfg67Y7+F8Rhvv+YXsIiGX0
# TkIwHQYDVR0OBBYEFDz+YL61H9M50y8W+urzdKxOSpf4MA4GA1UdDwEB/wQEAwIH
# gDATBgNVHSUEDDAKBggrBgEFBQcDAzCBtQYDVR0fBIGtMIGqMFOgUaBPhk1odHRw
# Oi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRDb2RlU2lnbmlu
# Z1JTQTQwOTZTSEEzODQyMDIxQ0ExLmNybDBToFGgT4ZNaHR0cDovL2NybDQuZGln
# aWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0Q29kZVNpZ25pbmdSU0E0MDk2U0hB
# Mzg0MjAyMUNBMS5jcmwwPQYDVR0gBDYwNDAyBgVngQwBAzApMCcGCCsGAQUFBwIB
# FhtodHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwgZQGCCsGAQUFBwEBBIGHMIGE
# MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wXAYIKwYBBQUH
# MAKGUGh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRH
# NENvZGVTaWduaW5nUlNBNDA5NlNIQTM4NDIwMjFDQTEuY3J0MAkGA1UdEwQCMAAw
# DQYJKoZIhvcNAQELBQADggIBAISWy98G7WUbOBA3S0odwfltQ3YZmuNgNZDoIdLQ
# YFnB43wgnClFuPIPaKJGYeRH90iioYKsnGDOYvUgr+b+XbIDRRqkHoYYZB+jDYUJ
# f1LS6eD79GAsLEomY/VzyRY9LEbYsmDmHi/riDWDiKWL0YYQmVuxU6NSLz4JZADA
# VsC7bZovRJnL9XFQo0QQxz9jymHH1UVBOAUUojrs7IznXBtQza/PYg+285kCoR/U
# ToA+Bc7j/mwon0tKlNCKyPn04viwjHRSIr8VlCH+qXU+nw6eSH7PVJWargv2sX/h
# t9zJ4JK843KRtd2mEXMUVcS2AUnmuwBSrxXhFQguR5nfrZBUHb4epiAMreGfidEl
# bmxEpzLaBegF8A+C7mCambjhnQ1p9b6JKuV1aS9qyfRf6AYF+OKLzBBbIAKLOmSx
# aHoJdn65B50/Gq5zUIxkoa8lKjEw4xtIBto4xYnFOLQJmiNeyAJeRLHbPGpHm6M+
# tTorAVDdGPQbhDlQT2RHn9pJDiJxFIbPdsNoEgtzAQee5US4QCng1qySpsvhQEoX
# JHh3jq62djlgx2GmVGOsysBfhcqjJROeo0+B32YQRHST/RBEaesZ6SFfXGaO3bBt
# onaU0JOQ9LOioHOuhGVNPjrcKT/NE99Bs2JF1Z8XJfPcDt5R0c10eRY1fiLJLvU5
# GNmrMYIblTCCG5ECAQEwfTBpMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNl
# cnQsIEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0IFRydXN0ZWQgRzQgQ29kZSBTaWdu
# aW5nIFJTQTQwOTYgU0hBMzg0IDIwMjEgQ0ExAhAKaypbp7cyIFa+lR7OVPAvMA0G
# CWCGSAFlAwQCAQUAoIIBbjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQg0dhMsoAp
# LS5qJBnDejtTJa/uAYvZxV3mgswHGycQR1UwggEABgorBgEEAYI3AgEMMYHxMIHu
# oIHFgIHCAFAAbwB3AGUAcgBlAGQAIABiAHkAIABFAHgAcABsAGkAYwBJAFQAIABD
# AG8AbgBzAHUAbAB0AGkAbgBnAC4AIABVAG4AbABvAGMAawAgAGEAbABsACAAZgBl
# AGEAdAB1AHIAZQBzACAAdwBpAHQAaAAgAFMAZQB0AC0ATwB1AHQAbABvAG8AawBT
# AGkAZwBuAGEAdAB1AHIAZQBzACAAQgBlAG4AZQBmAGEAYwB0AG8AcgAgAEMAaQBy
# AGMAbABlAC6hJIAiaHR0cHM6Ly9zZXQtb3V0bG9va3NpZ25hdHVyZXMuY29tIDAN
# BgkqhkiG9w0BAQEFAASCAgDhozc17xZ54z15jxUJrlrtYJfj0QJNuIx2cvpuCiEb
# H6LL4TrKpWljRkyvVFQpY8lLV1zcbrbw2aEfefs9faxJnjd+hFcSLW5qlyP5BDVO
# yIZ6sJMtokK/vu1vtGccFVFFuo/AQmPFajTevZPORptiUJyqTB/KyI/DH6C6asKh
# Dljisl/vy1FHshZjxTWYIJlTWg85hxjfB9hivlHO0dr/xKGXioAfXDlkz3fgQCo0
# MfzC1uhJ5Db0gVFmM7ugw5fA89jQ1o4ciSU1owPysgpzhh2yegqwfvuAdNrLRsjS
# nXRRg1ZXfFJjQXuKpCJMgSdPDDNZGvU3VOFFmkVs72SffuAL5DF6RJwibyGNPKB8
# ihTnMtYrDQYyGOmAwjY7Cvv3AFrmaHH1G0K6Sp/jU9eZz3I30SWgdZDNupV5uWjE
# CBVzRbMBewYF0+YV59t9E4p0oopM+AHoKIbLcqnScEyM7gNX3kjfHRrqc32KyvjU
# BjZHjYmfIsRkhfCGy6TknJrYwJB7t/DoOjegoSTeoffhGcyRhKNSN0QYTr6OPhak
# E3ZMVvGJKN3Q8JnFlvaFfBfY9tdQW9hXaLNbFR/ti2Pe8YIK/qANgESzIsJ+mXFd
# ZZdGN9KslhcD13Z1GFPAeECoQw4m3XVRHo1x4ZXXCMSVGUzciv1eWN0iGOD4FQgA
# aqGCF3cwghdzBgorBgEEAYI3AwMBMYIXYzCCF18GCSqGSIb3DQEHAqCCF1AwghdM
# AgEDMQ8wDQYJYIZIAWUDBAIBBQAweAYLKoZIhvcNAQkQAQSgaQRnMGUCAQEGCWCG
# SAGG/WwHATAxMA0GCWCGSAFlAwQCAQUABCCiRZpc85+8PA+2zdxkgXPvcibSaIdd
# 4CfJnzPOJOODJgIRAPa8M/RKO+zNkBrCbHOv3vsYDzIwMjUxMjIzMTE1MDA3WqCC
# EzowggbtMIIE1aADAgECAhAKgO8YS43xBYLRxHanlXRoMA0GCSqGSIb3DQEBCwUA
# MGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UE
# AxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBUaW1lU3RhbXBpbmcgUlNBNDA5NiBTSEEy
# NTYgMjAyNSBDQTEwHhcNMjUwNjA0MDAwMDAwWhcNMzYwOTAzMjM1OTU5WjBjMQsw
# CQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRp
# Z2lDZXJ0IFNIQTI1NiBSU0E0MDk2IFRpbWVzdGFtcCBSZXNwb25kZXIgMjAyNSAx
# MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA0EasLRLGntDqrmBWsytX
# um9R/4ZwCgHfyjfMGUIwYzKomd8U1nH7C8Dr0cVMF3BsfAFI54um8+dnxk36+jx0
# Tb+k+87H9WPxNyFPJIDZHhAqlUPt281mHrBbZHqRK71Em3/hCGC5KyyneqiZ7syv
# FXJ9A72wzHpkBaMUNg7MOLxI6E9RaUueHTQKWXymOtRwJXcrcTTPPT2V1D/+cFll
# ESviH8YjoPFvZSjKs3SKO1QNUdFd2adw44wDcKgH+JRJE5Qg0NP3yiSyi5MxgU6c
# ehGHr7zou1znOM8odbkqoK+lJ25LCHBSai25CFyD23DZgPfDrJJJK77epTwMP6eK
# A0kWa3osAe8fcpK40uhktzUd/Yk0xUvhDU6lvJukx7jphx40DQt82yepyekl4i0r
# 8OEps/FNO4ahfvAk12hE5FVs9HVVWcO5J4dVmVzix4A77p3awLbr89A90/nWGjXM
# Gn7FQhmSlIUDy9Z2hSgctaepZTd0ILIUbWuhKuAeNIeWrzHKYueMJtItnj2Q+aTy
# LLKLM0MheP/9w6CtjuuVHJOVoIJ/DtpJRE7Ce7vMRHoRon4CWIvuiNN1Lk9Y+xZ6
# 6lazs2kKFSTnnkrT3pXWETTJkhd76CIDBbTRofOsNyEhzZtCGmnQigpFHti58CSm
# vEyJcAlDVcKacJ+A9/z7eacCAwEAAaOCAZUwggGRMAwGA1UdEwEB/wQCMAAwHQYD
# VR0OBBYEFOQ7/PIx7f391/ORcWMZUEPPYYzoMB8GA1UdIwQYMBaAFO9vU0rp5AZ8
# esrikFb2L9RJ7MtOMA4GA1UdDwEB/wQEAwIHgDAWBgNVHSUBAf8EDDAKBggrBgEF
# BQcDCDCBlQYIKwYBBQUHAQEEgYgwgYUwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3Nw
# LmRpZ2ljZXJ0LmNvbTBdBggrBgEFBQcwAoZRaHR0cDovL2NhY2VydHMuZGlnaWNl
# cnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0VGltZVN0YW1waW5nUlNBNDA5NlNIQTI1
# NjIwMjVDQTEuY3J0MF8GA1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly9jcmwzLmRpZ2lj
# ZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNFRpbWVTdGFtcGluZ1JTQTQwOTZTSEEy
# NTYyMDI1Q0ExLmNybDAgBgNVHSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEw
# DQYJKoZIhvcNAQELBQADggIBAGUqrfEcJwS5rmBB7NEIRJ5jQHIh+OT2Ik/bNYul
# CrVvhREafBYF0RkP2AGr181o2YWPoSHz9iZEN/FPsLSTwVQWo2H62yGBvg7ouCOD
# wrx6ULj6hYKqdT8wv2UV+Kbz/3ImZlJ7YXwBD9R0oU62PtgxOao872bOySCILdBg
# hQ/ZLcdC8cbUUO75ZSpbh1oipOhcUT8lD8QAGB9lctZTTOJM3pHfKBAEcxQFoHlt
# 2s9sXoxFizTeHihsQyfFg5fxUFEp7W42fNBVN4ueLaceRf9Cq9ec1v5iQMWTFQa0
# xNqItH3CPFTG7aEQJmmrJTV3Qhtfparz+BW60OiMEgV5GWoBy4RVPRwqxv7Mk0Sy
# 4QHs7v9y69NBqycz0BZwhB9WOfOu/CIJnzkQTwtSSpGGhLdjnQ4eBpjtP+XB3pQC
# tv4E5UCSDag6+iX8MmB10nfldPF9SVD7weCC3yXZi/uuhqdwkgVxuiMFzGVFwYbQ
# siGnoa9F5AaAyBjFBtXVLcKtapnMG3VH3EmAp/jsJ3FVF3+d1SVDTmjFjLbNFZUW
# MXuZyvgLfgyPehwJVxwC+UpX2MSey2ueIu9THFVkT+um1vshETaWyQo8gmBto/m3
# acaP9QsuLj3FNwFlTxq25+T4QwX9xa6ILs84ZPvmpovq90K8eWyG2N01c4IhSOxq
# t81nMIIGtDCCBJygAwIBAgIQDcesVwX/IZkuQEMiDDpJhjANBgkqhkiG9w0BAQsF
# ADBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQL
# ExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJv
# b3QgRzQwHhcNMjUwNTA3MDAwMDAwWhcNMzgwMTE0MjM1OTU5WjBpMQswCQYDVQQG
# EwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0
# IFRydXN0ZWQgRzQgVGltZVN0YW1waW5nIFJTQTQwOTYgU0hBMjU2IDIwMjUgQ0Ex
# MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAtHgx0wqYQXK+PEbAHKx1
# 26NGaHS0URedTa2NDZS1mZaDLFTtQ2oRjzUXMmxCqvkbsDpz4aH+qbxeLho8I6jY
# 3xL1IusLopuW2qftJYJaDNs1+JH7Z+QdSKWM06qchUP+AbdJgMQB3h2DZ0Mal5kY
# p77jYMVQXSZH++0trj6Ao+xh/AS7sQRuQL37QXbDhAktVJMQbzIBHYJBYgzWIjk8
# eDrYhXDEpKk7RdoX0M980EpLtlrNyHw0Xm+nt5pnYJU3Gmq6bNMI1I7Gb5IBZK4i
# vbVCiZv7PNBYqHEpNVWC2ZQ8BbfnFRQVESYOszFI2Wv82wnJRfN20VRS3hpLgIR4
# hjzL0hpoYGk81coWJ+KdPvMvaB0WkE/2qHxJ0ucS638ZxqU14lDnki7CcoKCz6eu
# m5A19WZQHkqUJfdkDjHkccpL6uoG8pbF0LJAQQZxst7VvwDDjAmSFTUms+wV/FbW
# Bqi7fTJnjq3hj0XbQcd8hjj/q8d6ylgxCZSKi17yVp2NL+cnT6Toy+rN+nM8M7Ln
# LqCrO2JP3oW//1sfuZDKiDEb1AQ8es9Xr/u6bDTnYCTKIsDq1BtmXUqEG1NqzJKS
# 4kOmxkYp2WyODi7vQTCBZtVFJfVZ3j7OgWmnhFr4yUozZtqgPrHRVHhGNKlYzyjl
# roPxul+bgIspzOwbtmsgY1MCAwEAAaOCAV0wggFZMBIGA1UdEwEB/wQIMAYBAf8C
# AQAwHQYDVR0OBBYEFO9vU0rp5AZ8esrikFb2L9RJ7MtOMB8GA1UdIwQYMBaAFOzX
# 44LScV1kTN8uZz/nupiuHA9PMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggr
# BgEFBQcDCDB3BggrBgEFBQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3Nw
# LmRpZ2ljZXJ0LmNvbTBBBggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMuZGlnaWNl
# cnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcnQwQwYDVR0fBDwwOjA4oDag
# NIYyaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RH
# NC5jcmwwIAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3
# DQEBCwUAA4ICAQAXzvsWgBz+Bz0RdnEwvb4LyLU0pn/N0IfFiBowf0/Dm1wGc/Do
# 7oVMY2mhXZXjDNJQa8j00DNqhCT3t+s8G0iP5kvN2n7Jd2E4/iEIUBO41P5F448r
# SYJ59Ib61eoalhnd6ywFLerycvZTAz40y8S4F3/a+Z1jEMK/DMm/axFSgoR8n6c3
# nuZB9BfBwAQYK9FHaoq2e26MHvVY9gCDA/JYsq7pGdogP8HRtrYfctSLANEBfHU1
# 6r3J05qX3kId+ZOczgj5kjatVB+NdADVZKON/gnZruMvNYY2o1f4MXRJDMdTSlOL
# h0HCn2cQLwQCqjFbqrXuvTPSegOOzr4EWj7PtspIHBldNE2K9i697cvaiIo2p61E
# d2p8xMJb82Yosn0z4y25xUbI7GIN/TpVfHIqQ6Ku/qjTY6hc3hsXMrS+U0yy+GWq
# AXam4ToWd2UQ1KYT70kZjE4YtL8Pbzg0c1ugMZyZZd/BdHLiRu7hAWE6bTEm4XYR
# kA6Tl4KSFLFk43esaUeqGkH/wyW4N7OigizwJWeukcyIPbAvjSabnf7+Pu0VrFgo
# iovRDiyx3zEdmcif/sYQsfch28bZeUz2rtY/9TCA6TD8dC3JE3rYkrhLULy7Dc90
# G6e8BlqmyIjlgp2+VqsS9/wQD7yFylIz0scmbKvFoW2jNrbM1pD2T7m3XDCCBY0w
# ggR1oAMCAQICEA6bGI750C3n79tQ4ghAGFowDQYJKoZIhvcNAQEMBQAwZTELMAkG
# A1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRp
# Z2ljZXJ0LmNvbTEkMCIGA1UEAxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENB
# MB4XDTIyMDgwMTAwMDAwMFoXDTMxMTEwOTIzNTk1OVowYjELMAkGA1UEBhMCVVMx
# FTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNv
# bTEhMB8GA1UEAxMYRGlnaUNlcnQgVHJ1c3RlZCBSb290IEc0MIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAv+aQc2jeu+RdSjwwIjBpM+zCpyUuySE98orY
# WcLhKac9WKt2ms2uexuEDcQwH/MbpDgW61bGl20dq7J58soR0uRf1gU8Ug9SH8ae
# FaV+vp+pVxZZVXKvaJNwwrK6dZlqczKU0RBEEC7fgvMHhOZ0O21x4i0MG+4g1ckg
# HWMpLc7sXk7Ik/ghYZs06wXGXuxbGrzryc/NrDRAX7F6Zu53yEioZldXn1RYjgwr
# t0+nMNlW7sp7XeOtyU9e5TXnMcvak17cjo+A2raRmECQecN4x7axxLVqGDgDEI3Y
# 1DekLgV9iPWCPhCRcKtVgkEy19sEcypukQF8IUzUvK4bA3VdeGbZOjFEmjNAvwjX
# WkmkwuapoGfdpCe8oU85tRFYF/ckXEaPZPfBaYh2mHY9WV1CdoeJl2l6SPDgohIb
# Zpp0yt5LHucOY67m1O+SkjqePdwA5EUlibaaRBkrfsCUtNJhbesz2cXfSwQAzH0c
# lcOP9yGyshG3u3/y1YxwLEFgqrFjGESVGnZifvaAsPvoZKYz0YkH4b235kOkGLim
# dwHhD5QMIR2yVCkliWzlDlJRR3S+Jqy2QXXeeqxfjT/JvNNBERJb5RBQ6zHFynIW
# IgnffEx1P2PsIV/EIFFrb7GrhotPwtZFX50g/KEexcCPorF+CiaZ9eRpL5gdLfXZ
# qbId5RsCAwEAAaOCATowggE2MA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFOzX
# 44LScV1kTN8uZz/nupiuHA9PMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3z
# bcgPMA4GA1UdDwEB/wQEAwIBhjB5BggrBgEFBQcBAQRtMGswJAYIKwYBBQUHMAGG
# GGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBDBggrBgEFBQcwAoY3aHR0cDovL2Nh
# Y2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNydDBF
# BgNVHR8EPjA8MDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRBc3N1cmVkSURSb290Q0EuY3JsMBEGA1UdIAQKMAgwBgYEVR0gADANBgkqhkiG
# 9w0BAQwFAAOCAQEAcKC/Q1xV5zhfoKN0Gz22Ftf3v1cHvZqsoYcs7IVeqRq7IviH
# GmlUIu2kiHdtvRoU9BNKei8ttzjv9P+Aufih9/Jy3iS8UgPITtAq3votVs/59Pes
# MHqai7Je1M/RQ0SbQyHrlnKhSLSZy51PpwYDE3cnRNTnf+hZqPC/Lwum6fI0POz3
# A8eHqNJMQBk1RmppVLC4oVaO7KTVPeix3P0c2PR3WlxUjG/voVA9/HYJaISfb8rb
# II01YBwCA8sgsKxYoA5AY8WYIsGyWfVVa88nq2x2zm8jLfR+cWojayL/ErhULSd+
# 2DrZ8LaHlv1b0VysGMNNn3O3AamfV6peKOK5lDGCA3wwggN4AgEBMH0waTELMAkG
# A1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQDEzhEaWdp
# Q2VydCBUcnVzdGVkIEc0IFRpbWVTdGFtcGluZyBSU0E0MDk2IFNIQTI1NiAyMDI1
# IENBMQIQCoDvGEuN8QWC0cR2p5V0aDANBglghkgBZQMEAgEFAKCB0TAaBgkqhkiG
# 9w0BCQMxDQYLKoZIhvcNAQkQAQQwHAYJKoZIhvcNAQkFMQ8XDTI1MTIyMzExNTAw
# N1owKwYLKoZIhvcNAQkQAgwxHDAaMBgwFgQU3WIwrIYKLTBr2jixaHlSMAf7QX4w
# LwYJKoZIhvcNAQkEMSIEIAlzMTkq2GitIA6Et/Z83GpJh0u4nprQniGGAKfLvtdJ
# MDcGCyqGSIb3DQEJEAIvMSgwJjAkMCIEIEqgP6Is11yExVyTj4KOZ2ucrsqzP+Nt
# JpqjNPFGEQozMA0GCSqGSIb3DQEBAQUABIICAFKRSOZGd4muQq0n3AdciOQDQUTE
# 2r+ryaVvVqP/Ts3EYJm25FaqmWTTBtQ+tL3fzyCCZdZU+7aosxiPeAJSUzWK5OQp
# 6TC6TmD+9msa9qYrBdcD26GGSlwmUs6gxMGnfBaQDZNhE/q2bFn/wHbG1ZouGUkB
# qA3KCdcO5P75sUHq7tANL5Wv48jqqTjMijHxAyj2yBViaU/n2LC5Dau6b8SNeGhc
# d36ugGtVkSeY9pjJhAwwHf3WZrbL8+pRkqibpdJS7IJ5xL5FImGrrrh8O6c1cW+b
# nmdQUJxGP0lUiv7iE1eOjprZr1QIRejAHwYjZXUrfZKqQ57lly74G2lzEB/tVDVp
# O8GBHLEEBSSs+PMB/zkYUK8i/9718mOu8Am1cHHFEif93/BICv2rNFayfJ1PHNoJ
# IReb0Xi5dXGPHO9F8vc0clqFafBnaAdMTEGt/b4Qel4wRvz/y0Q7Zwj56jIi/q8x
# b4LQgG7bFpentaRYHLI59bMpHjFzSfR7WUi1KW5XvYwlNCZfT8h4Ve2KigjmgHgw
# w/dV7JFgUf5k4LmpK+JGNpoH7UuPSYjwSOkjcM99+7gO2MJRDc4l0ytm/rtBAWo9
# iDkx3H3sF12eCZ8m/EUAlNdDi0hh5kDKXFl4TudWjDb8JhN0JXpGcQAFV6X0gxjb
# GPySJpop9bpNXfXG
# SIG # End signature block
