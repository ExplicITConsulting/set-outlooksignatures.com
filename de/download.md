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
redirect_from:
---

<h2>Set-OutlookSignatures</h2>
<p>
Set-OutlookSignatures ist der Open-Source-Standard für E-Mail-Signaturen und Abwesenheitsnotizen für Exchange und alle Varianten von Outlook. Voller Funktionsumfang, kosteneffizient, unübertroffener Datenschutz.
</p>

<p><a id="download-link" href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-color: limegreen">➔ <span class="version-text">(lade…)</span>&nbsp;als ZIP-Datei herunterladen</button></a></p>

<p><a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/blob/main/docs/CHANGELOG.md"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-color: limegreen">➔ Changelog öffnen</button></a></p>

<p>Sie können erste Signaturen in unter einer Stunde verteilen. Folgen Sie der einfachen 3-Schritte-Anleitung, um einen Einblick in die Möglichkeiten von Set-OutlookSignatures zu erhalten und einen soliden Ausgangspunkt für Ihre eigenen Anpassungen zu schaffen.</p>

<p><a href="/quickstart"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-color: limegreen">➔ Schnellstart-Anleitung</button></a></p>

<h2>Das <span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle Add-On</span></h2>
<p>Das Benefactor Circle Add-On von <a href="https://explicitconsulting.at">ExplicIT Consulting</a> erweitert die Open-Source-Version um großartige zusätzliche Funktionen für Ihr Unternehmen.</p>

<p><a href="/benefactorcircle"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod)">➔ Das Benefactor Circle Add-On</button></a></p>


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
