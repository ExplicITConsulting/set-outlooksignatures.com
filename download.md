---
layout: page
title: |
  <span class="title is-2 has-text-white">
    Download Set-Outlook&shy;Signatures
  </span>
subtitle: |
  <span class="subtitle is-4 has-text-white">
    Get the Free and Open-Source core version
  </span>
description: |
  Download Set-OutlookSignatures. Get the Free and Open-Source core version. GitHub. FOSS.
image:
  path: "/assets/images/set-outlooksignatures benefactor circle opengraph1200x630.png"
  height: 1200
  width: 630
  alt: "Set-OutlookSignatures Benefactor Circle"
redirect_from:
---

<div style="min-height: 100vh;">
  <h2>Set-OutlookSignatures</h2>
  <p>
  Set-OutlookSignatures is the open-source standard for email signatures and out-of-office replies for Exchange and all of Outlook. Full-featured, cost-effective, unsurpassed data privacy.
  </p>

  <p><a id="download-link" href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-color: limegreen">➔ Download&nbsp;<span class="version-text">(loading…)</span>&nbsp;as ZIP file</button></a></p>

  <p><a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/blob/main/docs/CHANGELOG.md"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-color: limegreen">➔&nbsp;Open changelog</button></a></p>

  <p>You can deploy first signatures in less than an hour. Just follow the easy 3-step-process to get a glimpse of what Set-OutlookSignatures can do, and create a robust starting point for your own customizations.</p>

  <p><a href="/quickstart"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-color: limegreen">➔ Quick Start Guide</button></a></p>

  <h2>The <span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle add-on</span></h2>
  <p>The Benefactor Circle add-on from <a href="https://explicitconsulting.at">ExplicIT Consulting</a> enhances the open-source version with a great set of additional features for your enterprise.</p>

  <p><a href="/benefactorcircle"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod)">➔ The Benefactor Circle add-on</button></a></p>
</div>


<script>
  fetch('https://api.github.com/repos/Set-OutlookSignatures/Set-OutlookSignatures/releases/latest')
    .then(response => response.json())
    .then(data => {
      document.querySelectorAll('.version-text').forEach(span => {
        span.textContent = data.tag_name;
      });

      document.getElementById('download-link').href =
        `https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases/download/${data.tag_name}/Set-OutlookSignatures_${data.tag_name}.zip`;
    })
    .catch(error => {
      console.error('Error fetching release info:', error);
    });
</script>
