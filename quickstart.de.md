---
layout: "page"
lang: "de"
locale: "de"
title: "Schnellstart-Anleitung"
subtitle: "Signaturen in wenigen Minuten"
description: "Schnellstart-Anleitung. Signaturen innerhalb von Minuten bereitstellen."
permalink: "/quickstart"
---

## Schritt 1: Herunterladen & Entsperren {#step-1}
1. **Download:** Entpacken Sie das Archiv in einen lokalen Ordner.
    <p>
      <div class="buttons">
        <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="button sos-download-link is-link is-normal is-hovered has-text-black has-text-weight-bold mtrcs-download" style="background-color: LawnGreen">Software herunterladen</a>
        <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="sos-download-link mtrcs-download no-external-link-icon"><img src="https://img.shields.io/github/downloads/Set-OutlookSignatures/Set-OutlookSignatures/total?style=flat" alt="Downloads" loading="lazy"></a>
        <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/issues?q=" class="no-external-link-icon"><img src="https://img.shields.io/github/issues/Set-OutlookSignatures/Set-OutlookSignatures?style=flat" alt="Offene Issues" loading="lazy"></a>
      </div>
    </p>
2. **Entsperren:** Um den "Mark of the Web"-Schutz zu entfernen und die Ausführung zu ermöglichen:
    * **Rechtsklick** auf `Set-OutlookSignatures.ps1` > **Eigenschaften** > Haken bei **Zulassen** (Unblock) setzen.
    * *Oder* nutzen Sie das PowerShell-Cmdlet: `Unblock-File 'Set-OutlookSignatures.ps1'`.


## Schritt 2: Einmalige Vorbereitungen {#step-2}
#### Client und Benutzer
* **Erster Test:** Melden Sie sich mit einem **Testbenutzer** an einem Windows-System mit Classic Outlook und Word an. Wenn Sie Ihren eigenen Benutzer verwenden, könnten bestehende Signaturen überschrieben werden, sofern Sie nicht den Simulationsmodus nutzen.
* **Plattform-Unterstützung:** Linux, macOS und das neue Outlook erfordern das <span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle Add-on</span> sowie Postfächer in Exchange Online.

#### Entra ID (für Exchange Online)
Für den Zugriff auf die Graph API müssen Sie eine Entra ID App registrieren.
* **Dokumentation:** In `.\sample code\Create-EntraApp.ps1` finden Sie Details zu Berechtigungen und für Sicherheits-Audits.
* **Manuelle Einrichtung:** Folgen Sie den Anweisungen in `.\config\default graph config.ps1`.
* **Skriptbasierte Einrichtung:** Lassen Sie einen "Global Administrator" oder "Application Administrator" folgendes ausführen:
    ```powershell
    powershell.exe -noexit -file "c:\test\sample code\Create-EntraApp.ps1" -AppType "Set-OutlookSignatures" -AppName "Set-OutlookSignatures"
    ```
    *Für Sovereign Clouds (z. B. AzureChina) fügen Sie den Parameter `-CloudEnvironment [Name]` hinzu.*

#### Endpoint Security
Falls AppLocker, Defender, CrowdStrike… aktiv sind:
* Erlauben Sie die Ausführung und das Laden von Bibliotheken aus dem **TEMP-Ordner**.
* Vertrauen Sie Software, die mit dem Zertifikat von **ExplicIT Consulting** signiert ist (alle PS1- und DLL-Dateien im Download sind damit signiert).


## Schritt 3: Set-OutlookSignatures ausführen {#step-3}
* **Exchange On-Premises:**
    ```powershell
    powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1"
    ```
* **Exchange Online / Hybrid:**
    ```powershell
    powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1" -GraphOnly true -GraphClientId "<GraphClientId aus Schritt 2>"
    ```
    *Hinweis: `-GraphOnly true` ignoriert das lokale Active Directory. Nutzen Sie `-CloudEnvironment` für Sovereign Clouds.*

#### 🛡️ Ihre Signaturen testen – direkt und risikofrei {#simulation-mode}
Falls Sie keinen Zugriff auf das klassische Outlook haben oder einen Test ohne Auswirkungen durchführen möchten:
1. Führen Sie das Skript mit diesen Parametern aus: `-SimulateUser a@example.com -SimulateMailboxes a@example.com`
2. **Ergebnisse ansehen:** Öffnen Sie Ihren Ordner **'Dokumente\Outlook Signatures'**. 

Dieser **"[Simulationsmodus](/details#simulation-mode)"** erstellt die exakten Signaturen für den simulierten Benutzer als Dateien auf Ihrer Festplatte. Statt Outlook zu verändern, wird eine vollständige Vorschau generiert – der perfekte Weg, um Ihre Konfiguration zu verifizieren, ohne Systemeinstellungen zu ändern.


## Einstellungen anpassen {#customize}
#### Eigene Vorlagen verwenden
* **Ordnerstruktur:** Kopieren Sie den Ordner `.\sample templates` an einen neuen Ort. Beachten Sie unsere [FAQ zur empfohlenen Ordnerstruktur](/faq#what-is-the-recommended-folder-structure-for-script-license-template-and-config-files), um spätere Updates zu erleichtern.
* **Ausführung:** Verweisen Sie auf Ihre eigenen Dateien:
    * `-SignatureTemplatePath 'c:\ihr_pfad'`
    * `-SignatureIniFile 'c:\ihr_pfad\_Signatures.ini'`
    * *Fügen Sie `-UseHtmTemplates true` hinzu, falls Sie HTML- statt DOCX-Vorlagen verwenden.*


#### Nächste Schritte
* **Parameter & Funktionen:** Prüfen Sie die [Funktionsliste](/features) und die [Parameter-Dokumentation](/parameters).
* **Rollout-Planung:** Lesen Sie den [Ansatz zur organisatorischen Implementierung](/implementationapproach) und die [technischen Details](/details) (insbesondere das Kapitel zu Architektur-Überlegungen).
* **Präsentieren Sie Ihre Arbeit:** Haben Sie eine beeindruckende Signatur erstellt? [Kontaktieren Sie uns](/support), um Ihre Vorlagen oder ein Statement in unserem Showcase zu teilen!