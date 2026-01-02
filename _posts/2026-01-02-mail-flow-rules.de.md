---
layout: "post"
lang: "de"
locale: "de"
title: "Mail-Flow-Regeln funktionieren nicht für professionelle Signaturen"
description: "Mail-Flow-Regeln in Exchange sind im Vergleich zu speziellen E-Mail-Signaturlösungen veraltet und unflexibel."
published: true
tags:
slug: "mail-flow-rules"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
Seit vielen Jahren liest und hört man immer wieder, dass spezialisierte Lösungen zur zentralen Verwaltung und Verteilung von E-Mail-Signaturen nicht nötig sind, weil das in Exchange Server und Exchange Online mit [Mail Flow Rules](https://learn.microsoft.com/en-us/exchange/policy-and-compliance/mail-flow-rules/signatures) (auch bekannt als Transport Rules) direkt gelöst werden kann.

Der erste Eindruck mag positiv sein. Brauchbar sind Mail-Flow-Regeln in der Praxis aber nur für die niedrigsten Ansprüche an Signaturen und wenn man seine Benutzer, sein Marketing und auch die Empfänger von E-Mails enttäuschen möchte.

In aller Kürze und Direktheit:
- Microsoft aktualisiert Mail-Flow-Regeln seit Jahren nicht mehr.
- Benutzer sehen Signaturen nicht, während sie eine E-Mail schreiben.
- Die Zuordnung von Signaturen zu bestimmten Postfächern, Gruppen oder Benutzern ist unflexibel.
- Signaturen werden am Ende des gesamten Threads eingefügt, nicht am Ende der letzten E-Mail. Das bedeutet, dass Signaturen nicht dort erscheinen, wo sie hingehören, sondern gesammelt am Ende der Konversation – wo sie kaum jemand wahrnimmt.
- Es ist nicht möglich, zwischen neuen E-Mails und Antworten/Weiterleitungen zu unterscheiden.
- Die verfügbaren Platzhaltervariablen beziehen sich praktisch ausschließlich auf den Absender. Es gibt keine Variablen für den Manager des Absenders oder die Möglichkeit, zwischen Variablen des tatsächlichen Absenders und des sendenden Postfachs zu unterscheiden.
- Platzhaltervariablen können nicht angepasst werden.
- Aufgrund der [Limits für Mail-Flow-Regeln](https://learn.microsoft.com/en-us/office365/servicedescriptions/exchange-online-service-description/exchange-online-limits#journal-transport-and-inbox-rule-limits-1) ist der HTML-Code der Signaturen in der Größe beschränkt, und Bilder können typischerweise nur verlinkt, nicht eingebettet werden. Das kollidiert mit zwei Verhaltensweisen von Outlook:
  - Extern verlinkte Inhalte werden standardmäßig aus Sicherheitsgründen blockiert. Der Benutzer muss Outlook anweisen, die Bilder herunterzuladen, sonst erscheinen Platzhalter, die wie Fehlermeldungen wirken.
  - Beim Antworten werden verlinkte Bilder heruntergeladen und eingebettet – aber die Auflösung wird herunterskaliert, was zu unscharfen und pixeligen Bildern führt.


## Fazit
Mail Flow Rules sind eine Notlösung, die weder den Anforderungen moderner Markenkommunikation noch den Erwartungen der Benutzer gerecht wird.

Wer professionelle, konsistente und visuell ansprechende Signaturen möchte, kommt an spezialisierten Lösungen nicht vorbei.


## Möchten Sie mehr erfahren oder unsere Lösung in Aktion sehen?
[Kontaktieren Sie uns](/support) oder erfahren Sie mehr auf unserer [Website](/). Wir freuen uns darauf, mit Ihnen in Kontakt zu treten!