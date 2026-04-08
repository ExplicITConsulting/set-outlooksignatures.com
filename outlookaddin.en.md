---
layout: "page"
lang: "en"
locale: "en"
title: "The Outlook add-in"
subtitle: "Signatures for Outlook for Android and iOS, advanced features for all platforms"
description: "Extend Outlook with the Set-OutlookSignatures add-in. Automatic email signatures for iOS, Android, and all platforms. Self-hosted, secure, and enterprise-ready."
hero_link: "#overview"
hero_link_text: "<span><b>Overview: </b>What the add-in does</span>"
hero_link2: "#requirements"
hero_link2_text: "<span><b>Requirements: </b>Technical prerequisites</span>"
hero_link3: "#configuration-and-deployment"
hero_link3_text: "<span>Configuration and deployment options</span>"
hide_gh_sponsor: true
permalink: "/outlookaddin"
redirect_from:
  - "/outlookaddin/"
sitemap_priority: 0.8
sitemap_changefreq: weekly
---
<h2 id="overview">Overview</h2>
<p>With a <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle </span></a>license, you gain access to the Set-OutlookSignatures add-in.</p>
<p>The add-in makes signatures available in <b>Outlook for iOS and Android</b>, while supporting all Outlook editions across platforms. It's an ideal solution for Outlook editions that don't yet support roaming signatures and is particularly helpful in unmanaged BYOD scenarios.</p>
<p>It intelligently selects the appropriate signature based on the sender address, the type of item (new email, reply, or appointment), and any custom rules you define.</p>
<div class="box has-background-white-bis has-text-black" style=" border-left: 5px solid var(--benefactor-circle-color); border-right: 5px solid var(--benefactor-circle-color); ">
  <div class="columns is-multiline mt-0">
    <div class="column is-one-third-desktop is-one-third-tablet is-full-mobile">
      <div style="display: flex; gap: 0.75em;">
        ✨
        <div><b>Automatic Selection</b><br>Applies correct signatures on item creation.</div>
      </div>
    </div>
    <div class="column is-one-third-desktop is-one-third-tablet is-full-mobile">
      <div style="display: flex; gap: 0.75em;">
        👁️
        <div><b>Taskpane Preview</b><br>Users can manually select or preview signatures.</div>
      </div>
    </div>
    <div class="column is-one-third-desktop is-one-third-tablet is-full-mobile">
      <div style="display: flex; gap: 0.75em;">
        ☁️
        <div><b>On-Prem Roaming</b><br>Cloud-like experience for on-premises mailboxes.</div>
      </div>
    </div>
    <div class="column is-one-third-desktop is-one-third-tablet is-full-mobile">
      <div style="display: flex; gap: 0.75em;">
        🛡️
        <div><b>Privacy First</b><br>No middleware or proxy servers. Local execution.</div>
      </div>
    </div>
    <div class="column is-one-third-desktop is-one-third-tablet is-full-mobile">
      <div style="display: flex; gap: 0.75em;">
        ⚙️
        <div><b>Full Control</b><br>You control the version and configuration.</div>
      </div>
    </div>
    <div class="column is-one-third-desktop is-one-third-tablet is-full-mobile">
      <div style="display: flex; gap: 0.75em;">
        💎
        <div><b>Low Cost</b><br>Self-hosting keeps license costs minimal.</div>
      </div>
    </div>
    <div class="column is-one-third-desktop is-one-third-tablet is-full-mobile">
      <div style="display: flex; gap: 0.75em;">
        🚀
        <div><b>Enterprise Ready</b><br>Exchange Online and On-Premises support.</div>
      </div>
    </div>
  </div>
</div>


<h2 id="usage">Usage</h2>
<p>From an end user perspective, basically nothing needs to be done: When writing a new email, answering an email, or creating a new appointment, the add-in automatically adds the corresponding default signature.</p>
<p>For advanced usage, a taskpane is available to manually choose signatures, preview items, or override settings for debug logging.</p>
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <div style="display: flex; gap: 0.75em;">
        🌐
        <div>
          <p><b>Web (Exchange Online), New Outlook for Windows/Mac</b></p>
          <ul>
            <li><b>Emails:</b> "Message" tab > "Apps" icon</li>
            <li><b>Appointments:</b> Ribbon > "…" menu</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <div style="display: flex; gap: 0.75em;">
        💻
        <div>
          <p><b>Classic Outlook for Windows and Mac</b></p>
          <ul>
            <li><b>Emails:</b> "Message" tab > "All apps" icon</li>
            <li><b>Appointments:</b> "Meeting" tab > "All apps" icon</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <div style="display: flex; gap: 0.75em;">
        🏢
        <div>
          <p><b>Outlook for the web (on-prem)</b></p>
          <ul>
            <li><b>Compose:</b> Lower right corner of the window</li>
            <li><b>Appointments:</b> Right side of the top menu bar</li>
            <li><b>Read mode:</b> Left of the reply button</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <div style="display: flex; gap: 0.75em;">
        📱
        <div>
          <p><b>Mobile (iOS & Android)</b></p>
          <ul>
            <li><b>Read mode:</b> Three dots ("…" or "⋮") in the header</li>
            <li><b>Compose:</b> Signatures are added automatically</li>
            <li><b>Note:</b> Taskpanes are only supported in Read mode on mobile</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>


<h2 id="requirements">Requirements</h2>
<h3>Outlook clients</h3>
<p>The add-in works for all Microsoft-supported Outlook clients. It runs in the security context of the user and supports delegate scenarios.</p>
<div class="columns">
  <div class="column">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <p><b>Standard Mailboxes</b></p>
      <p>The add-in accesses signature information that the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a> has written to the user's mailbox in <a href="/details#step-1-create-signatures-and-out-of-office-replies">client or SimulateAndDeploy mode</a>.</p>
      <p>Shared mailboxes added with the credential of the logged-on user are directly supported.</p>
    </div>
  </div>
  <div class="column">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <p><b>Shared Mailboxes</b></p>
      <p>For shared mailboxes added with separate credentials, the add-in must be installed for that specific identity to access its signature data.</p>
    </div>
  </div>
</div>

<h3>Web server and domain</h3>
<p>The requirements for your web server are straightforward:</p>
<ul>
  <li>Reachable from mobile devices via the public internet.</li>
  <li>Use a dedicated host name (e.g., <code>https://outlookaddin01.example.com</code>). Do not use subdirectories.</li>
  <li>A valid TLS certificate. <a href="https://letsencrypt.org/">Let's Encrypt</a> is a good free alternative, especially when used with an <a href="https://letsencrypt.org/docs/client-options/">ACME client</a> for auto-renewal.</li>
  <li>Production servers should not return <code>Cache-Control</code> headers like <code>no-cache</code> or <code>no-store</code> for images.</li>
</ul>
<p><a href="https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website">Static website hosting in Azure Storage</a> is an uncomplicated, affordable and fast alternative. It includes a Microsoft-issued certificate, even in the free tier.</p>

<h3 id="entra-id-app">Entra ID app</h3>
<p>When mailboxes are hosted in Exchange Online, the add-in needs an Entra ID app to access the mailbox. Creating a separate app is strongly recommended.</p>
<div class="highlighter-rouge">
  <pre><code>powershell.exe -noexit -file "c:\test\sample code\Create-EntraApp.ps1" -AppType "OutlookAddIn" -AppName "Set-OutlookSignatures Outlook add-in" -OutlookAddInUrl "https://yourhost.yourdomain.com"</code></pre>
</div>

<p>For manual configuration, the following <b>Delegated Graph API</b> permissions must be granted with admin consent:</p>
<div class="columns is-multiline">
  <div class="column is-one-third-desktop is-one-third-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid LimeGreen;">
      <p><b>Mail.Read</b></p>
      <p>Allows reading emails in the current user's mailbox. Required due to Microsoft restrictions accessing roaming signatures.</p>
    </div>
  </div>
  <div class="column is-one-third-desktop is-one-third-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid LimeGreen;">
      <p><b>GroupMember.Read.All</b></p>
      <p>Allows the app to check group memberships to verify license groups for the signed-in user.</p>
    </div>
  </div>
  <div class="column is-one-third-desktop is-one-third-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid LimeGreen;">
      <p><b>User.Read.All</b></p>
      <p>Required to retrieve the User Principal Name (UPN) for a given SMTP email address.</p>
    </div>
  </div>
</div>
<p><b>Authentication:</b> Use <code>Single-page application</code> with a redirect URI of <code>brk-multihub://yourhost.yourdomain.com</code>.</p>


<h2 id="configuration-and-deployment">Configuration and deployment</h2>
<p>With every new release of Set-OutlookSignatures, the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a> comes with an updated Outlook add-in. You must update your deployment whenever the add-in version or your add-in configuration changes.</p>
<p>It is recommended to use at least two separate dedicated hostnames: One for testing and one for production (e.g., <code>https://outlookaddin01test.example.com</code> and <code>https://outlookaddin01.example.com</code>).</p>
<p>Deploying the add-in is a simple and fast three-step process: Configuring the code, uploading the files to a web server, and rolling out the manifest to your mailboxes.<br>You must update your deployment whenever the add-in version or your add-in configuration changes.</p>

<h3 id="configuration">Step 1: Configuration (Prepare)</h3>
<p>The add-in is built using the <code>run_before_deployment.ps1</code> script. This script injects your technical details into the source code and generates a <code>publish</code> folder containing your customized add-in code, include the <code>manifest.xml</code> file used for deployment.</p>

<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <p><b>General Settings</b></p>
      <ul>
        <li><b>Versioning:</b> Increment this every time you change a setting. This is the only way to force Outlook to clear its local cache and download the new files.</li>
        <li><b>Deployment URL:</b> Define your dedicated hosting domain (e.g., <code>https://outlookaddin01.example.com</code>).</li>
        <li><b>Cloud Environment:</b> Set your environment and Entra ID Client ID.</li>
        <li><b>Debug Logging:</b> Enable or disable detailed execution logs.</li>
      </ul>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <p><b>Automation Rules</b></p>
      <ul>
        <li><b>Platform Targeting:</b> Choose which hosts add signatures automatically.</li>
        <li><b>Item Types:</b> Enable automation for emails, appointments, or both.</li>
        <li><b>Client Signatures:</b> Optionally disable signatures configured by users.</li>
      </ul>
    </div>
  </div>
</div>
<div class="box has-background-white-bis has-text-black" style="border-top: 4px solid Yellow;">
  <p><b>Custom Rules Logic</b></p>
  <p class="mb-0">Modify <code>CustomRulesCode.js</code> to influence signature selection at runtime based on:</p>
  <div class="columns mt-0">
    <div class="column is-half-desktop is-half-tablet is-full-mobile pt-0">
      <ul>
        <li>Internal vs. external recipients</li>
        <li>The sender's email address</li>
        <li>Specific customers in the To field</li>
      </ul>
    </div>
    <div class="column is-half-desktop is-half-tablet is-full-mobile pt-0">
      <ul>
        <li>Mail vs. Appointment types</li>
        <li>Subject line keywords</li>
        <li>Item status (New, Reply, or Forward)</li>
      </ul>
    </div>
  </div>
  <p class="mt-2">You can even generate unique signatures at runtime without choosing a pre-deployed template. See <code>.\sample code\CustomRulesCode.js</code> for details.</p>
</div>

<h3 id="web-server-step">Step 2: Hosting (Publish)</h3>
<p><b>Deployment:</b> Run <code>run_before_deployment.ps1</code> and upload the content of the <code>publish</code> folder to your web server.</p>
<ul>
  <li>The files must be hosted at the root of a dedicated host name (e.g., <code>https://outlookaddin01.example.com</code>). Subdirectories, such as <code>https://www.example.com/outlookaddin01</code>, are not supported.</li>
  <li>Do not upload the <code>publish</code> folder itself, only its content, including subfolders.</li>
  <li><a href="https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website">Static website hosting in Azure Storage</a> is an uncomplicated, affordable and fast alternative. It includes a Microsoft-issued certificate, even in the free tier.</li>
</ul>

<h3 id="deployment-to-mailboxes">Step 3: Rollout (Deploy)</h3>
<p>When the <code>manifest.xml</code> file, the configuration or another part of the Outlook add-in changes, you need to tell your mailboxes that an updated version or configuration is available and must be downloaded.</p>
<p>The information from the manifest file is stored in the assigned mailboxes, but not the add-in itself - every Outlook client downloads a local copy of the add-in based on the one-time information transfer from the manifest file.</p>
<p>These downloaded files are cached locally. The cache is only updated when a manifest file with a changed version number is added to the configuration of the mailbox, or when the cache gets cleared manually.</p>
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <p><b>Individual Installation (Sideloading)</b></p>
      <p>Ideal for test scenarios. Sideloading of add-ins may have been disabled by your administrators.</p>
      <ul>
        <li><b>Exchange Online:</b> Open <code>https://outlook.cloud.microsoft/mail/inclientstore</code> > My add-ins > Add from file.</li>
        <li><b>On-prem:</b> Open <code>https://YourMailServer.example.com/owa/#path=/options/manageapps</code> > Add from file.</li>
        <li><b>Removal:</b> Draft a new mail, click the <b>Apps</b> button, right-click the add-in and select <b>Uninstall</b>.</li>
      </ul>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <p><b>Enterprise Deployment (Production)</b></p>
      <p>Ideal for mass deployment after the test phase.</p>
      <ul>
        <li><b><a href="https://learn.microsoft.com/en-us/microsoft-365/admin/manage/test-and-deploy-microsoft-365-apps?view=o365-worldwide">Integrated Apps</a>:</b> The modern method for Microsoft 365 environments.</li>
        <li><b><a href="https://learn.microsoft.com/en-us/microsoft-365/admin/manage/centralized-deployment-of-add-ins?view=o365-worldwide">Centralized Deployment</a>:</b> Use this if Integrated Apps is not yet available in your cloud tenant.</li>
      </ul>
      <p>Both methods share the same backend and are usually too slow for test scenarios: <a href="https://learn.microsoft.com/en-us/microsoft-365/admin/manage/centralized-deployment-faq?view=o365-worldwide#how-long-does-it-take-for-add-ins-to-show-up-for-all-users-">Microsoft documents state</a>  up to 24 hours for new add-in deployments, and up to 72 hours for changes to existing deployments. Consider <a href="#clear-the-outlook-add-in-cache">clearing the Outlook add-in cache</a> to speed up and test the deployment on select clients.</p>
    </div>
  </div>
</div>
<div class="box has-background-white-bis has-text-black mt-5" style="height: 100%; border-top: 4px solid Yellow;">
  <p id="clear-the-outlook-add-in-cache"><b>Clear the Outlook add-in cache</b></p>
  <p class="mb-0">When testing, Outlook sometimes takes too long updating its cache. Follow these official Microsoft instructions to manually clear it:</p>
  <div class="columns">
    <div class="column is-half-desktop is-half-tablet is-full-mobile">
      <ul>
        <li><b>Outlook for the Web:</b> Hard Refresh the browser window.</li>
        <li><b>Classic Outlook for Windows:</b> <a href="https://learn.microsoft.com/en-us/office/dev/add-ins/testing/clear-cache#classic-outlook-on-windows">Official instructions from Microsoft</a>.</li>
        <li><b>New Outlook for Windows:</b> <a href="https://learn.microsoft.com/en-us/office/dev/add-ins/testing/clear-cache#new-outlook-on-windows">Official instructions from Microsoft</a>.</li>
      </ul>
    </div>
    <div class="column is-half-desktop is-half-tablet is-full-mobile">
      <ul>
        <li><b>Outlook for Mac:</b> <a href="https://learn.microsoft.com/en-us/office/dev/add-ins/testing/clear-cache#clear-the-office-cache-on-mac">Official instructions from Microsoft</a>.</li>
        <li><b>Outlook for iOS:</b> Taskpane > Advanced options > <b>Reload add-in</b>.</li>
        <li><b>Outlook for Android:</b> App info > Force Stop > Clear Cache (do not tap Clear Data).</li>
      </ul>
    </div>
  </div>
  <p>Restart Outlook after clearing the cache, even if not explicitly prompted. Allow up to 10 minutes for add-ins to fully reload, especially in Classic Outlook for Windows. If launch events fail to trigger, a second restart usually resolves the issue.</p>
</div>


<h2 id="remarks">Remarks</h2>
<div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
  <p><b>General Platform Notes</b></p>
  <ul>
    <li><b>Roaming Signatures:</b> Microsoft currently limits add-in access to roaming signatures. The add-in uses data from the last run of Set-OutlookSignatures (v4.14.0+) as a workaround until this is resolved.</li>
    <li><b>Online Connection:</b> Microsoft APIs only allow access to online content. The add-in requires an active connection to the mailbox and cannot access offline cache or the local file system.</li>
    <li><b>Event Support:</b> Automation relies on Outlook "Launch Events" (e.g., OnNewMessageCompose). Note that Microsoft does not currently support add-ins for calendar invite responses.</li>
    <li><b>Office.js:</b> Microsoft dynamically updates the underlying framework. If automation behaves unexpectedly, the taskpane remains the reliable manual fallback.</li>
  </ul>
</div>

<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
      <p><b>Outlook for iOS & Android</b></p>
      <ul>
        <li>Only Exchange Online mailboxes are supported.</li>
        <li>Taskpanes are not permitted by Microsoft during compose mode; signatures are applied automatically via events.</li>
        <li>Automated signatures for new appointments are not yet supported by the mobile APIs.</li>
      </ul>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
      <p><b>Outlook for Mac</b></p>
      <ul>
        <li><b>New Outlook for Mac:</b> Fully supported and recommended.</li>
        <li><b>Classic Outlook for Mac:</b> Out of support by Microsoft. Support is provided on a best-effort basis due to API instability on this legacy platform.</li>
      </ul>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
      <p><b>Outlook for the web (On-Prem)</b></p>
      <ul>
        <li>Launch events are not supported by the on-premises APIs; signature selection must be done via the taskpane.</li>
        <li>Images may be replaced with alternate descriptions due to a known bug in the Microsoft office.js framework for on-prem hosts.</li>
      </ul>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
      <p><b>Classic Outlook for Windows</b></p>
      <ul>
        <li>Launch events can be unstable for on-prem mailboxes; use the taskpane if signatures do not appear automatically.</li>
        <li>Exchange Online mailboxes must use a version supporting Nested App Authentication, as legacy EWS tokens are deprecated.</li>
      </ul>
    </div>
  </div>
</div>


<p class="is-italic has-text-centered">
  The <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle</span></a> license funds the open-source mission, ensuring the core engine remains free and peer-reviewable for the global community.
</p>