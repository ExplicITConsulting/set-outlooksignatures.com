---
layout: "post"
lang: "de"
locale: "de"
title: "Aktueller Stand und Zukunft von Roaming-Signaturen"
description: "Als Microsoft im Jahr 2020 Roaming-Signaturen ankündigte, klang dies wie eine bahnbrechende Neuerung."
published: true
tags:
slug: "current-state-and-future-of-roaming-signatures"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
## Eine bahnbrechende Neuerung mit Pferdefuß
Als Microsoft im Jahr 2020 Roaming-Signaturen ankündigte, klang dies wie eine bahnbrechende Neuerung. Keine lokale Speicherung von Signaturen mehr. Ein einheitliches Erlebnis auf allen Geräten. Und endlich eine Lösung für die Beschränkung auf eine Signatur in Outlook on the web vor Ort.

So lautete zumindest die Theorie.

Schnellvorlauf bis Mitte 2025: Obwohl die meisten Mandanten Roaming-Signaturen nun aktiviert haben, ist die Realität komplizierter:
- Es gibt immer noch keine öffentliche API.
- Einige hartnäckige Fehler sind nach wie vor ungelöst (z.B. werden [Kodierungen nicht korrekt konvertiert](/faq#roaming-signatures-in-classic-outlook-on-windows-look-different)).
- Outlook unterstützt Roaming-Signaturen nicht auf allen Plattformen.

Wir bei Set-OutlookSignatures und ExplicIT sind überzeugt, dass Roaming-Signaturen die Zukunft sind. Aber die langsame Einführung und die begrenzte Kommunikation seitens Microsoft haben die Einführung erschwert. Aus diesem Grund haben wir viel in die Unterstützung dieser Funktion innerhalb von Set-OutlookSignatures investiert und bieten Funktionen, die keine andere Lösung auf dem Markt bieten kann.

Unsere Empfehlung für die meisten Kunden:
- Aktivieren Sie Roaming-Signaturen in Ihrem Mandanten.
- Deaktivieren Sie sie auf der Client-Seite.
- Überlassen Sie Set-OutlookSignatures den Rest.

Wenn Sie Set-OutlookSignatures nicht auf Ihren Clients laufen lassen können oder wollen, verteilen Sie Signaturen mit '[SimulateAndDeploy](/parameters#simulateanddeploy)' von einer zentralen Stelle aus.

## Und wie sieht es mit der mobilen Unterstützung aus?
Derzeit ist dies ein Problem, das oft eine teure Umleitung auf der Serverseite erfordert, nur um eine Signatur anzuwenden. Sobald Microsoft jedoch eine offizielle API veröffentlicht, wird sich dies ändern.

In der Zwischenzeit schließt das [Outlook Add-In](/outlookaddin), Teil des [Benefactor Circle Add-ons](/benefactorcircle), diese Lücke - und mehr - nicht nur auf Android und iOS, sondern auf allen von Outlook unterstützen Plattformen.

## Möchten Sie mehr erfahren oder unsere Lösung in Aktion sehen?
[Kontaktieren Sie uns](/support) oder erfahren Sie mehr auf unserer [Website](/). Wir freuen uns darauf, Sie kennenzulernen!