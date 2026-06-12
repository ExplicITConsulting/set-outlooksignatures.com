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
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

## Verhindern, dass Benutzer Signaturen hinzufügen, bearbeiten und entfernen

Die Wahrung einer einheitlichen Corporate Identity im gesamten Unternehmen ist eine Herausforderung – insbesondere dann, wenn Anwender eigenmächtig E-Mail-Signaturen verändern, veraltete Layouts nutzen oder diese komplett entfernen. Um Markenrichtlinien durchzusetzen und rechtliche Vorgaben (wie Pflichtangaben) zu sichern, müssen IT-Administratoren häufig Anpassungen an den Signatureinstellungen unterbinden.

Die technischen Möglichkeiten für eine solche Sperre hängen jedoch stark von der verwendeten Outlook-Version ab. Im Folgenden finden Sie einen detaillierten Überblick darüber, wie Sie Signaturänderungen auf verschiedenen Outlook-Plattformen einschränken können, welche Fallstricke existieren und welche Alternativen Ihnen zur Verfügung stehen.

### Klassisches Outlook für Windows

Sie können GUI-Elemente deaktivieren, sodass Benutzer in Outlook keine Signaturen hinzufügen, bearbeiten und entfernen können, indem Sie die Gruppenrichtlinieneinstellung (GPO) „Signaturen für E-Mail-Nachrichten nicht zulassen“ verwenden.

Die Einschränkungen dabei sind:

- Benutzer können weiterhin Signaturen im Dateisystem hinzufügen, bearbeiten und entfernen.
- Standardsignaturen werden nicht mehr automatisch hinzugefügt, wenn eine neue E-Mail erstellt oder eine E-Mail weitergeleitet/beantwortet wird. Benutzer müssen die korrekte Signatur manuell auswählen.
- Die GPO-Einstellung scheint bei einigen neueren Versionen von Outlook nicht zu funktionieren. Setzen Sie in diesem Fall den Registrierungsschlüssel (Registry Key) direkt.

Als Alternative können Sie eine oder beide der folgenden Optionen in Betracht ziehen:

- Führen Sie Set-OutlookSignatures regelmäßig aus (z. B. alle zwei Stunden) und verwenden Sie die Option „WriteProtect“ in der INI-Datei.
- Verwenden Sie die GPO-Einstellung „Elemente in der Benutzeroberfläche deaktivieren“ und nutzen Sie die folgenden Werte, um bestimmte signaturbedingte Teile der Benutzeroberfläche zu deaktivieren:
  - 5608: „SignatureInsertMenu“, die Dropdown-Liste/Schaltfläche, mit der Sie eine vorhandene Signatur zum Hinzufügen zu einer E-Mail auswählen und die „SignatureGallery“ öffnen können.
  - 22965: „SignatureGallery“, die Liste der Signaturen im „SignatureInsertMenu“. Verhindert die Auswahl einer anderen als der Standardsignatur zum Hinzufügen zu einer E-Mail, erlaubt aber weiterhin den Zugriff auf den „SignaturesStationeryDialog“.
  - 3766: „SignaturesStationeryDialog“, die GUI, über die Benutzer Signaturen hinzufügen, bearbeiten und entfernen können. Deaktiviert auch den Zugriff auf „Persönliches Briefpapier“ und „Briefpapier und Schriftarten“ – diese Einstellungen sollten ohnehin zentral gesteuert werden, um den Corporate Identity-/Corporate Design-Richtlinien zu entsprechen.

Eine Sache können Sie nicht deaktivieren: Outlook erlaubt es Benutzern immer, die Kopie der Signatur zu bearbeiten, nachdem sie einer E-Mail hinzugefügt wurde.

### Outlook im Web, Neues Outlook für Windows

Leider kann Outlook im Web nicht so feingranular konfiguriert werden wie das klassische Outlook. Sowohl in Exchange Online als auch in Exchange On-Premises erlaubt das Cmdlet `Set-OwaMailboxPolicy` keine detaillierte Konfiguration der Signatureinstellungen, sondern nur das Deaktivieren oder Aktivieren von Signaturfunktionen über den Parameter `SignaturesEnabled` für bestimmte Gruppen von Postfächern.

Es gibt keine Option, Signaturen schreibzuschützen oder Benutzer daran zu hindern, Signaturen hinzuzufügen, zu bearbeiten und zu entfernen, ohne alle signaturbezogenen Funktionen zu deaktivieren.

Führen Sie als Alternative Set-OutlookSignatures regelmäßig aus (z. B. alle zwei Stunden).

### Outlook für Android, Outlook für iOS, Outlook für Mac

Es gibt keinen dokumentierten Weg, um zu verhindern, dass Benutzer in diesen Editionen von Outlook Signaturen hinzufügen, bearbeiten oder entfernen.

### Das Outlook-Add-In

Das [Outlook-Add-in](/outlookaddin), Teil des <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle Add-ons</span></a>, enthält eine Funktion, mit der benutzerdefinierte Signaturoptionen ignoriert oder gelöscht werden können.

Wenn der Parameter `DISABLE_CLIENT_SIGNATURES` aktiviert ist:

- In Outlook im Web und im Neuen Outlook für Windows wird die Signaturoption für neue E-Mails, Antworten und Weiterleitungen deaktiviert. Eine ausgewählte Signatur wird ebenfalls deaktiviert.
- Im Klassischen Outlook für Windows und in Outlook für Mac wird die Signatur in den Abschnitten für neue Nachrichten und Antworten/Weiterleitungen des sendenden Kontos auf (keine) gesetzt.
- In Outlook für Android und Outlook für iOS wird die auf dem Mobilgerät gespeicherte Signatur gelöscht.

## Machen Sie jeden kleinen E-Mail-Moment zu einem professionellen Vorteil

E-Mail-Signaturen und Abwesenheitsnotizen mögen unbedeutend erscheinen, aber stellen Sie sich vor, wie oft sie gesehen werden.

Wir helfen Unternehmen, diese Kontaktpunkte für alle Benutzer zentral zu verwalten und zu standardisieren — **einheitliches Outlook-Branding überall, ohne Datenabfluss nach außen.** Kein manueller Aufwand, keine Inkonsistenzen, keine Daten verlassen Ihr Unternehmen. Mit Set-OutlookSignatures wird jede E-Mail zu einem konsistenten, sicheren und vollständig kontrollierten Markenerlebnis.

👉 Sehen Sie, was für Ihr E-Mail-Setup möglich ist  
→ [So funktioniert es (2 Minuten)](/)

👉 Möchten Sie es selbst ausprobieren?  
→ [Schnellstart](/quickstart)

_Nicht verantwortlich für die E-Mail-Konfiguration in Ihrem Unternehmen?_  
Teilen Sie diese Seite mit Ihrer IT-Abteilung oder Ihrem Marketingteam, sie werden es Ihnen danken.
