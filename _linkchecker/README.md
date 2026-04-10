# CheckLinks.ps1
This PowerShell script is a modular multi threaded web crawler designed to identify broken links and missing anchor fragments across a website. It uses Playwright to render pages, ensuring that links within modern JavaScript frameworks and Shadow DOM elements are correctly identified and validated.


## Requirements and Prerequisites
* PowerShell 7.5 or higher.  
* FullLanguage mode (required for thread safe operations).  
* Internet access (the script automatically downloads the HtmlAgilityPack and PSPlaywright dependencies to a temporary folder during execution).  
* Administrative privileges are recommended for the initial Playwright browser installation.


## Parameters
* StartUrl: The initial URL where the crawl begins.  
* SitemapUrl: A URL to a sitemap.xml file. All entries in the sitemap will be added to the crawl queue.  
* BrowserType: Choose between Chromium, Firefox, or WebKit. Default is Chromium.  
* BrowserHeadless: Boolean. Set to $true to run the browser in the background or $false to watch the process.  
* CheckFragments: Boolean. If true, the script verifies that the specific ID or Name exists on the target page for links containing a \#fragment.  
* CheckFragmentsInternalOnly: Boolean. If true, fragment validation is only performed for internal domain links.  
* ParallelWorkers: Number of simultaneous browser instances. Defaults to the number of logical processors.

## Usage Example
Run the script using the default parameters:  
```
.\checklinks.ps1
```

To run a deep check including fragments on an external sitemap:  
```
.\checklinks.ps1 -SitemapUrl "https://set-outlooksignatures.com/sitemap.xml" -CheckFragments $true -CheckFragmentsInternalOnly $false
```


## Internal Data Structures
To create custom reports, you can access the two primary thread safe dictionaries populated during the crawl:

### $PageData
A thread safe dictionary used to store the results of each crawled page.
* Key: The absolute URL of the page (lowercased host, includes path and query, but excludes fragments).  
* Value: A Hashtable containing:  
  * IdsAndNames: A hashset of all unique id and name attributes found on the page (used for fragment validation).  
  * StatusCode: The numeric HTTP status code (e.g., 200, 404).  
  * StatusMessage: A descriptive string containing error details or notes (e.g., 'Is not text/html.').

### $ReferenceMap
A thread safe dictionary used for backlink analysis, mapping targets to their source occurrences.
* Key: The absolute target URL ($hrefAbsolute). This follows the same normalization as $PageData keys (lowercased host, includes path and query) but includes the fragment.  
* Value: A ConcurrentBag of Hashtable objects where each entry represents an occurrence of that specific link:  
  * SourcePage: The absolute URL of the page where the link was found (lowercased host, includes path and query, no fragment).  
  * OriginalHref: The raw string exactly as it appeared in the href attribute (e.g., relative paths like ../about or fragments like \#contact).


## Integrated Sample Report
Upon completion, the script generates two types of output:
1. GridView Report: A pop up window (Out-GridView) that groups broken links by their full target URL. It shows the specific issue, the source pages containing the link, and the original href strings used in the HTML.  
2. Console Output: A text based summary printed directly in the terminal, color coding failed targets and listing the source pages for quick inspection.


## Custom Report: Link Leaderboard
The following unified reporting snippet utilizes the $ReferenceMap to identify the most heavily linked targets. It supports deep link analysis (fragments), domain specific scoping (internal vs. external), and "ex-aequo" ranking. This ensures that if multiple targets share a top tier, they are all included in the output.  
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
                $OriginalsString = ($group.Group.OriginalHref | Sort-Object -Unique) -join ', '
                Write-Host "      As: $OriginalsString"
            }
        }
    }
}
```