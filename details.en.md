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
    <div class="column is-half-desktop is-half-tablet is-full-mobile">
        <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
            <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
                <span>⚙️</span>
                <div>
                    <p><b>IT</b></p>
                    <ul style="list-style-type: none; margin-left: 0; padding-left: 0;">
                        <li class="mb-2"><a href="#architecture-considerations">Architecture considerations</a></li>
                        <li class="mb-2"><a href="#requirements-and-usage">Requirements and usage</a></li>
                        <li class="mb-2"><a href="#group-membership">Group membership</a></li>
                        <li class="mb-2"><a href="#run-set-outlooksignatures-while-outlook-is-running">Run Set-OutlookSignatures while Outlook is running</a></li>
                        <li class="mb-2"><a href="#hybrid-and-cloud-only-support">Hybrid and cloud-only support</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="column is-half-desktop is-half-tablet is-full-mobile">
        <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
            <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
                <span>🚀</span>
                <div>
                    <p><b>Marketing & Usage</b></p>
                    <ul style="list-style-type: none; margin-left: 0; padding-left: 0;">
                        <li class="mb-2"><a href="#signature-and-oof-template-file-format">Signature and OOF template file format</a></li>
                        <li class="mb-2"><a href="#template-tags-and-ini-files">Template tags and INI files</a></li>
                        <li class="mb-2"><a href="#signature-and-oof-application-order">Signature and OOF application order</a></li>
                        <li class="mb-2"><a href="#replacement-variables">Replacement variables</a></li>
                        <li class="mb-2"><a href="#outlook-for-the-web">Outlook for the web</a></li>
                        <li class="mb-2"><a href="#simulation-mode">Simulation mode</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="column is-full">
        <div class="box has-background-white-bis has-text-black" style="border-top: 4px solid LimeGreen;">
            <div style="display: flex; align-items: flex-start; gap: 0.75em;">
                <span>🛡️</span>
                <div>
                    <p><b>Security</b></p>
                    <ul style="list-style-type: none; margin-left: 0; padding-left: 0;">
                        <li class="mb-0"><a href="#security-considerations">Security considerations</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

**Why parameters are in a separate document:** There are many parameters, default values are chosen wisely, and custom values usually do not change over the years. See [Parameters](/parameters) for details.


## Architecture considerations
Most companies choose the same default setup:
- **Primary device** (managed): Where users do most daily email work.
- **Secondary devices** (often managed, sometimes unmanaged): Phones, tablets, occasional laptops, VDI sessions, or private devices.

### Recommended default pattern
- **Client mode** on the primary device keeps signatures and OOF replies up to date without central compute.
- Add the **[Outlook add-in](/outlookaddin)** to make signatures available on secondary devices and platforms where native signature automation is limited (mobile, BYOD, etc.).

### When central creation is better
Sometimes you cannot or do not want to run Set-OutlookSignatures in the security context of the logged-on user, for example:
- BYOD environments without a managed primary device
- Frontline workers using shared devices or only Outlook for the web
- Users who only work on mobile clients
- You prefer a central system (service account) instead of endpoint execution

For these scenarios, the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a> provides **SimulateAndDeploy** mode.

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


## Requirements and usage
### Core requirements
- **Exchange**: Exchange Online, Exchange on-premises, or Exchange hybrid
- **PowerShell**
  - Windows: Windows PowerShell 5.1 (`powershell.exe`) or PowerShell 7+ (`pwsh.exe`)
  - Linux/macOS: PowerShell 7+ (`pwsh`)

Set-OutlookSignatures can run in two modes (see [Architecture considerations](#architecture-considerations)):
- **Client mode** (recommended for most environments)
- **SimulateAndDeploy** (<a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a>)

### Outlook and Word requirements (Windows)
On Windows, Outlook and Word are *usually* required, but not in all constellations:
- If Outlook is installed and has profiles configured, Outlook is used as source for mailboxes.
- If Outlook is not installed or configured, New Outlook is used if available.
- If New Outlook is configured as default, New Outlook is used.
- Otherwise, Outlook for the web is used as source for mailboxes.

**Word 2010+** is required when:
- templates in **DOCX** format are used, or
- **RTF** signatures need to be created.

### Templates
Supported template formats:
- **DOCX** (Windows)
- **HTM** (Windows, Linux, macOS)

Set-OutlookSignatures ships with sample templates in both formats.

### Execution environment
- The software must run in **PowerShell Full Language mode**.
- On Windows and macOS, unblock `Set-OutlookSignatures.ps1` if needed (`Unblock-File` or file properties → Unblock).

### Endpoint security (AppLocker, Defender, CrowdStrike, …)
If you use application control, you may need to trust the existing digital file signature or allow execution/library loading from TEMP locations.

Set-OutlookSignatures and its components are digitally signed with an Extended Validation (EV) Code Signing Certificate.

### File access
Paths to templates and configuration (SignatureTemplatePath, OOFTemplatePath, GraphConfigFile, etc.) must be readable by the currently logged-in user.

For SharePoint Online access, you need to register an Entra ID app and grant admin consent (see [Quickstart](/quickstart)).

### Linux and macOS
Not all features are yet available or possible on Linux and macOS. Every parameter contains appropriate information; the most important restrictions are summarized here.

#### Common restrictions and notes for Linux and macOS
- Only mailboxes hosted in **Exchange Online** are supported reliably.
- Only **Graph** is supported, no local Active Directory.
  - `GraphOnly` is effectively **true** on Linux/macOS and requires an Entra ID app.
- Signature and OOF templates must be in **HTM** format.
  - `UseHtmTemplates` is effectively **true** on Linux/macOS.
- Only existing mount points and SharePoint Online paths can be accessed.
  - Set-OutlookSignatures does not create mount points.
  - This affects all parameters that point to paths (templates, INI files, config files, etc.).
- For non-Outlook clients (Thunderbird, Evolution, …), signatures can still be used via [AdditionalSignaturePath](/parameters#additionalsignaturepath) and [SignatureCollectionInDrafts](/parameters#signaturecollectionindrafts).
- Outlook for the web support requires the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a>.


## Security considerations
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


## Signature and OOF template file format
Only:
- Word files with extension **.docx**
- HTML files with extension **.htm**

### Relation between template file name and Outlook signature name
The name of the signature template file without extension is the name of the signature in Outlook.

Example: `Test signature.docx` → signature name `Test signature`

This can be overridden in the INI file with `OutlookSignatureName`.

Example:
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


## Template tags and INI files
Template tags define properties for templates, such as:
- Time ranges during which a template shall be applied or not applied
- Groups whose direct or indirect members are allowed or denied application of a template
- Mailbox email addresses which are allowed or denied application of a template
- Replacement-variable conditions that allow or deny application of a template
- Default signature selection for new mails and reply/forward
- OOF template target (internal/external)

### Why INI (or TOML-style) configuration?
We intentionally use an **old-fashioned INI-style** (and a TOML-like mindset) because it is easy to read and maintain:
- XML has too many brackets and structural noise.
- YAML relies on significant whitespace (easy to break accidentally).
- JSON is sensitive to commas/brackets.

INI-style keeps common cases simple and reviewable, which is ideal for template administration.

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


## Signature and OOF application order
Signatures are applied mailbox by mailbox.

### Mailbox priority (highest → lowest)
1. Mailbox of the currently logged-in user
2. Mailboxes from the default Outlook profile (in Outlook’s visible order)
3. Mailboxes from other Outlook profiles (profiles sorted alphabetically; mailboxes in visible order)

### Template priority (applied per mailbox)
1. Common templates
2. Group templates
3. Email-address templates
4. Replacement-variable templates

Within each group, templates are sorted by `SortOrder` and `SortCulture` (if defined in the INI file).

**Important consequence:** A template is applied only to the mailbox with the highest priority allowed to use it, so lower-priority mailboxes do not overwrite signatures intended for higher-priority ones.

You can influence behavior with the [MailboxSpecificSignatureNames](/parameters#mailboxspecificsignaturenames) parameter and with the `OutlookSignatureName` tag in the INI file.

OOF templates are applied only if the out-of-office assistant is currently disabled. If it is active or scheduled, OOF templates are not applied.


## Replacement variables
Replacement variables are case-insensitive placeholders in templates that are replaced with user or mailbox values at runtime.
- Replacement happens everywhere, including hyperlinks and image alternative text.
- Variables can come from Active Directory, Entra ID (Graph), or any custom source via script logic.
- Custom variables are supported via a [custom replacement variable config file](/parameters#replacementvariableconfigfile).

> **Tip for template admins:** After running the [Quickstart](/quickstart), inspect the generated sample signature **“Test all default replacement variables”**. It provides an overview of what ships by default (placeholders, formatting behavior, typical examples) without having to read long lists.


## Simulation mode
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