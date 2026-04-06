---
layout: "page"
lang: "en"
locale: "en"
title: "Architecture, requirements, usage"
subtitle: "How it works, what it needs, and how to use it"
description: "Discover Set-OutlookSignatures technical details: system requirements, supported platforms, template formats, group logic, variables, and simulation mode."
hero_link: /quickstart
hero_link_text: "Quickstart guide"
hero_link_style:
hero_link2: /faq
hero_link2_text: "FAQ"
hero_link2_style:
hero_link3: "/parameters"
hero_link3_text: "Parameters: Full configuration reference"
hero_link3_style:
permalink: "/details"
redirect_from:
  - "/details/"
sitemap_priority: 0.8
sitemap_changefreq: weekly
---
<div class="columns is-multiline">
    <div class="column is-half-desktop is-half-tablet is-full-mobile">
        <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
            <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
                <span>⚙️</span>
                <div>
                    <p><b>IT</b></p>
                    <p class="mb-0"><a href="#architecture-considerations">Architecture considerations</a></p>
                    <p><a href="#requirements-and-usage">Requirements and usage</a></p>
                </div>
            </div>
        </div>
    </div>
    <div class="column is-half-desktop is-half-tablet is-full-mobile">
        <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid LimeGreen;">
            <div style="display: flex; align-items: flex-start; gap: 0.5em;">
                <span>🛡️</span>
                <div>
                    <p><b>Security</b></p>
                    <p><a href="#security-considerations">Security considerations</a></p>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="columns is-multiline">
  <div class="column is-full">
    <div class="box has-background-white-bis has-text-black" style="border-top: 4px solid Blue;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🚀</span>
        <div style="flex: 1;">
          <p><b>Marketing</b></p>
          <div class="columns">
            <div class="column is-half">
                <p class="mb-0"><a href="#signature-and-oof-template-file-format">Signature and OOF template file format</a></p>
                <p class="mb-0"><a href="#replacement-variables">Replacement variables</a></p>
                <p><a href="#ini-files-and-template-tags">Template tags and INI files</a></p>
            </div>
            <div class="column is-half">
                <p class="mb-0"><a href="#ini-files-and-template-tags">Template tags and INI files</a></p>
                <p class="mb-0"><a href="#signature-and-oof-application-order">Signature and OOF application order</a></p>
                <p><a href="#simulation-mode">Simulation mode</a></p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

**Why parameters are in a separate document:** There are many [available parameters](/parameters), default values are chosen wisely, and custom values usually do not change over the years.


## Architecture considerations {#architecture-considerations}
Most companies choose the same default setup:
- **Primary device** (managed): Where users do most daily email work.
- **Secondary devices** (often managed, sometimes unmanaged): Phones, tablets, occasional laptops, VDI sessions, or private devices.

<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>💡</span>
        <div>
          <p><b>Recommended default pattern</b></p>
          <p>Client mode on the primary device keeps signatures and OOF replies up to date without central compute.</p>
          <p>Add the <a href="/outlookaddin">Outlook add-in</a> to make signatures available on secondary devices...</p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🏢</span>
        <div>
          <p><b>When central creation is better</b></p>
          <p>Sometimes you cannot or do not want to run Set-OutlookSignatures in the security context of the logged-on user...</p>
        </div>
      </div>
    </div>
  </div>
</div>

### Step 1: Create signatures and out-of-office replies
Set-OutlookSignatures comes with **client mode**, the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a> adds **SimulateAndDeploy** mode.

<div class="table-container">
  <table class="table  is-hoverable is-fullwidth">
    <thead>
      <tr>
        <th style="width: 15%;"></th>
        <th style="width: 42.5%;">Client mode</th>
        <th style="width: 42.5%;">SimulateAndDeploy</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><strong>Advantages</strong></td>
        <td>Uses idle resources on end user devices (Linux, Windows, macOS). Runs within the security context of the logged-on user. Is typically run more often, usually every two hours or at every log-on.</td>
        <td>Users do not need a primary device that is managed and runs Linux, macOS or Windows. Software or at least configuration must only be deployed to involved central systems.</td>
      </tr>
      <tr>
        <td><strong>Disadvantages</strong></td>
        <td>End users must log on to a device (Linux, Windows, macOS), not just to Outlook. The primary device of each user must be managed and run Windows, Linux or macOS. Software or at least configuration must be deployed to many decentral systems.</td>
        <td>Uses one or more central systems, which need appropriate resources. Runs within the security context of a service account requiring (temporary) full access to all user mailboxes. Is typically run less frequent, usually once a day or less often. Can only see and influence the configuration of Outlook for the web, reducing the feature set to what is possible without local Outlook state.</td>
      </tr>
      <tr>
        <td><strong>Recommended for</strong></td>
        <td>Users logging on to a primary device that is managed and runs Linux, Windows or macOS.</td>
        <td>Scenarios where you cannot or do not want to run Set-OutlookSignatures in the context of the logged-on user (shared devices, Outlook for the web only, mobile-only, unmanaged BYOD, etc.).</td>
      </tr>
    </tbody>
  </table>
</div>

<p>&nbsp;</p>

With the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a>, both modes can set **out-of-office replies** for internal and external recipients and also deploy signatures for mailboxes (and other Exchange recipient objects) the user can act as, even if they are not added as full mailboxes in Outlook (see the [VirtualMailboxConfigFile](/parameters#virtualmailboxconfigfile) parameter for details).

### Step 2: Make signatures available
- **Client mode** automatically updates the local Outlook signature store.
- **SimulateAndDeploy** has no access to end user devices and therefore treats **Outlook for the web** as the “local Outlook”.

With the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a> active, both modes can additionally make signatures available via multiple channels:
- **Outlook for the web:** On-prem supports one signature (new email preferred). Cloud combines with roaming signatures.
- **Roaming Signatures;:** Exchange Online feature; stores multiple signatures in the mailbox.
- **Outlook Add-in:** For Android, iOS, and unmanaged BYOD devices; automatic signature selection based on sender and rules.
- **Draft Email:** Universal compatibility via copy-paste; stores all signatures in HTML and plain text in Drafts.
- **Documents Folder:** Exports signatures to a local path (e.g. OneDrive-synced) for easy access in non-Outlook clients.


## Requirements and usage {#requirements-and-usage}
<div class="columns is-multiline">
  <div class="column is-one-third-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>💻</span>
        <div>
          <p><b>Core requirements</b></p>
          <p><b>Exchange</b>: Exchange Online, Exchange on-premises, or Exchange hybrid</p>
          <p><b>PowerShell</b>: PowerShell 5.1 (<code>powershell.exe</code>) on Windows, or PowerShell 7+ (<code>pwsh.exe</code>) cross-platform</p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-one-third-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>📝</span>
        <div>
          <p><b>Outlook and Word (Windows)</b></p>
          <p>On Windows, Outlook and Word are <i>usually</i> required:</p>
          <ul>
            <li>Outlook/New Outlook/OWA used as mailbox source.</li>
            <li><b>Word 2010+</b> required for <b>DOCX</b> templates or <b>RTF</b> signatures.</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-one-third-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>📄</span>
        <div>
          <p><b>Templates</b></p>
          <p>Supported template formats:</p>
          <ul>
            <li><b>DOCX</b> (Windows)</li>
            <li><b>HTM</b> (Windows, Linux, macOS)</li>
          </ul>
          <p>Set-OutlookSignatures ships with sample templates in both formats.</p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-one-third-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid LimeGreen;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🚀</span>
        <div>
          <p><b>Execution environment</b></p>
          <p>The software must run in <b>PowerShell Full Language mode</b>.</p>
          <p>On Windows and macOS, unblock <code>Set-OutlookSignatures.ps1</code> if needed (<code>Unblock-File</code> or file properties → Unblock).</p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-one-third-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid LimeGreen;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🛡️</span>
        <div>
          <p><b>Endpoint security</b></p>
          <p>If you use application control (AppLocker, Defender, CrowdStrike, …), you may need to trust the existing digital file signature or allow execution/library loading from TEMP locations.</p>
          <p>Set-OutlookSignatures and its components are digitally signed with an <b>EV Code Signing Certificate</b>.</p>
        </div>
      </div>
    </div>
  </div>

  <div class="column is-one-third-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>📂</span>
        <div>
          <p><b>File access</b></p>
          <p>Paths to templates and config must be readable by the logged-in user.</p>
          <p>For SharePoint Online access, register an Entra ID app and grant admin consent (see <a href="/quickstart">Quickstart</a>).</p>
        </div>
      </div>
    </div>
  </div>
</div>

### Linux and macOS
Not all features are yet available or possible on Linux and macOS. Every parameter contains appropriate information; the most important restrictions are summarized here.

<div class="columns is-multiline">
  <div class="column is-full">
    <div class="box has-background-white-bis has-text-black" style="border-top: 4px solid Yellow;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>❗</span>
        <div style="flex: 1;">
          <p><b>Common restrictions and notes for Linux and macOS</b></p>
          <div class="columns">
            <div class="column is-half">
              <ul>
                <li>Only mailboxes hosted in <b>Exchange Online</b> supported reliably.</li>
                <li>Only <b>Graph</b> is supported (<code>GraphOnly</code> is effectively <b>true</b>).</li>
                <li>Templates must be in <b>HTM</b> format (<code>UseHtmTemplates</code> is <b>true</b>).</li>
              </ul>
            </div>
            <div class="column is-half">
              <ul>
                <li>Only existing mount points and SharePoint paths can be accessed.</li>
                <li>Non-Outlook clients supported via <code>AdditionalSignaturePath</code>.</li>
                <li>OWA support requires the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a>.</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>


## Security considerations {#security-considerations}
The security model of Set-OutlookSignatures and the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a> is built on the principles of **Digital Sovereignty**, **Least Privilege**, and **Need to Know**.

- In **client mode for on-premises mailboxes**, no additional permissions or Graph registrations are required.
- In **Exchange Online**, permissions are limited to the required Graph endpoints.

<div class="table-container">
  <table class="table is-hoverable is-fullwidth">
    <thead>
      <tr>
        <th style="width: 25%;">Permission</th>
        <th style="width: 15%;">Client mode</th>
        <th style="width: 15%;">SimulateAndDeploy</th>
        <th style="width: 15%;">Outlook add‑in</th>
        <th>Required for</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td colspan="5"><strong>All environments</strong></td>
      </tr>
      <tr>
        <td>Temporary full access to mailboxes</td>
        <td></td>
        <td>● Required</td>
        <td></td>
        <td>Access to roaming signatures in Exchange Online. Direct-to-mailbox sync on-prem.</td>
      </tr>
      <tr>
        <td>Add-in manifest, <a href="https://learn.microsoft.com/en-us/office/dev/add-ins/outlook/understanding-outlook-add-in-permissions">ReadWriteMailbox</a></td>
        <td></td>
        <td></td>
        <td>● Required</td>
        <td>Set signature.</td>
      </tr>
      <tr>
        <td colspan="5" style="padding-top: 2em !important;"><strong>Cloud only Entra ID app</strong> (creating a separate app for each mode is strongly recommended)</td>
      </tr>
      <tr>
        <td colspan="5"><em>Setup</em></td>
      </tr>
      <tr>
        <td>Manual setup</td>
        <td><a href="https://raw.githubusercontent.com/Set-OutlookSignatures/Set-OutlookSignatures/refs/heads/main/src_Set-OutlookSignatures/config/default%20graph%20config.ps1">Graph config file</a></td>
        <td><a href="https://raw.githubusercontent.com/Set-OutlookSignatures/Set-OutlookSignatures/refs/heads/main/src_Set-OutlookSignatures/sample%20code/SimulateAndDeploy.ps1">SimulateAndDeploy</a></td>
        <td><a href="/outlookaddin#entra-id-app">Outlook add-in</a></td>
        <td></td>
      </tr>
      <tr>
        <td>Scripted setup</td>
        <td><a href="https://raw.githubusercontent.com/Set-OutlookSignatures/Set-OutlookSignatures/refs/heads/main/src_Set-OutlookSignatures/sample%20code/Create-EntraApp.ps1">Create-EntraApp.ps1</a></td>
        <td><a href="https://raw.githubusercontent.com/Set-OutlookSignatures/Set-OutlookSignatures/refs/heads/main/src_Set-OutlookSignatures/sample%20code/Create-EntraApp.ps1">Create-EntraApp.ps1</a></td>
        <td><a href="https://raw.githubusercontent.com/Set-OutlookSignatures/Set-OutlookSignatures/refs/heads/main/src_Set-OutlookSignatures/sample%20code/Create-EntraApp.ps1">Create-EntraApp.ps1</a></td>
        <td></td>
      </tr>
      <tr>
        <td colspan="5" style="padding-top: 2em !important;"><em>Graph API permissions, delegated</em></td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#email">email</a></td>
        <td>● Required</td>
        <td>● Required</td>
        <td></td>
        <td>Log on the current user.</td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#filesreadall">Files.Read.All</a></td>
        <td>○ Optional</td>
        <td>○ Optional</td>
        <td></td>
        <td>Access templates/config stored in SharePoint Online. Alternative: <a href="https://learn.microsoft.com/en-us/graph/permissions-reference#filesselectedoperationsselected">Files.SelectedOperations.Selected</a>.</td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#groupmemberreadall">GroupMember.Read.All</a></td>
        <td>● Required</td>
        <td>● Required</td>
        <td>● Required</td>
        <td>Find groups, get SIDs, and check license groups.</td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#mailread">Mail.Read</a></td>
        <td></td>
        <td></td>
        <td>● Required</td>
        <td>Required because of Microsoft restrictions accessing roaming signatures.</td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#mailreadwrite">Mail.ReadWrite</a></td>
        <td>● Required</td>
        <td>● Required</td>
        <td></td>
        <td>Connect to Outlook for the web. Set Outlook signatures.</td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#mailboxconfigitemreadwrite">MailboxConfigItem.ReadWrite</a></td>
        <td>● Required</td>
        <td>● Required</td>
        <td></td>
        <td>Connect to Outlook for the web. Set Outlook signatures.</td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#mailboxsettingsreadwrite">MailboxSettings.ReadWrite</a></td>
        <td>● Required</td>
        <td>● Required</td>
        <td></td>
        <td>Detect OOF state and set OOF replies.</td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#offline_access">offline_access</a></td>
        <td>● Required</td>
        <td>● Required</td>
        <td></td>
        <td>Get a refresh token from Graph.</td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#openid">openid</a></td>
        <td>● Required</td>
        <td>● Required</td>
        <td></td>
        <td>Log on the current user.</td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#profile">profile</a></td>
        <td>● Required</td>
        <td>● Required</td>
        <td></td>
        <td>Log on the current user and get basic properties.</td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#userreadall">User.Read.All</a></td>
        <td>● Required</td>
        <td>● Required</td>
        <td>● Required</td>
        <td>Get values for replacement variables. UPN lookup.</td>
      </tr>
      <tr>
        <td colspan="5" style="padding-top: 2em !important;"><em>Graph API permissions, application</em></td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#filesreadall">Files.Read.All</a></td>
        <td></td>
        <td>○ Optional</td>
        <td></td>
        <td>Access templates/config stored in SharePoint Online. Alternative: <a href="https://learn.microsoft.com/en-us/graph/permissions-reference#filesselectedoperationsselected">Files.SelectedOperations.Selected</a>.</td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#groupmemberreadall">GroupMember.Read.All</a></td>
        <td></td>
        <td>● Required</td>
        <td></td>
        <td>Find groups, get SIDs, and check license groups.</td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#mailreadwrite">Mail.ReadWrite</a></td>
        <td></td>
        <td>● Required</td>
        <td></td>
        <td>Connect to Outlook for the web. Set Outlook signatures.</td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#mailboxconfigitemreadwrite">MailboxConfigItem.ReadWrite</a></td>
        <td></td>
        <td>● Required</td>
        <td></td>
        <td>Connect to Outlook for the web. Set Outlook signatures.</td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#mailboxsettingsreadwrite">MailboxSettings.ReadWrite</a></td>
        <td></td>
        <td>● Required</td>
        <td></td>
        <td>Detect OOF state and set OOF replies.</td>
      </tr>
      <tr>
        <td><a href="https://learn.microsoft.com/en-us/graph/permissions-reference#userreadall">User.Read.All</a></td>
        <td></td>
        <td>● Required</td>
        <td></td>
        <td>Get values for replacement variables. UPN lookup.</td>
      </tr>
    </tbody>
  </table>
</div>


## Signature and OOF template file format {#signature-and-oof-template-file-format}
Word **DOCX** files or HTML files with extension **.htm**.

The name of the signature template file without extension is the name of the signature in Outlook: The template `Test signature.docx` becomes the signature with the name `Test signature`. This can be overridden in the INI file with `OutlookSignatureName`:
```
[Test signature.htm]
OutlookSignatureName = Test signature, do not use
```

### Proposed template and signature naming convention
A consistent naming convention helps both template maintainers and end users. One popular approach:
- Company
- Internal/External (int/ext)
- Language (two-letter code)
- Formal/Informal (frml/infrml)
- Optional mailbox hint (shared/delegate)

This is a recommendation; choose what fits your organization best.


## Replacement variables {#replacement-variables}
Replacement variables are case-insensitive placeholders in templates that are replaced with user or mailbox values at runtime.
- Replacement happens everywhere, including hyperlinks and image alternative text.
- Variables can come from Active Directory, Entra ID (Graph), or any custom source via script logic.
- Custom variables are supported via a [custom replacement variable config file](/parameters#replacementvariableconfigfile).

Replacement variables do not just provide static text values, they can deliver dynamic content based on freely definable conditions and even influence the design of your signature. Examples are [conditional banners](/faq#how-do-i-alternate-banners-and-other-images-in-signatures), conditional [texts](/faq#how-to-avoid-blank-lines-when-replacement-variables-return-an-empty-string), or account pictures.

Each replacement variable is available in four namespaces:
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full">
    <div class="column">
      <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
        <p><b>Current user</b></p>
        <p>Attributes of the person currently logged into the device.</p>
      </div>
    </div>
    <div class="column">
      <div class="box has-background-white-bis has-text-black" style="height: 100%; border-bottom: 4px solid Blue;">
        <p><b>User's manager</b></p>
        <p>Allows "Assistant to..." or "Escalate to..." dynamic links.</p>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full">
    <div class="column">
      <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
        <p><b>Current mailbox</b></p>
        <p>Attributes of the mailbox (e.g. Shared Mailbox) being processed.</p>
      </div>
    </div>
    <div class="column">
      <div class="box has-background-white-bis has-text-black" style="height: 100%; border-bottom: 4px solid Blue;">
        <p><b>Mailbox manager</b></p>
        <p>Attributes of the manager assigned to the specific mailbox.</p>
      </div>
    </div>
  </div>
</div>

Set-OutlookSignatures comes with a big set of default replacement variables, covering more than most companies ever need for their signatures. Instead of providing a long list here, we provide the `Test all default replacement variables` signature, which not only shows all placeholders but also account pictures, conditional banners, QR codes and more. There are three ways to get there:
- View the template in DOCX format or in HTML format on GitHub or in the `.\sample templates` folder of your download.
- See the final result, i.e. your real values instead of the placeholders, after running the [Quickstart](/quickstart) guide. Just create a new email and select the generated sample signature **“Test all default replacement variables”**.
- Click here to view the <a href="/assets/html/test all default replacement variables.html" target="_blank">"Test all default replacement variables" signature filled with data from our demo environment</a>.

### Photos (account pictures, user image) from Active Directory or Entra ID
The software supports replacing images in signature templates with actual user photos. These photos are per default taken from Entra ID and Active Directory, but you may also definitive alternative sources such as a file share, a SharePoint document library, a database, or a web service.

As with other variables, photos can be obtained from the currently logged-in user, its manager, the currently processed mailbox and its manager.

Set-Outlooksignatures comes with the following default replacement variables for handling account pictures:
- `$CurrentUserPhoto$`  
- `$CurrentUserPhotoDeleteEmpty$`  
- `$CurrentUserManagerPhoto$`  
- `$CurrentUserManagerPhotoDeleteEmpty$`  
- `$CurrentMailboxPhoto$`  
- `$CurrentMailboxPhotoDeleteEmpty$`  
- `$CurrentMailboxManagerPhoto$`  
- `$CurrentMailboxManagerPhotoDeleteEmpty$`  

> Note: Exchange and Outlook do not yet support images in OOF messages.

Adding account pictures is simple:
- When using DOCX template files
  1. Add a shape or a placeholder image.
  2. Set its text wrapping to "inline with text".
  3. Apply Word image features such as sizing, hadow, glow or reflection.
  4. Add one of the account pictures replacement variables, such as `$CurrentUserPhoto$`, to the alternative text of the image or shape.
- Whe using HTML template files
  1. Just add an account picture replacement variable to the the `src` or `alt` property of a placeholder image.

Set-OutlookSignatures take care of replacing the placeholder image or filling the shape with the desired account picture.

If you choose the "DeleteEmpty" option (e.g `$CurrentUserPhotoDeleteEmpty$`), the image or shape is deleted if there is no account picture available.


## INI files and template tags {#ini-files-and-template-tags}
INI files are an easy way to define which templates are to be used for which mailboxes, groups or users.

Template tags define properties for templates, such as:
- Time ranges during which a template shall be applied or not applied
- Groups whose direct or indirect members are allowed or denied application of a template
- Mailbox email addresses which are allowed or denied application of a template
- Replacement-variable conditions that allow or deny application of a template
- Default signature selection for new mails and reply/forward
- OOF template target (internal/external)

> **Why INI (or TOML-style) configuration?**
> We avoid modern formats like <b>XML, YAML, or JSON</b> because they rely on strict syntax (brackets, significant whitespace, commas) that is easily broken by non-IT staff.
> INI-style keeps common cases simple, human-readable, and easy to maintain without specialized database infrastructure.

### Allowed tags (common cases)
The following list focuses on the tags that are used most often.
- **Time range:** `202401010000-202401312359`  
  Use `-:` prefix to deny a time range: `-:202402010000-202402282359`  
  Add `Z` to interpret as UTC: `202401010000Z-202401312359Z`
- **Group assignment:** `<Environment> <Group Name>`  
  Assign a template to mailboxes that are (direct or indirect) members of this group.  
  When using the `-GraphOnly true` parameter, prefer Entra ID groups (`EntraID <Group Name>`), you can also use on-prem groups (`<DNS or NetBIOS name of AD domain> <Group Name>`).   
  Use `-:` prefix to deny a group: `-:<Environment> <Group Name>`
- **Mailbox email address:** `office@example.com`  
  Assign a template to a specific mailbox; use `-:` to deny: `-:test@example.com`
- **Replacement variable condition:** `$SomeVariable$`  
  Apply only when the variable evaluates to true. Use `-:` to deny: `-:$SomeVariable$`
- **Write protect (Windows Classic Outlook only):** `writeProtect`
- **Default signature:** `defaultNew`, `defaultReplyFwd`
- **OOF scope:** `internal`, `external`

For a complete reference and examples based on real-world use cases, see the INI files in the [`sample templates`](https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/tree/main/src_Set-OutlookSignatures/sample%20templates) folder.

> Note: Tags are case-insensitive.

### How to work with INI files
1. **Comments:** lines starting with `#` or `;`
2. Use the sample INI files shipped with Set-OutlookSignatures as a starting point (see [`sample templates`](https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/tree/main/src_Set-OutlookSignatures/sample%20templates) folder)
3. Put file names (with extension) in square brackets:
    ```
    [Company external English formal.docx]
    defaultNew
    ```
4. One tag per line below the file section header.
5. When using INI files, tags in filenames are treated as part of the name, not as tags.
6. Use parameters to point to the INI file:
   - [SignatureIniFile](/parameters#signatureinifile)
   - [OOFIniFile](/parameters#oofinifile)


## Signature and OOF application order {#signature-and-oof-application-order}
Set-OutlookSignatures knows which mailboxes a user added to Outlook, and in which order they are sorted. Signatures are applied mailbox by mailbox in this order.

<div class="columns is-multiline">
  <div class="column is-half">
    <div class="box has-background-white-bis has-text-black">
      <p class="mb-4"><b>Mailbox priority</b></p>
      <ol>
        <li>Primary logged-in user mailbox</li>
        <li>Default Outlook profile mailboxes</li>
        <li>Other Outlook profiles (alphabetical)</li>
      </ol>
    </div>
  </div>
  <div class="column is-half">
    <div class="box has-background-white-bis has-text-black">
      <p class="mb-4"><b>Template priority</b></p>
      <ol>
        <li>Common templates</li>
        <li>Group templates</li>
        <li>Email-address templates</li>
        <li>Variable-condition templates</li>
      </ol>
    </div>
  </div>
</div>

Within each group, templates are sorted by `SortOrder` and `SortCulture` (if defined in the INI file).

**Important consequence:** A template is applied only to the mailbox with the highest priority allowed to use it, so lower-priority mailboxes do not overwrite signatures intended for higher-priority ones.

You can influence behavior with the [MailboxSpecificSignatureNames](/parameters#mailboxspecificsignaturenames) parameter and with the `OutlookSignatureName` tag in the INI file.

OOF templates are applied only if the out-of-office assistant is currently disabled. If it is active or scheduled, OOF templates are not applied.


## Simulation mode {#simulation-mode}
Simulation mode is enabled when the parameter `SimulateUser` is passed.
It answers the question:
> “What will the signatures look like for user A, when Outlook is configured for the mailboxes X, Y and Z?”

In simulation mode:
- Outlook registry entries are not considered
- Nothing is changed in Outlook or Outlook for the web
- Resulting signatures are written to the path defined by `AdditionalSignaturePath`

Minimal example:
```
& .\Set-OutlookSignatures.ps1 -SimulateUser "a@example.com" -SimulateMailboxes "a@example.com", "x@example.com" -AdditionalSignaturePath "c:\test"
```

`SimulateMailboxes` is optional but highly recommended.<br>`SimulateTime` can be used to test time-based templates.<br>See `.\sample code\SimulationModeHelper.ps1` for helper logic.