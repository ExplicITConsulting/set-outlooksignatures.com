---
layout: "post"
lang: "de"
locale: "de"
title: "Signaturen für \"Senden als\" und \"Senden im Auftrag von\""
description: "In statischen Umgebungen ist dies in der Regel unkompliziert. In dynamischen Organisationen kann es jedoch schnell zu einer Herausforderung werden."
published: true
tags: 
slug: "sendas-sendonbehalf"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
In kleinen und statischen Umgebungen sind Signaturen für "Senden Als" und "Senden im Auftrag von" in der Regel unkompliziert. In dynamischen Umgebungen kann dies jedoch schnell zu einer Herausforderung werden: Delegierungsszenarien ändern sich häufig, insbesondere wenn Benutzer während Urlaubs- oder Krankheitszeiten temporäre Berechtigungen erteilen.

Die Kombination aus [Export-RecipientPermissions](https://explicitconsulting.at/open-source/export-recipientpermissions) und Set-OutlookSignatures automatisiert den Prozess:
- Export-RecipientPermissions dokumentiert und vergleicht Postfachberechtigungen. Sie können Benutzer automatisch über die von ihnen erteilten oder erhaltenen Berechtigungen benachrichtigen.
- Set-OutlookSignatures kann diese Daten über den Parameter "[VirtualMailboxConfigFile](/parameters#virtualmailboxconfigfile)" verwenden. Benutzer erhalten so Signaturen für berechtigte Postfächer, selbst wenn sie diese nicht als Postfach in Outlook hinzugefüht haben. Selbstverständlich werden die Signaturen auch wieder entfernt, wenn die Berechtigung nicht mehr gegeben ist.

Das Ergebnis sind vollständig automatisierte, aktuelle Signaturen, die sich an die tatsächliche Nutzung anpassen. Keine manuelle Nachverfolgung, keine veralteten Konfigurationen.


## Möchten Sie mehr erfahren oder unsere Lösung in Aktion sehen?
[Kontaktieren Sie uns](/support) oder erfahren Sie mehr auf unserer [Website](/). Wir freuen uns darauf, Sie kennenzulernen!