---
layout: page
lang: de
locale: de
title: Set-Outlook&shy;Signatures herunterladen
subtitle: Holen Sie sich die kostenlose und quelloffene Kernversion
description: E-Mail-Signaturen und Abwesenheitsnotizen für Exchange und alle Varianten von Outlook. Voller Funktionsumfang, kosteneffizient, unübertroffener Datenschutz.
image:
  path: "/assets/images/set-outlooksignatures benefactor circle opengraph1200x630.png"
  height: 1200
  width: 630
  alt: "Set-OutlookSignatures Benefactor Circle"
page_id: "download"
permalink: /download/
---
<h2 id="set-outlooksignatures">Set-OutlookSignatures</h2>
<p>
Set-OutlookSignatures ist der Open-Source-Standard für E-Mail-Signaturen und Abwesenheitsnotizen für Exchange und alle Varianten von Outlook. Voller Funktionsumfang, kosteneffizient, unübertroffener Datenschutz.
</p>

<p><a id="download-link" href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases"><button class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-color: limegreen">➔ Software herunterladen</button></a></p>

<p><a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/blob/main/docs/CHANGELOG.md"><button class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-color: limegreen">➔ Changelog lesen</button></a></p>

<p>Sie können Signaturen in wenigen Minuten verteilen. Folgen Sie der einfachen 3-Schritte-Anleitung, um einen Einblick in die Möglichkeiten von Set-OutlookSignatures zu erhalten und einen soliden Ausgangspunkt für Ihre eigenen Anpassungen zu schaffen.</p>

<p><a href="/quickstart"><button class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-color: limegreen">➔ Schnellstart-Anleitung</button></a></p>

<h2 id="benefactor-circle">Das <span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle Add-On</span></h2>
<p>Das Benefactor Circle Add-On von <a href="https://explicitconsulting.at">ExplicIT Consulting</a> erweitert die Open-Source-Version um großartige zusätzliche Funktionen für Ihr Unternehmen.</p>

<p><a href="/benefactorcircle"><button class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod)">➔ Das Benefactor Circle Add-On</button></a></p>

<script>
    // Function to fetch the latest release and update the link
    async function updateDownloadLink() {
        const owner = 'Set-OutlookSignatures';
        const repo = 'Set-OutlookSignatures';
        const repoURL = `https://api.github.com/repos/${owner}/${repo}/releases/latest`;

        try {
            const response = await fetch(repoURL);
            if (!response.ok) {
                throw new Error(`GitHub API request failed with status: ${response.status}`);
            }

            const data = await response.json();
            const firstAsset = data.assets[0];

            if (firstAsset && firstAsset.browser_download_url) {
                const downloadLink = document.getElementById('download-link');
                if (downloadLink) {
                    downloadLink.href = firstAsset.browser_download_url;
                }
            } else {
                console.error('No assets found for the latest release.');
            }
        } catch (error) {
            console.error('Error fetching latest release:', error);
        }
    }

    // Bind the function to the DOMContentLoaded event
    document.addEventListener('DOMContentLoaded', updateDownloadLink);
</script>