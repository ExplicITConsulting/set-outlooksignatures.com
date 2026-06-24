---
layout: "page"
lang: "en"
locale: "en"
title: "Test CSS"
subtitle: "Try stuff here"
description: "No description."
permalink: "/testcss"
redirect_from:
  - "/testcss/"
sitemap: false
---

## Markdown codeblocks

### no language

```
function ConvertDnToCanonicalObject {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$DistinguishedName
    )
[...]
variables:
  - ${{ if eq(variables['Build.SourceBranchName'], 'main') }}:
    - name: targetEnvironment
      value: 'Production'
  - ${{ else }}:
    - name: targetEnvironment
      value: 'Development'
```

### PowerShell

```powershell
function ConvertDnToCanonicalObject {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$DistinguishedName
    )

    process {
        $rdns = [regex]::Split($DistinguishedName, '(?<!\\),')

        $dcComponents = [System.Collections.Generic.List[string]]::new()
        $pathSegments = [System.Collections.Generic.List[string]]::new()

        foreach ($segment in $rdns) {
            $rdn = $segment.Trim()
            if (-not $rdn) { continue }

            $eq = $rdn.IndexOf('=')
            if ($eq -lt 1) { continue }

            $attr = $rdn.Substring(0, $eq).Trim()
            $val = ($rdn.Substring($eq + 1)).Trim() -replace '\\(.)', '$1' -replace '^"|"$', ''

            if ($attr -match '^(?i)DC$') {
                $dcComponents.Add($val)
            } else {
                $pathSegments.Add($val)
            }
        }

        $domainFqdn = $dcComponents -join '.'
        $pathSegments.Reverse() # Flip from Leaf->Root to Root->Leaf

        # 1. Full Canonical Path (FQDN/Segments/Leaf)
        $fullPathStr = $pathSegments -join '/'
        $canonicalPath = if ($fullPathStr) { "$domainFqdn/$fullPathStr" } else { $domainFqdn }

        # 2. Canonical Parent (FQDN/Segments)
        $parentSegmentsArray = if ($pathSegments.Count -gt 1) { $pathSegments.GetRange(0, $pathSegments.Count - 1) } else { @() }
        $parentPathOnly = $parentSegmentsArray -join '/'
        $canonicalParent = if ($parentPathOnly) { "$domainFqdn/$parentPathOnly" } else { $domainFqdn }

        [pscustomobject]@{
            DistinguishedName = $DistinguishedName
            CanonicalPath     = $canonicalPath
            CanonicalParent   = $canonicalParent
            CanonicalOUs      = $parentPathOnly   # <--- The "Clean" path without FQDN
            DomainFQDN        = $domainFqdn
            LeafValue         = if ($pathSegments.Count) { $pathSegments[-1] } else { $null }
        }
    }
}


# Example usage
# ConvertDnToCanonicalObject 'CN=Doe\, Jane,OU=OU B,OU=OU A,DC=example,DC=com'


# Example output
# DistinguishedName : CN=Doe\, Jane,OU=OU B,OU=OU A,DC=example,DC=com
# CanonicalPath     : example.com/OU A/OU B/Doe, Jane
# CanonicalParent   : example.com/OU A/OU B
# CanonicalOUs      : OU A/OU B
# DomainFQDN        : example.com
# LeafValue         : Doe, Jane
```

### YAML

```yaml
variables:
  - ${{ if eq(variables['Build.SourceBranchName'], 'main') }}:
      - name: targetEnvironment
        value: "Production"
  - ${{ else }}:
      - name: targetEnvironment
        value: "Development"
```

## Liquid syntax tags

### plaintext

{% highlight plaintext %}{% raw %}
function ConvertDnToCanonicalObject {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$DistinguishedName
    )
[...]
variables:
  - ${{ if eq(variables['Build.SourceBranchName'], 'main') }}:
    - name: targetEnvironment
      value: 'Production'
  - ${{ else }}:
    - name: targetEnvironment
      value: 'Development'
{% endraw %}{% endhighlight %}

### PowerShell

{% highlight powershell %}{% raw %}
function ConvertDnToCanonicalObject {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$DistinguishedName
    )

    process {
        $rdns = [regex]::Split($DistinguishedName, '(?<!\\),')

        $dcComponents = [System.Collections.Generic.List[string]]::new()
        $pathSegments = [System.Collections.Generic.List[string]]::new()

        foreach ($segment in $rdns) {
            $rdn = $segment.Trim()
            if (-not $rdn) { continue }

            $eq = $rdn.IndexOf('=')
            if ($eq -lt 1) { continue }

            $attr = $rdn.Substring(0, $eq).Trim()
            $val = ($rdn.Substring($eq + 1)).Trim() -replace '\\(.)', '$1' -replace '^"|"$', ''

            if ($attr -match '^(?i)DC$') {
                $dcComponents.Add($val)
            } else {
                $pathSegments.Add($val)
            }
        }

        $domainFqdn = $dcComponents -join '.'
        $pathSegments.Reverse() # Flip from Leaf->Root to Root->Leaf

        # 1. Full Canonical Path (FQDN/Segments/Leaf)
        $fullPathStr = $pathSegments -join '/'
        $canonicalPath = if ($fullPathStr) { "$domainFqdn/$fullPathStr" } else { $domainFqdn }

        # 2. Canonical Parent (FQDN/Segments)
        $parentSegmentsArray = if ($pathSegments.Count -gt 1) { $pathSegments.GetRange(0, $pathSegments.Count - 1) } else { @() }
        $parentPathOnly = $parentSegmentsArray -join '/'
        $canonicalParent = if ($parentPathOnly) { "$domainFqdn/$parentPathOnly" } else { $domainFqdn }

        [pscustomobject]@{
            DistinguishedName = $DistinguishedName
            CanonicalPath     = $canonicalPath
            CanonicalParent   = $canonicalParent
            CanonicalOUs      = $parentPathOnly   # <--- The "Clean" path without FQDN
            DomainFQDN        = $domainFqdn
            LeafValue         = if ($pathSegments.Count) { $pathSegments[-1] } else { $null }
        }
    }
}


# Example usage
# ConvertDnToCanonicalObject 'CN=Doe\, Jane,OU=OU B,OU=OU A,DC=example,DC=com'


# Example output
# DistinguishedName : CN=Doe\, Jane,OU=OU B,OU=OU A,DC=example,DC=com
# CanonicalPath     : example.com/OU A/OU B/Doe, Jane
# CanonicalParent   : example.com/OU A/OU B
# CanonicalOUs      : OU A/OU B
# DomainFQDN        : example.com
# LeafValue         : Doe, Jane
{% endraw %}{% endhighlight %}

### YAML

{% highlight yaml %}{% raw %}
variables:

- ${{ if eq(variables['Build.SourceBranchName'], 'main') }}:
  - name: targetEnvironment
    value: "Production"
- ${{ else }}: - name: targetEnvironment
  value: "Development"
{% endraw %}{% endhighlight %}

### YAML with linenumbers

{% highlight yaml linenos %}{% raw %}
variables:

- ${{ if eq(variables['Build.SourceBranchName'], 'main') }}:
  - name: targetEnvironment
    value: "Production"
- ${{ else }}: - name: targetEnvironment
  value: "Development"
{% endraw %}{% endhighlight %}
