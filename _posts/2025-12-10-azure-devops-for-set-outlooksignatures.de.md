---
layout: "post"
lang: "de"
locale: "de"
title: "Azure DevOps für Set-OutlookSignatures"
description: "Wie AIMTEC eine robuste, automatisierte und dynamische Signaturverwaltung mit Azure DevOps implementiert, die nahtlos mit Set-OutlookSignatures zusammenarbeitet"
published: true
tags: 
slug: "azure-devops-for-set-outlooksignatures"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
Hallo an die Set-OutlookSignatures-Community!

Mein Name ist Jiří Hrabák, ich bin ICT Senior Consultant bei [AIMTEC a. s.](https://www.aimtecglobal.com). AIMTEC bietet Lösungen für Digitalisierung, Automatisierung und IT – darunter Systeme wie SAP, erweiterte Planung und End-to-End-Logistikmanagement.

Ich freue mich, Ihnen zu berichten, wie wir eine robuste, automatisierte und dynamische Lösung für das Signaturmanagement mithilfe von Azure DevOps Pipelines implementiert haben, die nahtlos mit Set-OutlookSignatures zusammenarbeitet.

Wir haben die Erstellung und Bereitstellung von Benutzersignaturen und dem Outlook-Add-in automatisiert und sorgen so für Konsistenz und aktuelle Informationen in unserem gesamten Unternehmen, alles basierend auf den Benutzerattributen in Active Directory/Entra ID.


## Unsere Konfiguration: Signaturen als Code über Azure-Dienste
Unsere Lösung basiert auf einer gut strukturierten Konfiguration mit drei Git-Repositorys und Azure-Clouddiensten.

1. Die Repository-Struktur  
Wir verwenden drei verschiedene Repositorys innerhalb unseres Git-Systems:
   - MKT_outlook_signatures_templates: Speichert unsere Signaturvorlagen mit einem Hauptzweig für die Produktion und einem Testzweig für das Testen neuer Designs.
   - MKT_outlook_signatures: Enthält das zentrale PowerShell-Skript für den Signaturvorlagengenerator und die Lizenzdatei für das Benefactor Circle-Add-on.
   - MKT_outlook_signatures_plugin: Enthält den Quellcode, Continuous Integration (CI) und Pipeline-Definitionen für die Bereitstellung des Outlook-Add-ins (Plugins).
2. Azure Static App für das Plugin  
Das Outlook-Add-in (Plugin) wird auf einer Azure Static Web App unter Verwendung der kostenlosen Stufe gehostet. Wir nutzen dessen Umgebungsfunktion zur Trennung:
   - Produktion: Zuordnung zu einer benutzerdefinierten Domäne (z. B. https://outlookaddin.example.com).
   - Entwicklung: Verwendet die generierte Azure-Domäne (z. B. https://outlookaddin-development.example.com).

Die Pipeline verarbeitet die Bereitstellung mithilfe von umgebungsspezifischen Variablen, die in der Variablengruppe "azure-static-aimoutlooksignatures" definiert sind:
```
variables:
  - ${{ if eq(variables['Build.SourceBranchName'], 'main') }}:
    - name: targetEnvironment
      value: 'Production'
  - ${{ else }}:
    - name: targetEnvironment
      value: 'Development'
```

## Automatisierte Pipeline zur Signaturgenerierung
Die wahre Stärke unseres Setups liegt in der automatisierten Pipeline zur Signaturgenerierung, die automatisch auf der Grundlage von Benutzeränderungen in unserem HR-System ausgelöst wird.

### Auslösen der Signaturaktualisierung
Unser Personalmanagementsystem (HRM) aktualisiert Benutzerattribute in Active Directory/Entra ID.

Wir verwenden das Erweiterungsattribut 1 als Auslöser: Wenn dieses Attribut von 0 auf 1 aktualisiert wird, wird die Pipeline für diesen bestimmten Benutzer ausgelöst.

### Der Prozess der Signaturgenerierung
Die Pipeline des Vorlagengenerators verwendet einen parametrisierten Ansatz, um den Zielbenutzer (UPN) und die Version der Signaturvorlage zu definieren.
```
  - name: UPN
    type: object
    default: ['xx@yy', 'xx@yy']

  - name: version
    type: string
    default: '4.23.0'
```

Die wichtigsten Schritte innerhalb des Auftrags nutzen die leistungsstarke Funktion "SimulateAndDeploy":
1. Temporäre Postfachberechtigungen erteilen  
Das Skript stellt zunächst eine Verbindung zu Exchange Online her. Damit das Dienstkonto für die Signaturgenerierung (signature-service@example.com) die Signatur anwenden kann, gewährt das Skript vorübergehend die Berechtigung für den vollständigen Zugriff auf das Postfach.
    ```
    Add-MailboxPermission -Identity $email -User "signature-service@example.com" -AccessRights "fullaccess" -Confirm:$false
    ```
2. Set-OutlookSignatures ausführen  
  Die Pipeline führt das Skript "Generate-signatures-devops.ps1" aus, das dann "Set-OutlookSignatures.ps1" mit den erforderlichen Parametern aufruft, um die Signatur direkt in der Mailbox des Benutzers bereitzustellen.  
    ```
    $SimulateAndDeployParams = @{
      # Define parameters here
    }
    
    & ./Set-OutlookSignatures_v$version/sample code/SimulateAndDeploy.ps1 @SimulateAndDeployParams
    ```
3. Temporäre Postfachberechtigungen entfernen  
  Unmittelbar nach der Bereitstellung wird die temporäre Vollzugriffsberechtigung aus Sicherheitsgründen widerrufen und das Erweiterungsattribut zurückgesetzt.
    ```
    Remove-MailboxPermission -Identity $email -User "signature-service@example.com" -AccessRights FullAccess -Confirm:$false

    Set-Mailbox -Identity $email -CustomAttribute1 $null
    ```

## Technische Gründe für das Outlook-Add-in
Die Entscheidung für das Outlook-Add-in, das auf einer statischen Azure-Web-App gehostet wird, basiert auf zwei wesentlichen technischen Vorteilen:
- Plattformunterstützung (macOS): Während Set-OutlookSignatures Roaming-Signaturen und deren Herunterladen/Hochladen für macOS Outlook unterstützt, gewährleistet das Add-in eine konsistente Funktionalität auf allen Plattformen. Wir müssen uns nicht um den Client kümmern, der für den Zugriff auf das Postfach verwendet wird.
- Effizienz durch zentralisierte Bereitstellung: Das Add-in wird in Kombination mit dem Parameter „SimulateAndDeploy” verwendet. Mit dieser Methode kann die Azure DevOps-Pipeline die Signatur direkt in der Mailbox des Benutzers bereitstellen, ohne dass ein Skript oder eine Arbeit auf dem Clientgerät ausgeführt werden muss. Dadurch entfällt die Ausführung auf der Clientseite, was als elegantere und weniger arbeitsintensive Lösung angesehen wird.

Das Add-In-Manifest wird über die Pipeline in der Azure Static Web App bereitgestellt, wobei die kostenlose Stufe genutzt wird.
```
- task: AzureStaticWebApp@0
  inputs:
    azure_static_web_apps_api_token: $(deploy-token)
    # ...
    workingDirectory: "$(Pipeline.Workspace)/manifest"
    skip_app_build: true # boolean. Skip app build.
    skip_api_build: true # boolean. Skip api build.
    app_location: "/" # App source code path
    # ...
    deployment_environment: "$(targetEnvironment)"
```

## Fazit
Dieser dynamische, attributbasierte Ansatz bietet eine zuverlässige, codezentrierte Lösung für das Signaturmanagement und stellt sicher, dass unsere Signaturen konsistent und auf dem neuesten Stand sind, wobei nur minimale manuelle Eingriffe erforderlich sind.

Jiří Hrabák, ICT Senior Consultant, [AIMTEC a. s.](https://www.aimtecglobal.com)


## Möchten Sie mehr erfahren oder unsere Lösung in Aktion sehen? Oder selber einen Gastbeitrag auf unserem Blog veröffentlichen?
[Kontaktieren Sie uns](/support) oder erfahren Sie mehr auf unserer [Website](/). Wir freuen uns darauf, mit Ihnen in Kontakt zu treten!