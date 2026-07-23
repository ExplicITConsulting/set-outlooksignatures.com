---
layout: "post"
lang: "de"
locale: "de"
title: Signaturen für Send-As-Berechtigungen
description: Outlook-Signaturen für Send As, Send on Behalf, freigegebene Postfächer, Verteilerlisten und delegierte Identitäten bereitstellen.
slug: sendas-signatures
published: true
tags:
show_sidebar: true
redirect_from:
  - "/blog/2025/08/19/signatures-sendas-sendonbehalf"
  - "/blog/2025/08/19/signatures-sendas-sendonbehalf/"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

Wenn Benutzer E-Mails mit **Senden als**- oder **Senden im Auftrag von**-Berechtigungen versenden, ist das verwendete Absenderpostfach häufig kein primäres Outlook-Postfach. Das ist entscheidend, weil Outlook Signaturen nur für primäre Postfächer vollständig unterstützt, und Set-OutlookSignatures bei der Verwaltung von Signaturen demselben Postfachmodell folgt.

Standardmäßig verarbeitet die Software nur primäre Postfächer. Das sind Postfächer, die in Outlook als separate Konten hinzugefügt wurden. Dieses Verhalten entspricht der Outlook-Logik: Outlook bietet keine vollständige Signaturunterstützung für Postfächer, die über **Diese zusätzlichen Postfächer öffnen** eingebunden werden, oder für Absenderidentitäten, die nur über das Feld **Von** ausgewählt werden.

#### Freigegebene Postfächer, zusätzliche Postfächer und delegierte Absender

In Microsoft-365-Umgebungen gibt es mehrere typische Szenarien, in denen Administratoren postfachspezifische Signaturen bereitstellen möchten, obwohl das Postfach nicht als primäres Konto konfiguriert ist:

- freigegebene Postfächer, die per Automapping verbunden sind
- zusätzliche Postfächer, die manuell hinzugefügt wurden
- Postfächer, die nur über Senden-als-Berechtigungen verwendet werden
- Postfächer, die nur über Senden-im-Auftrag-von-Berechtigungen verwendet werden
- Verteilerlisten mit delegierten Sendeberechtigungen

Diese Szenarien unterscheiden sich grundlegend vom primären Postfach eines Benutzers, weil Outlook für viele dieser Absenderidentitäten keinen Mechanismus zur Zuweisung von Standardsignaturen bietet.

#### Unterstützung für automatisch zugeordnete und zusätzliche Postfächer

Wenn Set-OutlookSignatures automatisch zugeordnete und zusätzliche Postfächer erkennen soll, aktivieren Sie die entsprechende Funktion mit dem Parameter `-SignaturesForAutomappedAndAdditionalMailboxes true`.

```powershell
.\Set-OutlookSignatures.ps1 -SignaturesForAutomappedAndAdditionalMailboxes true
```

Nach der Aktivierung kann die Software Signaturen für diese Postfachtypen bereitstellen.

Wichtig ist dabei die technische Einschränkung von Outlook: Signaturen können bereitgestellt werden, sie können aber nicht als Standardsignaturen gesetzt werden, weil Outlook selbst die Zuweisung von Standardsignaturen für diese nicht primären Postfächer nicht unterstützt. Das [Outlook Add-in](https://set-outlooksignatures.com/outlookaddin) kann diese Outlook-Einschränkung einfach umgehen.

#### Die Herausforderung bei Senden als und Senden im Auftrag von

Komplexer wird es, wenn Benutzer von Identitäten senden, die in Outlook überhaupt nicht als Postfach verbunden sind.

Typische Beispiele sind:

- ein freigegebenes Postfach, für das Benutzer nur Senden-als-Berechtigungen haben
- ein Postfach, für das Benutzer Senden-im-Auftrag-von-Berechtigungen haben
- eine Verteilerliste mit delegierten Sendeberechtigungen

In diesen Fällen wählen Benutzer einfach eine alternative Absenderadresse im Feld **Von** aus. Das Postfach oder die Verteilergruppe ist möglicherweise gar nicht als Konto in Outlook vorhanden.

Ein Beispiel:

Mitglieder der Gruppe `Example\Group` dürfen senden als:

- `m@example.com`
- `dg@example.com`

Die Organisation möchte für beide Absenderidentitäten eigene Signaturen bereitstellen.

Dabei treten sofort zwei praktische Probleme auf:

- `dg@example.com` ist eine Verteilergruppe und kann nicht als Postfach zu Outlook hinzugefügt werden.
- `m@example.com` ist typischerweise nicht als primäres Postfach verbunden, weil die meisten Benutzer zwar Senden-als-Berechtigungen, aber keine Vollzugriffsberechtigungen haben. Einige Benutzer verbinden das Postfach überhaupt nicht, sondern wählen `m@example.com` nur als Absenderadresse aus.

#### Lösungsoption A: Signaturen über die Gruppe mit Sendeberechtigung zuweisen

Der am breitesten einsetzbare Ansatz besteht darin, die Signaturvorlagen derselben Gruppe zuzuweisen, der auch die delegierten Sendeberechtigungen erteilt wurden.

```ini
[External English formal m@example.com.docx]
Example Group

[External English formal dg@example.com.docx]
Example Group
```

Wenn Set-OutlookSignatures das primäre Postfach des Benutzers verarbeitet, wird die Gruppenmitgliedschaft ausgewertet. Gehört der Benutzer zur Gruppe mit den delegierten Sendeberechtigungen, werden die zugewiesenen Signaturen verfügbar.

Dieser Ansatz funktioniert sowohl für Postfächer als auch für Verteilergruppen, weil er nicht davon abhängt, dass die Ziel-Absenderidentität in Outlook als Postfach verbunden ist.

Die zentrale Einschränkung: Ersetzungsvariablen aus dem Namensraum `$CurrentMailbox[...]$` beziehen sich in diesem Fall weiterhin auf das persönliche Postfach des Benutzers, weil dieses Postfach gerade verarbeitet wird.

#### Lösungsoption B: Virtuelles Postfach verwenden

Die zweite Option steht nur für Postfächer zur Verfügung, nicht für Verteilergruppen.

Mit dem **Benefactor Circle add-on** kann ein Postfach als virtuelles Postfach behandelt werden, unabhängig davon, ob es in Outlook hinzugefügt wurde oder nicht. Gesteuert wird dies über den Parameter `VirtualMailboxConfigFile`.

Die Signatur kann dann direkt dem Postfach selbst zugewiesen werden:

```ini
[External English formal SendAs m@example.com.docx]
m@example.com

## Signatur nicht bereitstellen, wenn m@example.com das persönliche Postfach des angemeldeten Benutzers ist

-CURRENTUSER:m@example.com
```

Mit diesem Ansatz verarbeitet Set-OutlookSignatures das Postfach als virtuelles Postfach. Dadurch ist eine Signaturzuweisung auch dann möglich, wenn Benutzer nur über delegierte Berechtigungen von dieser Adresse senden.

Ein zusätzlicher Vorteil ist, dass sowohl benutzerspezifische als auch postfachspezifische Ersetzungsvariablen verfügbar werden:

- `$CurrentUser[...]$`
- `$CurrentMailbox[...]$`

Das bietet mehr Flexibilität, wenn der Signaturinhalt Informationen aus dem Benutzerkonto und aus dem delegierten Postfach kombinieren soll.

#### Vor und nach der Implementierung

Vor der Implementierung:

- Benutzer wählen eine alternative Absenderadresse aus.
- Das Postfach ist möglicherweise nicht als primäres Outlook-Konto vorhanden.
- Verteilergruppen können überhaupt nicht als Postfach hinzugefügt werden.
- Die Signaturzuweisung ist schwierig oder uneinheitlich.

Nach der Implementierung:

- Delegierte Absenderidentitäten können eigene Signaturen erhalten.
- Signaturen für freigegebene Postfächer bleiben verfügbar, auch wenn das Postfach nicht verbunden ist.
- Verteilergruppen können über gruppenbasierte Zuweisung abgedeckt werden.
- Administratoren können die Signaturbereitstellung an bestehenden Microsoft-365-Berechtigungsstrukturen ausrichten.

> 💡 **Best Practice:** Weisen Sie Signaturen in Send-As- und Send-on-Behalf-Szenarien derselben Sicherheits- oder Microsoft-365-Gruppe zu, die auch die Sendeberechtigungen erhält. So bleiben Berechtigungsverwaltung und Signaturzielgruppe synchron, ohne doppelte Pflege pro Postfach.

Wenn postfachspezifische Ersetzungsvariablen benötigt werden, verwenden Sie für Postfachidentitäten, die möglicherweise nicht in Outlook verbunden sind, die Funktion für virtuelle Postfächer des Benefactor Circle add-ons. Damit bleibt die Signaturbereitstellung konsistent, ohne die technischen Grenzen von Outlook zu ignorieren.

<!--
LinkedIn Post:

Send-As- und Send-on-Behalf-Szenarien erzeugen in Outlook ein konkretes Signaturproblem: Die Absenderidentität ist häufig kein primäres Postfach. Sie kann ein automatisch zugeordnetes Postfach, ein zusätzliches Postfach, eine nur über das Feld Von ausgewählte Adresse oder eine Verteilerliste sein, die überhaupt nicht als Postfach hinzugefügt werden kann.

Diese Unterscheidung ist wichtig, weil Outlook solche Absenderidentitäten aus Signatursicht nicht wie primäre Postfächer behandelt. Ein Benutzer kann berechtigt sein, von einem freigegebenen Postfach oder einer Verteilergruppe zu senden, während die Signaturzuweisung dennoch über eine Berechtigungsgruppe, ein erkanntes zusätzliches Postfach oder eine virtuelle Postfachdefinition gelöst werden muss.

Die praktische Frage lautet daher nicht nur, wer von einer Adresse senden darf, sondern welchem Objekt die Signatur zugewiesen werden soll. Wenn diese Zuordnung nicht stimmt, bleiben Absenderadresse und Signaturlogik voneinander getrennt.

https://set-outlooksignatures.com/de/blog/2026/08/19/sendas-signatures
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
