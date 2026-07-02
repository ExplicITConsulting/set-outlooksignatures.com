---
layout: "post"
lang: "de"
locale: "de"
title: "Delegieren der Abwesenheitsverwaltung mit Exchange RBAC"
description: "Wie ausgewählte Benutzer automatische Antworten für Abteilungspostfächer verwalten können, ohne umfassende Exchange-Administratorrechte zu erhalten"
published: true
tags:
show_sidebar: true
slug: "delegate-oof"
permalink: "/blog/:year/:month/:day/:slug"
redirect_from:
  - "/blog/:slug"
  - "/blog/:slug/"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

Abwesenheitsantworten sind eine kleine Einstellung mit überraschend großer operativer Wirkung. Wenn ein Postfachbesitzer abwesend ist, wenn ein freigegebenes Postfach eine temporäre Nachricht benötigt oder wenn ein Abteilungspostfach außerhalb der Geschäftszeiten aktualisiert werden muss, landet diese Aufgabe häufig beim lokalen Supportteam, im Sekretariat oder bei einer Abteilungskoordination.

Die falsche Lösung besteht darin, diesen Benutzern umfassende Exchange-Administrationsrechte zu geben. Die bessere Lösung ist eine fokussierte Exchange-RBAC-Rolle, die nur jene Postfachoptionen verfügbar macht, die für automatische Antworten erforderlich sind, und diese Rolle anschließend nur für Postfächer in der jeweiligen Abteilung zuweist.

Dieser Artikel zeigt ein praxisnahes Modell, mit dem die Abwesenheitsverwaltung an ausgewählte reguläre Endbenutzer delegiert werden kann. Diese Benutzer werden nicht zu Exchange-Administratoren gemacht. Sie erhalten lediglich die konkreten RBAC-Rolleneinträge, die erforderlich sind, um automatische Antworten für Postfächer innerhalb ihres Abteilungsbereichs zu verwalten.

Das Modell passt außerdem gut in ein umfassenderes Governance-Modell für Signaturen und Abwesenheitsantworten. Set-OutlookSignatures und das Benefactor-Circle-Add-on können Abwesenheitsantworten für interne und externe Empfänger mithilfe von Template-Tags und INI-Dateien zentral erstellen und bereitstellen. Dieses RBAC-Muster ergänzt diesen Ansatz, wenn ausgewählte Benutzer kontrollierten manuellen Zugriff auf dieselbe Postfacheinstellung benötigen. Siehe [Template tags and INI files](https://set-outlooksignatures.com/details#template-tags-and-ini-files).

Das Zielmodell ist:

- zwei dedizierte Rollen auf Basis von MyBaseOptions erstellen;
- die unterstützenden Rolleneinträge beibehalten, die Outlook im Web / ECP für dieses Postfachoptionsszenario erwartet;
- OOF-Management-FullControl verwenden, wenn delegierte Benutzer automatische Antworten aktivieren, deaktivieren, planen und den Antworttext bearbeiten dürfen;
- OOF-Management-ToggleOnly verwenden, wenn delegierte Benutzer automatische Antworten nur aktivieren, deaktivieren oder planen dürfen;
- den Schreibbereich über das Attribut Department einschränken;
- den Zugriff über Rollengruppen delegieren;
- das Ergebnis mit PowerShell und Outlook im Web / ECP überprüfen.

Alle Namen, Abteilungen, Postfächer, Unternehmen und Domänen in diesem Artikel sind fiktiv. Ersetzen Sie sie durch Werte aus Ihrer eigenen Umgebung.

## Warum hierfür MyBaseOptions verwendet wird

In diesem Szenario geht es nicht darum, eine weitere Administratorebene zu schaffen. Es geht darum, ausgewählten Endbenutzern die Durchführung genau einer Postfachoptionsaufgabe für eine kontrollierte Menge von Postfächern zu ermöglichen: die Verwaltung automatischer Antworten.

Deshalb sollten die Rollen auf MyBaseOptions basieren. MyBaseOptions ist die Endbenutzerrolle für Postfachoptionen. In einem normalen Self-Service-Szenario können Benutzer damit grundlegende Optionen für ihr eigenes Postfach verwalten. Indem aus MyBaseOptions bereichsbezogene untergeordnete Rollen erstellt, die verfügbaren Rolleneinträge reduziert und diese Rollen über bereichsbezogene Rollengruppen zugewiesen werden, kann dieselbe Postfachoptionsfunktion für eine auf Abteilungen begrenzte Zielmenge delegiert werden.

Das Benennungsschema in diesem Artikel verwendet nur zwei finale Rollen:

- OOF-Management-FullControl
- OOF-Management-ToggleOnly

Eine funktionierende Abwesenheitsrolle enthält typischerweise diese vier Rolleneinträge:

- Import-RecipientDataProperty
- Get-MailboxAutoReplyConfiguration
- Set-ADServerSettings
- Set-MailboxAutoReplyConfiguration

Auf den ersten Blick scheinen nur die beiden Cmdlets für automatische Antworten erforderlich zu sein. In der Praxis sind die zusätzlichen Einträge für die Postfachoptionsoberfläche in Outlook im Web / ECP wichtig:

- Import-RecipientDataProperty stammt weiterhin aus MyBaseOptions und ist Teil der Oberfläche der Postfachoptionsrolle.
- Set-ADServerSettings unterstützt das Verhalten der Verzeichnisansicht in der Exchange-Sitzung.
- Get-MailboxAutoReplyConfiguration liest den aktuellen Status der automatischen Antworten.
- Set-MailboxAutoReplyConfiguration schreibt den Status, die Zeitplanung, die Zielgruppe und den Nachrichtentext der automatischen Antworten.

## Wann eine zentrale Bereitstellung besser geeignet ist

RBAC-Delegierung ist nützlich, wenn eine ausgewählte Gruppe von Benutzern automatische Antworten für bestimmte Abteilungspostfächer manuell verwalten muss. Sie ist jedoch nicht das einzige Governance-Modell.

Wenn das Ziel darin besteht, Abwesenheitsantworten für viele Benutzer oder Postfächer zentral zu standardisieren und zu verteilen, kann das Benefactor-Circle-Add-on operativ besser passen. Zusammen mit Set-OutlookSignatures kann es Template-Tags und INI-Dateien verwenden, um Abwesenheitsantworten für interne und externe Empfänger aus zentral verwalteten Vorlagen bereitzustellen. Siehe [Template tags and INI files](https://set-outlooksignatures.com/details#template-tags-and-ini-files).

Eine praktische Aufteilung ist:

- Set-OutlookSignatures und das Benefactor-Circle-Add-on für eine zentrale, vorlagenbasierte OOF-Bereitstellung verwenden;
- das RBAC-Modell aus diesem Artikel verwenden, wenn ausgewählte Benutzer kontrollierte OOF-Verwaltung auf Postfachebene benötigen;
- Abteilungsbereiche verwenden, damit manuelle Delegierung begrenzt und nachvollziehbar bleibt.

## Schritt 1: Die Full-Control-Rolle erstellen

Erstellen Sie die Full-Control-Rolle direkt aus MyBaseOptions.

```powershell
New-ManagementRole -Name "OOF-Management-FullControl" -Parent "MyBaseOptions"
```

Entfernen Sie alles außer den vier Rolleneinträgen, die für das Abwesenheits-Postfachoptionsszenario erforderlich sind.

```powershell
Get-ManagementRoleEntry "OOF-Management-FullControl\*" |
    Where-Object {
        $_.Name -notin @(
            "Import-RecipientDataProperty",
            "Get-MailboxAutoReplyConfiguration",
            "Set-ADServerSettings",
            "Set-MailboxAutoReplyConfiguration"
        )
    } |
    Remove-ManagementRoleEntry -Confirm:$false
```

Legen Sie anschließend explizit die Parameter für Set-MailboxAutoReplyConfiguration fest. Dadurch entsteht die Full-Control-Rolle, mit der automatische Antworten aktiviert, deaktiviert, geplant und bearbeitet werden können.

```powershell
Set-ManagementRoleEntry "OOF-Management-FullControl\Set-MailboxAutoReplyConfiguration" `
    -Parameters AutoDeclineFutureRequestsWhenOOF,AutoReplyState,Confirm,CreateOOFEvent,Debug,DeclineAllEventsForScheduledOOF,DeclineEventsForScheduledOOF,DeclineMeetingMessage,DomainController,EndTime,ErrorAction,ErrorVariable,EventsToDeleteIDs,ExternalAudience,ExternalMessage,Identity,IgnoreDefaultScope,InternalMessage,OOFEventSubject,OutBuffer,OutVariable,StartTime,Verbose,WarningAction,WarningVariable,WhatIf
```

Beispiel für einen Full-Control-Vorgang:

```powershell
Set-MailboxAutoReplyConfiguration `
    -Identity "shared.operations@example.com" `
    -AutoReplyState Scheduled `
    -StartTime "2026-07-01 08:00" `
    -EndTime "2026-07-15 17:00" `
    -InternalMessage "I am currently out of office." `
    -ExternalMessage "Thank you for your message. I am currently out of office." `
    -ExternalAudience All
```

## Schritt 2: Die Toggle-Only-Rolle erstellen

Erstellen Sie die Toggle-Only-Rolle direkt aus MyBaseOptions.

```powershell
New-ManagementRole -Name "OOF-Management-ToggleOnly" -Parent "MyBaseOptions"
```

Entfernen Sie alles außer den gleichen vier Rolleneinträgen, die im Full-Control-Szenario verwendet werden.

```powershell
Get-ManagementRoleEntry "OOF-Management-ToggleOnly\*" |
    Where-Object {
        $_.Name -notin @(
            "Import-RecipientDataProperty",
            "Get-MailboxAutoReplyConfiguration",
            "Set-ADServerSettings",
            "Set-MailboxAutoReplyConfiguration"
        )
    } |
    Remove-ManagementRoleEntry -Confirm:$false
```

Beschränken Sie Set-MailboxAutoReplyConfiguration auf Parameter für Status und Zeitplanung.

```powershell
Set-ManagementRoleEntry "OOF-Management-ToggleOnly\Set-MailboxAutoReplyConfiguration" `
    -Parameters AutoReplyState,StartTime,EndTime,Identity,Confirm,WhatIf,Verbose,Debug,ErrorAction,ErrorVariable,OutBuffer,OutVariable,WarningAction,WarningVariable
```

Ein Toggle-Only-Benutzer sollte Folgendes ausführen können:

```powershell
Set-MailboxAutoReplyConfiguration `
    -Identity "shared.operations@example.com" `
    -AutoReplyState Enabled
```

Und Folgendes sollte nicht möglich sein:

```powershell
Set-MailboxAutoReplyConfiguration `
    -Identity "shared.operations@example.com" `
    -InternalMessage "Changed by delegated user"
```

Erwartetes Ergebnis:

```text
A parameter cannot be found that matches parameter name 'InternalMessage'.
```

Wenn die delegierten Benutzer hauptsächlich über Outlook im Web / ECP arbeiten sollen, bevorzugen Sie die Full-Control-Rolle, sofern Sie das Toggle-Only-Verhalten in der Benutzeroberfläche nicht getestet haben. Die Oberfläche kann beim Speichern Nachrichtenfelder mitsenden.

## Schritt 3: Die Rolleneinträge bestätigen

Prüfen Sie die Full-Control-Rolle.

```powershell
Get-ManagementRoleEntry "OOF-Management-FullControl\*" |
    Select-Object Name,Role,Parameters |
    ConvertTo-Json -Depth 5
```

Prüfen Sie die Toggle-Only-Rolle.

```powershell
Get-ManagementRoleEntry "OOF-Management-ToggleOnly\*" |
    Select-Object Name,Role,Parameters |
    ConvertTo-Json -Depth 5
```

Beide Rollen sollten diese Einträge enthalten:

```text
Import-RecipientDataProperty
Get-MailboxAutoReplyConfiguration
Set-ADServerSettings
Set-MailboxAutoReplyConfiguration
```

Für OOF-Management-FullControl stellen Sie sicher, dass InternalMessage, ExternalMessage, ExternalAudience und die Planungsparameter vorhanden sind.

Für OOF-Management-ToggleOnly stellen Sie sicher, dass InternalMessage, ExternalMessage, ExternalAudience, DeclineMeetingMessage und andere Text- oder Inhaltsparameter nicht vorhanden sind.

## Schritt 4: Den Abteilungsverwaltungsscope erstellen

Der Management Scope steuert, welche Zielpostfächer die delegierten Benutzer ändern können. Dieser Artikel verwendet Department, weil es sichtbar ist und sich einfach mit Get-User überprüfen lässt.

Beispiel für die fiktive Abteilung Operations:

```powershell
New-ManagementScope `
    -Name "OOF-Operations Scope" `
    -RecipientRestrictionFilter "Department -eq 'Operations'"
```

Beispiel für die fiktive Abteilung CustomerCare:

```powershell
New-ManagementScope `
    -Name "OOF-CustomerCare Scope" `
    -RecipientRestrictionFilter "Department -eq 'CustomerCare'"
```

Überprüfen Sie den Attributwert, bevor Sie ihn für die Bereichsdefinition verwenden.

```powershell
Get-User -Identity "alex.wilber@example.com" |
    Select-Object Name,Department,RecipientType
```

Sie können auch alle Postfächer auflisten, die in einem abteilungsbasierten Scope enthalten wären.

```powershell
Get-User -Filter "Department -eq 'Operations'" |
    Select-Object Name,Department,RecipientType
```

Wenn das Abteilungsattribut auf dem Benutzerobjekt gepflegt wird, verwenden Sie Get-User zur Überprüfung. Wenn Ihr lokaler Betriebsprozess hauptsächlich mit Postfächern arbeitet, können Sie auch postfachzentrierte Prüfungen verwenden. Wichtig ist jedoch, dass der OPath-Filter zur Empfängerobjekteigenschaft passt, die von Exchange RBAC verwendet wird.

## Schritt 5: Rollengruppen für die delegierten Benutzer erstellen

Die Rollengruppe ist der Zuweisungscontainer. Sie enthält die delegierten Endbenutzer und kombiniert eine szenariospezifische Rolle mit dem abteilungsbezogenen Schreibbereich.

### Full-Control-Gruppe für Operations

```powershell
New-RoleGroup `
    -Name "OOF_Operations_FullControl" `
    -Roles "OOF-Management-FullControl" `
    -CustomRecipientWriteScope "OOF-Operations Scope" `
    -Members "ava.reed@example.com"
```

### Toggle-Only-Gruppe für Operations

```powershell
New-RoleGroup `
    -Name "OOF_Operations_ToggleOnly" `
    -Roles "OOF-Management-ToggleOnly" `
    -CustomRecipientWriteScope "OOF-Operations Scope" `
    -Members "noah.brooks@example.com"
```

Fügen Sie bei Bedarf weitere delegierte Benutzer hinzu.

```powershell
Add-RoleGroupMember `
    -Identity "OOF_Operations_FullControl" `
    -Member "mia.clark@example.com"
```

Entfernen Sie Benutzer, wenn die Delegierung nicht mehr erforderlich ist.

```powershell
Remove-RoleGroupMember `
    -Identity "OOF_Operations_FullControl" `
    -Member "mia.clark@example.com" `
    -Confirm:$false
```

Nach Änderungen an der Mitgliedschaft sollte sich der delegierte Benutzer abmelden und erneut anmelden, bevor die Weboberfläche getestet wird.

## Schritt 6: Rollengruppen und Scopes überprüfen

Listen Sie Rollengruppen auf, die die benutzerdefinierten Abwesenheitsrollen verwenden.

```powershell
Get-RoleGroup |
    Where-Object {
        $_.Roles -contains "OOF-Management-FullControl" -or
        $_.Roles -contains "OOF-Management-ToggleOnly"
    } |
    Select-Object Name,Roles,ManagedBy
```

Prüfen Sie die Mitglieder einer bestimmten Rollengruppe.

```powershell
Get-RoleGroupMember "OOF_Operations_FullControl"
Get-RoleGroupMember "OOF_Operations_ToggleOnly"
```

Prüfen Sie den Management Scope.

```powershell
Get-ManagementScope "OOF-Operations Scope" |
    Format-List Name,RecipientRestrictionFilter,RecipientRoot,RecipientFilterType
```

Prüfen Sie, welche Empfänger dem Abteilungswert entsprechen.

```powershell
Get-User -Filter "Department -eq 'Operations'" |
    Select-Object Name,Department,RecipientType
```

Testen Sie ein Postfach innerhalb des Scopes.

```powershell
Get-MailboxAutoReplyConfiguration -Identity "shared.operations@example.com"
Set-MailboxAutoReplyConfiguration `
    -Identity "shared.operations@example.com" `
    -AutoReplyState Enabled
```

Testen Sie ein Postfach außerhalb des Scopes.

```powershell
Set-MailboxAutoReplyConfiguration `
    -Identity "shared.finance@example.com" `
    -AutoReplyState Enabled
```

Der Vorgang außerhalb des Scopes sollte fehlschlagen, weil sich das Zielpostfach außerhalb des benutzerdefinierten Empfängerschreibbereichs befindet.

## Schritt 7: Überprüfung über Outlook im Web / ECP

Der praktische Test besteht darin, zu prüfen, ob der delegierte Benutzer die Aufgabe über die erwartete Benutzeroberfläche ausführen kann.

### Klassischer ECP-Ablauf

- Melden Sie sich mit dem delegierten Benutzerkonto beim Exchange Control Panel an.
- Öffnen Sie das Benutzermenü und wählen Sie **Another user**.
- Wählen Sie ein Postfach aus, dessen Department-Wert innerhalb des zugewiesenen Scopes liegt.
- Öffnen Sie **E-Mail organisieren** / **Organize email**.
- Wählen Sie **Automatische Antwortnachricht einrichten** / **Set up an automatic reply message**.
- Aktivieren oder deaktivieren Sie automatische Antworten.
- Konfigurieren Sie bei Bedarf den Zeitplan.
- Geben Sie die interne und externe Nachricht ein oder aktualisieren Sie sie, wenn der delegierte Benutzer die Full-Control-Rolle besitzt.
- Speichern Sie die Änderung.
- Wiederholen Sie den Test mit einem Postfach aus einer anderen Abteilung und bestätigen Sie, dass der delegierte Benutzer es nicht verwalten kann.

### Moderner Outlook-im-Web-Ablauf

- Öffnen Sie Outlook im Web im Kontext des Postfachs, das getestet werden soll.
- Öffnen Sie **Einstellungen**.
- Wechseln Sie zu **Mail** > **Automatische Antworten**.
- Aktivieren Sie automatische Antworten.
- Wählen Sie optional **Antworten nur während eines Zeitraums senden** und legen Sie Start- und Endzeit fest.
- Geben Sie die interne automatische Antwort ein, wenn das Bearbeiten von Nachrichten Teil der delegierten Rolle ist.
- Konfigurieren Sie externe Antworten, falls erforderlich und erlaubt.
- Speichern Sie die Konfiguration.

Validieren Sie das Endergebnis mit PowerShell.

```powershell
Get-MailboxAutoReplyConfiguration -Identity "shared.operations@example.com" |
    Format-List AutoReplyState,StartTime,EndTime,ExternalAudience,InternalMessage,ExternalMessage
```

## Abschließende Gedanken

Abwesenheitsantworten sind Teil derselben Kommunikationsoberfläche wie E-Mail-Signaturen: klein, wiederkehrend, stark sichtbar und leicht falsch zu verwalten, wenn sie manuell gepflegt werden. Ein fokussiertes RBAC-Modell gibt Organisationen eine kontrollierte Delegierungsebene, während Set-OutlookSignatures und das Benefactor-Circle-Add-on eine zentrale, vorlagenbasierte Möglichkeit bieten, Abwesenheitsantworten für interne und externe Empfänger bereitzustellen. Siehe [Template tags and INI files](https://set-outlooksignatures.com/details#template-tags-and-ini-files).

Ein sauberes Delegierungsmodell für Abwesenheitsantworten benötigt keine umfassenden Exchange-Administratorrechte. Das funktionierende Muster ist:

- OOF-Management-FullControl direkt aus MyBaseOptions für vollständige Verwaltung automatischer Antworten erstellen;
- OOF-Management-ToggleOnly direkt aus MyBaseOptions für ausschließliches Aktivieren, Deaktivieren und Planen erstellen;
- Import-RecipientDataProperty, Get-MailboxAutoReplyConfiguration, Set-ADServerSettings und Set-MailboxAutoReplyConfiguration in beiden Rollen beibehalten;
- Zielpostfächer mit einem abteilungsbasierten Management Scope einschränken;
- getrennte Rollengruppen für jede Abteilung und jedes Szenario verwenden.

Dadurch erhalten ausgewählte Endbenutzer genau die Fähigkeit, die sie benötigen: automatische Antworten für Abteilungspostfächer verwalten, ohne allgemeine Exchange-Administratoren zu werd

## Machen Sie jeden kleinen E-Mail-Moment zu einem professionellen Vorteil

E-Mail-Signaturen und Abwesenheitsnotizen mögen unbedeutend erscheinen, aber stellen Sie sich vor, wie oft sie gesehen werden.

Wir helfen Unternehmen, diese Kontaktpunkte für alle Benutzer zentral zu verwalten und zu standardisieren — **einheitliches Outlook-Branding überall, ohne Datenabfluss nach außen.** Kein manueller Aufwand, keine Inkonsistenzen, keine Daten verlassen Ihr Unternehmen. Mit Set-OutlookSignatures wird jede E-Mail zu einem konsistenten, sicheren und vollständig kontrollierten Markenerlebnis.

👉 Sehen Sie, was für Ihr E-Mail-Setup möglich ist  
→ [So funktioniert es (2 Minuten)](https://set-outlooksignatures.com/)

👉 Möchten Sie es selbst ausprobieren?  
→ [Schnellstart](https://set-outlooksignatures.com/quickstart)

_Nicht verantwortlich für die E-Mail-Konfiguration in Ihrem Unternehmen?_  
Teilen Sie diese Seite mit Ihrer IT-Abteilung oder Ihrem Marketingteam, sie werden es Ihnen danken.
