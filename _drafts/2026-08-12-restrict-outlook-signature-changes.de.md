---
layout: "post"
lang: "de"
locale: "de"
title: "Änderungen an Outlook-Signaturen verhindern"
description: "Outlook-Signaturfunktionen einschränken und die korrekte Signatur auf Desktop-, Web-, Mac- und mobilen Clients beim Senden durchsetzen."
slug: "restrict-signature-changes"
published: true
tags:
show_sidebar: true
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

Outlook bietet keine zentrale administrative Einstellung, die Änderungen an Signaturen gleichzeitig in Classic Outlook, New Outlook, Outlook im Web, Outlook für Mac und den mobilen Clients verhindert. Selbst wenn sich die Signaturverwaltung in einem Client einschränken lässt, können Benutzer eine bereits eingefügte Signatur während der Nachrichtenerstellung weiterhin verändern oder vollständig entfernen.

Diese Unterscheidung ist in Unternehmensumgebungen wesentlich. Das Deaktivieren eines Signatur-Editors beschränkt einen Teil der Benutzeroberfläche, bestimmt aber nicht zwangsläufig den Inhalt der Nachricht, die das Unternehmen tatsächlich verlässt. Eine verlässliche Implementierung muss daher zwei getrennte Anforderungen erfüllen:

1. Benutzerverwaltete Signaturoptionen in den jeweiligen Outlook-Clients reduzieren oder entfernen.
2. Die korrekte Signatur anwenden, nachdem der Benutzer die Bearbeitung der Nachricht abgeschlossen hat.

Die verfügbaren Steuerungsmöglichkeiten unterscheiden sich erheblich zwischen den Outlook-Plattformen.

#### Classic Outlook für Windows

Classic Outlook bietet die umfangreichsten administrativen Steuerungsmöglichkeiten. Jede davon hat jedoch betriebliche Auswirkungen.

Die Gruppenrichtlinie **Do not allow signatures for email messages** deaktiviert die Outlook-Oberfläche zum Hinzufügen, Bearbeiten und Entfernen von Signaturen. Die zugrunde liegenden Signaturdateien werden dadurch jedoch nicht geschützt. Benutzer können diese Dateien weiterhin direkt im Dateisystem ändern oder löschen.

Die Richtlinie verhindert außerdem, dass Outlook Standardsignaturen automatisch zu neuen Nachrichten, Antworten und Weiterleitungen hinzufügt. Benutzer müssen die gewünschte Signatur dann manuell auswählen, was die angestrebte Einheitlichkeit wiederum beeinträchtigen kann. Bei einigen neueren Outlook-Versionen greift die Gruppenrichtlinie möglicherweise nicht; in diesen Fällen muss der entsprechende Registrierungswert direkt gesetzt werden.

Eine weniger einschneidende Alternative besteht darin, Set-OutlookSignatures regelmäßig auszuführen, beispielsweise alle zwei Stunden, und in der INI-Datei die Option `WriteProtect` zu verwenden. Dadurch werden zentral erzeugte Signaturen bei jedem Lauf wiederhergestellt. Änderungen, die Benutzer zwischen zwei Ausführungen vornehmen, werden damit jedoch nicht unmittelbar verhindert.

Administratoren können außerdem über die Gruppenrichtlinie **Disable Items in User Interface** bestimmte Funktionen der Signaturverwaltung ausblenden:

- `5608` — `SignatureInsertMenu`: Deaktiviert die Dropdown-Schaltfläche zum Einfügen einer vorhandenen Signatur oder zum Öffnen des Signaturkatalogs.
- `22965` — `SignatureGallery`: Verhindert die Auswahl einer anderen als der vorgegebenen Standardsignatur, lässt den Zugriff auf `SignaturesStationeryDialog` jedoch bestehen.
- `3766` — `SignaturesStationeryDialog`: Deaktiviert die Oberfläche zum Hinzufügen, Bearbeiten und Entfernen von Signaturen. Dadurch entfällt zugleich der Zugriff auf persönliches Briefpapier sowie auf Briefpapier- und Schriftarteinstellungen. Diese Funktionen sollten üblicherweise zentral verwaltet werden, wenn verbindliche Corporate-Design-Vorgaben gelten.

Mit diesen Einstellungen lässt sich einschränken, wie Benutzer gespeicherte Signaturen verwalten. Eine in den Nachrichtentext eingefügte Signatur wird dadurch jedoch nicht geschützt. Ihr Inhalt bleibt während der Nachrichtenerstellung editierbar.

#### New Outlook für Windows und Outlook im Web

New Outlook und Outlook im Web bieten deutlich weniger granulare Steuerungsmöglichkeiten.

In Exchange Online und Exchange Server stellt `Set-OwaMailboxPolicy` den Parameter `SignaturesEnabled` bereit. Damit lässt sich die Signaturfunktion für die von der Richtlinie erfassten Postfächer aktivieren oder deaktivieren. Ein Schreibschutzmodus ist jedoch nicht vorhanden.

Administratoren können daher nicht gleichzeitig zentral verwaltete Signaturen zulassen und Benutzer separat daran hindern, eigene Signaturen hinzuzufügen, zu bearbeiten oder zu löschen. Die native Auswahl beschränkt sich im Wesentlichen darauf, die Signaturfunktion insgesamt zu aktivieren oder zu deaktivieren.

Eine regelmäßige Ausführung von Set-OutlookSignatures kann die zentral definierte Konfiguration wiederherstellen. Eine zeitgesteuerte Neuerstellung kontrolliert jedoch keine Änderungen, die während des Verfassens einer Nachricht vorgenommen werden.

#### Outlook für Mac, Android und iOS

Outlook für Mac sowie die mobilen Outlook-Clients bieten keine Möglichkeit, sämtliche Änderungen an einer Signatur während der Nachrichtenerstellung zu verhindern. Lokale Signaturkonfigurationen und der editierbare Nachrichteninhalt geben Benutzern bis zum Senden weiterhin einen gewissen Handlungsspielraum.

Der Versuch, jede einzelne Bearbeitungsoberfläche zu sperren, stellt für diese Clients deshalb kein vollständiges Governance-Modell dar. Der verlässlich kontrollierbare Zeitpunkt ist der Sendevorgang, nachdem die Bearbeitung abgeschlossen wurde.

#### Benutzerverwaltete Signaturoptionen entfernen

Das Outlook Add-in, das im Benefactor Circle Add-on enthalten ist, kann benutzerdefinierte Signaturoptionen über `DISABLE_CLIENT_SIGNATURES` ignorieren oder entfernen.

Das sichtbare Verhalten hängt vom verwendeten Outlook-Client ab:

- In New Outlook für Windows und Outlook im Web wird die Signaturauswahl für neue Nachrichten, Antworten und Weiterleitungen deaktiviert. Eine zuvor ausgewählte Signatur wird ebenfalls deaktiviert.
- In Classic Outlook für Windows und Outlook für Mac wird die Standardsignatur des sendenden Kontos sowohl für **Neue Nachrichten** als auch für **Antworten/Weiterleitungen** auf **(keine)** gesetzt.
- In Outlook für Android und Outlook für iOS wird die auf dem mobilen Gerät gespeicherte Signatur gelöscht.

Dadurch werden konkurrierende clientseitige Signaturvorgaben entfernt und zentral erzeugte Signaturen erhalten eine kontrolliertere Ausgangssituation. Der endgültige Nachrichteninhalt ist damit noch nicht garantiert, da Benutzer den bereits eingefügten Inhalt weiterhin ändern können, bevor sie **Senden** auswählen.

#### Verhalten vor und nach der Durchsetzung beim Senden

**Vor der Durchsetzung beim Senden** können Administratoren Signaturdialoge deaktivieren, clientseitige Standardsignaturen entfernen und zentral verwaltete Signaturen regelmäßig neu erzeugen. Diese Maßnahmen verringern Abweichungen, verhindern aber nicht, dass ein Benutzer die eingefügte Signatur vor dem Senden verändert oder löscht. Die Nachricht in den gesendeten Elementen kann daher von der zentral zugewiesenen Vorlage abweichen.

**Nach der Durchsetzung beim Senden** wendet das Outlook Add-in die definierte Signatur unmittelbar nach Auswahl von **Senden** an. Manuelle Änderungen werden überschrieben, eine fehlende Signatur wird hinzugefügt und die Nachricht in den gesendeten Elementen enthält die anhand der zentralen Regeln ausgewählte Signatur.

An diesem Punkt verlagert sich die Signaturverwaltung von der Kontrolle einer Client-Konfiguration auf die Kontrolle des tatsächlich versendeten Ergebnisses.

#### Signatur beim Senden anwenden

Das Outlook Add-in unterstützt die folgenden Launch Events:

- `OnMessageSend`
- `OnAppointmentSend`

Wenn diese Ereignisse aktiviert sind, wendet das Add-in die definierte Signatur unmittelbar nach Auswahl von **Senden** an. Die Durchsetzung erfolgt clientseitig in Outlook. Die endgültig angewendete Signatur ist deshalb auch in den gesendeten Elementen sichtbar.

`OnMessageSend` gilt für E-Mail-Nachrichten. `OnAppointmentSend` überträgt dasselbe Prinzip auf terminbezogene Inhalte. In beiden Fällen wird die Signatur angewendet, nachdem der Benutzer die reguläre Bearbeitung abgeschlossen hat, aber bevor das jeweilige Element zugestellt wird.

Set-OutlookSignatures erzeugt die zentral verwalteten Signaturen und stellt die Zuweisungslogik bereit. Das Outlook Add-in verwendet die vorbereiteten Signaturdaten anschließend während der Nachrichtenerstellung und wendet mit aktivierten Send Launch Events das definierte Ergebnis beim Senden erneut an.

Damit wird eine Einschränkung adressiert, die alle Outlook-Clients betrifft: Die Organisation muss sich nicht darauf verlassen, dass jeder Client einen wirksamen Schreibschutz für Signaturen bereitstellt. Stattdessen wird die zugewiesene Signatur zu dem Zeitpunkt durchgesetzt, an dem die Nachricht zur ausgehenden Unternehmenskommunikation wird.

> 💡 **Best Practice:** Aktivieren Sie `DISABLE_CLIENT_SIGNATURES`, erzeugen undzuweisen Sie die Signaturen zentral mit Set-OutlookSignatures und aktivieren Sie `OnMessageSend` sowie `OnAppointmentSend`. So werden clientseitig verwaltete Signaturen entfernt und das zentral definierte Ergebnis beim Senden erneut angewendet.

#### Das resultierende Outlook-Verhalten

Eine mehrstufige Implementierung führt für Benutzer und Administratoren zu klar erkennbaren Änderungen:

- Benutzer verfügen nicht mehr über konkurrierende, clientseitig definierte Standardsignaturen.
- Zentral erzeugte Signaturen basieren weiterhin auf den Vorlagen und Zuweisungsregeln der Organisation.
- Änderungen an einer eingefügten Signatur während der Bearbeitung bestimmen nicht mehr das endgültige versendete Ergebnis.
- Fehlende Signaturinhalte werden beim Senden wiederhergestellt.
- Die endgültig angewendete Signatur ist in den gesendeten Elementen sichtbar.
- Dasselbe Durchsetzungsprinzip lässt sich in Classic Outlook, New Outlook, Outlook im Web, Outlook für Mac, Outlook für Android und Outlook für iOS verwenden.

Native Outlook- und Exchange-Einstellungen bleiben nützlich, um den Zugriff auf Signaturfunktionen einzuschränken, insbesondere in Classic Outlook. Sie sollten jedoch nicht als Nachweis dafür betrachtet werden, dass jede ausgehende Nachricht tatsächlich die vorgeschriebene Signatur enthält.

Für Organisationen, die ein vorhersehbares Ergebnis benötigen, liegt die wirksame Kontrolle daher nicht in einer Sperre des Signatur-Editors. Entscheidend ist die Kombination aus zentral erzeugten Signaturdaten, der Entfernung clientseitig verwalteter Standardsignaturen und der Durchsetzung über die Outlook-Sendeereignisse.

<!--
LinkedIn Post:

Outlook bietet keine einzelne Einstellung, die Signaturänderungen gleichzeitig in Classic Outlook, New Outlook, Outlook im Web, Outlook für Mac und den mobilen Clients verhindert. Selbst wenn die Signaturverwaltung deaktiviert ist, kann bereits in eine Nachricht eingefügter Inhalt weiterhin verändert werden.

Native Richtlinien können den Zugriff auf Signatur-Editoren reduzieren. Clientseitig verwaltete Standardsignaturen lassen sich separat entfernen, doch keine dieser Maßnahmen bestimmt allein, welcher Inhalt nach Abschluss der Bearbeitung tatsächlich versendet wird.

Damit bleibt die Frage, ob Signatur-Governance lediglich die verfügbaren Einstellungen kontrollieren soll oder den tatsächlichen Nachrichteninhalt zum Zeitpunkt des Sendens.

https://set-outlooksignatures.com/de/blog/2026/08/12/restrict-signature-changes
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
