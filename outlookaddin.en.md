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
hero_link3: "#deployment-to-mailboxes"
hero_link3_text: "<span><b>Deployment: </b>Rollout options</span>"
hide_gh_sponsor: true
permalink: "/outlookaddin"
redirect_from:
  - "/outlookaddin/"
sitemap_priority: 0.8
sitemap_changefreq: weekly
---
<h2 id="overview">Overview</h2>
<p>With a <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle license</span></a>, you gain access to the Set-OutlookSignatures add-in.</p>

<div class="columns">
  <div class="column">
    <p>The add-in makes signatures available in <strong>Outlook for iOS and Android</strong>, while supporting all Outlook editions across platforms. It's an ideal solution for Outlook editions that don't yet support roaming signatures and is particularly helpful in unmanaged BYOD scenarios.</p>
    <p>It intelligently selects the appropriate signature based on the sender address, the type of item (new email, reply, or appointment), and any custom rules you define.</p>
  </div>
  <div class="column">
    <div class="box has-background-white-bis" style="border-top: 4px solid var(--benefactor-circle-color);">
      <p><b>Key Functionality</b></p>
      <ul>
        <li><strong>Automatic Selection:</strong> Applies correct sigs on item creation.</li>
        <li><strong>Taskpane Preview:</strong> Users can manually select or preview.</li>
        <li><strong>On-Prem Roaming:</strong> Cloud-like experience for on-prem mailboxes.</li>
      </ul>
    </div>
  </div>
</div>
<div class="columns mt-5">
  <div class="column">
    <p>🛡️ <b>Privacy First</b><br><small>No middleware or proxy servers. Local execution.</small></p>
  </div>
  <div class="column">
    <p>⚙️ <b>Full Control</b><br><small>You control the version and configuration.</small></p>
  </div>
  <div class="column">
    <p>💎 <b>Low Cost</b><br><small>Self-hosting keeps license costs minimal.</small></p>
  </div>
  <div class="column">
    <p>🚀 <b>Enterprise Ready</b><br><small>Exchange Online and On-Premises support.</small></p>
  </div>
</div>
<hr>


<h2 id="usage">Usage</h2>
<p>From an end user perspective, basically nothing needs to be done or configured: When writing a new email, answering an email, or creating a new appointment, the add-in automatically adds the corresponding default signature.</p>
<p>For advanced usage and debug logging, a taskpane is available in all Outlook versions supporting this feature.</p>
<p>In compose mode, the taskpane allows to manually choose a signature, set the selected signature, and to temporarily override admin-defined settings for debug logging and Outlook host restrictions.</p>
<p>In message read mode, the taskpane cannot set signatures, of course. But it is very useful to check if the add-in is deployed correctly, and if it can access signatures. This is especially useful on mobile devices, in situations where enabling the debug mode is not wanted, and for basic tests when launch events are not triggered by Outlook.</p>
<div class="columns is-multiline">
  <div class="column is-6-desktop is-12-tablet">
    <div class="box has-background-white-bis has-text-black" style="height: 100%;">
      <p><b>Outlook for the web (Exchange Online), New Outlook for Windows, New Outlook for Mac</b></p>
      <ul>
        <li>New mail, reply mail, read mail: "Message" tab, "Apps" icon</li>
        <li>New appointment: Ribbon, "…" menu</li>
      </ul>
    </div>
  </div>
  <div class="column is-6-desktop is-12-tablet">
    <div class="box has-background-white-bis has-text-black" style="height: 100%;">
      <p><b>Outlook for the web (on-prem)</b></p>
      <ul>
        <li>New mail, reply mail: Lower right corner of the compose window</li>
        <li>New appointment: At the right of the menu bar at the top of the compose window</li>
        <li>Read mail: Left to the reply button</li>
      </ul>
    </div>
  </div>
  <div class="column is-6-desktop is-12-tablet">
    <div class="box has-background-white-bis has-text-black" style="height: 100%;">
      <p><b>Classic Outlook for Windows, Classic Outlook for Mac</b></p>
      <ul>
        <li>New mail, reply mail, read mail: "Message" tab, "All apps" icon</li>
        <li>New appointment: "Appointment" or "Meeting" tab, "All apps" icon</li>
      </ul>
    </div>
  </div>
  <div class="column is-6-desktop is-12-tablet">
    <div class="box has-background-white-bis has-text-black" style="height: 100%;">
      <p><b>Outlook for iOS, Outlook for Android</b></p>
      <ul>
        <li>These platforms do not support taskpanes for new mails, reply mails and appointments.</li>
        <li>Read mail: Three dots ("…" or "⋮") in the email header</li>
      </ul>
    </div>
  </div>
</div>


<h2 id="requirements">Requirements</h2>
<h3>Outlook clients</h3>
<p>The Outlook add-in works for all Outlook clients that are supported by Microsoft. See the <a href="#remarks">Remarks</a> chapter in this section for possible limitations that may apply due to platform specific Microsoft restrictions.</p>
<p>The add-in always runs in the context of the user that is used by Outlook to access a mailbox. Delegate scenarios are supported. This means the following:</p>
<ul>
  <li>User A has the Outlook add-in installed. The Outlook add-in can access all signature information that the Benefactor Circle add-on or the SimulateAndDeploy mode of Set-OutlookSignatures has written to the mailbox of user A. The add-in can be used in the mailbox of user A and in all other mailboxes that user A accesses with his own credentials.</li>
  <li>When user A has added a mailbox with separate credentials, such as adding shared mailbox B using shared mailbox B's credentials, the add-in installed in user A's mailbox will not work for shared mailbox B. Shared mailbox B needs to have the add-in installed, too, and the add-in only has access to signature information that the Benefactor Circle add-on or the SimulateAndDeploy mode of Set-OutlookSignatures has written to the shared mailbox B. For shared mailbox B, delegate scenarios are supported, too.</li>
</ul>

<h3>Web server and domain</h3>
<p>Whatever web server you choose, the requirements are low:</p>
<ul>
  <li>Reachable from mobile devices via the public internet.</li>
  <li>Use a dedicated host name ("https://outlookaddin01.example.com"), do not use subdirectories ("https://addins.example.com/outlook01").</li>
  <li>A valid TLS certificate.<br>Self-signed certificates can be used for development and testing, as long as the certificate is trusted by the client used for testing.<br>Certificates from <a href="https://letsencrypt.org/">Let's Encrypt</a> are a good free alternative, especially when used together with an <a href="https://letsencrypt.org/docs/client-options/">ACME client</a> auto-renewing them.</li>
  <li>In production, the server hosting the images shouldn't return a Cache-Control header specifying no-cache, no-store, or similar options in the HTTP response.</li>
</ul>
<p><a href="https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website">Static website hosting in Azure Storage</a> is an uncomplicated, affordable and fast alternative. It comes with a *.web.core.windows.net hostname and a Microsoft-issued certificate, even in the free tier.</p>
<p>We recommend to use use two separate dedicated hostnames, such as "https://outlookaddin01.example.com" and "https://outlookaddin01test.example.com". This way, you can use one for testing and one for production. For tests, sideloading is the preferred method, while Microsoft 365 Centralized Deployment or Integrated Apps are ideal for mass deployment.</p>

<h3>Set-OutlookSignatures</h3>
<p>The Outlook add-in can add existing signatures, but is not able to create them itself on the fly. The Benefactor Circle add-on prepares signature data in a way that it can be used by the Outlook add-in.</p>

<h3>Entra ID app</h3>
<p>When mailboxes are hosted in Exchange Online, the Outlook add-in needs an Entra ID app to access the mailbox.</p>
<p>Creating a separate Entra ID app for the Outlook add-in is strongly recommended over modifying an existing app.</p>
<p>You can run the following command to automatically create the Entra ID app. You need an Entra ID account with "Application Administrator" or "Global Administrator" permissions.</p>
<div class="terminal-ui mt-2 mb-4" style="background: #2d3436; border-radius: 6px; padding: 1.5rem; position: relative; box-shadow: 0 4px 6px rgba(0,0,0,0.3);">
  <div style="position: absolute; top: 10px; left: 15px; display: flex; gap: 6px;">
    <span style="width: 10px; height: 10px; background: #ff5f56; border-radius: 50%;"></span>
    <span style="width: 10px; height: 10px; background: #ffbd2e; border-radius: 50%;"></span>
    <span style="width: 10px; height: 10px; background: #27c93f; border-radius: 50%;"></span>
  </div>
  <pre style="background: transparent; padding: 0; color: white; white-space: pre-wrap; word-break: keep-all; overflow-wrap: anywhere; margin-top: 0.5rem;"><code style="color: white !important;">powershell.exe -noexit -file "c:\test\sample code\Create-EntraApp.ps1" -AppType "OutlookAddIn" -AppName "Set-OutlookSignatures Outlook add-in" -OutlookAddInUrl "https://yourhost.yourdomain.com"</code></pre>
</div>
<p><small><em>For national or sovereign clouds, add the <a href="/parameters#cloudenvironment"><code>-CloudEnvironment</code></a> parameter.</em></small></p>
<p>If you want to create the Entra ID app manually, the required minimum settings for the Entra ID app are:</p>
<ul>
  <li>A name of your choice.</li>
  <li>A supported account type (it is strongly recommended to only allow access from users of your tenant).</li>
  <li>Authentication platform <code>Single-page application</code> with a redirect URI of <code>brk-multihub://&lt;your_deployment_domain&gt;</code>. If your DEPLOYMENT_URL is <code>https://outlookaddin01.example.com</code>, the redirect URI must be <code>brk-multihub://outlookaddin01.example.com</code>.</li>
  <li>Access to the following delegated (not application!) <code>Graph API</code> permissions:
    <ul>
      <li>Mail.Read: Allows to read emails in mailbox of the currently logged-on user (and in no other mailboxes). Required because of Microsoft restrictions accessing roaming signatures.</li>
      <li>GroupMember.Read.All: Allows the app to list groups, read basic group properties and read membership of all groups the signed-in user has access to. Required to find and check license groups.</li>
      <li>User.Read.All: Allows the app to read the full set of profile properties, reports, and managers of other users in your organization, on behalf of the signed-in user. Required to get the UPN for a given SMTP email address.</li>
    </ul>
  </li>
  <li>Grant admin consent for all permissions</li>
</ul>



<h2 id="configuration-and-deployment-to-the-web-server">Configuration and deployment to the web server</h2>
<p>With every new release of Set-OutlookSignatures, <a href="/benefactorcircle">Benefactor Circle</a> members not only receive an updated Benefactor Circle license file, but also an updated Outlook add-in.</p>
<p>With every new release of the Outlook add-in, you need to update your add-in deployment (sideloading M365 Centralized Deployment, M365 Integrated Apps) so that Outlook can download and use the newest code.</p>
<p>It is recommended to use use two separate dedicated hostnames at least: One for testing and one for production, such as "https://outlookaddin01.example.com" and "https://outlookaddin01test.example.com".</p>
<p>You can also have multiple different instances of the Outlook add-in in production, for example when you want to configure the add-in differently depending on how different user groups work with email - see the <a href="/details#architecture-considerations">Architecture considerations</a> chapter of the "Technical details, requirements and usage" document for an example. Each instance needs a dedicated hostname. Make sure that each mailbox only uses one instance of the add-in, never more.</p>
<p>To configure the add-in and deploy it to your web server:</p>
<ul>
  <li>Open <code>run_before_deployment.ps1</code> and follow the instructions in it to configure the add-in to your needs.</li>
  <li>You can configure the following settings:
    <ul>
      <li>The version number. Outlook add-ins have four version number parts. The first three parts match the version number of Set-OutlookSignatures, the last part is up to you.</li>
      <li>The URL you deploy the add-in to.</li>
      <li>On which Outlook hosts and platforms signatures shall be added automatically for new emails and email replies.</li>
      <li>On which Outlook hosts and platforms signatures shall be added automatically for new appointments.</li>
      <li>If you want or do not want to disable client signatures configured by your users.</li>
      <li>Your cloud environment and the application (client) ID of the Entra ID app (required for Exchange Online mailboxes only).</li>
      <li>Enable or disable debug logging.</li>
      <li>Add custom code to the add-in so you can directly influence which signature it will set. For example, you can set a specific signature…
        <ul>
          <li>…when there are only internal recipients, or another signature when there are external recipients</li>
          <li>…depending on the from email address</li>
          <li>…when a specific customer is in the To field</li>
          <li>…when the current item is a mail or an appointment</li>
          <li>…when the current item is a new mail, or another signature when it is a reply or a forward</li>
          <li>…depending on the subject</li>
          <li>…or any other condition derived from the information available in the customRulesProperties object</li>
        </ul>
        <p>You can even create your own signature at runtime, without choosing one previously deployed with Set-OutlookSignatures.</p>
        <p>See <code>.\sample code\CustomRulesCode.js</code> in the Outlook add-in folder for details.</p>
      </li>
    </ul>
  </li>
  <li>Run <code>run_before_deployment.ps1</code> in PowerShell.</li>
  <li>Upload the content of the <code>publish</code> folder to your web server.</li>
</ul>
<p>When the <code>manifest.xml</code> file, the configuration or another part of the Outlook add-in changes, you not only need to update the files on the web server, you also need to tell your mailboxes that an updated version or configuration is available and must be downloaded from the web server. The "<a href="#deployment-to-mailboxes">Deployment to mailboxes</a>" chapter describes the available deployment options for add-ins.</p>



<h2 id="deployment-to-mailboxes">Deployment to mailboxes</h2>
<p>When the <code>manifest.xml</code> file, the configuration or another part of the Outlook add-in changes, you need to tell your mailboxes that an updated version or configuration is available and must be downloaded. Due to caching mechanisms, especially in Classic Outlook for Windows, this does not happen automatically.</p>
<p>This is required when:</p>
<ul>
  <li>A new release of the Outlook add-in is published by <a href="https://explicitconsulting.at">ExplicIT Consulting</a>.</li>
  <li>You change a configuration option in the <code>run_before_deployment.ps1</code> file which is marked to require an updated deployment.</li>
  <li>You modify the <code>manifest.xml</code> file manually.</li>
</ul>
<p>You can choose from three different ways to deploy the Outlook add-in to your mailboxes. For tests, sideloading is the preferred method, while Microsoft 365 Centralized Deployment or Integrated Apps are ideal for mass deployment.</p>

<h3>Individual installation through users</h3>
<p>This method is also called sideloading. It is ideal for test scenarios.</p>
<p>For mailboxes in Exchange Online:</p>
<ul>
  <li>Open <code>https://outlook.cloud.microsoft/mail/inclientstore</code>.</li>
  <li>Click on <code>My add-ins</code>.</li>
  <li>Below <code>Custom Addins</code>, click on <code>Add a custom add-in</code> and on <code>Add from file</code>.</li>
  <li>In the file selection dialog, enter the manifest.xml file URL as file name and click on <code>Open</code>.</li>
  <li>Click on <code>Install</code>.</li>
  <li>Refresh the browser window.</li>
</ul>
<p>For mailboxes hosted on-prem:</p>
<ul>
  <li>Open <code>https://YourMailServer.example.com/owa/#path=/options/manageapps</code>.</li>
  <li>Click on the plus sign to add an add-in, and choose <code>Add from file</code>.</li>
  <li>In the file selection dialog, enter the manifest.xml file URL as file name and click on <code>Open</code>.</li>
  <li>Click on </code>Install</code>.</li>
  <li>Refresh the browser window.</li>
</ul>
<p>Sideloading of add-ins may have been disabled by your administrators. Do not use the URLs mentioned above to remove custom add-ins, as this fails most times. Instead, use one of the following options:</p>
<ul>
  <li>Open Outlook for the web, draft a new mail, click on the <code>Apps</code> button, right-click the Set-OutlookSignatures add-in and select <code>Uninstall</code>.</li>
  <li>Remove the custom add-in in Outlook for Android or Outlook for iOS.</li>
</ul>

<h3>Microsoft 365 Centralized Deployment or Integrated Apps</h3>
<p>Microsoft 365 Centralized Deployment and deployment via Integrated Apps both provide the following benefits:</p>
<ul>
  <li>An admin can deploy and assign an Outlook add-in directly to a mailbox, to multiple mailboxes via a group, or to ever mailbox in the organization.</li>
  <li>When Outlook starts, it automatically downloads the assigned add-in. If the add-in supports it, it appears in Outlooks ribbon.</li>
  <li>An add-in is automatically removed from a mailbox when an admin disables or deletes the add-in assignment, or if the mailbox is removed from a group that the add-in is assigned to.</li>
</ul>
<p>Both methods are ideal for mass deployment in production environments. They are usually too slow (up to 72 hours) for test scenarios.</p>
<p>If the Integrated Apps feature is not yet available in your sovereign and government cloud tenant, you have to use Centralized Deployment instead. See the following links for instructions:</p>
<ul>
  <li><a href="https://learn.microsoft.com/en-us/microsoft-365/admin/manage/test-and-deploy-microsoft-365-apps?view=o365-worldwide">Integrated Apps</a></li>
  <li><a href="https://learn.microsoft.com/en-us/microsoft-365/admin/manage/centralized-deployment-of-add-ins?view=o365-worldwide">Microsoft 365 Centralized Deployment</a></li>
</ul>

<h3>Clear the Outlook add-in cache</h3>
<p>When testing add-ins, especially when using the sideloading method, Outlook sometimes messes up its cache or takes too long updating it. To avoid problems, it is a good idea to manually clear the add-in cache in test scenarios.</p>
<ul>
  <li><strong>Outlook for the web:</strong> Hard Refresh the website.</li>
  <li><strong>Classic Outlook for Windows:</strong> Close Outlook, then follow the <a href="https://learn.microsoft.com/en-us/office/dev/add-ins/testing/clear-cache#classic-outlook-on-windows">official instructions from Microsoft</a>. Note: launch events may not trigger until a restart even if the taskpane works.</li>
  <li><strong>New Outlook for Windows:</strong> Close Outlook, then follow the <a href="https://learn.microsoft.com/en-us/office/dev/add-ins/testing/clear-cache#new-outlook-on-windows">official instructions from Microsoft</a>.</li>
  <li><strong>Outlook for macOS:</strong> Close Outlook, then follow the <a href="https://learn.microsoft.com/en-us/office/dev/add-ins/testing/clear-cache#clear-the-office-cache-on-mac">official instructions from Microsoft</a>.</li>
  <li><strong>Outlook for iOS:</strong> Open the taskpane of the Outlook add-in, scroll down to "Advanced options" and tap the "Reload add-in" button.</li>
  <li><strong>Outlook for Android:</strong> Long-press the icon > App info > Force Stop > Storage and Cache > Clear Cache (do not tap Clear Data).</li>
</ul>



<h2 id="remarks">Remarks</h2>
<h3>General</h3>
<ul>
  <li>Microsoft is actively blocking access to roaming signatures for Outlook add-ins. The add-in will be updated when this block has been removed. In the meantime, the add-in has access to the data of the last run of Set-OutlookSignatures v4.14.0 and higher.</li>
  <li>The Microsoft APIs only allow access to online content. There is no way to access offline mailbox content or the file system. This means that the Outlook add-in only works when Outlook has an online connection to the user's mailbox.</li>
  <li>The easiest way to test the add-in and its basic functionality is to use the taskpane. For specific debugging on Android and iOS, you need to use the DEBUG option in <code>run_before_deployment.ps1</code>.</li>
  <li>The add-in can run automatically when one of the following launch events is triggered by Outlook: <code>OnNewMessageCompose</code>, <code>OnNewAppointmentOrganizer</code>, <code>OnMessageFromChanged</code>, <code>OnAppointmentFromChanged</code>, <code>OnMessageRecipientsChanged</code>, <code>OnAppointmentAttendeesChanged</code>.
    <ul>
      <li>Not all these events are supported on all platforms, see <a href="https://learn.microsoft.com/en-us/office/dev/add-ins/outlook/autolaunch#supported-events">this Microsoft article</a>.</li>
      <li>Outlook currently does not support add-ins on calendar invite responses.</li>
    </ul>
  </li>
  <li>Microsoft dynamically updates the local copy of the office.js framework. This may lead to problems that suddenly appear although neither Outlook nor the add-in have changed. Where available, use the taskpane as a workaround.</li>
</ul>
<div class="columns is-multiline">
  <div class="column is-half">
    <div class="box has-background-white-bis has-text-black" style="height: 100%;">
      <p><b>Outlook for Android</b></p>
      <ul>
        <li>Only mailboxes hosted in Exchange Online are supported.</li>
        <li>Setting the signature on new appointments is not yet supported by Microsoft.</li>
        <li>Taskpanes are not allowed during compose mode.</li>
      </ul>
    </div>
  </div>
  <div class="column is-half">
    <div class="box has-background-white-bis has-text-black" style="height: 100%;">
      <p><b>Outlook for iOS</b></p>
      <ul>
        <li>Only mailboxes hosted in Exchange Online are supported.</li>
        <li>Setting the signature on new appointments is not yet supported by Microsoft.</li>
        <li>Taskpanes are not allowed during compose mode.</li>
      </ul>
    </div>
  </div>
  <div class="column is-half">
    <div class="box has-background-white-bis has-text-black" style="height: 100%;">
      <p><b>Outlook for Mac</b></p>
      <ul>
        <li>Use the New Outlook for Mac whenever possible; Classic Outlook for Mac is out of support.</li>
        <li>Support for Classic Outlook for Mac is best-effort due to API instability.</li>
      </ul>
    </div>
  </div>
  <div class="column is-half">
    <div class="box has-background-white-bis has-text-black" style="height: 100%;">
      <p><b>Outlook for the web on-prem</b></p>
      <ul>
        <li>Launch events are not supported; only the taskpane works.</li>
        <li>Images are replaced with alternate descriptions due to a Microsoft office.js bug.</li>
      </ul>
    </div>
  </div>
</div>
<div class="box has-background-white-bis has-text-black" style="height: 100%;">
  <p><b>Classic Outlook for Windows</b></p>
  <ul>
    <li>Launch event APIs are sometimes unstable for on-prem mailboxes. Use the taskpane when in doubt.</li>
    <li>For mailboxes in Exchange Online, the Outlook version version used must support Nested App Authentication. Microsoft disabled legacy EWS Exchange Online tokens; they cannot be re-enabled since October 2025 due to security reasons.</li>
  </ul>
</div>

<p class="is-italic has-text-centered">
  The <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle</span></a> license funds the open-source mission, ensuring the core engine remains free and peer-reviewable for the global community.
</p>