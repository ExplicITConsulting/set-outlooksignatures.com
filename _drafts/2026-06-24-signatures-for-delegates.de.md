---
layout: "post"
lang: "de"
locale: "de"
title: "Signaturen für Mailbox-Delegierte, aber nicht für den Eigentümer"
description: "Dies ist eine häufige Anforderung in Szenarien mit Vorgesetzten und Sekretären oder Assistenten: Weisen Sie allen Personen mit Zugriff auf userA@example.com eine Signatur zu, außer Benutzer A."
published: true
author: Markus Gruber
tags: 
slug: "signatures-for-delegates"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
Dies ist eine häufige Anforderung in Szenarien zwischen Vorgesetzten und Sekretären oder Assistenten: "Weisen Sie allen Personen mit Zugriff auf userA@example.com eine Signatur zu, außer BenutzerA."

Mit Set-OutlookSignatures lässt sich dies ganz einfach umsetzen:
```
[delegate template name.docx]
# Die Vorlage allen Personen zuweisen, die userA@example.com als Postfach in Outlook haben.
userA@example.com
# Die Vorlage nicht dem Besitzer des Postfachs userA@example.com besitzt.
-CURRENTUSER:userA@example.com
```

Das war's schon. Einfach und effektiv.

Gehen wir nun einen Schritt weiter. Sie können eine einzige Delegiertenvorlage für Ihr gesamtes Unternehmen verwenden, um alle Delegierungsszenarien abzudecken.

Stellen Sie einfach sicher, dass die Vorlage \$CurrentUser[...]\$ und \$CurrentMailbox[...]\$ korrekt verwendet. Verwenden Sie die Vorlage dann in Ihrer .ini-Datei mit verschiedenen Signaturnamen wieder:
```
[Company EN external formal delegate.docx]
userA@example.com
-CURRENTUSER:userA@example.com
OutlookSignatureName = Company EN external formal userA@

[Company EN external formal delegate.docx]
userX@example.com
-CURRENTUSER:userX@example.com
OutlookSignatureName = Company EN external formal UserX@
```

## Möchten Sie mehr erfahren oder unsere Lösung in Aktion sehen?
[Kontaktieren Sie uns](/contact) oder erfahren Sie mehr auf unserer [Website](/). Wir freuen uns darauf, mit Ihnen in Kontakt zu treten!