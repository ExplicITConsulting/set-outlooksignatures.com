---
layout: "page"
lang: "en"
locale: "en"
title: "Technical details, requirements and usage"
subtitle: "What it needs, how it works and how to use it"
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
    <div class="column is-one-third-desktop is-half-tablet is-full-mobile">
        <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
            <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
                <span>⚙️</span>
                <div>
                    <p class="mb-4"><b>IT</b></p>
                    <ul>
                        <li class="mb-2"><a href="#architecture-considerations">Architecture considerations</a></li>
                        <li class="mb-2"><a href="#requirements-and-usage">Requirements and usage</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="column is-one-third-desktop is-half-tablet is-full-mobile">
        <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid LimeGreen;">
            <div style="display: flex; align-items: flex-start; gap: 0.75em;">
                <span>🛡️</span>
                <div>
                    <p class="mb-4"><b>Security</b></p>
                    <ul>
                        <li class="mb-0"><a href="#security-considerations">Security considerations</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="column is-one-third-desktop is-half-tablet is-full-mobile">
        <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
            <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
                <span>🚀</span>
                <div>
                    <p class="mb-4"><b>Marketing & Usage</b></p>
                    <ul>
                        <li class="mb-2"><a href="#signature-and-oof-template-file-format">Signature and OOF template file format</a></li>
                        <li class="mb-2"><a href="#replacement-variables">Replacement variables</a></li>
                        <li class="mb-2"><a href="#ini-files-and-template-tags">Template tags and INI files</a></li>
                        <li class="mb-2"><a href="#signature-and-oof-application-order">Signature and OOF application order</a></li>
                        <li class="mb-2"><a href="#simulation-mode">Simulation mode</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

**Why parameters are in a separate document:** There are many parameters, default values are chosen wisely, and custom values usually do not change over the years. See [Parameters](/parameters) for details.


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

| | Client mode | SimulateAndDeploy |
|---|---|---|
| **Advantages** | Uses idle resources on end user devices (Linux, Windows, macOS). Runs within the security context of the logged-on user. Is typically run more often, usually every two hours or at every log-on. | Users do not need a primary device that is managed and runs Linux, macOS or Windows. Software or at least configuration must only be deployed to involved central systems. |
| **Disadvantages** | End users must log on to a device (Linux, Windows, macOS), not just to Outlook. The primary device of each user must be managed and run Windows, Linux or macOS. Software or at least configuration must be deployed to many decentral systems. | Uses one or more central systems, which need appropriate resources. Runs within the security context of a service account requiring (temporary) full access to all user mailboxes. Is typically run less frequent, usually once a day or less often. Can only see and influence the configuration of Outlook for the web, reducing the feature set to what is possible without local Outlook state. |
| **Recommended for** | Users logging on to a primary device that is managed and runs Linux, Windows or macOS. | Scenarios where you cannot or do not want to run Set-OutlookSignatures in the context of the logged-on user (shared devices, Outlook for the web only, mobile-only, unmanaged BYOD, etc.). |

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
          <p class="mb-4"><b>Core requirements</b></p>
          <ul>
            <li><b>Exchange</b>: Exchange Online, Exchange on-premises, or Exchange hybrid</li>
            <li><b>PowerShell</b>
              <ul>
                <li>Windows: Windows PowerShell 5.1 (<code>powershell.exe</code>) or PowerShell 7+ (<code>pwsh.exe</code>)</li>
                <li>Linux/macOS: PowerShell 7+ (<code>pwsh</code>)</li>
              </ul>
            </li>
          </ul>
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
          <p class="mb-4"><b>Execution environment</b></p>
          <ul>
            <li>The software must run in <b>PowerShell Full Language mode</b>.</li>
            <li>On Windows and macOS, unblock <code>Set-OutlookSignatures.ps1</code> if needed (<code>Unblock-File</code> or file properties → Unblock).</li>
          </ul>
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
          <p class="mb-4"><b>File access</b></p>
          <ul>
            <li>Paths to templates and config must be readable by the logged-in user.</li>
            <li>For SharePoint Online access, register an Entra ID app and grant admin consent (see <a href="/quickstart">Quickstart</a>).</li>
          </ul>
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
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.75em;">
        <span style="font-size: 1.5rem;">❗</span>
        <div>
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

| Permission | Client mode | SimulateAndDeploy | Outlook add‑in | Required for |
| :--- | :--- | :--- | :--- | :--- |
| Setup instructions | Manual setup: [`.\config\default graph config.ps1`](https://raw.githubusercontent.com/Set-OutlookSignatures/Set-OutlookSignatures/refs/heads/main/src_Set-OutlookSignatures/config/default%20graph%20config.ps1)<br/>Scripted setup: [`.\sample code\Create-EntraApp.ps1`](https://raw.githubusercontent.com/Set-OutlookSignatures/Set-OutlookSignatures/refs/heads/main/src_Set-OutlookSignatures/sample%20code/Create-EntraApp.ps1) | Manual setup: [`.\sample code\SimulateAndDeploy.ps1`](https://raw.githubusercontent.com/Set-OutlookSignatures/Set-OutlookSignatures/refs/heads/main/src_Set-OutlookSignatures/sample%20code/SimulateAndDeploy.ps1)<br/>Scripted setup: [`.\sample code\Create-EntraApp.ps1`](https://raw.githubusercontent.com/Set-OutlookSignatures/Set-OutlookSignatures/refs/heads/main/src_Set-OutlookSignatures/sample%20code/Create-EntraApp.ps1) | Manual setup: [Outlook add-in](/outlookaddin#entra-id-app)<br/>Scripted setup: [`.\sample code\Create-EntraApp.ps1`](https://raw.githubusercontent.com/Set-OutlookSignatures/Set-OutlookSignatures/refs/heads/main/src_Set-OutlookSignatures/sample%20code/Create-EntraApp.ps1) | |
| **All environments:** Temporary full access to mailboxes | | ● Required | | Access to roaming signatures in Exchange Online. Direct-to-mailbox sync on-prem. |
| **All environments:** Outlook add-in manifest, [ReadWriteMailbox](https://learn.microsoft.com/en-us/office/dev/add-ins/outlook/understanding-outlook-add-in-permissions) | | | ● Required | Set signature. |
| **Cloud Only:** Graph API, delegated, [email](https://learn.microsoft.com/en-us/graph/permissions-reference#email) | ● Required | ● Required | | Log on the current user. |
| **Cloud Only:** Graph API, delegated, [Files.Read.All](https://learn.microsoft.com/en-us/graph/permissions-reference#filesreadall) | ○ Optional | ○ Optional | | Access templates/config stored in SharePoint Online. Alternative: [Files.SelectedOperations.Selected](https://learn.microsoft.com/en-us/graph/permissions-reference#filesselectedoperationsselected). |
| **Cloud Only:** Graph API, delegated, [GroupMember.Read.All](https://learn.microsoft.com/en-us/graph/permissions-reference#groupmemberreadall) | ● Required | ● Required | ● Required | Find groups, get SIDs, and check license groups. |
| **Cloud Only:** Graph API, delegated, [Mail.Read](https://learn.microsoft.com/en-us/graph/permissions-reference#mailread) | | | ● Required | Required because of Microsoft restrictions accessing roaming signatures. |
| **Cloud Only:** Graph API, delegated, [Mail.ReadWrite](https://learn.microsoft.com/en-us/graph/permissions-reference#mailreadwrite) | ● Required | ● Required | | Connect to Outlook for the web. Set Outlook signatures. |
| **Cloud Only:** Graph API, delegated, [MailboxConfigItem.ReadWrite](https://learn.microsoft.com/en-us/graph/permissions-reference#mailboxconfigitemreadwrite) | ● Required | ● Required | | Connect to Outlook for the web. Set Outlook signatures. |
| **Cloud Only:** Graph API, delegated, [MailboxSettings.ReadWrite](https://learn.microsoft.com/en-us/graph/permissions-reference#mailboxsettingsreadwrite) | ● Required | ● Required | | Detect OOF state and set OOF replies. |
| **Cloud Only:** Graph API, delegated, [offline_access](https://learn.microsoft.com/en-us/graph/permissions-reference#offline_access) | ● Required | ● Required | | Get a refresh token from Graph. |
| **Cloud Only:** Graph API, delegated, [openid](https://learn.microsoft.com/en-us/graph/permissions-reference#openid) | ● Required | ● Required | | Log on the current user. |
| **Cloud Only:** Graph API, delegated, https://learn.microsoft.com/en-us/graph/permissions-reference#profile | ● Required | ● Required | | Log on the current user and get basic properties. |
| **Cloud Only:** Graph API, delegated, [User.Read.All](https://learn.microsoft.com/en-us/graph/permissions-reference#userreadall) | ● Required | ● Required | ● Required | Get values for replacement variables. UPN lookup. |
| **Cloud Only:** Graph API, application, [Files.Read.All](https://learn.microsoft.com/en-us/graph/permissions-reference#filesreadall) | | ○ Optional | | Access templates/config stored in SharePoint Online. Alternative: [Files.SelectedOperations.Selected](https://learn.microsoft.com/en-us/graph/permissions-reference#filesselectedoperationsselected). |
| **Cloud Only:** Graph API, application, [GroupMember.Read.All](https://learn.microsoft.com/en-us/graph/permissions-reference#groupmemberreadall) | | ● Required | | Find groups, get SIDs, and check license groups. |
| **Cloud Only:** Graph API, application, [Mail.ReadWrite](https://learn.microsoft.com/en-us/graph/permissions-reference#mailreadwrite) | | ● Required | | Connect to Outlook for the web. Set Outlook signatures. |
| **Cloud Only:** Graph API, application, [MailboxConfigItem.ReadWrite](https://learn.microsoft.com/en-us/graph/permissions-reference#mailboxconfigitemreadwrite) | | ● Required | | Connect to Outlook for the web. Set Outlook signatures. |
| **Cloud Only:** Graph API, application, [MailboxSettings.ReadWrite](https://learn.microsoft.com/en-us/graph/permissions-reference#mailboxsettingsreadwrite) | | ● Required | | Detect OOF state and set OOF replies. |
| **Cloud Only:** Graph API, application, [User.Read.All](https://learn.microsoft.com/en-us/graph/permissions-reference#userreadall) | | ● Required | | Get values for replacement variables. UPN lookup. |


## Signature and OOF template file format {#signature-and-off-template-file-format}
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
  <div class="column is-quarter-desktop is-half-tablet">
    <div class="box has-background-white-bis" style="height: 100%; border-left: 4px solid Blue;">
      <p><b>Current User</b></p>
      <p class="is-size-7">Attributes of the person currently logged into the device.</p>
    </div>
  </div>
  <div class="column is-quarter-desktop is-half-tablet">
    <div class="box has-background-white-bis" style="height: 100%; border-left: 4px solid Blue;">
      <p><b>User's Manager</b></p>
      <p class="is-size-7">Allows "Assistant to..." or "Escalate to..." dynamic links.</p>
    </div>
  </div>
  <div class="column is-quarter-desktop is-half-tablet">
    <div class="box has-background-white-bis" style="height: 100%; border-left: 4px solid Blue;">
      <p><b>Current Mailbox</b></p>
      <p class="is-size-7">Attributes of the mailbox (e.g. Shared Mailbox) being processed.</p>
    </div>
  </div>
  <div class="column is-quarter-desktop is-half-tablet">
    <div class="box has-background-white-bis" style="height: 100%; border-left: 4px solid Blue;">
      <p><b>Mailbox Manager</b></p>
      <p class="is-size-7">Attributes of the manager assigned to the specific mailbox.</p>
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

<div class="box has-background-dark has-text-white">
  <p>Why INI (or TOML-style) configuration?</p>
  <div class="columns">
    <div class="column">
      <p>We avoid modern formats like <b>XML, YAML, or JSON</b> because they rely on strict syntax (brackets, significant whitespace, commas) that is easily broken by non-IT staff.</p>
    </div>
    <div class="column">
      <p><b>INI-style</b> keeps common cases simple, human-readable, and easy to maintain without specialized database infrastructure.</p>
    </div>
  </div>
</div>


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

> Note: Tags are case-insensitive.

### How to work with INI files
1. **Comments:** lines starting with `#` or `;`
2. Use the sample INI files shipped with Set-OutlookSignatures as a starting point (see `.\sample templates` folder)
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
    <div class="box has-background-white-bis">
      <p><b>Mailbox Priority</b></p>
      <ol class="is-size-7">
        <li>Primary logged-in user mailbox</li>
        <li>Default Outlook profile mailboxes</li>
        <li>Other Outlook profiles (alphabetical)</li>
      </ol>
    </div>
  </div>
  <div class="column is-half">
    <div class="box has-background-white-bis">
      <p><b>Template Priority</b></p>
      <ol class="is-size-7">
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

### Minimal example
```
& .\Set-OutlookSignatures.ps1 -SimulateUser "a@example.com" -SimulateMailboxes "a@example.com", "x@example.com" -AdditionalSignaturePath "c:\test"
```

`SimulateMailboxes` is optional but highly recommended.

`SimulateTime` can be used to test time-based templates.

See `.\sample code\SimulationModeHelper.ps1` for helper logic.