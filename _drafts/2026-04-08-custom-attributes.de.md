---
layout: "post"
lang: "de"
locale: "de"
title: "Benutzerdefinierte Attribute und berechnete Daten in E-Mail-Signaturen"
description: "Die meisten Informationen, die in E-Mail-Signaturen verwendet werden, stammen direkt aus Ihrem Verzeichnisdienst. Aber was ist mit den Daten, für die es kein vordefiniertes Feld gibt?"
published: true
tags: 
slug: "custom-attributes"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
Die meisten Informationen, die in E-Mail-Signaturen verwendet werden, stammen direkt aus Ihrem Verzeichnisdienst. Vor- und Nachnamen, Berufsbezeichnungen, Telefonnummern, Bürostandorte und sogar Angaben zu Vorgesetzten sind in der Regel bereits vorhanden.

Aber was ist mit den Daten, für die es kein vordefiniertes Feld gibt? Beispiele hierfür sind:
- Berufsbezeichnungen in mehreren Sprachen
- Akademische Titel, die vor oder nach dem Namen stehen
- Arbeitszeiten für Teilzeit- oder Schichtarbeit
- Geschlechtspronomen zur Unterstützung einer inklusiven Kommunikation

Sie können diese Daten zentral speichern, indem Sie benutzerdefinierte Attribute verwenden. In Exchange stehen standardmäßig 15 benutzerdefinierte Attribute zur Verfügung. Sie können auch eigene Attribute in Active Directory oder Entra ID erstellen.

Set-OutlookSignatures erleichtert die Arbeit mit diesen Daten:
- Verwenden Sie vordefinierte Ersatzvariablen wie \$CurrentUserExtAttr1\$ oder \$CurrentMailboxManagerExtAttr2\$.
- Stellen Sie eine Verbindung zu externen Datenquellen wie CSV-Dateien, Datenbanken oder Webdiensten her.
- Verwenden Sie PowerShell-Logik, um Werte dynamisch zu berechnen.

Sie können auch bedingte Logik verwenden, um interne Abteilungsnamen öffentlichen Namen zuzuordnen, oder saisonale Regeln auf Signaturinhalte anwenden.

## Möchten Sie mehr erfahren oder unsere Lösung in Aktion sehen?
[Kontaktieren Sie uns](/contact) oder erfahren Sie mehr auf unserer [Website](/). Wir freuen uns darauf, mit Ihnen in Kontakt zu treten!