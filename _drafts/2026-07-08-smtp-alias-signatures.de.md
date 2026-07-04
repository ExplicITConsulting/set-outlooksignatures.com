---
layout: "post"
lang: "de"
locale: "de"
title: "Outlook-Signaturen für Alias- und sekundäre SMTP-Adressen"
description: "So wenden Sie die richtige Outlook-Signatur an, wenn Benutzer über eine Alias- oder sekundäre SMTP-Adresse senden."
published: true
tags:
show_sidebar: true
slug: "smtp-alias-signatures"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

Viele Postfächer haben mehr als eine Absenderadresse. Ein Benutzer kann beispielsweise die primäre SMTP-Adresse `first.last@example.com` und eine zusätzliche Absenderadresse wie `first.last@contoso.com` haben.

Die IT kennt dies üblicherweise als sekundäre SMTP-Adresse. Marketing betrachtet sie oft einfacher als Alias-Adresse: eine weitere E-Mail-Adresse, die eine Marke, ein Unternehmen, eine Region, einen Geschäftsbereich, eine Kampagne oder eine Kommunikationsidentität repräsentiert.

Beide Sichtweisen sind richtig.

Der technische Begriff ist wichtig, weil er beschreibt, wie die Adresse am Postfach existiert. Die Marketing-Perspektive ist wichtig, weil die Adresse für den Empfänger sichtbar ist. Wenn sich die Absenderadresse ändert, muss sich häufig auch die Signatur ändern.

Genau hier hat Outlook eine wichtige Einschränkung.

Outlook kann Standardsignaturen für Postfächer definieren, aber nicht für einzelne Absenderadressen desselben Postfachs. Mit anderen Worten: Outlook kann einem Postfach eine Standardsignatur zuweisen, aber nicht nativ eine Standardsignatur für `first.last@example.com` und eine andere für `first.last@contoso.com`.

Für Organisationen mit mehreren Marken, Geschäftsbereichen, Regionen, übernommenen Unternehmen oder dedizierten Kommunikationsidentitäten ist das relevant. Die ausgewählte Absenderadresse und die angewendete E-Mail-Signatur sollten dieselbe Geschichte erzählen.

### Das Szenario

Betrachten Sie dieses Postfach:

- Primäre SMTP-Adresse: `first.last@example.com`
- Alias-Adresse / sekundäre SMTP-Adresse: `first.last@contoso.com`

Die Anforderung ist klar:

- E-Mails, die von `first.last@example.com` gesendet werden, sollen die reguläre Signatur verwenden.
- E-Mails, die von `first.last@contoso.com` gesendet werden, sollen eine Signatur verwenden, die zur Contoso-Identität passt.

Aus Branding- und Compliance-Sicht ist das genau das, was Benutzer erwarten. Aus Sicht der nativen Outlook-Konfiguration ist es jedoch nicht als normale Standardsignatur-Einstellung verfügbar.

### Warum das für Marketing und IT wichtig ist

Für Marketing ist die Absenderadresse Teil des sichtbaren Markenerlebnisses. Sie beeinflusst, wie Empfänger die Nachricht einordnen: welches Unternehmen spricht, welche Marke repräsentiert wird und welcher rechtliche oder kampagnenbezogene Kontext gilt.

Für IT ist dieselbe Adresse ein Postfachattribut und eine Absenderidentität. Es kann technisch unkompliziert sein, einem Postfach eine Alias-Adresse / sekundäre SMTP-Adresse hinzuzufügen, aber Outlook stellt keine separate Standardsignatur-Einstellung für jede Adresse bereit.

Dadurch entsteht eine Lücke zwischen technischer Postfachkonfiguration und markenkonformer Kommunikation.

Der Benutzer kann die richtige Absenderadresse auswählen, aber die passende Signatur muss trotzdem automatisch folgen.

### Die Lösung: Set-OutlookSignatures und das Outlook Add-in verwenden

Set-OutlookSignatures erstellt und verteilt die erforderlichen Signaturen zentral. Das [Outlook Add-in](https://set-outlooksignatures.com/outlookaddin), verfügbar mit dem <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle Add-on</span></a>, kann anschließend die richtige Signatur basierend auf der in Outlook ausgewählten Absenderadresse anwenden.

Dadurch entsteht eine klare Aufgabenteilung:

- Marketing definiert den richtigen Signaturinhalt für jede sichtbare Absenderidentität.
- IT verteilt die Signaturen zentral mit Set-OutlookSignatures.
- Das Outlook Add-in erkennt die Absenderadresse der aktuellen E-Mail, und `CUSTOM_RULES_CODE` wählt basierend auf seiner Konfiguration die passende Signatur aus.

Das Ergebnis ist für Benutzer einfach: Sie wählen die Absenderadresse aus, und Outlook wendet die passende Signatur an.

#### Die Set-OutlookSignatures-INI-Datei konfigurieren

Erstellen Sie zuerst die reguläre Signatur für das Postfach. Das folgende Beispiel verwendet eine mailadressenspezifische Zuweisung, die Zuweisung könnte aber auch auf einer Gruppe basieren.

```ini
# Create signature for mailbox
# Example uses a mail address specific assignment, it could also be a group

[formal.docx]
first.last@example.com
defaultNew
```

Dadurch wird die Standardsignatur für das Postfach erstellt und als Standardsignatur für neue E-Mails konfiguriert.

Erstellen Sie anschließend separate Signaturen für neue E-Mails und Antworten für die Alias-Adresse / sekundäre SMTP-Adresse:

```ini
# Create signature for secondary SMTP address (alias address)

[formal Contoso.docx]
first.last@contoso.com

[informal Contoso.docx]
first.last@contoso.com
```

Dadurch werden die adressspezifischen Signaturen für den Benutzer verfügbar. Die automatische Auswahl für die Alias-Adresse / sekundäre SMTP-Adresse übernimmt das Outlook Add-in.

#### Das Outlook Add-in konfigurieren

Das Outlook Add-in unterstützt die Option `CUSTOM_RULES_CODE`. Dieser JavaScript-Code wird jedes Mal ausgeführt, wenn ein Launch Event das Add-in auslöst oder wenn ein Benutzer im Aufgabenbereich des Add-ins auf `Set selected signature` klickt.

Der Code kann das aktuelle Outlook-Element auswerten und entscheiden, welche Signatur angewendet werden soll.

In diesem Beispiel prüft das Add-in, ob die Nachricht von `first.last@contoso.com` gesendet wird. Wenn ja, wendet es eine Signatur für neue E-Mails und eine andere Signatur für Antworten oder Weiterleitungen an.

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

Die Logik ist bewusst leicht verständlich gehalten:

- `targetEmail` ist die Alias-Adresse / sekundäre SMTP-Adresse, die die spezielle Signatur auslösen soll.
- `sigNew` ist die Signatur für neue E-Mails.
- `sigReply` ist die Signatur für Antworten und Weiterleitungen.
- `customRulesProperties.itemIsNew` erkennt, ob das aktuelle Element eine neue E-Mail ist.
- `customRulesProperties.itemFrom.emailAddress` enthält die in Outlook ausgewählte Absenderadresse.
- `customRulesProperties.availableSignatures` prüft, ob die Zielsignatur verfügbar ist.
- `customRulesResultSignatureName` teilt dem Add-in mit, welche bereitgestellte Signatur angewendet werden soll.
- `customRulesResultNotification` zeigt eine kurze Bestätigung in Outlook an.

Wenn neue E-Mails und Antworten unterschiedliche Signaturen verwenden sollen, setzen Sie einfach unterschiedliche Werte für `sigNew` und `sigReply`.

#### Wann `CUSTOM_RULES_CODE` ausgeführt wird

`CUSTOM_RULES_CODE` wird jedes Mal ausgeführt, wenn ein Launch Event das Outlook Add-in auslöst. Er wird außerdem ausgeführt, wenn der Benutzer im Aufgabenbereich des Add-ins auf `Set selected signature` klickt.

Dadurch wird die Regel kontextabhängig. Das Add-in kann die aktuelle E-Mail betrachten, die ausgewählte Absenderadresse erkennen und die passende Signatur anwenden.

Für Szenarien mit Alias-Adressen / sekundären SMTP-Adressen ist genau das der fehlende Baustein: Outlook allein kennt Standardsignaturen nur pro Postfach, während das Add-in auf die tatsächlich in der E-Mail verwendete Absenderadresse reagieren kann.

### Abschließende Gedanken

Alias-Adressen / sekundäre SMTP-Adressen werden häufig aus guten geschäftlichen Gründen verwendet: Marken, Unternehmen, Regionen, Geschäftsbereiche, Kampagnen und besondere Kommunikationskontexte. Wenn sich die Absenderadresse ändert, muss sich jedoch häufig auch die E-Mail-Signatur ändern.

Outlook allein kann keine separaten Standardsignaturen pro Absenderadresse desselben Postfachs definieren. Outlook kann Standardsignaturen nur für das Postfach definieren.

Durch die Kombination von Set-OutlookSignatures mit dem [Outlook Add-in](https://set-outlooksignatures.com/outlookaddin) aus dem <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle Add-on</span></a> können Organisationen diese Lücke schließen. Signaturen werden weiterhin zentral erstellt und verteilt, während das Add-in die richtige Signatur basierend auf der in Outlook ausgewählten Absenderadresse anwendet.

Marketing erhält konsistentes Branding. IT erhält eine verwaltbare und automatisierte Konfiguration. Benutzer erhalten die richtige Signatur, ohne darüber nachdenken zu müssen.

## Machen Sie jeden kleinen E-Mail-Moment zu einem professionellen Vorteil

E-Mail-Signaturen und Abwesenheitsnotizen mögen unbedeutend erscheinen, aber stellen Sie sich vor, wie oft sie gesehen werden.

Wir helfen Unternehmen, diese Kontaktpunkte für alle Benutzer zentral zu verwalten und zu standardisieren — **einheitliches Outlook-Branding überall, ohne Datenabfluss nach außen.** Kein manueller Aufwand, keine Inkonsistenzen, keine Daten verlassen Ihr Unternehmen. Mit Set-OutlookSignatures wird jede E-Mail zu einem konsistenten, sicheren und vollständig kontrollierten Markenerlebnis.

👉 Sehen Sie, was für Ihr E-Mail-Setup möglich ist  
→ [So funktioniert es (2 Minuten)](https://set-outlooksignatures.com/)

👉 Möchten Sie es selbst ausprobieren?  
→ [Schnellstart](https://set-outlooksignatures.com/quickstart)

_Nicht verantwortlich für die E-Mail-Konfiguration in Ihrem Unternehmen?_  
Teilen Sie diesen Artikel mit Ihrer IT-Abteilung oder Ihrem Marketingteam, sie werden es Ihnen danken.
