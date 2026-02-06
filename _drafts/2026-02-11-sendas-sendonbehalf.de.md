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
In statischen Umgebungen ist dies in der Regel unkompliziert. In dynamischen Organisationen kann es jedoch schnell zu einer Herausforderung werden. Delegierungsszenarien ändern sich häufig, insbesondere wenn Benutzer während Urlaubs- oder Krankheitszeiten temporäre Berechtigungen erteilen.

So vereinfacht die Kombination aus [Export-RecipientPermissions](https://explicitconsulting.at/open-source/export-recipientpermissions) und Set-OutlookSignatures den Prozess:
- Export-RecipientPermissions dokumentiert und vergleicht Postfachberechtigungen. Sie können Benutzer automatisch über die von ihnen erteilten oder erhaltenen Berechtigungen benachrichtigen.
- Set-OutlookSignatures verwendet diese Daten, um Benutzern, die über Berechtigungen zum Senden als oder im Namen eines anderen Benutzers für ein anderes Postfach verfügen, dynamisch zusätzliche Signaturen zuzuweisen. Am einfachsten lässt sich dies mit dem Parameter „[VirtualMailboxConfigFile](/parameters#38-virtualmailboxconfigfile)” erreichen.

Das Ergebnis ist eine vollständig automatisierte, aktuelle Signaturbereitstellung, die sich an die tatsächliche Nutzung anpasst. Keine manuelle Nachverfolgung, keine veralteten Konfigurationen.


## Möchten Sie mehr erfahren oder unsere Lösung in Aktion sehen?
[Kontaktieren Sie uns](/support) oder erfahren Sie mehr auf unserer [Website](/). Wir freuen uns darauf, Sie kennenzulernen!