---
layout: "post"
lang: "de"
locale: "de"
title: "Set-OutlookSignatures v4.31.0: Bessere globale Add-in-Unterstützung"
description: "v4.31.0 verbessert Lokalisierung, Taskpane-Bedienung, Bereitstellungsprüfungen und konsistente Outlook-Signaturen."
slug: "v4-31-0"
published: true
tags: ["new release"]
show_sidebar: true
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

Set-OutlookSignatures v4.31.0 verbessert die Outlook Add-in-Nutzung in internationalen Microsoft 365-Umgebungen durch stärkere Lokalisierung, bessere Taskpane-Bedienung, genauere Signaturvorschauen, erweiterte Bereitstellungsprüfungen und konsistentere Signaturlogik. Die Version ist besonders relevant für Organisationen, in denen Outlook über mehrere Länder, Sprachen, Senderadressen, Abteilungen und Mailbox-Szenarien hinweg eingesetzt wird.

Die sichtbarste Änderung betrifft das Taskpane des Outlook Add-ins. Es kann sich nun automatisch an die Anzeigesprache von Outlook anpassen, unterstützt 379 Locales mit 101 regionalen und skriptbezogenen Varianten über 86 Basissprachen hinweg und unterstützt bidirektionale Layouts für Links-nach-rechts- und Rechts-nach-links-Sprachen.

Das ist mehr als eine Oberflächenverbesserung. In realen Microsoft 365-Umgebungen treffen Sprache, regionale Darstellung, manuelle Signaturauswahl, automatische Signaturlogik, Aliase, Delegationen und Compliance-Anforderungen oft zusammen. v4.31.0 reduziert mehrere Stellen, an denen diese Pfade bisher auseinanderlaufen konnten.

## Besseres Taskpane für mehrsprachige Outlook-Umgebungen

In internationalen Tenants ist die Outlook-Anzeigesprache kein Nebenthema. Sie beeinflusst, ob Benutzer eine Oberfläche intuitiv verstehen, ob der Support wiederkehrende Erklärungen liefern muss und ob manuelle Signaturauswahl zuverlässig genutzt wird.

Vor v4.31.0 war die Taskpane-Erfahrung weniger stark auf mehrsprachige Umgebungen ausgerichtet. Benutzer konnten Signaturen auswählen und anwenden, aber das Add-in spiegelte nicht die volle Bandbreite an Sprach-, Regions- und Schreibrichtungsanforderungen wider, wie sie in globalen Organisationen üblich sind.

Nach v4.31.0 kann das Taskpane seine Sprache an Outlook anpassen und Layouts für Rechts-nach-links-Sprachen korrekt berücksichtigen. Für Benutzer entsteht dadurch eine natürlichere Bedienung, unabhängig davon, ob Outlook beispielsweise auf Deutsch, Englisch, Arabisch, Hebräisch oder in einer anderen unterstützten Sprache und Region genutzt wird.

Für Administratoren bedeutet das weniger Sondererklärungen. Das Add-in verhält sich näher an dem, was Benutzer von ihrer Outlook-Umgebung erwarten.

## Taskpane-Auswahl wird verständlicher

v4.31.0 verbessert auch die Art, wie Benutzer Signaturen im Taskpane auswählen und prüfen.

Das Taskpane enthält nun eine Signaturgalerie mit Overlay-Schaltflächen. Benutzer können eine Signatur dadurch visuell auswählen und sind nicht mehr nur auf eine namensbasierte Auswahl angewiesen. Das ist hilfreich, wenn mehrere Signaturen ähnlich benannt sind, sich aber in Layout, Kampagnenbanner, Disclaimer, Regionstext oder Absenderkontext unterscheiden.

Auch die Vorschau wurde verbessert:

- Wenn „Automatisch auswählen“ aktiv ist, zeigt das Taskpane die automatisch gewählte Signatur.
- `CUSTOM_RULES_CODE` wird vor dem Rendern der Vorschau ausgeführt.
- Die Vorschau zeigt die finale Signatur, die aus `customRulesResultSignatureName` oder `customRulesResultSignatureBody` resultiert.

Vor dieser Änderung konnte ein Benutzer im Taskpane eine Signatur sehen oder auswählen, die nicht vollständig dem Ergebnis entsprach, das durch die eigentliche Logik angewendet wurde.

Nach v4.31.0 liegt die Vorschau näher an der Signatur, die tatsächlich in die Nachricht eingefügt wird. Das reduziert Missverständnisse, insbesondere wenn automatische Auswahl, manuelle Auswahl und kundenspezifische Regeln zusammenwirken.

## Sprachbewusste Signaturlogik

Die Lokalisierungsverbesserungen sind nicht nur visuell. v4.31.0 ergänzt auch neue Eigenschaften und Funktionen für `CUSTOM_RULES_CODE`.

Neue Werte in `customRulesProperties` sind:

- `outlookDisplayLanguage`: die von `Office.context.displayLanguage` zurückgegebene Outlook-Anzeigesprache, üblicherweise in einem Format wie `en-GB` oder `de-AT`
- `taskpaneDisplayLanguage`: die im Taskpane gesetzte Anzeigesprache oder eine leere Zeichenfolge, wenn die Logik nicht durch das Taskpane ausgelöst wurde
- `taskpaneSelectedSignatureName`: der Name der Signatur, die ein Benutzer manuell im Taskpane ausgewählt hat, oder eine leere Zeichenfolge bei „Automatisch auswählen“
- `signatureBodyBeforeCustomRules`: der Signaturinhalt vor Ausführung von `CUSTOM_RULES_CODE`, sodass HTML- oder Plain-Text-Signaturen direkt per Code angepasst werden können
- `getSignautureBody`: eine Funktion, um den tatsächlichen Inhalt einer bestimmten Signatur abzurufen

Der Unterschied zwischen `outlookDisplayLanguage` und `taskpaneDisplayLanguage` ist in echten Rollouts wichtig. Outlook kann eine bestimmte Sprache liefern, während ein Benutzer im Taskpane bewusst eine andere Sprache auswählt. v4.31.0 stellt beide Werte zur Verfügung, damit Regeln nicht auf einer einzigen Annahme über die Sprache basieren müssen.

In `.\sample code\CustomRulesCode.js` wurden außerdem Beispiele ergänzt, unter anderem für:

- das Setzen einer Signatur für einen Alias oder eine sekundäre SMTP-Adresse
- das Voranstellen eines Hinweises bei sensitiven Nachrichten
- das automatische Anpassen des Taskpanes an die Outlook-Anzeigesprache

> 💡 **Best Practice:** Testen Sie das Outlook Add-in vor einem breiten Rollout mit repräsentativen Outlook-Anzeigesprachen und mindestens einer Rechts-nach-links-Sprache, vor allem wenn Signaturen regionale Rechtstexte, sprachabhängige Banner oder `CUSTOM_RULES_CODE` verwenden.

## Konsistentere Behandlung automatischer und manueller Signaturpfade

v4.31.0 ändert auch, wann `CUSTOM_RULES_CODE` ausgeführt wird.

Bisher war dieser Code vor allem mit launch-event-gesteuertem Verhalten verbunden. Er konnte die Signaturauswahl oder den Signaturinhalt anpassen, wenn Outlook automatisch eine Signatur angewendet hat. Die manuelle Auswahl im Taskpane war dagegen ein anderer Pfad.

Mit v4.31.0 wird `CUSTOM_RULES_CODE` auch ausgeführt, wenn ein Benutzer manuell eine Signatur im Taskpane auswählt.

Dadurch werden Szenarien möglich oder konsistenter, etwa:

- Hinweise bei sensitiven Nachrichten voranzustellen
- Inhalte abhängig von Nachrichteneigenschaften anzuhängen
- den Signaturinhalt vor dem Einfügen zu verändern
- Logik für Aliase oder sekundäre SMTP-Adressen anzuwenden
- Informationen aus der Taskpane-Sprache in die finale Signaturentscheidung einzubeziehen

Das ist wichtig, weil manuelle Auswahl nicht mehr automatisch ein Sonderpfad außerhalb der Organisationslogik sein muss. Wenn eine Organisation Signaturen nach Absenderkontext, Sprache, Sensitivität oder Nachrichteneigenschaften anpasst, kann diese Logik nun auf mehr Nutzungspfade angewendet werden.

Bestehender `CUSTOM_RULES_CODE` sollte vor der Bereitstellung geprüft werden. Code, der bisher davon ausgegangen ist, nur bei Launch Events ausgeführt zu werden, kann nun auch bei manuellen Taskpane-Aktionen laufen.

Es gibt außerdem eine erweiterte Taskpane-Option, mit der Benutzer `CUSTOM_RULES_CODE` für manuelle Vorgänge deaktivieren können. Diese Option kann zentral über `CUSTOM_RULES_CODE_DEACTIVATABLE` in `run_before_deployment.ps1` deaktiviert werden.

## Stärkere Bereitstellungsprüfungen für das Outlook Add-in

Der Bereitstellungshelfer `run_before_deployment.ps1` wurde erweitert.

Er zeigt nun nicht mehr nur Unterschiede in `manifest.xml` an. Stattdessen prüft er alle Konfigurationswerte, einschließlich `CUSTOM_RULES_CODE`.

Dafür ist eine Datei `set-outlooksignatures.config.json` auf dem Webserver erforderlich. Diese Datei wird bei der ersten Add-in-Bereitstellung mit dieser Version automatisch erstellt.

Das hilft Administratoren, Konfigurationsabweichungen vor dem Rollout zu erkennen. Gerade bei Add-ins reicht ein reiner Manifest-Vergleich oft nicht aus, weil relevantes Verhalten auch von anderen Konfigurationswerten abhängt.

Die Log-Ausgaben des Add-ins enthalten nun außerdem Zeitstempel. Das erleichtert die Analyse von lang laufendem Code, insbesondere wenn `CUSTOM_RULES_CODE` verwendet wird.

## Erweiterte Dokumentation für Architektur, Sicherheit und Betrieb

v4.31.0 erweitert auch die Dokumentation rund um Architektur, Sicherheit, Implementierung und Deployment.

Für Set-OutlookSignatures wurden ergänzt:

- ein Architekturdiagramm in den Architecture considerations
- ein Sicherheitsdiagramm in den Security considerations
- ein Abschnitt zu Architektur- und Sicherheitsanforderungen im Implementation approach
- eine überarbeitete Struktur des Implementation approach, die neutrale Anforderungen von produktspezifischen Empfehlungen trennt

Für das Outlook Add-in wurden ergänzt:

- Troubleshooting-Hinweise und ein Deployment-Diagramm zur Configuration and deployment
- Workflow-Diagramme mit Konfigurationsbezug für Launch Events und Taskpane-Nutzung
- ein Workflow-Diagramm zu den Möglichkeiten von `CUSTOM_RULES_CODE`

Das ist für Enterprise-Rollouts relevant. Architektur- und Sicherheitsverantwortliche fragen nicht nur, ob eine Signaturlösung funktioniert. Sie wollen wissen, wo Komponenten laufen, welche Datenflüsse entstehen, welche Konfigurationen relevant sind und wie der Betrieb nachvollziehbar bleibt.

## Änderungen im Set-OutlookSignatures-Kern

Auch der Kern von Set-OutlookSignatures erhält Kompatibilitäts- und Wartungsverbesserungen.

Die Word Interop Assembly verwendet nun Late Binding. Statt die DLL direkt durch das Skript zu laden, wird sie über die Windows COM-Schnittstelle anhand der Office-Registryeinträge geladen. Dadurch kann Windows automatisch die passende DLL-Version auswählen, wenn mehrere Office-Versionen parallel installiert sind.

Mehrere Abhängigkeiten und Datenquellen wurden aktualisiert:

- `address-formatter` auf Commit `7eb7a5b`
- Address-formatting-Datenbank auf Commit `836de3e`
- `libphonenumber-csharp` auf `v9.0.35`
- `MSAL.Net` auf `v4.86.1`
- `PreMailer.Net` auf `v2.7.3`
- `@azure/msal-browser` auf `v5.17.1`

Die Beispielvorlagen wurden außerdem auf ein neues Layout aktualisiert und verwenden nun `$MPostalAddressCompany$` anstelle einer fest hinterlegten fiktiven Adresse.

Diese Punkte sind nicht die lautesten Release-Themen, aber sie sind im Betrieb wichtig. Adressformatierung, Telefonnummernverarbeitung, Authentifizierungsbibliotheken, HTML-Aufbereitung und Office-Integration beeinflussen, ob Signaturen stabil erzeugt, korrekt dargestellt und zuverlässig angewendet werden.

## Neue Artikel und FAQ-Erweiterungen

Mit der Version wurden außerdem neue Inhalte zu typischen Enterprise-Signaturszenarien ergänzt:

- flexible Berechtigungsverwaltung für Delegates und Vertretungskonfigurationen
- der finanzielle Aufwand manueller E-Mail-Signaturen
- SMTP-Alias-Signaturen in Outlook
- FAQ-Hinweise zum Anwenden von Signaturen für Aliase oder sekundäre SMTP-Adressen

Diese Inhalte passen zur Richtung der Version. Signaturverwaltung muss abbilden, wie E-Mail in Microsoft 365 tatsächlich genutzt wird: mit Delegationen, Cover-Konfigurationen, Aliasadressen, sekundären SMTP-Adressen, manueller Auswahl und unterschiedlichen Sprach- oder Regionserwartungen.

## Was sich praktisch ändert

Vor v4.31.0 mussten globale Outlook Add-in-Bereitstellungen mehr getrennte Pfade berücksichtigen: Sprachverhalten, manuelle Taskpane-Auswahl, automatische Launch-Event-Verarbeitung, Vorschauverhalten und Bereitstellungskonfiguration.

Nach v4.31.0 sind diese Pfade enger miteinander verbunden. Das Taskpane ist besser für mehrsprachige Umgebungen geeignet, Benutzer können Signaturen visuell auswählen, Vorschauen zeigen genauer das finale Ergebnis, benutzerdefinierte Regeln können sowohl automatische als auch manuelle Vorgänge berücksichtigen und Bereitstellungsprüfungen gehen über das Manifest hinaus.

Set-OutlookSignatures, das Benefactor Circle Add-on und das Outlook Add-in sind nun in v4.31.0 verfügbar. Für Organisationen, die das Add-in über Länder, Geschäftsbereiche, Shared Mailboxes, Aliase oder sprachspezifische Signaturvarianten hinweg einsetzen, ist diese Version ein sinnvoller Anlass für Prüfung und Test.

Die vollständige Liste der Änderungen, einschließlich Abhängigkeitsupdates, Dokumentationserweiterungen, Konfigurationsverbesserungen und Outlook Add-in-Änderungen, finden Sie im [vollständigen Changelog](https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/blob/main/docs/CHANGELOG.md).

<!--
LinkedIn Post:

Set-OutlookSignatures v4.31.0 ist für die Kernlösung, das Benefactor Circle Add-on und das Outlook Add-in verfügbar. Die Version verbessert die Nutzung des Outlook Add-ins in internationalen Microsoft 365-Umgebungen mit breiterer Lokalisierung, bidirektionaler Taskpane-Unterstützung, visueller Signaturgalerie, besseren Vorschauen, stärkeren Bereitstellungsprüfungen und erweiterter Architektur- und Sicherheitsdokumentation.

Außerdem wird die manuelle Auswahl im Taskpane näher an die automatische Signaturverarbeitung herangeführt, etwa wenn Signaturlogik von Aliasadressen, Sensitivitätshinweisen, Spracheinstellungen oder Änderungen am Signaturinhalt abhängt. Das sind genau die Details, die in Umgebungen mit mehreren Ländern, Abteilungen, Shared Mailboxes und unterschiedlichen Senderkontexten relevant werden.

Die Version ist weniger ein einzelnes neues Feature, sondern eher ein Schritt, mehrere operative Lücken zwischen Konfiguration, Benutzererlebnis und der final in Outlook angewendeten Signatur zu schließen.

https://set-outlooksignatures.com/de/blog/2026/07/19/v4-31-0
-->

## Machen Sie jeden kleinen E-Mail-Moment zu einem professionellen Vorteil

E-Mail-Signaturen und Abwesenheitsnotizen mögen unbedeutend erscheinen, aber stellen Sie sich vor, wie oft sie gesehen werden.

Wir helfen Unternehmen, diese Kontaktpunkte für alle Benutzer zentral zu verwalten und zu standardisieren — **einheitliches Outlook-Branding überall, ohne Datenabfluss nach außen.** Kein manueller Aufwand, keine Inkonsistenzen, keine Daten verlassen Ihr Unternehmen. Mit Set-OutlookSignatures wird jede E-Mail zu einem konsistenten, sicheren und vollständig kontrollierten Markenerlebnis.

👉 Sehen Sie, was für Ihr E-Mail-Setup möglich ist  
→ [So funktioniert es (2 Minuten)](https://set-outlooksignatures.com/)

👉 Möchten Sie es selbst ausprobieren?  
→ [Schnellstart](https://set-outlooksignatures.com/quickstart)

_Nicht verantwortlich für die E-Mail-Konfiguration in Ihrem Unternehmen?_  
Teilen Sie diesen Artikel mit Ihrer IT-Abteilung oder Ihrem Marketingteam, sie werden es Ihnen danken.
