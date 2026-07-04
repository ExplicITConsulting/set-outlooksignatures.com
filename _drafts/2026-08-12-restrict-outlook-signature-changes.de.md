---
layout: "post"
lang: "de"
locale: "de"
title: "So verhindern Sie, dass Benutzer Signaturen ändern oder löschen"
description: "Erfahren Sie, wie Sie Signaturänderungen in Outlook (Classic, New, Web & Mobile) einschränken und welche Alternativen es gibt."
published: true
tags:
show_sidebar: true
slug: "restrict-outlook-signature-changes"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

## Verhindern, dass Benutzer Signaturen hinzufügen, bearbeiten und entfernen

Die Wahrung einer einheitlichen Corporate Identity im gesamten Unternehmen ist eine Herausforderung – insbesondere dann, wenn Benutzer E-Mail-Signaturen häufig ändern, veraltete Versionen verwenden oder diese vollständig entfernen. Um Markenrichtlinien durchzusetzen und rechtliche Anforderungen sicherzustellen, müssen IT-Administratoren die Möglichkeit einschränken, dass Benutzer ihre Signaturen eigenständig verändern.

Die technischen Möglichkeiten hierfür unterscheiden sich jedoch je nach verwendeter Outlook-Version erheblich. Im Folgenden finden Sie einen detaillierten Überblick darüber, wie Sie Signaturänderungen auf verschiedenen Outlook-Plattformen einschränken, welche Einschränkungen bestehen und welche besseren Alternativen verfügbar sind.

### Klassisches Outlook für Windows

Sie können GUI-Elemente deaktivieren, sodass Benutzer in Outlook keine Signaturen hinzufügen, bearbeiten oder entfernen können, indem Sie die Gruppenrichtlinieneinstellung „Signaturen für E-Mail-Nachrichten nicht zulassen“ verwenden.

Einschränkungen:

- Benutzer können weiterhin Signaturen im Dateisystem hinzufügen, bearbeiten und entfernen
- Standardsignaturen werden nicht mehr automatisch hinzugefügt, wenn eine neue E-Mail erstellt oder eine E-Mail weitergeleitet bzw. beantwortet wird
- Benutzer müssen die richtige Signatur manuell auswählen
- Die GPO-Einstellung scheint bei einigen neueren Outlook-Versionen nicht zuverlässig zu funktionieren; in diesem Fall setzen Sie den entsprechenden Registrierungsschlüssel direkt

Als Alternative können Sie eine oder mehrere der folgenden Optionen in Betracht ziehen:

- Führen Sie Set-OutlookSignatures regelmäßig aus (z. B. alle zwei Stunden) und verwenden Sie die Option `WriteProtect` in der INI-Datei
- Verwenden Sie die GPO-Einstellung „Elemente in der Benutzeroberfläche deaktivieren“ und nutzen Sie folgende Werte:
  - 5608: `SignatureInsertMenu` – Auswahl einer Signatur und Zugriff auf die Signaturgalerie
  - 22965: `SignatureGallery` – verhindert die Auswahl alternativer Signaturen, erlaubt aber weiterhin Zugriff auf den Einstellungsdialog
  - 3766: `SignaturesStationeryDialog` – verhindert das Erstellen, Bearbeiten und Löschen von Signaturen sowie den Zugriff auf Briefpapier-Einstellungen

Eine Einschränkung bleibt bestehen: Outlook erlaubt es immer, die eingefügte Signatur innerhalb der E-Mail vor dem Versand zu bearbeiten.

### Outlook im Web, neues Outlook für Windows

Outlook im Web bietet deutlich weniger Steuerungsmöglichkeiten. In Exchange Online und Exchange On-Premises erlaubt das Cmdlet `Set-OwaMailboxPolicy` lediglich das generelle Aktivieren oder Deaktivieren von Signaturfunktionen über den Parameter `SignaturesEnabled`.

Eine granulare Steuerung ist nicht möglich:

- Kein Schreibschutz für Signaturen
- Keine Möglichkeit, Bearbeitung oder Entfernung zu verhindern, ohne Signaturen vollständig zu deaktivieren

Als Alternative: Führen Sie Set-OutlookSignatures regelmäßig aus (z. B. alle zwei Stunden).

### Outlook für Android, Outlook für iOS, Outlook für Mac

Es gibt keine Möglichkeit, Benutzer während der Erstellung vollständig an der Bearbeitung von Signaturen zu hindern — moderne Ansätze ermöglichen jedoch die Durchsetzung der korrekten Signatur beim Senden.

### Das Outlook Add-in

Das [Outlook Add-in](/outlookaddin), Teil des <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle Add-ons</span></a>, bietet eine Funktion, um benutzerdefinierte Signaturen zu ignorieren oder zu entfernen.

Wenn der Parameter `DISABLE_CLIENT_SIGNATURES` aktiviert ist:

- In Outlook im Web und im neuen Outlook für Windows werden Signaturoptionen für neue E-Mails, Antworten und Weiterleitungen deaktiviert
- Im klassischen Outlook für Windows und in Outlook für Mac wird die Signatur für neue Nachrichten sowie Antworten/Weiterleitungen auf „(keine)“ gesetzt
- In Outlook für Android und iOS wird die lokal gespeicherte Signatur gelöscht

Das Deaktivieren clientseitiger Signaturen entfernt zwar benutzerdefinierte Optionen, garantiert jedoch nicht, wie die endgültige E-Mail zum Zeitpunkt des Versands aussieht.

Für vollständige Kontrolle kombinieren Sie diese Einstellung mit einer Durchsetzung beim Senden (`OnMessageSend`). Dadurch wird sichergestellt, dass die korrekte Signatur vor dem Versand immer angewendet wird – selbst wenn Benutzer während der Erstellung Änderungen vornehmen.

Dies lässt eine zentrale Lücke erkennbar: die Durchsetzung genau in dem Moment, in dem sie entscheidend ist – beim Senden der E-Mail.

#### Der fehlende Baustein: Signaturen beim Senden erzwingen

Alle oben beschriebenen Ansätze haben eine grundlegende Einschränkung:  
Sobald eine Signatur in eine E-Mail eingefügt wurde, kann der Benutzer sie vor dem Versand bearbeiten oder entfernen.

Mit aktuellen Versionen des Outlook Add-ins lässt sich diese Einschränkung nun effektiv aufheben.

Durch Aktivierung der Launch Events:

- `OnMessageSend`
- `OnAppointmentSend`

wird eine definierte Signatur **unmittelbar nach dem Klick auf „Senden“ angewendet**.

Die Durchsetzung erfolgt clientseitig in Outlook, sodass Benutzer die endgültige Signatur direkt in ihren gesendeten Elementen sehen.

Das bedeutet:

- Manuelle Änderungen werden überschrieben
- Fehlende Signaturen werden automatisch ergänzt
- Jede gesendete Nachricht enthält die korrekte, compliant Signatur

Dieser Ansatz verändert die Signatur-Governance grundlegend:  
👉 Statt zu versuchen, Benutzer an Änderungen zu hindern (was Outlook technisch nicht vollständig zulässt)  
👉 wird das korrekte, regelkonforme Ergebnis exakt im Moment des Sendens erzwungen

Damit sind `OnMessageSend` und `OnAppointmentSend` der einzige Ansatz, der eine korrekte Signatur in jeder gesendeten E-Mail garantiert — unabhängig vom Benutzerverhalten — und somit die zuverlässigste und zukunftssicherste Lösung.

Aus Sicht von Governance und Compliance schließt dies eine lange bestehende Lücke:

- Rechtliche Hinweise können nicht mehr entfernt werden
- Corporate Branding wird konsequent durchgesetzt
- Regulatorische Anforderungen sind beim Versand jeder Nachricht sichergestellt

Dies ist besonders relevant für Unternehmen mit strengen regulatorischen oder Compliance-Vorgaben.

In der Praxis bedeutet das: Die Einhaltung von Signaturrichtlinien hängt nicht mehr vom Verhalten der Benutzer ab.

Mit anderen Worten: Signaturmanagement entwickelt sich von einer Best-Effort-Konfiguration zu einem vollständig durchsetzbaren Kontrollmechanismus.

> 💡 **Best Practice**
>
> Die effektivste Konfiguration kombiniert:
>
> - Deaktivierung clientseitiger Signaturen (`DISABLE_CLIENT_SIGNATURES`)
> - Zentrale Signaturerstellung
> - Durchsetzung beim Senden über `OnMessageSend`
>
> Dieser mehrschichtige Ansatz stellt eine kontrollierte Benutzererfahrung und gleichzeitig vollständige Compliance bei jeder gesendeten E-Mail sicher.

## Machen Sie jeden kleinen E-Mail-Moment zu einem professionellen Vorteil

E-Mail-Signaturen und Abwesenheitsnotizen mögen unbedeutend erscheinen, aber stellen Sie sich vor, wie oft sie gesehen werden.

Wir helfen Unternehmen, diese Kontaktpunkte für alle Benutzer zentral zu verwalten und zu standardisieren — **einheitliches Outlook-Branding überall, ohne Datenabfluss nach außen.** Kein manueller Aufwand, keine Inkonsistenzen, keine Daten verlassen Ihr Unternehmen. Mit Set-OutlookSignatures wird jede E-Mail zu einem konsistenten, sicheren und vollständig kontrollierten Markenerlebnis.

👉 Sehen Sie, was für Ihr E-Mail-Setup möglich ist  
→ [So funktioniert es (2 Minuten)](https://set-outlooksignatures.com/)

👉 Möchten Sie es selbst ausprobieren?  
→ [Schnellstart](https://set-outlooksignatures.com/quickstart)

_Nicht verantwortlich für die E-Mail-Konfiguration in Ihrem Unternehmen?_  
Teilen Sie diesen Artikel mit Ihrer IT-Abteilung oder Ihrem Marketingteam, sie werden es Ihnen danken.

