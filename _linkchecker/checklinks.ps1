$AllLinksToCheck = New-Object 'System.Collections.Generic.HashSet[string]'
$PagesChecked = New-Object 'System.Collections.Generic.HashSet[string]'
$Queue = New-Object 'System.Collections.Generic.Queue[string]'

# Define the URL of the sitemap AND/OR a StartUrl
$SitemapUrl = 'https://set-outlooksignatures.com/sitemap.xml'
$StartUrl = 'https://set-outlooksignatures.com'

if ($StartUrl) {
    $StartDomain = ([uri]$StartUrl).Host
} elseif ($SitemapUrl) {
    $StartDomain = ([uri]$SitemapUrl).Host
} else {
    Write-Error 'You must specify at least a SitemapUrl or a StartUrl.'
    exit 1
}

if ($StartUrl) {
    $Queue.Enqueue($StartUrl)
}

if ($SitemapUrl) {
    try {
        # Fetch the sitemap content from the web
        $response = Invoke-WebRequest -Uri $SitemapUrl -UseBasicParsing
        [xml]$Sitemap = $response.Content

        # Initialize Namespace Manager to handle Sitemap and XHTML prefixes
        $ns = New-Object System.Xml.XmlNamespaceManager($Sitemap.NameTable)
        $ns.AddNamespace('ns', 'http://www.sitemaps.org/schemas/sitemap/0.9')
        $ns.AddNamespace('xhtml', 'http://www.w3.org/1999/xhtml')

        # 1. Extract standard <loc> links
        $locLinks = $Sitemap.SelectNodes('//ns:loc', $ns) | Select-Object -ExpandProperty '#text'

        # 2. Extract <xhtml:link> href attributes (localization links)
        $xhtmlLinks = $Sitemap.SelectNodes('//xhtml:link', $ns) | ForEach-Object { $_.getAttribute('href') }

        # Combine all links and remove duplicates
        $allLinks = ($locLinks + $xhtmlLinks) | Select-Object -Unique

        # Display the results
        $allLinks | ForEach-Object {
            $Queue.Enqueue($_)
        }
    } catch {
        Write-Error "Failed to download or parse the sitemap: $($_.Exception.Message)"
    }
}

# Required to access the UrlDecode method
Add-Type -AssemblyName System.Web

function GetLinksFromWebsite {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Url
    )

    try {
        $absoluteLinks = New-Object 'System.Collections.Generic.HashSet[string]'
        $baseUri = [System.Uri]$Url
        $response = Invoke-WebRequest -Uri $Url -ErrorAction Stop

        foreach ($link in $response.Links.href) {
            if ([string]::IsNullOrWhiteSpace($link)) {
                continue
            }

            try {
                $transformedUri = [System.Uri]::new($baseUri, $link)

                if ($transformedUri.Scheme -iin @('http', 'https')) {
                    $null = $absoluteLinks.Add($transformedUri.AbsoluteUri)
                } else {
                    continue
                }
            } catch {
                continue
            }
        }
        return $absoluteLinks
    } catch {
        Write-Host "    Failed to retrieve links from $($Url)" -ForegroundColor Yellow
        return $null
    }
}

# Main recursive loop
Write-Host 'Crawling'
while ($Queue.Count -gt 0) {
    $CurrentUrl = $Queue.Dequeue()

    # Normalize the current URL by removing fragments for the 'Checked' check
    $CurrentUrlClean = @($CurrentUrl -split '#(?!/)')[0]
    if ($PagesChecked.Contains($CurrentUrlClean)) { continue }
    $null = $PagesChecked.Add($CurrentUrlClean)

    Write-Host "  $($CurrentUrlClean)"

    $LinksOnPage = GetLinksFromWebsite -Url $CurrentUrl

    foreach ($link in $LinksOnPage) {
        # 1. Add the FULL link (including #) to your final collection
        $null = $AllLinksToCheck.Add($link)

        # 2. Determine if the base page should be crawled
        try {
            $foundUri = [uri]$link
            $linkClean = @($link -split '#(?!/)')[0]

            # Domain/Subdomain check
            if ($foundUri.Host -eq $StartDomain -or $foundUri.Host.EndsWith(".$StartDomain")) {
                # Only enqueue if the BASE page hasn't been checked
                if (-not $PagesChecked.Contains($linkClean)) {
                    $Queue.Enqueue($linkClean)
                }
            }
        } catch { continue }
    }
}

Write-Host
Write-Host 'Crawl results'
Write-Host "  Unique Pages crawled (without fragments): $($PagesChecked.Count)"
Write-Host "  Unique Links found (with fragments): $($AllLinksToCheck.Count)"




$LinkResults = New-Object 'System.Collections.Generic.List[PSObject]'
$PageContentCache = @{}

Write-Host
Write-Host "Verifying $($AllLinksToCheck.Count) links"

foreach ($link in $AllLinksToCheck) {
    #Write-Host "  $($link)"

    if (([uri]$link).Scheme -inotin ('http', 'https')) {
        continue
    }

    $uriParts = @($link -split '#(?!/)')
    $baseUrl = $uriParts[0]
    $rawAnchor = $(if ($uriParts.Count -gt 1) { $uriParts[1] } else { $null })
    $decodedAnchor = [System.Web.HttpUtility]::UrlDecode($rawAnchor)

    $pageExists = $false
    $anchorExists = $null
    $statusCode = 0

    # 1. Fetch Page (with Cache)
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

    # 2. Check Decoded Anchor
    if ($pageExists -and ![string]::IsNullOrEmpty($rawAnchor)) {
        # Convert %C3%A4 back to 'ä' for matching against the HTML source
        $html = $PageContentCache[$baseUrl]

        # Regex to find id="anchor" or name="anchor" (Literal match)
        $pattern = "(id|name)=['""]$([regex]::Escape($decodedAnchor))['""]"

        if ($html -match $pattern) {
            $anchorExists = $true
        } else {
            $anchorExists = $false
        }
    }

    $LinkResults.Add([PSCustomObject]@{
            FullLink      = $link
            DecodedAnchor = $decodedAnchor
            BasePageValid = $pageExists
            AnchorFound   = $anchorExists
            StatusCode    = $statusCode
        })
}

$LinkResults | Where-Object { (-not $_.BasePageValid) -or ($_.DecodedAnchor -and (-not $_.AnchorFound)) }