---
layout: "post"
lang: "de"
locale: "de"
title: "Kodierungen erkennen und konvertieren"
description: "ConvertEncoding ermöglicht die zuverlässige Erkennung und Konvertierung von Kodierungen"
published: true
tags:
slug: "detect-and-convert-encodings"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
Die Geschichte der Kodierung begann lange vor der IT. Selbst die ersten Alphabete waren Versuche, gesprochene Sprache in visuelle Symbole zu übersetzen. Ob Keilschrift, Hieroglyphen oder das lateinische Alphabet: Jede Kultur entwickelte ihre eigenen Systeme, um Informationen zu kodieren und über Zeit und Raum hinweg zu bewahren. 

Mit dem Aufkommen der Computer wurde die Kodierung zu einer technischen Herausforderung. Zeichen mussten in Bytes übersetzt werden, was zu über 140 verschiedenen Zeichenkodierungen führte, die moderne Betriebssysteme und Frameworks auch heute noch unterstützen. ASCII, ISO-8859, Windows-1252, Shift-JIS – jede Kodierung hat ihre eigenen Eigenschaften und Einschränkungen.

Unicode war und ist ein Meilenstein: Ein System, das (fast) alle Zeichen in allen Sprachen darstellen kann. Leider ist auch Unicode keine universelle Lösung. Es gibt mehrere Varianten (UTF-8, UTF-16, UTF-32), mit und ohne BOM und mit teilweise inkompatiblen Implementierungen.

HTML macht es noch komplizierter, indem es zwischen interner und externer Kodierung unterscheidet.

Die kostenlose und quelloffene PowerShell-Funktion ConvertEncoding, Teil von Set-OutlookSignatures, macht die leistungsstarke und ebenfalls kostenlose und quelloffene Bibliothek UTF.Unknown einfach nutzbar.

ConvertEncoding ermöglicht die zuverlässige Erkennung von Kodierungen über BOMs, HTML-Metadaten und heuristische Analysen und konvertiert Inhalte bei Bedarf in andere Formate. Selbst HTML-Dateien werden korrekt angepasst, einschließlich Meta-Tags. Dadurch lassen sich unterschiedliche Kodierungen leicht handhaben.

## Möchten Sie mehr erfahren oder unsere Lösung in Aktion sehen?
[Kontaktieren Sie uns](/support) oder erfahren Sie mehr auf unserer [Website](/). Wir freuen uns darauf, mit Ihnen in Kontakt zu treten!