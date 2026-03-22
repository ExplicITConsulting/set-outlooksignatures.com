---
layout: "page"
lang: "en"
locale: "en"
title: "Quickstart guide"
subtitle: "Signatures in minutes"
description: "Quickstart guide. Deploy signatures within minutes."
permalink: "/quickstart"
---
## Step 1: Download {#step-1}
<div class="buttons">
Download and extract the archive to a local folder: 
  <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="button sos-download-link is-info is-normal is-hovered  has-text-weight-bold  mtrcs-download">Download software</a>
  <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="sos-download-link mtrcs-download no-external-link-icon"><img src="https://img.shields.io/github/downloads/Set-OutlookSignatures/Set-OutlookSignatures/total?style=flat" alt="Downloads" loading="lazy"></a>
  <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/issues?q=" class="no-external-link-icon"><img src="https://img.shields.io/github/issues/Set-OutlookSignatures/Set-OutlookSignatures?style=flat" alt="Open issues" loading="lazy"></a>
</div>
<p><small>To remove the 'mark of the web' from 'Set-OutlookSignatures.ps1' and allow execution, right-click the file > Properties > check Unblock - or use the 'Unblock-File' cmdlet.</small></p>


## Step 2: One-time Preparations {#step-2}
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #48c774;">
      <p><b>💻 Client and User</b></p>
      <ul>
        <li>Log on with a test user on Windows with Classic Outlook and Word. Using your own account may overwrite existing signatures if you do not use simulation mode.</li>
        <li>Linux, macOS, and New Outlook require the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a> and Exchange Online hosting.</li>
      </ul>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="border-top: 4px solid #ffdd57;">
      <p><b>🛡️ Endpoint Security (AppLocker, Defender, CrowdStrike…)</b></p>
      <ul style="margin-left: 1.5rem; list-style-type: disc;">
        <li>Allow execution and library loading from the TEMP folder.</li>
        <li>Trust software signed with ExplicIT Consulting's certificate -  all included PS1 and DLL files are signed with this certificate.</li>
      </ul>
    </div>
  </div>
  <div class="column is-full">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #3273dc;">
      <p><b>☁️ Entra ID app (for Exchange Online only)</b></p>
      <ul>
        <li>Review '.\sample code\Create-EntraApp.ps1' for permissions and security audit details.</li>
        <li>Follow the instructions in '.\config\default graph config.ps1'for manual setup or have a "Global Administrator" or "Application Administrator" run the provided PowerShell command.
            <div class="terminal-ui mt-2 mb-4" style="background: #2d3436; border-radius: 6px; padding: 1.5rem; position: relative;">
                <div style="position: absolute; top: 10px; left: 15px; display: flex; gap: 6px;">
                <span style="width: 10px; height: 10px; background: #ff5f56; border-radius: 50%;"></span>
                <span style="width: 10px; height: 10px; background: #ffbd2e; border-radius: 50%;"></span>
                <span style="width: 10px; height: 10px; background: #27c93f; border-radius: 50%;"></span>
            </div>
            <pre style="background: transparent; padding: 0; color: white; white-space: pre-wrap; margin-top: 0.5rem;"><code style="color: white !important;">powershell.exe -noexit -file "c:\test\sample code\Create-EntraApp.ps1" -AppType "Set-OutlookSignatures" -AppName "Set-OutlookSignatures"</code></pre>
            </div>
            <p><em>For sovereign clouds (e.g., AzureChina), add the <a href="/parameters#cloudenvironment">'-CloudEnvironment'</a> parameter.</em></p>
        </li>
      </ul>
    </div>
  </div>
</div>


## Step 3: Run Set-OutlookSignatures {#step-3}

<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #7957d5;">
      <p><b>Exchange On-Prem</b></p>
      <div class="terminal-ui mt-2 mb-4" style="background: #2d3436; border-radius: 6px; padding: 1.5rem; position: relative; box-shadow: 0 4px 6px rgba(0,0,0,0.3);">
        <div style="position: absolute; top: 10px; left: 15px; display: flex; gap: 6px;">
          <span style="width: 10px; height: 10px; background: #ff5f56; border-radius: 50%;"></span>
          <span style="width: 10px; height: 10px; background: #ffbd2e; border-radius: 50%;"></span>
          <span style="width: 10px; height: 10px; background: #27c93f; border-radius: 50%;"></span>
        </div>
        <pre style="background: transparent; padding: 0; color: white; white-space: pre-wrap; margin-top: 0.5rem;"><code style="color: white !important;">powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1"</code></pre>
      </div>
    </div>
  </div>

  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #3273dc;">
      <p><b>Exchange Online / Hybrid</b></p>
      <div class="terminal-ui mt-2 mb-4" style="background: #2d3436; border-radius: 6px; padding: 1.5rem; position: relative; box-shadow: 0 4px 6px rgba(0,0,0,0.3);">
        <div style="position: absolute; top: 10px; left: 15px; display: flex; gap: 6px;">
          <span style="width: 10px; height: 10px; background: #ff5f56; border-radius: 50%;"></span>
          <span style="width: 10px; height: 10px; background: #ffbd2e; border-radius: 50%;"></span>
          <span style="width: 10px; height: 10px; background: #27c93f; border-radius: 50%;"></span>
        </div>
        <pre style="background: transparent; padding: 0; color: white; white-space: pre-wrap; margin-top: 0.5rem;"><code style="color: white !important;">powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1" -GraphOnly true -GraphClientId "<GraphClientId from Step 2>"</code></pre>
      </div>
    </div>
    <p><em>'-GraphOnly true' ensures on-prem AD is ignored. Add the <a href="/parameters#cloudenvironment">'-CloudEnvironment'</a> parameter if using a sovereign cloud.</em></p>
  </div>
</div>

<div class="message is-info" style="border-left: 5px solid goldenrod;">
  <div class="message-header" style="background-color: goldenrod; color: #000;">
    <p id="simulation-mode">🛡️ Test your signatures – directly and risk-free</p>
  </div>
  <div class="message-body">
    <p>If you lack Classic Outlook or want a zero-impact trial of the software:</p>
    <ol>
      <li>Run the script with: '-SimulateUser a@example.com -SimulateMailboxes a@example.com'</li>
      <li>See the results in your 'Documents\Outlook Signatures' folder.</li>
    </ol>
    <p>This <a href="/details#simulation-mode">Simulation Mode</a> creates the exact signatures for the simulated user as files on your disk. Instead of modifying Outlook, it generates a complete preview — the perfect way to verify your configuration without changing any system settings.</p>
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