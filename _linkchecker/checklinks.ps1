#Requires -Version 7.5

# --- Configuration ---
$SitemapUrl = 'https://set-outlooksignatures.com/sitemap.xml'
$StartUrl    = 'https://set-outlooksignatures.com'

# --- Initialization ---
# This map stores: "Link" = @("Page1", "Page2")
$LinkSourceMap = @{} 
$PagesChecked  = New-Object 'System.Collections.Generic.HashSet[string]'
$Queue         = New-Object 'System.Collections.Generic.Queue[string]'
$PageContentCache = @{}

if ($StartUrl) {
    $StartDomain = ([uri]$StartUrl).Host
} elseif ($SitemapUrl) {
    $StartDomain = ([uri]$SitemapUrl).Host
} else {
    Write-Host 'You must specify at least a SitemapUrl or a StartUrl.' -ForegroundColor Red
    exit 1
}

# Helper function to track which page links to what
function Add-LinkMapping {
    param($Link, $SourcePage)
    if (-not $LinkSourceMap.ContainsKey($Link)) {
        $LinkSourceMap[$Link] = New-Object 'System.Collections.Generic.HashSet[string]'
    }
    $null = $LinkSourceMap[$Link].Add($SourcePage)
}

if ($StartUrl) {
    $Queue.Enqueue($StartUrl)
}

# --- Sitemap Processing ---
if ($SitemapUrl) {
    try {
        $response = Invoke-WebRequest -Uri $SitemapUrl -UseBasicParsing
        [xml]$Sitemap = $response.Content

        $ns = New-Object System.Xml.XmlNamespaceManager($Sitemap.NameTable)
        $ns.AddNamespace('ns', 'http://www.sitemaps.org/schemas/sitemap/0.9')
        $ns.AddNamespace('xhtml', 'http://www.w3.org/1999/xhtml')

        $locLinks = $Sitemap.SelectNodes('//ns:loc', $ns) | Select-Object -ExpandProperty '#text'
        $xhtmlLinks = $Sitemap.SelectNodes('//xhtml:link', $ns) | ForEach-Object { $_.getAttribute('href') }

        ($locLinks + $xhtmlLinks) | Select-Object -Unique | ForEach-Object {
            $Queue.Enqueue($_)
            Add-LinkMapping -Link $_ -SourcePage "Sitemap"
        }
    } catch {
        Write-Host "Failed to download or parse sitemap: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Add-Type -AssemblyName System.Web

function GetLinksFromWebsite {
    param ([Parameter(Mandatory = $true)][string]$Url)
    try {
        $absoluteLinks = New-Object 'System.Collections.Generic.HashSet[string]'
        $baseUri = [System.Uri]$Url
        $response = Invoke-WebRequest -Uri $Url -ErrorAction Stop -TimeoutSec 15

        foreach ($link in $response.Links.href) {
            if ([string]::IsNullOrWhiteSpace($link)) { continue }
            try {
                $transformedUri = [System.Uri]::new($baseUri, $link)
                if ($transformedUri.Scheme -iin @('http', 'https')) {
                    $null = $absoluteLinks.Add($transformedUri.AbsoluteUri)
                }
            } catch { continue }
        }
        return $absoluteLinks
    } catch {
        Write-Host "    Failed to retrieve links from $Url" -ForegroundColor Yellow
        return $null
    }
}

# --- Crawl Loop ---
Write-Host "Crawling $StartDomain..."
while ($Queue.Count -gt 0) {
    $CurrentUrl = $Queue.Dequeue()
    $CurrentUrlClean = @($CurrentUrl -split '#(?!/)', 2)[0]

    if ($PagesChecked.Contains($CurrentUrlClean)) { continue }
    $null = $PagesChecked.Add($CurrentUrlClean)

    Write-Host "  $CurrentUrlClean"
    $LinksOnPage = GetLinksFromWebsite -Url $CurrentUrl

    if ($null -ne $LinksOnPage) {
        foreach ($link in $LinksOnPage) {
            # Map the link to the current page
            Add-LinkMapping -Link $link -SourcePage $CurrentUrlClean

            try {
                $foundUri = [uri]$link
                $linkClean = @($link -split '#(?!/)', 2)[0]

                # If link is internal, add to queue for further crawling
                if ($foundUri.Host -eq $StartDomain -or $foundUri.Host.EndsWith(".$StartDomain")) {
                    if (-not $PagesChecked.Contains($linkClean)) {
                        $Queue.Enqueue($linkClean)
                    }
                }
            } catch { continue }
        }
    }
}

# --- Validation Logic ---
Write-Host
Write-Host "Verifying $($LinkSourceMap.Count) unique links found"
$LinkResults = New-Object 'System.Collections.Generic.List[PSObject]'

foreach ($link in $LinkSourceMap.Keys) {
    $uriParts = @($link -split '#(?!/)', 2)
    $baseUrl = $uriParts[0]
    $rawAnchor = if ($uriParts.Count -gt 1) { $uriParts[1] } else { $null }
    $decodedAnchor = [System.Web.HttpUtility]::UrlDecode($rawAnchor)

    $pageExists = $false
    $anchorExists = $null
    $statusCode = 0

    if (-not $PageContentCache.ContainsKey($baseUrl)) {
        try {
            $response = Invoke-WebRequest -Uri $baseUrl -Method Get -TimeoutSec 10 -ErrorAction Stop
            $PageContentCache[$baseUrl] = $response.Content
            $pageExists = $true
            $statusCode = [int]$response.StatusCode
        } catch {
            $PageContentCache[$baseUrl] = $null
            $statusCode = if ($_.Exception.Response) { [int]$_.Exception.Response.StatusCode } else { 0 }
        }
    } else {
        $pageExists = $null -ne $PageContentCache[$baseUrl]
        $statusCode = 200
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
        StatusCode    = $statusCode
        FoundOnPages  = ($LinkSourceMap[$link] -join '; ') # All pages containing this link
    })
}

# --- Final Results ---
Write-host
Write-Host "Broken Links"
$LinkResults | Where-Object { (-not $_.BasePageValid) -or ($_.AnchorFound -eq $false) } | Select-Object FullLink, StatusCode, BasePageValid, AnchorFound, FoundOnPages | Format-List