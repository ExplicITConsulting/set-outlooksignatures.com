---
layout: page
title: |
  <p class="has-text-white">
    Download Set-OutlookSignatures
  </p>
subtitle: |
  <p class="subtitle is-3 has-text-white">
    Get the Free and Open-Source core version
  </p>
description: |
  Download Set-OutlookSignatures. Get the Free and Open-Source core version. GitHub. FOSS.
image:
  path: "/assets/images/set-outlooksignatures benefactor circle opengraph1200x630.png"
  height: 1200
  width: 630
  alt: "Set-OutlookSignatures Benefactor Circle"
redirect_from:
---

## Set-OutlookSignatures
Set-OutlookSignatures is the open-source gold standard for email signatures and out-of-office replies for Exchange and all of Outlook. Full-featured, cost-effective, unsurpassed data privacy.

The latest release of the free and open-source core version of Set-OutlookSignatures is <span class="version-text">Loading...</span>.

Read the <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/blob/main/docs/CHANGELOG.md" target="_blank">changelog</a>, or directly <a id="download-link" href="#" target="_blank">download <span class="version-text">Loading...</span> as ZIP file</a>.

<script>
  fetch('https://api.github.com/repos/Set-OutlookSignatures/Set-OutlookSignatures/releases/latest')
    .then(response => response.json())
    .then(data => {
      document.querySelectorAll('.version-text').forEach(span => {
        span.textContent = data.tag_name;
      });

      document.getElementById('download-link').href = `https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases/download/${data.tag_name}/Set-OutlookSignatures_${data.tag_name}.zip`;
    })
    .catch(error => {
      console.error('Error fetching release info:', error);
    });
</script>


## The Benefactor Circle add-on
ExplicIT's [Benefactor Circle add-on](benefactorcircle.md) enhances the open-source version with a great set of additional features.

See the [Benefactor Circle add-on](benefactorcircle.md) site for details on how to purchase and buy the add-on.


<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
