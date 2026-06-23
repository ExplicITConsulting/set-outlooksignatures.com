# CheckLinks.ps1
This PowerShell script is a modular multi-threaded web crawler designed to identify broken links, missing assets, and anchor fragment issues across a website. It uses Playwright to render pages, ensuring that elements within modern JavaScript frameworks and Shadow DOM components (like images, scripts, and links) are correctly identified and validated.


## Requirements and Prerequisites
* PowerShell 7.5 or higher.
* FullLanguage mode (required for thread-safe operations).
* Internet access (the script automatically downloads dependencies to a temporary folder).
* Administrative privileges are recommended for the initial Playwright browser installation.


## Parameters
* `StartUrl`: The initial URL where the crawl begins.
* `SitemapUrl`: A URL to a sitemap.xml file. All entries in the sitemap will be added to the crawl queue.
* `BrowserType`: Choose between Chromium, Firefox, or WebKit. Default is Chromium.
* `BrowserHeadless`: Boolean. Set to `$true` to run in the background.
* `CheckFragments`: String: InternalAndExternal, InternalOnly, ExternalOnly, or None. If enabled, verifies that the specific ID or Name exists on the target page for URLs containing a #fragment.
* `CheckFragmentsInternalOnly`: Boolean. If true, fragment validation is only performed for internal domain links.
* `ParallelWorkers`: Number of simultaneous browser instances.
* `ExportFile`: Export the scan results as CliXml to this file for later use.


## Usage Example
Run the script using the default parameters:

```powershell
.\checklinks.ps1
```

To run a deep check including fragments on an external sitemap:
```powershell
.\checklinks.ps1 -SitemapUrl "https://example.com/sitemap.xml" -CheckFragments $true -CheckFragmentsInternalOnly $false
```


## Internal Data Structures
The script populates two primary thread-safe dictionaries that capture all discovered resources (Links, Images, Scripts, etc.):

### \$PageData
Stores the validation results and metadata for every unique URL encountered.
* Key: The absolute URL (normalized).
* Value: A Hashtable containing:
* `IdsAndNames`: A hashset of all unique id and name attributes found (used for fragment validation).
* `StatusCode`: The numeric HTTP status code (e.g., 200, 404).
* `StatusMessage`: Details on the result (e.g., 'OK', '404 Not Found', or 'Is not text/html').

### \$ReferenceMap
Maps every target resource back to the pages that reference it.
* Key: The absolute target URL (includes fragments).
* Value: A ConcurrentBag of Hashtable objects representing each occurrence:
  * `SourcePage`: The URL where the reference was found.
  * `Attribute`: The specific HTML attribute that contained the URL (e.g., href, src, data-src).
  * `OriginalHref`: The raw string from the HTML (could be an href, src, or other URI attribute).


## Integrated Sample Report
Upon completion, the script generates two types of output:
1. GridView Report: A pop up window (Out-GridView) that groups broken links by their full target URL. It shows the specific issue, the source pages containing the link, and the original href strings used in the HTML.  
2. Console Output: A text based summary printed directly in the terminal, color coding failed targets and listing the source pages for quick inspection.


## Custom Report: Link Leaderboard
The following unified reporting snippet utilizes `$ReferenceMap` to identify the most heavily linked targets. It supports deep link analysis (fragments), domain specific scoping (internal vs. external), and "ex-aequo" ranking. This ensures that if multiple targets share a top tier, they are all included in the output.  
```
# Toggle this to switch between "Exact Href (w/ fragments)" or "Base Page (no fragments)"
$IncludeFragments = $true

# Scope Toggle: 'Internal', 'External', or 'InternalAndExternal'
$TargetScope = 'InternalAndExternal'

# Detail Toggles
$ShowSourcePages = $false
$ShowOriginalHrefs = $false

# Define the "Top X" rank (e.g., show everyone in the top 10 tiers, allowing for ties/ex-aequo)
$TopX = 3

# Helper to identify internal targets based on the start domain
$ReferenceKeys = $ReferenceMap.Keys | Where-Object {
    try {
        $isInternal = (([uri]$_).Host -ieq $StartDomain) -or (([uri]$_).Host -ilike "*.$($StartDomain)")
    } catch {
        $isInternal = $false
    }
    if ($TargetScope -ieq 'Internal') { return $isInternal }
    if ($TargetScope -ieq 'External') { return -not $isInternal }
    return $true
}

# Group keys and calculate usage
$AllGroups = $ReferenceKeys | Group-Object {
    if ($IncludeFragments) { $_ } else { StandardizeAbsoluteUrl -InputString $_ -IncludeFragment $false }
} | Select-Object @{
    Name       = 'Target'
    Expression = { $_.Name }
}, @{
    Name       = 'TotalUsage'
    Expression = { ($_.Group | ForEach-Object { $ReferenceMap[$_].Count } | Measure-Object -Sum).Sum }
}, @{
    Name       = 'RelatedKeys'
    Expression = { $_.Group }
} | Sort-Object TotalUsage -Descending

# Determine the threshold for Top X including ties (ex-aequo, $AllGroups is already sorted by TotalUsage descending)
$ThresholdScore = ($AllGroups | Select-Object -ExpandProperty TotalUsage -Unique | Select-Object -First $TopX)[-1]
$ReportGroups = $AllGroups | Where-Object { $_.TotalUsage -ge $ThresholdScore }

# Output the unified report
Write-Host "Top $TopX Leaderboard (Scope: $TargetScope, Fragments: $IncludeFragments, Including Ties)"

foreach ($entry in $ReportGroups) {
    Write-Host "  $($entry.Target) (Total Usage: $($entry.TotalUsage))"

    if ($ShowSourcePages) {
        # Flatten all occurrences from the ReferenceMap for all related keys in this group
        $AllOccs = foreach ($key in $entry.RelatedKeys) { $ReferenceMap[$key] }

        # Group by SourcePage to see unique original strings per source
        $SourceGroups = $AllOccs | Group-Object SourcePage
        foreach ($group in $SourceGroups) {
            Write-Host "    Used on: $($group.Name)"

            if ($ShowOriginalHrefs) {
                $OriginalsString = @($group.Group | ForEach-Object { "$($_.Attribute)='$($_.OriginalHref)'" } | Sort-Object -Culture 127 -Unique) -join ', '
                Write-Host "      As: $OriginalsString"
            }
        }
    }
}
```


## Post-Scan Data Analysis
After the script completes, it leaves several variables in your session for manual inspection:
- `$StartUrl`: The URL to begin the search on.
- `$SitmapUrl`: The URL of the sitemap.xml file to use.
- `$StartDomain`: The base domain of the search (`([uri]$StartUrl).Host` or `([uri]$SitemapUrl).Host)`).
- `$PageData`: A thread-safe dictionary containing the status and fragment IDs for every crawled page.
- `$ReferenceMap`: A dictionary mapping every target URL to a list of pages that link to it.

If you want to save the state of a scan to a single file for later analysis, you can bundle the critical data structures into a CliXml file.

To export to a single file, run this after a scan finishes to save the domain, page cache, and reference map:
```
@{
    # Script parameters
    StartUrl        = $StartUrl
    SitemapUrl      = $Sitemapurl
    BrowserType     = $BrowserType
    BrowserHeadless = $BrowserHeadless
    CheckFragments  = $CheckFragments
    ParallelWorkers = $ParallelWorkers
    ExportFile      = $ExportFile

    # Other variables
    StartDomain    = $StartDomain
    PageData       = $PageData
    ReferenceMap   = $ReferenceMap
} | Export-CliXml -Path 'checklinks scan data.clixml' -Force
```

To load and restore the data, run this:
```
$ImportedData = Import-CliXml -Path "checklinks scan data.clixml"

# Script parameters
$StartUrl        = $ImportedData.StartUrl
$SitemapUrl      = $ImportedData.Sitemapurl
$BrowserType     = $ImportedData.BrowserType
$BrowserHeadless = $ImportedData.BrowserHeadless
$CheckFragments  = $ImportedData.CheckFragments
$ParallelWorkers = $ImportedData.ParallelWorkers
$ExportFile      = $ImportedData.ExportFile

# Other variables
$StartDomain    = $ImportedData.StartDomain
$PageData       = $ImportedData.PageData
$ReferenceMap   = $ImportedData.ReferenceMap
```