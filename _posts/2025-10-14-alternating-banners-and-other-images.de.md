---
layout: "post"
lang: "de"
locale: "de"
title: "Banner und andere Bilder zufällig wechseln"
description: "Führen Sie eine Marketingkampagne mit mehreren Bannern durch?"
published: true
author: Markus Gruber
tags: 
slug: "alternating-banners-and-other-images"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
## Führen Sie eine Marketingkampagne mit mehreren Bannern durch?

Diese manuell in den Signaturen Ihres Teams zu rotieren, ist nahezu unmöglich und definitiv nicht skalierbar.

Mit Set-OutlookSignatures können Sie die Bannerrotation mühelos automatisieren, indem Sie flexible, auf Ihre Bedürfnisse zugeschnittene Bedingungen verwenden.

Ob Sie nun:
- Banner nach dem Zufallsprinzip rotieren möchten, um eine Ermüdung der Betrachter zu vermeiden,
- bestimmte Banner für bestimmte Abteilungen oder Standorte anzeigen möchten,
- Banner je nach Saison, Datum oder sogar externen Daten wie Wetter oder Aktienkursen anpassen möchten

All das ist möglich und einfach zu implementieren.

1. Fügen Sie alle Banner zu Ihrer Vorlage hinzu und definieren Sie einen alternativen Text  
   - Verwenden Sie '`$CurrentMailbox_Banner1DELETEEMPTY$`' für Banner 1, '`$CurrentMailbox_Banner2DELETEEMPTY$`' für Banner 2 usw.  
   - Der Teil 'DELETEEMPTY' löscht ein Bild, wenn die entsprechende Ersatzvariable keinen Wert enthält.
2. Erstellen Sie eine benutzerdefinierte Ersatzvariable für jedes Banner in Ihrer Konfigurationsdatei für Ersatzvariablen und weisen Sie nur einer dieser Variablen zufällig einen Wert zu:
    ```powershell
    $tempBannerIdentifiers = @(1, 2, 3)

    $tempBannerIdentifiers | Foreach-Object {
        $ReplaceHash["CurrentMailbox_Banner$($_)"] = $null
    }

    $ReplaceHash["CurrentMailbox_Banner$($tempBannerIdentifiers | Get-Random)"] = $true

    Remove-Variable -Name 'tempBannerIdentifiers'
    ```
Jetzt wird bei jedem Ausführen von Set-OutlookSignatures ein anderes zufälliges Banner aus der Vorlage ausgewählt und die anderen Banner werden gelöscht.

Sie können dies noch weiter verbessern:  
- Verwenden Sie Banner 1 doppelt so oft wie die anderen. Fügen Sie es einfach mehrmals zum Code hinzu: '`$tempBannerIdentifiers = @(1, 1, 2, 3)`'  
- Weisen Sie Banner bestimmten Benutzern, Abteilungen, Standorten oder anderen Attributen zu.  
- Beschränken Sie die Verwendung von Bannern nach Datum oder Jahreszeit.  
- Sie können Banner basierend auf Ihrem Aktienkurs oder dem von einem Webdienst abgefragten Wetter zuweisen.  
- Und vieles mehr, einschließlich beliebiger Kombinationen der oben genannten Optionen.

## Möchten Sie mehr erfahren oder unsere Lösung in Aktion sehen?
[Kontaktieren Sie uns](/contact) oder erfahren Sie mehr auf unserer [Website](). Wir freuen uns darauf, mit Ihnen in Kontakt zu treten!