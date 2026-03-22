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
Download and unzip the archive to a local folder: 
  <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="button sos-download-link is-info is-normal is-hovered  has-text-weight-bold  mtrcs-download">Download software</a>
  <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="sos-download-link mtrcs-download no-external-link-icon"><img src="https://img.shields.io/github/downloads/Set-OutlookSignatures/Set-OutlookSignatures/total?style=flat" alt="Downloads" loading="lazy"></a>
  <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/issues?q=" class="no-external-link-icon"><img src="https://img.shields.io/github/issues/Set-OutlookSignatures/Set-OutlookSignatures?style=flat" alt="Open issues" loading="lazy"></a>
</div>


## Step 2: One-time Preparations {#step-2}
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #3273dc;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>💻</span>
        <div style="hyphens: manual;">
          <p><b>Client and User</b></p>
          <p>Log on with a test user on Windows with Classic Outlook and Word. Running this on your primary account will overwrite signatures named '<code>Formal</code>' or '<code>Informal</code>' unless you use simulation mode, which is described later.</p>
          <p>Linux, macOS, and New Outlook require the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a> and Exchange Online hosting.</p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #48c774;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🛡️</span>
        <div style="hyphens: manual;">
          <p><b>Endpoint Security (AppLocker, Defender, CrowdStrike…)</b></p>
          <p>Trust software signed with ExplicIT Consulting's certificate - all included PS1 and DLL files are signed with this certificate.</p>
          <p>If needed, allow execution and library loading from the TEMP folder.</p>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="columns is-multiline">
  <div class="column is-full">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #ffdd57;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>☁️</span>
        <div style="hyphens: manual;">
          <p><b>Create Entra ID app for Exchange Online</b></p>
          <p>Follow the instructions in '<code>.\config\default graph config.ps1</code>' for manual setup or have a "Global Administrator" or "Application Administrator" run the provided PowerShell command.</p>
          <div class="terminal-ui mt-2 mb-4" style="background: #2d3436; border-radius: 6px; padding: 1.5rem; position: relative; box-shadow: 0 4px 6px rgba(0,0,0,0.3);">
            <div style="position: absolute; top: 10px; left: 15px; display: flex; gap: 6px;">
              <span style="width: 10px; height: 10px; background: #ff5f56; border-radius: 50%;"></span>
              <span style="width: 10px; height: 10px; background: #ffbd2e; border-radius: 50%;"></span>
              <span style="width: 10px; height: 10px; background: #27c93f; border-radius: 50%;"></span>
            </div>
            <pre style="background: transparent; padding: 0; color: white; white-space: pre-wrap; word-break: keep-all; overflow-wrap: anywhere; margin-top: 0.5rem;"><code style="color: white !important;">powershell.exe -noexit -file "c:\test\sample code\Create-EntraApp.ps1" -AppType "Set-OutlookSignatures" -AppName "Set-OutlookSignatures"</code></pre>
          </div>
          <p><small><em>For national or sovereign clouds, add the <a href="/parameters#cloudenvironment">'<code>-CloudEnvironment</code>'</a> parameter.</em></small>
          </p>
        </div>
      </div>
    </div>
  </div>
</div>


## Step 3: Run Set-OutlookSignatures {#step-3}
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #3273dc;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>☁️</span>
        <div>
          <p><b>Exchange Online / Hybrid</b></p>
          <div class="terminal-ui mt-2 mb-4" style="background: #2d3436; border-radius: 6px; padding: 1.5rem; position: relative; box-shadow: 0 4px 6px rgba(0,0,0,0.3);">
            <div style="position: absolute; top: 10px; left: 15px; display: flex; gap: 6px;">
              <span style="width: 10px; height: 10px; background: #ff5f56; border-radius: 50%;"></span>
              <span style="width: 10px; height: 10px; background: #ffbd2e; border-radius: 50%;"></span>
              <span style="width: 10px; height: 10px; background: #27c93f; border-radius: 50%;"></span>
            </div>
            <pre style="background: transparent; padding: 0; color: white; white-space: pre-wrap; word-break: keep-all; overflow-wrap: anywhere; margin-top: 0.5rem;"><code style="color: white !important;">powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1" -GraphOnly true -GraphClientId "<GraphClientId from Step 2>"</code></pre>
          </div>
          <p><small><em>'<code>-GraphOnly true</code>' ensures on-prem AD is ignored. Add the <a href="/parameters#cloudenvironment">'<code>-CloudEnvironment</code>'</a> parameter if using a national or sovereign cloud.</em></small></p>
          <p><small><em>If the script fails to run, right-click Set-OutlookSignatures.ps1 > Properties > check Unblock.</em></small></p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #3273dc;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🏢</span>
        <div>
          <p><b>Exchange On-Prem</b></p>
          <div class="terminal-ui mt-2 mb-4" style="background: #2d3436; border-radius: 6px; padding: 1.5rem; position: relative; box-shadow: 0 4px 6px rgba(0,0,0,0.3);">
            <div style="position: absolute; top: 10px; left: 15px; display: flex; gap: 6px;">
              <span style="width: 10px; height: 10px; background: #ff5f56; border-radius: 50%;"></span>
              <span style="width: 10px; height: 10px; background: #ffbd2e; border-radius: 50%;"></span>
              <span style="width: 10px; height: 10px; background: #27c93f; border-radius: 50%;"></span>
            </div>
            <pre style="background: transparent; padding: 0; color: white; white-space: pre-wrap; word-break: keep-all; overflow-wrap: anywhere; margin-top: 0.5rem;"><code style="color: white !important;">powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1"</code></pre>
          </div>
          <p><small><em>If the script fails to run, right-click Set-OutlookSignatures.ps1 > Properties > check Unblock.</em></small></p>
        </div>
      </div>
    </div>
  </div>
</div>
<p><b>You now find three new signatures in Outlook, based on the integrated sample templates and the attributes of your own user:</b></p>
<ul>
  <li><b>'<code>Formal</code>'</b> is ideal for new emails to external recipients.</li>
  <li><b>'<code>Informal</code>'</b> is great for replies and forwards and for internal emails.</li>
  <li><b>'<code>Test all default replacement variables</code>'</b> gives you an overview of the integrated placeholders and a glimpse of what is possible for images and banners, phone number and address formatting.</li>
</ul>
<div class="columns is-multiline">
  <div class="column is-full">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #ffdd57;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>💡</span>
        <div style="hyphens: manual;">
          <p><b>Pro-tip: Start risk-free with Simulation Mode</b></p>
          <p>If you lack Classic Outlook or want a zero-impact trial of the software, use <a href="/details#simulation-mode">Simulation Mode</a>: This mode creates the exact signatures for the simulated user as files on your disk, without modifying Outlook — the perfect way to verify your configuration without changing any system settings.</p>
          <p>Just add the parameter '<code>-SimulateUser a@example.com -SimulateMailboxes a@example.com</code>' and see the results in your '<code>Documents\Outlook Signatures</code>' folder.</p>
        </div>
      </div>
    </div>
  </div>
</div>


## Customize {#customize}
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #3273dc;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🎨</span>
        <div style="hyphens: manual;">
          <p><b>Deploy Your Own Templates</b></p>
          <p>Ready to move beyond samples? Copy '<code>.\sample templates</code>' to a new folder and start editing. We recommend following our <a href="/faq#what-is-the-recommended-folder-structure-for-script-license-template-and-config-files">folder structure guide</a> to make future updates a breeze.</p>
          <p>Point the script to your new files using:</p>
          <ul>
            <li><code>-SignatureTemplatePath "C:\Signatures\Templates"</code></li>
            <li><code>-SignatureIniFile "C:\Signatures\Templates\_Signatures.ini"</code></li>
          </ul>
          <p><small><em>Using HTML? Just add <code>-UseHtmTemplates true</code>.</em></small></p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #48c774;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🚀</span>
        <div style="hyphens: manual;">
          <p><b>Scale Your Rollout</b></p>
          <p>Once your templates are ready, explore the <a href="/features">Full Feature List</a> and <a href="/parameters">Parameter Docs</a> to automate the deployment across your organization.</p>
          <p>Review the <a href="/implementationapproach">Implementation Approach</a> for best practices on technical architecture and user communication.</p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-full">
    <div class="box has-background-white-bis has-text-black" style="border-top: 4px solid #ff3860;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>⭐</span>
        <div style="hyphens: manual;">
          <p><b>Share Your Success!</b></p>
          <p>Did you build something stunning? <a href="/support">Get in touch</a> to share your templates or a testimonial for our showcase and inspire others in the community!</p>
        </div>
      </div>
    </div>
  </div>
</div>