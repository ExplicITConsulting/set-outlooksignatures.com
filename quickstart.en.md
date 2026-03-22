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
        <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="button sos-download-link is-info is-normal is-hovered  has-text-weight-bold  mtrcs-download">Download software</a>
        <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="sos-download-link mtrcs-download no-external-link-icon"><img src="https://img.shields.io/github/downloads/Set-OutlookSignatures/Set-OutlookSignatures/total?style=flat" alt="Downloads" loading="lazy"></a>
        <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/issues?q=" class="no-external-link-icon"><img src="https://img.shields.io/github/issues/Set-OutlookSignatures/Set-OutlookSignatures?style=flat" alt="Open issues" loading="lazy"></a>
      </div>
    </p>
2.  **Unblock:** To remove the 'mark of the web' and allow execution:
    * **Right-click** `Set-OutlookSignatures.ps1` > **Properties** > check **Unblock**.
    * *Or* use the PowerShell cmdlet: `Unblock-File 'Set-OutlookSignatures.ps1'`.


## Step 2: One-time Preparations {#step-2}
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #48c774;">
      <p><b>💻 Client and User</b></p>
      <ul>
        <li><b>Initial Test:</b> Log on with a test user on Windows with Classic Outlook and Word. Using your own account may overwrite existing signatures if you do not use simulation mode.</li>
        <li><b>Platform Support:</b> Linux, macOS, and New Outlook require the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a> and Exchange Online hosting.</li>
      </ul>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="border-top: 4px solid #ffdd57;">
      <p><b>🛡️ Endpoint Security</b></p>
      <p>If using AppLocker, Defender, CrowdStrike…:</p>
      <ul style="margin-left: 1.5rem; list-style-type: disc;">
        <li>Allow execution and library loading from the TEMP folder.</li>
        <li>Trust software signed with ExplicIT Consulting's certificate (all included PS1 and DLL files are signed).</li>
      </ul>
    </div>
  </div>
  <div class="column is-full">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #3273dc;">
      <p><b>☁️ Entra ID (for Exchange Online)</b></p>
      <p>To access the Graph API, you must register an Entra ID app.</p>
      <ul>
        <li><b>Documentation:</b> Review '.\sample code\Create-EntraApp.ps1' for permissions and security audit details.</li>
        <li><b>Manual Setup:</b> Follow instructions in '.\config\default graph config.ps1'.</li>
        <li><b>Scripted Setup:</b> Have a "Global Administrator" or "Application Administrator" run the provided PowerShell command.
            <div class="terminal-ui mt-2 mb-4" style="background: #2d3436; border-radius: 6px; padding: 1.5rem; position: relative;">
                <div style="position: absolute; top: 10px; left: 15px; display: flex; gap: 6px;">
                <span style="width: 10px; height: 10px; background: #ff5f56; border-radius: 50%;"></span>
                <span style="width: 10px; height: 10px; background: #ffbd2e; border-radius: 50%;"></span>
                <span style="width: 10px; height: 10px; background: #27c93f; border-radius: 50%;"></span>
            </div>
            <pre style="font-color: white; background: transparent; padding: 0; color: #fab1a0; overflow-x: auto; margin-top: 0.5rem;"><code>powershell.exe -noexit -file "c:\test\sample code\Create-EntraApp.ps1" -AppType "Set-OutlookSignatures" -AppName "Set-OutlookSignatures"</code></pre>
            </div>
            <p><em>For sovereign clouds (e.g., AzureChina), add the [CloudEnvironment](/parameters#cloudenvironment) parameter.</em></p>
        </li>
      </ul>
    </div>
  </div>
</div>


## Step 3: Run Set-OutlookSignatures {#step-3}

* **Exchange On-Prem:**
<div class="terminal-ui mt-2 mb-4" style="background: #2d3436; border-radius: 6px; padding: 1.5rem; position: relative; box-shadow: 0 4px 6px rgba(0,0,0,0.3);">
  <div style="position: absolute; top: 10px; left: 15px; display: flex; gap: 6px;">
    <span style="width: 10px; height: 10px; background: #ff5f56; border-radius: 50%;"></span>
    <span style="width: 10px; height: 10px; background: #ffbd2e; border-radius: 50%;"></span>
    <span style="width: 10px; height: 10px; background: #27c93f; border-radius: 50%;"></span>
  </div>
  <pre style="font-color: white; background: transparent; padding: 0; color: #fab1a0; overflow-x: auto; margin-top: 0.5rem;"><code>powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1"</code></pre>
</div>

* **Exchange Online / Hybrid:**
<div class="terminal-ui mt-2 mb-4" style="background: #2d3436; border-radius: 6px; padding: 1.5rem; position: relative; box-shadow: 0 4px 6px rgba(0,0,0,0.3);">
  <div style="position: absolute; top: 10px; left: 15px; display: flex; gap: 6px;">
    <span style="width: 10px; height: 10px; background: #ff5f56; border-radius: 50%;"></span>
    <span style="width: 10px; height: 10px; background: #ffbd2e; border-radius: 50%;"></span>
    <span style="width: 10px; height: 10px; background: #27c93f; border-radius: 50%;"></span>
  </div>
  <pre style="font-color: white; background: transparent; padding: 0; color: #fab1a0; overflow-x: auto; margin-top: 0.5rem;"><code>powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1" -GraphOnly true -GraphClientId "<GraphClientId from Step 2>"</code></pre>
</div>

*Note: `-GraphOnly true` ensures on-prem AD is ignored. Add the [CloudEnvironment](/parameters#cloudenvironment) parameter if using a sovereign cloud.*

<div class="message is-info mt-6" style="border-left: 5px solid goldenrod;">
  <div class="message-header" style="background-color: goldenrod; color: #000;">
    <p>🛡️ Test your signatures – directly and risk-free {#simulation-mode}</p>
  </div>
  <div class="message-body">
    <p>If you lack Classic Outlook or want a zero-impact trial of the software:</p>
    <ol class="mt-2 mb-3" style="margin-left: 1.5rem;">
      <li>Run the script with: <code>-SimulateUser a@example.com -SimulateMailboxes a@example.com</code></li>
      <li><b>See the results:</b> Open your <b>'Documents\Outlook Signatures'</b> folder.</li>
    </ol>
    <p>This <b>"[Simulation Mode](/details#simulation-mode)"</b> creates the exact signatures for the simulated user as files on your disk. Instead of modifying Outlook, it generates a complete preview — the perfect way to verify your configuration without changing any system settings.</p>
  </div>
</div>


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