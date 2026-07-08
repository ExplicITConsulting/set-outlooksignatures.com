---
layout: "post"
lang: "de"
locale: "de"
title: SMTP-Alias-Signaturen in Outlook
description: Steuern Sie Outlook-Signaturen passend zur gewählten Alias- oder sekundären SMTP-Adresse in Microsoft 365.
slug: smtp-alias-signatures
published: true
tags:
show_sidebar: true
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

Ein Mitarbeiter verfasst eine E-Mail über die Adresse first.last@contoso.com. Beim Versand wird jedoch die Standardsignatur von first.last@example.com eingefügt – inklusive falscher Unternehmensangaben, falscher Kontaktdaten und einer Markenidentität, die nicht zur gewählten Absenderadresse passt. Der Fehler fällt häufig erst dann auf, wenn Kunden verwirrt reagieren oder Antworten an die falsche Organisation richten.

# Outlook kann keine Standardsignaturen pro Absenderadresse festlegen

Viele Microsoft-365-Postfächer verfügen über mehrere Absenderidentitäten. Neben der primären SMTP-Adresse kommen oft Alias-Adressen für Tochtergesellschaften, Marken, Regionen, Geschäftsbereiche oder spezielle Kommunikationszwecke zum Einsatz.

Sobald mehrere sichtbare Absenderidentitäten verwendet werden, entsteht eine einfache Anforderung: Zur gewählten Absenderadresse soll automatisch die passende Signatur erscheinen.

Genau hier stößt Outlook an eine Grenze. Standardmäßig können Signaturen auf Postfachebene zugewiesen werden, nicht jedoch pro Absenderadresse innerhalb desselben Postfachs. Outlook kennt also eine Standardsignatur für das Postfach, unabhängig davon, welche Alias- oder sekundäre SMTP-Adresse der Benutzer beim Verfassen der E-Mail auswählt.

Damit entsteht eine Lücke zwischen technischer Konfiguration und professioneller Unternehmenskommunikation.

Marketing erwartet einen konsistenten Markenauftritt. Compliance erwartet die korrekten rechtlichen Angaben. Die IT kann zusätzliche SMTP-Adressen problemlos bereitstellen, erhält in Outlook jedoch keine separate Standardsignatur pro Absenderidentität.

Wer mehrere Kommunikationsidentitäten über ein einziges Postfach verwendet, riskiert daher inkonsistente ausgehende E-Mails.

# Das eigentliche Problem ist die Kommunikationsidentität

Betrachten wir folgendes Postfach:

- Primäre SMTP-Adresse: `first.last@example.com`
- Sekundäre SMTP-Adresse: `first.last@contoso.com`

Die gewünschte Logik ist eindeutig:

- E-Mails von `first.last@example.com` sollen die reguläre Unternehmenssignatur verwenden.
- E-Mails von `first.last@contoso.com` sollen automatisch eine Signatur der Marke Contoso erhalten.

Für Empfänger ist die Absenderadresse ein sichtbarer Teil der Nachricht. Sie vermittelt, welches Unternehmen kommuniziert, welche Marke vertreten wird und welchem geschäftlichen oder rechtlichen Kontext die Nachricht zuzuordnen ist.

Wenn Absenderadresse und Signatur nicht zusammenpassen, entsteht mehr als nur ein optischer Fehler. Unternehmen verlieren Konsistenz in ihrer Außenwirkung, Kommunikationsprozesse werden unnötig fehleranfällig, und Compliance-Anforderungen lassen sich schwerer durchsetzen.

> 💡 **Best Practice:** Behandeln Sie Alias- und sekundäre SMTP-Adressen als eigene Kommunikationsidentitäten. Sobald eine Adresse eine andere Marke, Gesellschaft, Region oder Geschäftseinheit repräsentiert, sollte dafür auch eine eigene Signatur definiert werden.

# Signaturen anhand der gewählten Absenderadresse anwenden

Set-OutlookSignatures erstellt und verteilt Signaturen zentral innerhalb der Microsoft-365-Umgebung. Das <a href="https://set-outlooksignatures.com/outlookaddin">Outlook Add-in</a>, verfügbar über das <a href="https://set-outlooksignatures.com/de/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle Add-on</span></a>, kann anschließend automatisch ignatur anhand der in Outlook ausgewählten Absenderadresse anwenden.

Dadurch ergibt sich eine klare Rollenverteilung.

Das Marketing definiert die Inhalte für jede Kommunikationsidentität. Die IT übernimmt die zentrale Bereitstellung über Set-OutlookSignatures. Das Outlook Add-in bewertet beim Verfassen der Nachricht die gewählte Absenderadresse und bestimmt über `CUSTOM_RULES_CODE`, welche Signatur eingefügt werden soll.

Für Benutzer bleibt der Ablauf einfach. Sie wählen die gewünschte Absenderadresse aus, und die passende Signatur wird automatisch angewendet.

# Konfigurationsbeispiel

Zunächst wird die reguläre Signatur für das Postfach erstellt.

Die folgende Konfiguration weist die Signatur der primären SMTP-Adresse zu und definiert sie als Standardsignatur für neue Nachrichten.

```ini
# Create signature for mailbox
# Example uses a mail address specific assignment, it could also be a group
[formal.docx]
first.last@example.com
defaultNew
```

Anschließend werden die Signaturen für die sekundäre SMTP-Adresse angelegt.

```ini
# Create signature for secondary SMTP address (alias address)
[formal Contoso.docx]
first.last@contoso.com

[informal Contoso.docx]
first.last@contoso.com
```

Nach der Bereitstellung stehen die Signaturen dem Benutzer zur Verfügung. Die automatische Auswahl übernimmt anschließend das Outlook Add-in.

Hierzu kann `CUSTOM_RULES_CODE` verwendet werden.

Der folgende Code prüft die aktuell ausgewählte Absenderadresse. Wird die Nachricht über `first.last@contoso.com` versendet, wendet das Add-in automatisch die entsprechende Signatur an. Für neue Nachrichten und Antworten können unterschiedliche Signaturen verwendet werden.

```javascript
var targetEmail = "first.last@contoso.com";
var sigNew = "formal Contoso";
var sigReply = "informal Contoso";

var targetSignature = customRulesProperties.itemIsNew ? sigNew : sigReply;
var notificationText = "Applied " + targetSignature + " automatically.";

if (customRulesProperties.itemFrom.emailAddress.toLowerCase() === targetEmail.toLowerCase()) {
  if (customRulesProperties.availableSignatures.indexOf(targetSignature) !== -1) {
    customRulesResultSignatureName = targetSignature;
    customRulesResultNotification = notificationText;
  } else {
    await logMessage("Signature '" + targetSignature + "' not found in available signatures.");
  }
}
```

Die Logik orientiert sich direkt an der tatsächlich verwendeten Absenderidentität:

- `targetEmail` definiert die Alias- bzw. sekundäre SMTP-Adresse.
- `sigNew` definiert die Signatur für neue E-Mails.
- `sigReply` definiert die Signatur für Antworten und Weiterleitungen.
- `customRulesProperties.itemIsNew` erkennt, ob eine neue Nachricht erstellt wird.
- `customRulesProperties.itemFrom.emailAddress` enthält die in Outlook ausgewählte Absenderadresse.
- `customRulesProperties.availableSignatures` prüft, ob die gewünschte Signatur verfügbar ist.
- `customRulesResultSignatureName` legt fest, welche bereitgestellte Signatur angewendet wird.
- `customRulesResultNotification` informiert den Benutzer über die automatische Auswahl.

Der Code wird bei jedem Launch Event des Add-ins ausgeführt und zusätzlich dann, wenn ein Benutzer im Aufgabenbereich **Set selected signature** auswählt.

Genau dadurch wird die Entscheidung kontextabhängig. Das Add-in betrachtet die aktuell geöffnete Nachricht, erkennt die verwendete Absenderadresse und wendet unmittelbar die dazugehörige Signatur an.

Für Organisationen mit mehreren Marken, Unternehmen, Regionen oder Kommunikationsidentitäten innerhalb desselben Postfachs schließt das eine Lücke, die Outlook selbst nicht abdecken kann.

<!--
LinkedIn Post:

Der Fehler entsteht bereits beim Wechsel der Absenderadresse in Outlook. Der Benutzer wählt first.last@contoso.com als SMTP-Alias aus, doch die E-Mail erhält weiterhin die Signatur von first.last@example.com – inklusive Markenauftritt, Kontaktdaten und rechtlichen Angaben einer anderen Organisation.

In vielen Microsoft-365-Umgebungen entwickelt sich dieses Problem schleichend. Neue Marken, Tochtergesellschaften oder Kampagnen erhalten eigene Absenderadressen, während Outlook weiterhin mit Standardsignaturen auf Postfachebene arbeitet und die tatsächlich verwendete Kommunikationsidentität nicht berücksichtigt.

Für den Empfänger wirkt die Nachricht widersprüchlich. Die Absenderadresse verweist auf ein Unternehmen, die Signatur auf ein anderes. Genau diese Diskrepanz wird hier näher betrachtet: https://set-outlooksignatures.com/de/blog/2026/07/08/smtp-alias-signatures
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
