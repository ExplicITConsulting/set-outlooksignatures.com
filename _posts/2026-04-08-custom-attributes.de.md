---
layout: "post"
lang: "de"
locale: "de"
title: "Benutzerdefinierte Attribute und berechnete Daten in E-Mail-Signaturen"
description: "Die meisten Informationen, die in E-Mail-Signaturen verwendet werden, stammen direkt aus Ihrem Verzeichnisdienst. Aber was ist mit den Daten, für die es kein vordefiniertes Feld gibt?"
published: true
tags: 
show_sidebar: true
slug: "custom-attributes"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
Die meisten Daten, die in E-Mail-Signaturen erscheinen, sind bereits in Ihrem Verzeichnisdienst vorhanden. Vor- und Nachnamen, Jobtitel, Telefonnummern, Standorte, Firmennamen und sogar Berichtslinien gehören standardmäßig zu Exchange, Active Directory oder Entra ID.

Das funktioniert gut, solange sich Ihre Anforderungen innerhalb der Grenzen bewegen, für die diese Systeme ursprünglich konzipiert wurden.

In der Praxis müssen E-Mail-Signaturen jedoch häufig **Kontext**, **Zielgruppe** und **Richtlinien** abbilden, nicht nur Verzeichnisfelder. Und genau hier beginnen die Probleme.


## Wenn Standard-Verzeichnisfelder nicht ausreichen
Es gibt viele Fälle, in denen die Informationen, die Sie in einer E-Mail-Signatur anzeigen möchten, im Verzeichnis keinen natürlichen Platz haben. Häufige Beispiele sind:
- **Jobtitel in mehreren Sprachen**  
  Interne Jobtitel werden oft nur in einer Sprache gepflegt (meist Englisch), während externe Kommunikation lokalisierte oder kundenorientierte Varianten erfordert.
- **Akademische oder berufliche Titel**  
  Titel wie *Dr.*, *Prof.*, *MBA* oder *PhD* müssen vor oder nach dem Namen erscheinen, teilweise abhängig von regionalen oder rechtlichen Konventionen.
- **Arbeitszeiten oder Erreichbarkeit**  
  Besonders wichtig für Teilzeitkräfte, geteilte Rollen, Schichtbetriebe oder Support-Teams.
- **Geschlechtspronomen und inklusive Sprachmarker**  
  Zunehmend relevant für inklusive Kommunikation, aber kein Bestandteil klassischer Verzeichnisschemata.
- **Regulatorische oder vertragliche Disclaimer**  
  Die nur für bestimmte Rollen, Abteilungen oder Zeiträume gelten.

Der Versuch, solche Informationen in Felder wie *Notes*, *Title* oder *Department* zu pressen, führt schnell zu Mehrdeutigkeiten, Inkonsistenzen und Governance-Problemen.


## Benutzerdefinierte Attribute: strukturierte Flexibilität ohne Schema-Chaos
Hier kommen **benutzerdefinierte Attribute** ins Spiel.

Exchange On-Premises und Exchange Online stellen standardmäßig **15 benutzerdefinierte Attribute** bereit. Diese Felder sind:
- Über Exchange, Entra ID und PowerShell schreib- und lesbar
- Nicht von Microsoft intern belegt
- Für Benutzer und Postfächer verfügbar
- Ideal für organisationsspezifische Metadaten

Darüber hinaus können Sie **Schemaerweiterungen** in Active Directory oder Entra ID definieren, um komplexere Szenarien abzubilden – allerdings mit höherem Governance- und Lifecycle-Aufwand, der bewusst eingeplant werden sollte.

Der entscheidende Vorteil benutzerdefinierter Attribute liegt darin, dass Sie **zweckgerichtete, strukturierte Daten** speichern können, ohne bestehende Felder zu überladen oder undokumentierte Konventionen einzuführen.


## Benutzerdefinierte Attribute mit Ziel und Struktur entwerfen
Ein häufiger Fehler besteht darin, benutzerdefinierte Attribute als „freie Zusatzfelder“ zu behandeln. In der Praxis funktionieren sie am besten, wenn sie gezielt und konsistent entworfen werden, zum Beispiel:
- `ExtAttr1`: Öffentlicher Jobtitel (EN)
- `ExtAttr2`: Öffentlicher Jobtitel (DE)
- `ExtAttr3`: Akademischer Titel (Präfix)
- `ExtAttr4`: Akademischer Titel (Suffix)
- `ExtAttr5`: Pronomen
- `ExtAttr6`: Text zu Arbeitszeiten

Diese Klarheit erleichtert Validierung, Dokumentation und Weiterverwendung der Daten nicht nur für E-Mail-Signaturen, sondern auch für andere Systeme.


## Benutzerdefinierte Attribute in Set-OutlookSignatures verwenden
Set-OutlookSignatures ist darauf ausgelegt, solche Daten ohne Reibungsverluste zu verarbeiten.

Sobald Ihre Attribute befüllt sind, können Sie sie direkt in Signaturvorlagen über vordefinierte Ersetzungsvariablen verwenden, zum Beispiel:
- `$CurrentUserExtAttr1$`
- `$CurrentUserExtAttr5$`
- `$CurrentMailboxManagerExtAttr2$`

So bleiben Signaturvorlagen sauber und deklarativ, während Logik und Datenpflege dort stattfinden, wo sie hingehören: im Verzeichnis oder in unterstützenden Systemen.

Keine fragile String-Verarbeitung. Keine duplizierten Vorlagen pro Abteilung, Sprache oder Rolle.


## Jenseits des Verzeichnisses: externe und berechnete Daten
Nicht alle Daten gehören ins Verzeichnis, und Set-OutlookSignatures geht auch nicht davon aus.

Für Fälle, in denen Verzeichnisattribute nicht die richtige Wahl sind, können Daten aus folgenden Quellen eingebunden werden:
- **CSV-Dateien** (für einfache Zuordnungen oder zeitlich begrenzte Kampagnen)
- **Datenbanken** (für strukturierte, governte Datensätze)
- **Webservices oder APIs** (für zentral verwaltete oder Echtzeitdaten)

Das ist besonders hilfreich, wenn:
- Rechts- oder Branding-Teams bestimmte Inhalte verantworten
- Daten abgeleitet statt gespeichert werden
- Eine Erweiterung des Verzeichnisschemas vermieden werden soll

Zusätzlich erlaubt Set-OutlookSignatures den Einsatz von **PowerShell-Logik**, um Werte dynamisch zu berechnen. Beispiele sind:
- Unterschiedliche Namensformate je Region
- Zusammensetzen von Werten aus mehreren Attributen
- Normalisierung inkonsistenter Quelldaten
- Fallback-Logik, wenn ein Attribut fehlt


## Bedingte Logik: Signaturen kontextabhängig machen
Einer der größten Vorteile berechneter Daten ist **bedingte Logik**.

Anstatt Inhalte fest zu verdrahten, können Regeln definiert werden, etwa:
- Abbildung interner Abteilungsnamen auf externe Bezeichnungen  
  („Corp IT Services“ → „Information Technology“)
- Anzeige unterschiedlicher Kontaktdaten je Rolle oder Standort
- Anwendung unterschiedlicher rechtlicher Hinweise je Gesellschaft oder Land
- Aktivieren oder Deaktivieren von Inhaltsblöcken anhand von Zeiträumen

Eine saisonale Regel könnte zum Beispiel vorübergehend erweiterte Support-Zeiten anzeigen oder automatisch bestimmte Aktionen entfernen, sobald sie ablaufen.

So werden E-Mail-Signaturen von statischen Vorlagen zu **richtliniengesteuerten Kommunikationselementen**.


## Governance, Konsistenz und langfristige Wartbarkeit
Die Zentralisierung benutzerdefinierter und berechneter Daten bringt Vorteile, die weit über Flexibilität hinausgehen.

Sie verbessert:
- **Konsistenz**: Eine zentrale Quelle für Rollen-, Titel- und Inhaltsdarstellung
- **Change-Management**: Änderungen erfolgen an den Daten, nicht an dutzenden Vorlagen
- **Nachvollziehbarkeit**: Klare Zuständigkeiten für Inhalte und Logik
- **Skalierbarkeit**: Neue Anforderungen führen nicht zu einer Explosion von Vorlagen

Vor allem entkoppelt sie **Darstellung** von **Datenspeicherung**, genau dort, wo ausgereifte Identitäts- und Messaging-Architekturen hingehören.


## Fazit
E-Mail-Signaturen werden oft als nebensächliches Branding-Thema betrachtet. Tatsächlich gehören sie zu den am häufigsten genutzten und extern sichtbarsten Kommunikationskanälen eines Unternehmens.

Durch den Einsatz benutzerdefinierter Attribute und berechneter Daten – anstatt Standardfelder zu missbrauchen oder Vorlagen zu duplizieren – gewinnen Sie:
- Ausdrucksstärkere Signaturen
- Bessere Governance
- Einfachere Anpassung an neue Anforderungen
- Deutlich weniger technischen Ballast im Laufe der Zeit


## Möchten Sie mehr erfahren oder unsere Lösung in Aktion sehen?
[Kontaktieren Sie uns](/support) oder erfahren Sie mehr auf unserer [Website](/). Wir freuen uns darauf, Sie kennenzulernen!