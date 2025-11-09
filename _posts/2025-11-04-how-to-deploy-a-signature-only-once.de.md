---
layout: "post"
lang: "de"
locale: "de"
title: "Eine Signatur nur einmal verteilen – und eine clevere Alternative"
description: "Manchmal möchten Sie eine Signatur nur einmal bereitstellen zbd dem Benutzer die Möglichkeit geben, sie zu personalisieren."
published: true
author: Markus Gruber
tags:
slug: "how-to-deploy-a-signature-only-once"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
Signaturverwaltungslösungen wie Set-OutlookSignatures wurden entwickelt, um Benutzerfehler zu reduzieren, Aktualisierungen zu vereinfachen und IT- und Marketingteams die effiziente Verwaltung von Signaturen zu ermöglichen.

Manchmal möchten Sie eine Signatur nur einmal bereitstellen, dem Benutzer die Möglichkeit geben, sie zu personalisieren, und sie anschließend nie wieder überschreiben.

Es gibt drei Möglichkeiten, dies mit Set-OutlookSignatures zu erreichen:
1. **Verknüpfen Sie eine Vorlage mit einer benutzerdefinierten Ersatzvariablen**  
    Definieren Sie eine Signaturvorlage in Ihrer INI-Datei und verwenden Sie eine benutzerdefinierte Ersatzvariable, um die Bereitstellung zu steuern.

    Ihr benutzerdefinierter Code überprüft, ob die Signatur bereits vorhanden ist – wenn ja, setzt er die benutzerdefinierte Variable auf "false" und stoppt die Bereitstellung.
2. **Verwenden Sie den Parameter "VirtualMailboxConfigFile”, der im Add-on "Benefactor Circle” enthalten ist**  
    Bei dieser erweiterten Methode wird die Signaturkonfiguration vollständig im Code und nicht in der INI-Datei definiert.

    Ihr benutzerdefinierter Code kann bedingte Logik basierend auf Gruppenmitgliedschaft, Benutzerattributen und mehr enthalten.
3. **Die clevere Alternative: Stellen Sie eine Referenzsignatur bereit, die Benutzer kopieren und ändern können**  
    Dies ist der beliebteste Ansatz unter unseren Kunden. Anstatt eine einmalige Bereitstellung zu erzwingen, stellen Sie eine stets aktuelle Referenzsignatur bereit. Benutzer können diese kopieren, personalisieren und als ihre eigene verwenden.
    
    Technisch gesehen handelt es sich nicht um eine einmalige Bereitstellung, aber es ist eine clevere, benutzerfreundliche Alternative, die Konsistenz und Flexibilität in Einklang bringt.

## Möchten Sie mehr erfahren oder unsere Lösung in Aktion sehen?
[Kontaktieren Sie uns](/contact) oder erfahren Sie mehr auf unserer [Website](/). Wir freuen uns darauf, mit Ihnen in Kontakt zu treten!