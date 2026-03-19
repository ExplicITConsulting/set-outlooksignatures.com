---
layout: "page"
lang: "en"
locale: "en"
title: "Quickstart guide"
subtitle: "Signatures in minutes"
description: "Quickstart guide. Deploy signatures within minutes."
permalink: "/quickstart"
---

## Step 1: Download & Unblock {#step-1}
1.  **Download:** Extract the archive to a local folder.
    <p>
      <div class="buttons">
        <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="button sos-download-link is-link is-normal is-hovered has-text-black  has-text-weight-bold  mtrcs-download">Download software</a>
        <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="sos-download-link mtrcs-download no-external-link-icon"><img src="https://img.shields.io/github/downloads/Set-OutlookSignatures/Set-OutlookSignatures/total?style=flat" alt="Downloads" loading="lazy"></a>
        <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/issues?q=" class="no-external-link-icon"><img src="https://img.shields.io/github/issues/Set-OutlookSignatures/Set-OutlookSignatures?style=flat" alt="Open issues" loading="lazy"></a>
      </div>
    </p>
2.  **Unblock:** To remove the 'mark of the web' and allow execution:
    * **Right-click** `Set-OutlookSignatures.ps1` > **Properties** > check **Unblock**.
    * *Or* use the PowerShell cmdlet: `Unblock-File 'Set-OutlookSignatures.ps1'`.


## Step 2: One-time Preparations {#step-2}
##### Client and User
* **Initial Test:** Log on with a **test user** on Windows with Classic Outlook and Word. Using your own account may overwrite existing signatures if you do not use simulation mode.
* **Platform Support:** Linux, macOS, and New Outlook require the <span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span> and Exchange Online hosting.

##### Entra ID (for Exchange Online)
To access the Graph API, you must register an Entra ID app.
* **Documentation:** Review `.\sample code\Create-EntraApp.ps1` for permissions and security audit details.
* **Manual Setup:** Follow instructions in `.\config\default graph config.ps1`.
* **Scripted Setup:** Have a 'Global Administrator' or 'Application Administrator' run:
    ```powershell
    powershell.exe -noexit -file "c:\test\sample code\Create-EntraApp.ps1" -AppType "Set-OutlookSignatures" -AppName "Set-OutlookSignatures"
    ```
    *For sovereign clouds (e.g., AzureChina), add: `-CloudEnvironment [EnvironmentName]`*

##### Endpoint Security
If using AppLocker, Defender, CrowdStrike…:
* Allow execution and library loading from the **TEMP** folder.
* Trust software signed with **ExplicIT Consulting's** certificate (all included PS1 and DLL files are signed).


## Step 3: Run Set-OutlookSignatures {#step-3}
* **Exchange On-Prem:**
    ```powershell
    powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1"
    ```
* **Exchange Online / Hybrid:**
    ```powershell
    powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1" -GraphOnly true -GraphClientId "<GraphClientId from Step 2>"
    ```
    *Note: `-GraphOnly true` ensures on-prem AD is ignored. Add `-CloudEnvironment` if using a sovereign cloud.*

##### 🛡️ Test your signatures – directly and risk-free {#simulation-mode}
If you lack Classic Outlook or want a zero-impact trial of the software:
1. Run the script with: `-SimulateUser a@example.com -SimulateMailboxes a@example.com`
2. **See the results:** Open your **'Documents\Outlook Signatures'** folder. 

This **"[Simulation Mode](/details#simulation-mode)"** creates the exact signatures for the simulated user as files on your disk. Instead of modifying Outlook, it generates a complete preview — the perfect way to verify your configuration without changing any system settings.


## Customize Settings {#customize}
##### Use Your Own Templates
* **Folder Structure:** Copy `.\sample templates` to a new folder. Follow our [recommended structure FAQ](/faq#what-is-the-recommended-folder-structure-for-script-license-template-and-config-files) to simplify future upgrades.
* **Execution:** Point the script to your custom files:
    * `-SignatureTemplatePath 'c:\your_path'`
    * `-SignatureIniFile 'c:\your_path\_Signatures.ini'`
    * *Add `-UseHtmTemplates true` if using HTML instead of DOCX.*


##### Next Steps
* **Parameters & Features:** Check the [Feature List](/features) and [Parameter Docs](/parameters).
* **Rollout Planning:** Read the [Organizational implementation approach](/implementationapproach) and [Technical details](/details) (specifically the *Architecture considerations* chapter).
* **Showcase Your Work:** Build something stunning? [Get in touch](/support) to share your templates or a statement for our showcase!