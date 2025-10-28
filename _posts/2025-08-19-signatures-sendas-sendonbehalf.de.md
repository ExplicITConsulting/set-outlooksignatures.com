---
layout: "post"
lang: "de"
locale: "de"
title: "Signaturen für Senden Als und Senden Im Auftrag Von"
description:
published: true
author: Markus Gruber
tags: 
slug: "signatures-sendas-sendonbehalf"
permalink: "/blog/:year/:month/:day/:slug/"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
## Wie implementieren Sie Signaturen für Szenarien mit „Senden Als” und „Senden Im Auftrag Von”?

Sie möchten Signaturen für Postfächer oder Verteilerlisten zuweisen, die Benutzer nicht zu Outlook hinzufügen, sondern durch Auswahl einer anderen Absenderadresse mit den Rechten "Senden als" oder "Senden im Auftrag von" verwenden?

Mit Set-OutlookSignatures ist dies ganz einfach, wenn Sie die Best Practices von Microsoft für Berechtigungen befolgen:
- Weisen Sie die Berechtigungen „Senden als“ oder „Senden im Namen von“ einer Gruppe zu, nicht direkt einem Benutzer.
- Erstellen Sie eine Signaturvorlage und weisen Sie sie dieser Gruppe zu.

## Möchten Sie mehr erfahren oder unsere Lösung in Aktion sehen?
[Kontaktieren Sie uns](/contact/) oder erfahren Sie mehr auf unserer [Website](/). Wir freuen uns darauf, mit Ihnen in Kontakt zu treten!