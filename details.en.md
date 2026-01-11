---
layout: "page"
lang: "en"
locale: "en"
title: "Technical details, requirements and usage"
subtitle: "What it needs, how it works and how to use it"
description: "Discover Set-OutlookSignatures technical details: system requirements, supported platforms, template formats, group logic, variables, and simulation mode."
hero_link: /quickstart
hero_link_text: "<span><b>Quick Start Guide</b></span>"
hero_link_style: |
  style="background-color: LawnGreen;"
hero_link2: /support
hero_link2_text: "<span><b>Support</b></span>"
hero_link2_style: |
  style="background-color: LawnGreen;"
permalink: "/details"
redirect_from:
  - "/details/"
sitemap_priority: 0.8
sitemap_changefreq: weekly
---
## Technical details<!-- omit in toc -->
- [1. Get to know Set-OutlookSignatures](#1-get-to-know-set-outlooksignatures)
- [2. Requirements and usage](#2-requirements-and-usage)
  - [2.1. Linux and macOS](#21-linux-and-macos)
    - [2.1.1. Common restrictions and notes for Linux and macOS](#211-common-restrictions-and-notes-for-linux-and-macos)
    - [2.1.2. Linux specific restrictions and notes](#212-linux-specific-restrictions-and-notes)
    - [2.1.3. macOS specific restrictions and notes](#213-macos-specific-restrictions-and-notes)
- [3. Architecture considerations](#3-architecture-considerations)
  - [3.1. Creating signatures and out-of-office replies](#31-creating-signatures-and-out-of-office-replies)
  - [3.2. Making signatures available](#32-making-signatures-available)
    - [3.2.1. Outlook on the web](#321-outlook-on-the-web)
    - [3.2.2. Roaming signatures](#322-roaming-signatures)
    - [3.2.3. Outlook add-in](#323-outlook-add-in)
    - [3.2.4. Draft email](#324-draft-email)
    - [3.2.5. Documents folder](#325-documents-folder)
- [4. Group membership](#4-group-membership)
  - [4.1. Group membership in Entra ID](#41-group-membership-in-entra-id)
  - [4.2. Group membership in Active Directory](#42-group-membership-in-active-directory)
- [5. Run Set-OutlookSignatures while Outlook is running](#5-run-set-outlooksignatures-while-outlook-is-running)
- [6. Signature and OOF template file format](#6-signature-and-oof-template-file-format)
  - [6.1. Relation between template file name and Outlook signature name](#61-relation-between-template-file-name-and-outlook-signature-name)
  - [6.2. Proposed template and signature naming convention](#62-proposed-template-and-signature-naming-convention)
- [7. Template tags and INI files](#7-template-tags-and-ini-files)
  - [7.1. Allowed tags](#71-allowed-tags)
  - [7.2. How to work with INI files](#72-how-to-work-with-ini-files)
- [8. Signature and OOF application order](#8-signature-and-oof-application-order)
- [9. Replacement variables](#9-replacement-variables)
  - [9.1. Photos (account pictures, user image) from Active Directory or Entra ID](#91-photos-account-pictures-user-image-from-active-directory-or-entra-id)
    - [9.1.1. When using DOCX template files](#911-when-using-docx-template-files)
    - [9.1.2. When using HTM template files](#912-when-using-htm-template-files)
    - [9.1.3. Common behavior](#913-common-behavior)
  - [9.2. Delete images when attribute is empty, variable content based on group membership](#92-delete-images-when-attribute-is-empty-variable-content-based-on-group-membership)
  - [9.3. Custom image replacement variables](#93-custom-image-replacement-variables)
- [10. Outlook on the web](#10-outlook-on-the-web)
- [11. Hybrid and cloud-only support](#11-hybrid-and-cloud-only-support)
  - [11.1. Basic Configuration](#111-basic-configuration)
  - [11.2. Advanced Configuration](#112-advanced-configuration)
  - [11.3. Authentication](#113-authentication)
- [12. Simulation mode](#12-simulation-mode)


## 1. Get to know Set-OutlookSignatures
To get to know Set-OutlookSignatures, we recommend the following sequence:
1. The [feature comparison](/features#feature-comparison) gives you a quick overview of topics to consider when choosing a solution for central management and deployment of email signatures and out-of-office replies. 
2. Learn in detail about the [feature list](/features#features) of Set-OutlookSignatures and the Benefactor Circle add-on.
3. Watch the [demo video](/benefactorcircle#demo) to see how a typical real-life use case is implemented.
4. Get practical: Deploy signatures within minutes with the [Quick Start Guide](/quickstart)!

You want to know more?
- [Requirements and usage](#2-requirements-and-usage)
- [Parameters](/parameters)
- [Frequently Asked Questions (FAQ)](/faq)
- [The Outlook add-in](/outlookaddin)
- The [Changelog](https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/blob/main/docs/CHANGELOG.md)
- An [organizational implementation approach](/implementationapproach)
- Features available exclusively to [Benefactor Circle](/benefactorcircle) members

The '`sample code`' folder contains additional scripts and advanced usage examples, such as deploying signatures without user or client interaction.

When facing a problem: Before creating a new issue, check the documentation, previous [issues](https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/issues?q=) and [discussions](https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/discussions?discussions_q=). You can also switch to the fast lane: <a href="https://explicitconsulting.at">ExplicIT Consulting</a> offers first-class [professional support](/support).

You are welcome to share your experiences with Set-OutlookSignatures, exchange ideas with other users or suggest new features in our [discussions board](https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/discussions?discussions_q=).


## 2. Requirements and usage  
You need Exchange Online or Exchange on-prem.

Set-Outlook can run on Linux, macOS or Windows systems with PowerShell:
- Windows: Windows PowerShell 5.1 ('powershell.exe', part of Windows) or PowerShell 7+ ('pwsh.exe')
- Linux, macOS: PowerShell 7+ ('pwsh')

Set-OutlookSignatures can run in two modes. See '[3. Architecture considerations](#3-architecture-considerations)' later in this document for details. In short:
- Client mode, in the security context of the currently logged-in user.<br>This mode is recommended for most scenarios as it allows Set-OutlookSignatures to read which mailboxes the user added to Outlook or Outlook on the web, and as this mode does not require central computing ressources.
- SimulateAndDeploy mode, using a service account to push signatures into users mailboxes.<br>This mode is ideal when users log on to clients where Set-OutlookSignatures can not be run in their security context (shared devices with a master login, users with a Microsoft 365 F-license, users only using phones or Android/iOS tablets), in BYOD scenarios, or when your simply want do not want to run Set-OutlookSignatures on any of your clients.

On Windows, Outlook and Word are usually required, but not in all constellations:
- When Outlook 2010 or higher is installed and has profiles configured, Outlook is used as source for mailboxes to deploy signatures for.  
  - If Outlook is not installed or configured, New Outlook is used if available.
  - If New Outlook is configured as default application in Outlook, New Outlook is used.
  - In any other cases, Outlook on the web is used as source for mailboxes.
- Word 2010 or higher is required when templates in DOCX format are used, or when RTF signatures need to be created.

Signature templates can be in DOCX (Windows) or HTML format (Windows, Linux, macOS). Set-OutlookSignatures comes with sample templates in both formats.

The software must run in PowerShell Full Language mode. Constrained Language mode is not supported, as some features such as Base64 conversions are not available in this mode or require very slow workarounds.

On Windows and macOS, unblock the file 'Set-OutlookSignatures.ps1'. You can use the PowerShell cmdlet 'Unblock-File' for this, or right-click the file in File Explorer, select Properties and check 'Unblock'.  
This removes the 'mark of the web', which can prevent script execution when the PowerShell execution policy is set to RemoteSigned.

If you use AppLocker or a comparable solution (Defender, CrowdStrike, Ivanti, and others), you may need to add the existing digital file signature to your allow list, or define additional settings in your security software.

**Thanks to our partnership with <a href="https://explicitconsulting.at">ExplicIT Consulting</a>, Set-OutlookSignatures and its components are digitally signed with an Extended Validation (EV) Code Signing Certificate (which is the highest code signing standard available).  
This is not only available for Benefactor Circle members, but also the Free and Open Source core version is code signed.**

The paths to the template and configuration files (SignatureTemplatePath, OOFTemplatePath, GraphConfigFile, etc.) must be accessible by the currently logged-in user. The files must be at least readable for the currently logged-in user.

In cloud environments, you need to register Set-OutlookSignatures as Entra ID app and provide admin consent for the required permissions. See the Quick Start Guide or '.\config\default graph config.ps1' for details.

### 2.1. Linux and macOS
Not all features are yet available on Linux and macOS. Every parameter contains appropriate information, which can be summarized as follows:

#### 2.1.1. Common restrictions and notes for Linux and macOS
- Only mailboxes hosted in Exchange Online are supported. On-prem mailboxes usually work when addressed via Exchange Online, but this is not guaranteed.
- Only Graph is supported, no local Active Directories.<br>The parameter `GraphOnly` is automatically set to `true` and Linux and macOS, which requires an Entra ID app - the [Quick Start Guide](/quickstart) helps you implement this.
- Signature and OOF templates must be in HTM format.<br>Microsoft Word is not available on Linux, and the file format conversion cannot be done without user impact on macOS.<br>If you do not want to manually convert your DOCX files to HTM, remove incompatible and superfluous code and restore images to their original resolution: Our partner <a href="https://explicitconsulting.at">ExplicIT Consulting</a> offers a commercial batch conversion service.<br>The parameter `UseHtmTemplates` is automatically set to `true` on Linux and macOS.
- Only existing mount points and SharePoint Online paths can be accessed.<br>Set-OutlookSignatures cannot create mount points itself, as there are just too many possibilities.<br>This is important for all parameters pointing to folders or files (`SignatureTemplatePath`, `SignatureIniFile`, `OOFTemplatePath`, `OOFIniFile`, `AdditionalSignaturePath`, `ReplacementVariableConfigFile`, `GraphConfigFile`, etc.). The default values for these parameters are automatically set correctly, so that you can follow the Quick Start Guide without additional configuration. When hosting `GraphConfigFile` on SharePoint Online make sure you also define the `GraphClientID` parameter.<br><br>If SharePoint Online is not an option for you, consider one of the following options for production use:
  - Deploy a software package that not only contains Set-OutlookSignatures, but also all required template and configuration files.
  -	Place Set-OutlookSignatures, the templates and its configuration as ZIP file in a public place (such as your website), and use Intune with a remediation script to download and extract the ZIP file (this might not need your security requirements).
  - Change your execution script or task, so that all required paths are mounted before Set-OutlookSignatures is run.


#### 2.1.2. Linux specific restrictions and notes
- Users need to access their mailboxes via Outlook on the web, as no other form of Outlook is available on Linux (use emulation tools such as Wine, CrossOver, PlayOnLinux, Proton, etc. at your own risk).
  - Support for Outlook on the web requires the Benefactor Circle add-on. See <a href="/benefactorcircle">Benefactor Circle</a> for details.
- When using email clients such as Mozilla Thunderbird, GNOME Evolution, KDE KMail or others, you can still use signatures created by Set-OutlookSignatures with the Benefactor Circle add-on, as they are stored in the folder `$([IO.Path]::Combine([environment]::GetFolderPath('MyDocuments'), 'Outlook Signatures'))` per default (parameter `AdditionalSignaturePath`).


#### 2.1.3. macOS specific restrictions and notes
- Classic Outlook on Mac is supported
  - Until Classic Outlook supports roaming signatures (which is very likely to never happen), it is treated like Outlook on Windows configured not to use roaming signatures. Consider using the '-MailboxSpecificSignatureNames' parameter.
- New Outlook on Mac is supported
  - Until New Outlook supports roaming signatures (not yet announced by Microsoft), it is treated like Outlook on Windows configured not to use roaming signatures. Consider using the '-MailboxSpecificSignatureNames' parameter.
  - If New Outlook is enabled, an alternate method of account detection is used, as scripting is not yet supported by Microsoft, but already announced on the M365 roadmap. This alternate method may detect accounts that are no longer used in Outlook (see software output for details).  
  - If the alternate method does not find accounts, Outlook on the web is used and existing signatures are synchronized with New Outlook on Mac.
    - Support for Outlook on the web requires the Benefactor Circle add-on. See <a href="/benefactorcircle">Benefactor Circle</a> for details.
- Classic Outlook on Mac and New Outlook on Mac do not allow external software to set default signatures.
- When using email clients such as Apple Mail or others, you can still use signatures created by Set-OutlookSignatures with the Benefactor Circle add-on, as they are stored in the folder `$([IO.Path]::Combine([environment]::GetFolderPath('MyDocuments'), 'Outlook Signatures'))` per default (parameter `AdditionalSignaturePath`).


## 3. Architecture considerations
Most companies choose the same default setup for their environment:
- Each user has a primary device running Linux, macOS or Windows.<br>On this device, the user performs the majority of his computer related tasks - from our point of view, this is working with emails.<br>This primary device is managed, i.e. controlled by the company at software level at least.
- Users often have secondary devices, which can be essential for daily work but are used less often than the primary device (especially for our use case of working with emails).<br>Typical secondary devices are the user's company smartphone, an occasionally used laptop or virtual machine, but also non-company devices used to access company email.<br>Secondary devices are ususally only managed devices when they belong to the company.

The best for this scenario is to run Set-OutlookSignatures on each user's primary device as described in the [Quick Start Guide](/quickstart): Depending on your needs and environment, you may realize this with a [logon script](/faq#12-how-do-i-start-the-software-from-the-command-line-or-a-scheduled-task), a [scheduled task](/faq#12-how-do-i-start-the-software-from-the-command-line-or-a-scheduled-task), a [desktop icon](/faq#446-create-desktop-icons-cross-platform), a [desired state configuration](/faq#444-deploy-and-run-software-using-desired-state-configuration-dsc), or other methods.  
Of course, users [never see Set-OutlookSignatures](/faq#121-start-set-outlooksignatures-in-hiddeninvisible-mode) - signatures are just there and always up-to-date.

You then add the [Outlook add-in](/outlookaddin) to the mix to make signatures available in Outlook running on secondary devices (Outlook on Android, Outlook on iOS, etc.). This also covers the use of Outlook on devices that are not managed, such as accessing the company mailbox from Outlook installed on a private computer.

Sometimes, this default scenario is not possible or not wanted. Examples are:
* Users do not have a managed primary device, for example in a BYOD (bring your own device) scenario.
* The primary user device is managed but not running an OS on which Set-OutlookSignatures can be executed (Linux, macOS, Windows).
* Users never log on to a device, only to services. This is often the case when Microsoft 365 F-licenses are used and users only log on to Outlook on the web, for example.
* You want to use Set-OutlookSignatures, but you prefer running it on a central system instead of running it on your clients.

Set-OutlookSignatures and the [Benefactor Circle add-on](/benefactorcircle) support all these scenarios by offering differing methods for the creation of signatures as well as for making these signatures available to end users.

Contrary to other solutions, you do not have to decide for one fixed combination of these methods - you can mix and match different combinations to perfectly meet your requirements.

**Our recommendation is also the scenario used most often by our customers:**
* For users with a primary managed device running Linux, macOS or Windows, Set-OutlookSignatures runs on their client ([hidden/non-visible](/faq#121-start-set-outlooksignatures-in-hiddeninvisible-mode), of course). This primary managed device can also be a virtual desktop instance (VDI) or a terminal server session.<br>The assigned Outlook add-in instance is configured to automatically add signatures only in Outlook on Android and Outlook on iOS.
* Frontline workers (production and healthcare staff, for example) primarily using shared devices or only logging on to Outlook on the web get their signatures centrally via SimulateAndDeploy.<br>The assigned Outlook add-in instance is configured to automatically add signatures only in Outlook on Android and Outlook on iOS.
* Users primarily working on unmanaged devices get their signatures centrally via SimulateAndDeploy.<br>The assigned Outlook add-in instance is configured to automatically add signatures on all Outlook editions on all platforms.

The following chapters dive deeper into the differences between creating signatures and out-of-office replies, and making signatures available to end users. They also describe which options are available, what their pros and cons are, and when they are used best.

### 3.1. Creating signatures and out-of-office replies
Set-OutlookSignatures comes with client mode, the Benefactor Circle add-on adds [SimulateAndDeploy](/parameters#19-simulateanddeploy) mode.

While building the base for SimulateAndDeploy, pure [simulation mode](/details#12-simulation-mode) is not discussed here as it is not intended to be used for mass deployment but as a quality control feature.

<div style="display: grid;">
  <div class="table-container">
    <table class="table" style="min-width: 50em;">
      <thead>
        <tr>
          <th class="has-text-weight-bold" style="width: 15%;"></th>
          <th class="has-text-weight-bold" style="width: 42.5%;">Client mode</th>
          <th class="has-text-weight-bold" style="width: 42.5%;">SimulateAndDeploy</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="has-text-weight-bold">Advantages</td>
          <td>
              <p>Uses idle resources on end user devices (Linux, Windows, macOS).</p>
              <p>Runs within the security context of the logged-on user.</p>
              <p>Is typically run more often, usually every two hours or at every log-on.</p>
          </td>
          <td>
              <p>Users do not need a primary device that is managed and runs Linux, macOS or Windows.</p>
              <p>Software or at least configuration must only be deployed to involved central systems.</p>
          </td>
        </tr>
        <tr>
          <td class="has-text-weight-bold">Disadvantages</td>
          <td>
              <p>End users must log on to a device (Linux, Windows, macOS), not just to Outlook.</p>
              <p>The primary device of each user must be managed und run Windows, Linux or macOS.</p>
              <p>Software or at least configuration must be deployed to many decentral systems.</p>
          </td>
          <td>
              <p>Uses one or more central systems, which need according resources.</p>
              <p>Runs within the security context of a service account requiring (temporary) full access to all user mailboxes.</p>
              <p>Is typically run less frequent, usually once a day or less often.</p>
              <p>Can only see and influence the configuration of Outlook on the web, reducing the feature set of Set-OutlookSignatures to what is possible in simulation mode.</p>
          </td>
        </tr>
        <tr>
          <td class="has-text-weight-bold">Recommended for</td>
          <td>
              <p>Users logging on to a primary device that is managed and runs Linux, Windows or macOS.</p>
          </td>
          <td>
            <p>Scenarios where you cannot or do not want to run Set-OutlookSignatures in the context of the logged-on user.<br>Examples are users mainly working on shared devices with a master login, only using Outlook on the web, only using phones or Android/iOS tablets, and unmanaged BYOD scenarios.</p>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</div>

With the Benefactor Circle add-on, both modes can:
- Set [out-of-office replies](/parameters#11-setcurrentuseroofmessage) for internal and external recipients.
- Deploy signatures for mailboxes (and other Exchange recipient objects) the user has access to but not added to Outlook. See the [VirtualMailboxConfigFile](/parameters#38-virtualmailboxconfigfile) parameter for details, and combine it with [Export-RecipientPermissions](https://explicitconsulting.at/open-source/export-recipientpermissions) for maximum automation.

### 3.2. Making signatures available
Signatures created in client mode or SimulateAndDeploy mode need to be made available to the end user.

Signatures created in client mode are automatically made available to the local Outlook installation. With the Benefactor Circle add-on, client mode also makes signatures available in the 'Documents' folder of the logged-on user.

SimulateAndDeploy mode has no access to end user devices and therefore treats Outlook on the web as the local Outlook installation. It cannot not make signatures available in a user's 'Documents' folder.

With the Benefactor Circle add-on active, both modes per default also make signatures available
- in Outlook on the web,
- as roaming signatures (cloud only),
- for use with the Outlook add-in,
- and in a draft email.

#### 3.2.1. Outlook on the web
The [SetCurrentUserOutlookWebSignature](https://set-outlooksignatures.com/parameters#10-setcurrentuseroutlookwebsignature) parameter is enabled by default with the Benefactor Cicle add-on.

Mailboxes hosted in Exchange on-prem only support one signature in Outlook on the web, so the default signature defined for new emails is preferred over the default signature defined for replies and forwards.

Mailboxes hosted in Exchange Online combine the on-prem behavior described above with the roaming signature feature described in the next chapter. The on-prem behavior is only used when Outlook on the web is accessed from smartphone browsers or when administrators have disabled roaming signatures at the tenant level.

#### 3.2.2. Roaming signatures
Roaming signatures is an Exchange Online only feature. The idea is to no longer store signatures locally but in the mailbox itself.

This feature is currently supported only by Outlook on the web, New Outlook on Windows and Classic Outlook on Windows.

Even when Microsoft is slow in taking this feature forward and competing signature solutions boycott it because of its impact on their business model, the creators of Set-OutlookSignatures and the Benefactor Circle add-on absolutely believe that roaming signatures are the way.

With the Benefactor Circle add-on, all signatures are [automatically made available as roaming signatures](/parameters#31-mirrorcloudsignatures). Roaming signatures are synchronized using our own engine with all Outlook editions on Linux, Windows and macOS. This not only overcomes platform limits, but also avoids [problems with Outlook's own sync engine](/faq#41-roaming-signatures-in-classic-outlook-on-windows-look-different).

Until roaming signatures are supported by all Outlook editions on all platforms, running Set-OutlookSignatures with the Benefactor Circle add-on in client mode and using the Outlook add-in are a great alternative to make signatures available everywhere.

See our blog post '[Current state and furte of roaming signatures](/blog/2025/10/20/current-state-and-future-of-roaming-signatures)' for more context.

#### 3.2.3. Outlook add-in
The [Outlook add-in](/outlookaddin), part of the Benefactor Circle add-on, is available for all Outlook editions.

The add-in makes signatures - created by Set-OutlookSignatures in client or SimulateAndDeploy mode - available in Outlook on Android and Outlook on iOS, while supporting all Outlook editions across platforms.

It's an ideal solution for Outlook editions that don't yet support roaming signatures and is particularly helpful in unmanaged BYOD (bring your own device) scenarios. For on-premises mailboxes, it delivers a roaming signature experience comparable to the cloud.

The Outlook add-in includes a task pane that lets users preview a selected signature and insert it into the email or appointment they are currently composing.

It can automatically apply the correct signature as soon as a new email or appointment is created, which is especially useful for Outlook on Android and Outlook on iOS. It intelligently selects the appropriate signature based on the sender address, the type of item (new email, reply, or appointment), and any custom rules you define.

You can have as many add-in instances with differing configurations as you need, just follow the [technical specifications](/outlookaddin#32-web-server-and-domain) of the Outlook add-in.

#### 3.2.4. Draft email
The [SignatureCollectionInDrafts](/parameters#35-signaturecollectionindrafts) parameter, enabled per default with the Benefactor Circle add-on, creates and updates an email message with the subject 'My signatures, powered by Set-OutlookSignatures Benefactor Circle' in the drafts folder of the current user.

The draft email contains all available signatures in HTML and plain text format.

This allows for easy copy-paste access to signatures in mail clients that do not have a signatures API and do not support Outlook add-ins: Apple Mail, Google Gmail, Samsung Mail, Mozilla Thunderbird, GNOME Evolution, KDE KMail, and others.

#### 3.2.5. Documents folder
The [AdditionalSignaturePath](/parameters#14-additionalsignaturepath) parameter, enabled per default with the Benefactor Circle add-on, copies signatures to an additional path.

When this path is synchronized and made available on all user devices, for example via Microsoft OneDrive or Nextcloud, users have file-level access to signatures everywhere.

The signatures can then be viewed and copied to mail clients that do not have a signatures API and do not support Outlook add-ins: Apple Mail, Google Gmail, Samsung Mail, Mozilla Thunderbird, GNOME Evolution, KDE KMail, and others.


## 4. Group membership  
### 4.1. Group membership in Entra ID
When no Active Directory connection is available or the `GraphOnly` parameter is set to `true`, Entra ID is queried for transitive group membership via the Graph API. This query includes security and distribution groups.

Transitive means that not only direct group membership is considered, but also the membership resulting of groups being members of other groups, a.k.a. nested or indirect membership.

In Microsoft Graph, membership in dynamic groups is automatically considered.


### 4.2. Group membership in Active Directory
When an Active Directory connection is available and the `GraphOnly` parameter ist not set to `true`, Active Directory is queried via LDAP.

Per default, all static security and distribution groups of group scopes global and universal are considered.

Group membership is evaluated against the whole Active Directory forest of the mailbox, and against all trusted domains (and their subdomains) the user has access to.

Group membership is evaluated transitively. Transitive means that not only direct group membership is considered, but also the membership resulting of groups being members of other groups, a.k.a. nested or indirect membership.

When Active Directory is used, SIDHistory is always included when evaluating group membership.

In Exchange resource forest scenarios with linked mailboxes, the group membership of the linked account (as populated in msExchMasterAccountSID) is not considered, only the group membership of the actual mailbox.

Group membership from Active Directory is retrieved by combining queries:
- Security groups are determined via the tokenGroupsGlobalAndUniversal attribute. Querying this attribute is nearly instant, resource saving on client and server, and also considers sIDHistory. This query includes security groups with the global or universal scope type in the whole forest.
- Distribution groups are queried via special LDAP_MATCHING_RULE_IN_CHAIN query that allows for very fast searching of group membership in the whole forest.
- Group membership across trusts is considered when the trusted domain/forest is included in TrustsToCheckForGroups, which is the default for all detected trusts. Cross-trust group membership is retrieved with an optimized LDAP query, considering the sID and sIDHistory of the group memberships retrieved in the steps before. This query only includes groups with the domain local scope type, as this is the only group type that can be used across trusts.

Only static groups are considered. Please see the FAQ section for detailed information why dynamic groups are not included in group membership queries on-prem.

Per default, the mailbox's own forest is not checked for membership in domain local groups, no matter if of type security or distribution. This is because querying for membership in domain local groups cannot be done fast, as there is no cache and every domain local group domain in the forest has to be queried for membership. Also, domain local groups are usually not used when granting permissions in Exchange. You can enable searching for domain local groups in the mailbox's forest by setting the parameter `IncludeMailboxForestDomainLocalGroups` to `$true`.


## 5. Run Set-OutlookSignatures while Outlook is running  
Outlook and Set-OutlookSignatures can run simultaneously.

On Windows, Outlook is never run or stopped by Set-OutlookSignatures. On macOS, Outlook may be started in the background, as this is a required by Outlook's engine for script access.

New and changed signatures can be used instantly in Outlook.

Changing which signature name is to be used as default signature for new emails or for replies and forwards requires restarting Outlook.   


## 6. Signature and OOF template file format  
Only Word files with the extension .docx and HTML files with the extension .htm are supported as signature and OOF template files.  
### 6.1. Relation between template file name and Outlook signature name
The name of the signature template file without extension is the name of the signature in Outlook.
Example: The template "Test signature.docx" will create a signature named "Test signature" in Outlook.

This can be overridden in the INI file with the 'OutlookSignatureName' parameter.
Example: The template "Test signature.htm" with the following INI file configuration will create a signature named "Test signature, do not use".

```
[Test signature.htm]
OutlookSignatureName = Test signature, do not use
```

### 6.2. Proposed template and signature naming convention
To make life easier for template maintainers and for users, a consistent template and signature naming convention should be used.

There are multiple approaches, with the following one gaining popularity: `<Company> <internal/external> <Language> <formal/informal> <additional info>`

Let's break down the components:
- Company: Useful when your users work with multiple company or brand names.
- Internal/External: Usually abbreviated as int and ext. Show if a signature is intended for use with a purely internal recipient audience, or if an external audience is involved.
- Language: Usually abbreviated to a two-letter code, such as AT for Austria. This way, you can handle multi-language signatures.
- Formal/informal: Usually abbreviated as frml and infrml. Allows you to deploy signatures with a certain formality in the salutation of the signature.
- Additional info: Typically used to identify signatures for shares mailboxes or in delegate scenarios.

Example signature names for a user having access to his own mailbox and the office mailbox:
- CompA ext DE frml
- CompA ext DE frml office@
- CompA ext DE infrml
- CompA ext DE infrml office@
- CompA ext EN frml
- CompA ext EN frml office@
- CompA ext EN infrml
- CompA ext EN infrml office@
- CompA int EN infrml
- CompA int EN infrml office@

For the user, the selection process may look complicated at first sight, but is actually quite natural and fast:
- Example A: Informal German mail sent to externals from own mailbox
  1. "I act in the name of company CompA" -> "CompA"
  2. "The mail has at least one external recipient" -> "CompA ext"
  3. "The mail is written in German language" -> "CompA ext DE"
  4. "The tone is informal" -> "CompA ext DE infrml"
  5. "I send from my own mailbox" -> no change, use "CompA ext DE infrml"
- Example B: Formal English mail sent to externals from office@
  1. "I act in the name of company CompA" -> "CompA"
  2. "The mail has at least one external recipient" -> "CompA ext"
  3. "The mail is written in English language" -> "CompA ext EN"
  4. "The tone is formal" -> "CompA ext EN frml"
  5. "I send from the office mailbox" -> "CompA ext EN frml office@"
- Example C: Internal English mail from own mailbox
  1. "I act in the name of company CompA" -> "CompA"
  2. "The mail has only internal recipients" -> "CompA int"
  3. "The mail is written in English language" -> "CompA int EN"
  4. "The tone is informal" -> "CompA int EN infrml"
  5. "I send from my own mailbox" -> "CompA int EN infrml"

Don't forget: You can use one and the same template for different signature names. In the example above, the template might not be named `CompA ext EN frml office@.docx`, but `CompA ext EN frml shared@.docx` and be used multiple times in the INI file:

```
# office@example.com
[CompA ext EN frml shared@.docx]
office@example.com
OutlookSignatureName = CompA ext EN frml office@
DefaultNew

# marketing@example.com
[CompA ext EN frml shared@.docx]
marketing@example.com
OutlookSignatureName = CompA ext EN frml marketing@
DefaultNew
```


## 7. Template tags and INI files
Tags define properties for templates, such as
- time ranges during which a template shall be applied or not applied
- groups whose direct or indirect members are allowed or denied application of a template
- specific email addresses (including alias and secondary addresses) which are are allowed or denied application of a template
- specific replacement variables which allow or deny application of a template
- an Outlook signature name that is different from the file name of the template
- if a signature template shall be set as default signature for new emails or as default signature for replies and forwards
- if a OOF template shall be set as internal or external message

There are additional tags which are not template specific, but change the behavior of Set-OutlookSignatures:
- specific sort order for templates (ascending, descending, as listed in the file)
- specific sort culture used for sorting ascendingly or descendingly (de-AT or en-US, for example)

If you want to give template creators control over the INI file, place it in the same folder as the templates.

Tags are case insensitive.
### 7.1. Allowed tags
- Time range: `<yyyyMMddHHmm-yyyyMMddHHmm>`, `-:<yyyyMMddHHmm-yyyyMMddHHmm>`
  - Make this template valid only during the specific time range (`yyyy` = year, `MM` = month, `dd` = day, `HH` = hour (00-24), `mm` = minute).
  - The `-:` prefix makes this template invalid during the specified time range.
  - Examples: `202112150000-202112262359` for the 2021 Christmas season, `-:202202010000-202202282359` for a deny in February 2022
  - If the software does not run after a template has expired, the template is still available on the client and can be used.
  - Time ranges are interpreted as local time per default, which means times depend on the user or client configuration. If you do not want to use local times, but global times just add 'Z' as time zone. For example: `202112150000Z-202112262359Z`
  - This feature requires a Benefactor Circle license
- Assign template to group: `<DNS or NetBIOS name of AD domain> <SamAccountName of group>`, `<DNS or NetBIOS name of AD domain> <Display name of group>`, `-:<DNS or NetBIOS name of AD domain> <SamAccountName of group>`, `-:<DNS or NetBIOS name of AD domain> <Display name of group>`
  - Make this template specific for an Outlook mailbox being a direct or indirect member of this group or distribution list
  - The `-:` prefix makes this template invalid for the specified group.
  - Examples: `EXAMPLE Domain Users`, `-:Example GroupA`  
  - Groups must be available in Active Directory and/or Entra ID. Groups like `Everyone` and `Authenticated Users` only exist locally, not in Active Directory or Entra ID.
  - This tag supports alternative formats, which are of special interest if you are in a cloud only or hybrid environmonent:
    - `<DNS or NetBIOS name of AD domain> <SamAccountName of group>` and `<DNS or NetBIOS name of AD domain> <Display name of group>` can be queried from Microsoft Graph if the groups are synced between on-prem and the cloud. SamAccountName is queried before DisplayName. Use these formats when your environment is hybrid or on premises.
    - `EntraID <Object ID of group>`, `EntraID <securityIdenfifier of group>`, `EntraID <email-address-of-group@example.com>`, `EntraID <mailNickname of group>`, `EntraID <DisplayName of group>` do not work with a local Active Directory, only with Microsoft Graph. They are queried in the order given. You can use 'AzureAD' instead of 'EntraID'. 'EntraID' and 'AzureAD' are the literal, case-insensitive strings 'EntraID' and 'AzureAD', not a variable. Use these formats when you are in a hybrid or cloud only environment.<br>'`EntraID`' and '`AzureAD`' always refer to the home tenant of the currently logged-in user. To address a specific tenant in cross-tenant scenarios (see '`GraphClientID`' for details), use one of the following formats: '`EntraID_<a registered DNS domain>`' ('`EntraID_example.onmicrosoft.com`'), or '`EntraID_<Tenant ID>`' ('`EntraID_00000000-0000-0000-0000-000000000000`').
  - '`<DNS or NetBIOS name of AD domain>`' and '`<EXAMPLE>`' are just examples. You need to replace them with the actual NetBios domain name of the Active Directory domain containing the group.
  - 'EntraID' and 'AzureAD' are not examples. If you want to assign a template to a group stored in Entra ID, you have to use 'EntraID' or 'AzureAD' as domain name.
  - When multiple groups are defined, membership in a single group is sufficient to be assigned the template - it is not required to be a member of all the defined groups.  
  - Which group naming format should I choose?
    - When using the '`<DNS or NetBIOS name of AD domain> <…>`' format, use the SamAccountName whenever possible. The combination of domain name and SamAccountName is unique, while a display name may exist multiple times in a domain.
    - When using the '`EntraID <…>`' format, prefer Object ID and securityIdentifier whenever possible. Object ID and securityIdentifier are always unique, email address and mailNickname can wrongly exist on multiple objects, and the uniqueness of displayName is in your hands.
  - When should I refer on-prem groups and when Entra ID groups?
    - When using the '`-GraphOnly true`' parameter, prefer Entra ID groups ('`EntraID <…>`'). You may also use on-prem groups ('`<DNS or NetBIOS name of AD domain> <…>`') as long as they are synchronized to Entra ID.
    - In hybrid environments without using the '`-GraphOnly true`' parameter, prefer on-prem groups ('`<DNS or NetBIOS name of AD domain> <…>`') synchronized to Entra ID. Pure entra ID groups ('`EntraID <…>`') only make sense when all mailboxes covered by Set-OutlookSignatures are hosted in Exchange Online.
    - Pure on-prem environments: You can only use on-prem groups ('`<DNS or NetBIOS name of AD domain> <…>`'). When moving to a hybrid environment, you do not need to adapt the configuration as long as you synchronize your on-prem groups to Entra ID.
- Group membership of current user: `CURRENTUSER:<syntax of "Assign template to group">`
  - Make this template specific for the logged on user if his _personal_ mailbox (which does not need to be in Outlook) is a direct or indirect member of this group or distribution list
  - Example: Assign template to every mailbox, but not if the mailbox of the current user is member of the group EXAMPLE\Group

    ```
    [template.docx]
    -CURRENTUSER:EXAMPLE Group
    ```

- Email address: `<SmtpAddress>`, `-:<SmtpAddress>`
  - Make this template specific for the assigned email address (all SMTP addresses of a mailbox are considered, not only the primary one)
  - The `-:` prefix makes this template invalid for the specified email address.
  - Examples: `office@example.com`, `-:test@example.com`
  - The `CURRENTUSER:` and `-CURRENTUSER:` prefixes make this template invalid for the specified email addresses of the current user.  
  Example: Assign template to every mailbox, but not if the personal mailbox of the current user has the email address userX@example.com
  - Useful for delegate or boss-secretary scenarios: "Assign a template to everyone having the boss mailbox userA@example.com in Outlook, but not for UserA itself" is realized like that in the INI file:

    ```
    [delegate template name.docx]
    # Assign the template to everyone having userA@example.com in Outlook
    userA@example.com
    # Do not assign the template to the actual user owning the mailbox userA@example.com
    -CURRENTUSER:userA@example.com
    ```

    You can even only use only one delegate template for your whole company to cover all delegate scenarios. Make sure the template correctly uses `$CurrentUser[…]$` and `$CurrentMailbox[…]$` replacement variables, and then use the template multiple times in the INI file, with different signature names:

    ```
    [Company EN external formal delegate.docx]
    # Assign the template to everyone having userA@example.com in Outlook
    userA@example.com
    # Do not assign the template to the actual user owning the mailbox userA@example.com
    -CURRENTUSER:userA@example.com
    # Use a custom signature name instead of the template file name 
    OutlookSignatureName = Company EN external formal userA@


    [Company EN external formal delegate.docx]
    # Assign the template to everyone having userX@example.com in Outlook
    userX@example.com
    # Do not assign the template to the actual user owning the mailbox userX@example.com
    -CURRENTUSER:userX@example.com
    # Use a custom signature name instead of the template file name 
    OutlookSignatureName = Company EN external formal UserX@
    ```

- Replacement variable: `<ReplacementVariable>`, `-:<ReplacementVariable>`
  - Make this template specific for the assigned replacement variable
  - The `-:` prefix makes this template invalid for the specified replacement variable.
  - Replacement variable are checked for true or false values. If a replacement variable is not a boolean (true or false) value per se, it is converted to the boolean data type first.
    - Replacement variables that can only hold one value evaluate to false if they contain no value (null, empty) or have the value 0. All other values evaluate to true.
    - Replacement variables that can hold multiple values evaluate to false if they contain no value, or if they contain only one value, which in turn evaluates to false. All other values evaluate to true.
  - Examples:
    - `$CurrentMailboxManagerMail$` (apply if current user has a manager with an email address)
    - `-:$CurrentMailboxManagerMail$` (do not apply if current user has a manager with an email address)
    - A template should only be applied to users which are member of the Marketing group and the Sales group at the same time:
      - Use a custom replacement variable config file, define the custom replacement variable `$CurrentMailbox-IsMemberOf-MarketingAndSales$` and set it to yes if the current user's mailbox is member of the Marketing and the Sales groups at the same time:  

        ```
        @(
          @('CurrentUser', '$CurrentUser-IsMemberOf-MarketingAndSales$', 'EXAMPLEDOMAIN Marketing', 'EXAMPLEDOMAIN Sales'),
          @()
        ) | Where-Object { $_ } | ForEach-Object {
          if (
            $((Get-Variable -Name "ADProps$($_[0])" -ValueOnly).GroupsSids -icontains $(ResolveToSid($_[2]))) -and 
            $((Get-Variable -Name "ADProps$($_[0])" -ValueOnly).GroupsSids -icontains $(ResolveToSid($_[3]))) 
          ) { 
            $ReplaceHash[$_[1]] = 'yes'
          } else {
            $ReplaceHash[$_[1]] = $null 
          } 
        }
        ```

      - The template INI configuration then looks like this:

        ```
        [template.docx]
        $CurrentUser-IsMemberOf-MarketingAndSales$
        ```

      - If you want a template only to not be applied to users whose primary mailbox is a of the Marketing group and the Sales group at the same time:

        ```
        [template.docx]
        -:$CurrentUser-IsMemberOf-MarketingAndSales$
        ```

      - Combinations are possible: Only in January 2024, for all members of EXAMPLEDOMAIN\Examplegroup but not for the mailbox example@example.com and not for users whose primary mailbox is a of the Marketing group and the Sales group at the same time:

        ```
        [template.docx]
        202401010000-202401312359
        EXAMPLEDOMAIN Examplegroup
        -:example@example.com
        -:$CurrentUser-IsMemberOf-MarketingAndSales$
        ```

- Write protect: `writeProtect`
    - Write protects the signature files. Works only in Classic Outlook on Windows. Modifying the signature in Outlook's signature editor leads to an error on saving, but the signature can still be changed after it has been added to an email.  
- Set signature as default for new emails: `defaultNew` (signature template files only)  
    - Set signature as default signature for new mails  
- Set signature as default for replies and forwarded emails: `defaultReplyFwd` (signature template files only)  
    - Set signature as default signature for replies and forwarded mails  
- Set OOF reply as default for internal recipients: `internal` (OOF template files only)  
    - Set template as default OOF message for internal recipients  
    - If neither `internal` nor `external` is defined, the template is set as default OOF message for internal and external recipients  
- Set OOF reply as default for external recipients: `external` (OOF template files only)  
    - Set template as default OOF message for external recipients  
    - If neither `internal` nor `external` is defined, the template is set as default OOF message for internal and external recipients

<br>Tags can be combined: A template may be assigned to several groups, email addresses and time ranges, be denied for several groups, email adresses and time ranges, be used as default signature for new emails and as default signature for replies and forwards - all at the same time. Simple add different tags below a file name, separated by line breaks (each tag needs to be on a separate line).


### 7.2. How to work with INI files
1. Comments  
  Comment lines start with '#' or ';'  
	Whitespace at the beginning and the end of a line is ignored  
  Empty lines are ignored  
2. Use the INI files in `.\templates\Signatures DOCX with ini` and `.\templates\Out-of-Office DOCX with ini` as templates and starting point
3. Put file names with extensions in square brackets  
  Example: `[Company external English formal.docx]`  
  Putting file names in single or double quotes is possible, but not necessary.  
  File names are case insensitive
    `[file a.docx]` is the same as `["File A.docx"]` and `['fILE a.dOCX']`  
  File names not mentioned in this file are not considered, even if they are available in the file system. Set-OutlookSignatures will report files which are in the file system but not mentioned in the current ini, and vice versa.<br>  
  When there are two or more sections for a filename: The keys and values are not combined, each section is considered individually (SortCulture and SortOrder still apply).  
  This can be useful in the following scenario: Multiple shared mailboxes shall use the same template, individualized by using `$CurrentMailbox[…]$` variables. A user can have multiple of these shared mailboxes in his Outlook configuration.
    - Solution A: Use multiple templates (possible in all versions)
      - Instructions
        - Create a copy of the initial template for each shared mailbox.
        - For each template copy, create a corresponding INI entry which assigns the template copy to a specific email address (including alias and secondary addresses).
      - Result
        - Templates<br>One template file for each shared mailbox
          - `template shared mailbox A.docx`
          - `template shared mailbox B.docx`
          - `template shared mailbox C.docx`
        - INI file

          ```
          [template shared mailbox A.docx]
          SharedMailboxA@example.com

          [template shared mailbox B.docx]
          SharedMailboxB@example.com

          [template shared mailbox C.docx]
          SharedMailboxC@example.com
          ```

    - Solution B: Use only one template (possible with v3.1.0 and newer)
      - Instructions
        - Create a single initial template.
        - For each shared mailbox, create a corresponding INI entry which assigns the template to a specific email address (including alias and secondary addresses) and defines a separate Outlook signature name.
      - Result
        - Templates<br>One template file for all shared mailboxes
          - `template shared mailboxes.docx`
        - INI file

          ```
          [template shared mailboxes.docx]
          SharedMailboxA@example.com
          OutlookSignatureName = template SharedMailboxA

          [template shared mailboxes.docx]
          SharedMailboxB@example.com
          OutlookSignatureName = template SharedMailboxB

          [template shared mailboxes.docx]
          SharedMailboxC@example.com
          OutlookSignatureName = template SharedMailboxC
          ```

    You can even only use only one delegate template for your whole company to cover all delegate scenarios. Make sure the template correctly uses `$CurrentUser[…]$` and `$CurrentMailbox[…]$` replacement variables, and then use the template multiple times in the INI file, with different signature names:

    ```
    [Company EN external formal delegate.docx]
    # Assign the template to everyone having userA@example.com in Outlook
    userA@example.com
    # Do not assign the template to the actual user owning the mailbox userA@example.com
    -CURRENTUSER:userA@example.com
    # Use a custom signature name instead of the template file name 
    OutlookSignatureName = Company EN external formal userA@


    [Company EN external formal delegate.docx]
    # Assign the template to everyone having userX@example.com in Outlook
    userX@example.com
    # Do not assign the template to the actual user owning the mailbox userX@example.com
    -CURRENTUSER:userX@example.com
    # Use a custom signature name instead of the template file name 
    OutlookSignatureName = Company EN external formal UserX@
    ```

4. Add tags in the lines below the filename
  Example: `defaultNew`
    - Do not enclose tags in square brackets. This is not allowed here, but required when you add tags directly to file names.    - When an INI file is used, tags in file names are not considered as tags, but as part of the file name, so the Outlook signature name will contain them.  
    - Only one tag per line is allowed.
    Adding not a single tag to file name section is valid. The signature template is then classified as a common template.
    - Putting file names in single or double quotes is possible, but not necessary
    - Tags are case insensitive  
    `defaultNew` is the same as `DefaultNew` and `dEFAULTnEW`
    - You can override the automatic Outlook signature name generation by setting OutlookSignatureName, e. g. `OutlookSignatureName = This is a custom signature name`  
    With this option, you can have different template file names for the same Outlook signature name. Search for "Marketing external English formal" in the sample INI files for an example. Take care of signature group priorities (common, group, email address, replacement variable) and the SortOrder and SortCulture parameters.
5. Remove the tags from the file names in the file system  
Else, the file names in the INI file and the file system do not match, which will result in some templates not being applied.  
It is recommended to create a copy of your template folder for tests.
6. Make the software use the INI file by passing the `SignatureIniFile` and/or `OOFIniFile` parameter


## 8. Signature and OOF application order  
Signatures are applied mailbox for mailbox. The mailbox list is sorted as follows (from highest to lowest priority):
- Mailbox of the currently logged-in user
- Mailboxes from the default Outlook profile, in the sort order shown in Outlook (and not in the order they were added to the Outlook profile)
- Mailboxes from other Outlook profiles. The profiles are sorted alphabetically. Within each profile, the mailboxes are sorted in the order they are shown in Outlook.

For each mailbox, templates are applied in a specific order: Common templates first, group templates second, email address specific templates third, replacement variables last.

Each one of these templates groups can have one or more time range tags assigned. Such a template is only considered if the current system time is within at least one of these time range tags.
- Common templates are templates with either no tag or only `[defaultNew]` and/or `[defaultReplyFwd]` (`[internal]` and/or `[external]` for OOF templates).
- Within these template groups, templates are sorted according to the sort order and sort culture defines in the configuration file.
- Every centrally stored signature template is only applied to the mailbox with the highest priority allowed to use it. This ensures that no mailbox with lower priority can overwrite a signature intended for a higher priority mailbox.

OOF templates are only applied if the out-of-office assistant is currently disabled. If it is currently active or scheduled to be automatically activated in the future, OOF templates are not applied.  


## 9. Replacement variables  
Replacement variables are case insensitive placeholders in templates which are replaced with actual user or mailbox values at runtime.

Replacement variables are replaced everywhere, including links, QuickTips and alternative text of images.

With this feature, you cannot only show email addresses and telephone numbers in the signature and OOF message, but show them as links which open a new email message (`"mailto:"`) or dial the number (`"tel:"`) via a locally installed softphone when clicked.

Custom Active directory attributes are supported as well as custom replacement variables, see `.\config\default replacement variables.ps1` for details.  
Attributes from Microsoft Graph need to be mapped, this is done in `.\config\default graph config.ps1`.

Variables can also be retrieved from other sources than Active Directory by adding custom code to the variable config file.

Per default, `.\config\default replacement variables.ps1` contains the following replacement variables:  
- Currently logged-in user  
    - `$CurrentUserGivenName$`: Given name  
    - `$CurrentUserSurname$`: Surname  
    - `$CurrentUserDepartment$`: Department  
    - `$CurrentUserTitle$`: (Job) Title  
    - `$CurrentUserStreetAddress$`: Street address  
    - `$CurrentUserPostalcode$`: Postal code  
    - `$CurrentUserLocation$`: Location  
    - `$CurrentUserState$`: State  
    - `$CurrentUserCountry$`: Country  
    - `$CurrentUserTelephone$`: Telephone number  
    - `$CurrentUserFax$`: Facsimile number  
    - `$CurrentUserMobile$`: Mobile phone  
    - `$CurrentUserMail$`: email address  
    - `$CurrentUserPhoto$`: Photo from Active Directory or Entra ID, see "[9.1. Photos (account pictures, user image) from Active Directory or Entra ID](#91-photos-account-pictures-user-image-from-active-directory-or-entra-id)" for details  
    - `$CurrentUserPhotoDeleteEmpty$`: Photo from Active Directory or Entra ID, see "[9.1. Photos (account pictures, user image) from Active Directory or Entra ID](#91-photos-account-pictures-user-image-from-active-directory-or-entra-id)" for details  
    - `$CurrentUserExtAttr1$` to `$CurrentUserExtAttr15$`: Exchange extension attributes 1 to 15  
    - `$CurrentUserOffice$`: Office room number (physicalDeliveryOfficeName)  
    - `$CurrentUserCompany$`: Company  
    - `$CurrentUserMailNickname$`: Alias (mailNickname)  
    - `$CurrentUserDisplayName$`: Display Name  
- Manager of currently logged-in user  
    - Same variables as logged-in user, `$CurrentUserManager[…]$` instead of `$CurrentUser[…]$`  
- Current mailbox  
    - Same variables as logged-in user, `$CurrentMailbox[…]$` instead of `$CurrentUser[…]$`  
- Manager of current mailbox  
    - Same variables as logged-in user, `$CurrentMailboxManager[…]$` instead of `$CurrentMailbox[…]$`  

### 9.1. Photos (account pictures, user image) from Active Directory or Entra ID
The software supports replacing images in signature templates with photos stored in Active Directory.

When using images in OOF templates, please be aware that Exchange and Outlook do not yet support images in OOF messages.

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

#### 9.1.1. When using DOCX template files
When using DOCX template files, there are two ways you can embed account pictures: The shape option or the "link and embed" option.

Both ways allow to apply Word image features such as sizing, a shadow, a glow or a reflection. The shape option allows for more graphical freedom, as you can use arrows, stars and many more as container for account pictures.

The crucial part for both ways is to set the text wrapping to "inline with text". If you don't, Outlook and other email clients will not place the image in the correct place as the position of floating shapes in Word cannot reliably be translated to HTML.

The sample signature template '`Test all default replacement variables`' contains examples for both ways, as well as some images formatted as "floating" images.

**Steps for the shape option:**
1. Add a shape to the signature template.
2. Apply any formatting you want to it.
3. Add one of the default replacement variables (such as '`$CurrentUserPhoto$`') to the alternative text of the shape.
4. Set the text wrapping of the shape to "inline with text".

**Steps for the "link and embed" option:**
1. Create a sample image file which will later be used as placeholder.  
2. Insert the image into the signature template. Make sure to use `Insert | Pictures | This device` (Word 2019, other versions have the same feature in different menus) and to select the option `Insert and Link` - if you forget this step, a specific Word property is not set and the software will not be able to replace the image.  
3. Apply any formatting you want to it.
4. Add one of the default replacement variables (such as '`$CurrentUserPhoto$`') to the alternative text of the shape.

When Set-OutlookSignatures finds a shape in a template file with an image replacement variable in its alternative text, it fills the shape with the account picture.

When Set-Outlooksignatures finds a linked and embedded image in a template file with an image replacement variable in its alternative text, it replaces the image with the account picture (as if you would use Word's `"Change picture"` function).

#### 9.1.2. When using HTM template files
Images are replaced when the `src` or `alt` property of the image tag contains an image replacement variable.

Be aware that Outlook does not support the full HTML feature set. For example:
- Some (older) Outlook versions ignore the `width` and `height` properties for embedded images.  
  To overcome this limitation, use images in a connected folder (such as `Test all default replacement variables.files` in the sample templates folder) and additionally set the Set-OutlookSignatures parameter '[EmbedImagesInHtml](/parameters#26-embedimagesinhtml)' to ``false`.
- Text and image formatting are limited, especially when HTML5 or CSS features are used.
- Consider switching to DOCX templates for easier maintenance.


#### 9.1.3. Common behavior
If there is no photo available in Active Directory, there are two options:  
- You used the `$Current[…]Photo$` variables: The sample image used as placeholder is shown in the signature.  
- You used the `$Current[…]PhotoDeleteempty$` variables: The sample image used as placeholder is deleted from the signature, which may affect the layout of the remaining signature depending on your formatting options.

**Attention**: A signature with embedded images has the expected file size in DOCX, HTML and TXT formats, but the RTF file will be much bigger.

The signature template `.\templates\Signatures DOCX\Test all signature replacement variables.docx` contains several embedded images and can be used for a file comparison:  
- .docx: 23 KB  
- .htm: 87 KB  
- .RTF without workaround: 27.5 MB  
- .RTF with workaround: 1.4 MB
  
The software uses a workaround, but the resulting RTF files are still huge compared to other file types and especially for use in emails. If this is a problem, please either do not use embedded images in the signature template (including photos from Active Directory), or switch to HTML formatted emails.

If you ran into this problem outside this script, please consider modifying the ExportPictureWithMetafile setting as described in  <a href="https://support.microsoft.com/kb/224663">this Microsoft article</a>.  
If the link is not working, please visit the <a href="https://web.archive.org/web/20180827213151/https://support.microsoft.com/en-us/help/224663/document-file-size-increases-with-emf-png-gif-or-jpeg-graphics-in-word">Internet Archive Wayback Machine's snapshot of Microsoft's article</a>.  


### 9.2. Delete images when attribute is empty, variable content based on group membership
You can avoid creating multiple templates which only differ by the images contained by only creating one template containing all images and marking this images to be deleted when a certain replacement variable is empty.

Just add the text `$<name of the replacement variable>DELETEEMPTY$` (for example: `$CurrentMailboxExtAttr10DeleteEmpty$` ) to the description or alt text of the image. Taking the example, the image is deleted when extension attribute 10 of the current mailbox is empty.

This can be combined with the `GroupsSIDs` attribute of the current mailbox or current user to only keep images when the mailbox is member of a certain group.

Examples:
- A signature should only show a social network icon with an associated link when there is data in the extension attribute 10 of the mailbox:
  - Insert the icon of the social network in the template, set the hyperlink target to '$CurrentMailboxExtAttr10$' and add '$CurrentMailboxExtAttr10Deleteempty$' to the description of the picture.
    - When using embedded and linked pictures, you can also set the file name to '$CurrentMailboxExtAttr10Deleteempty$'
- A signature should only contain a certain image when the current mailbox is a member of the Marketing group:
  - Create a new replacement variable. We use '$CurrentMailbox-ismemberof-marketing$' in the following example.
    - Attention on-prem users: If Domain Local Active Directory groups are involved, you need to set the `IncludeMailboxForestDomainLocalGroups` parameter to `true` when running Set-OutlookSignatures, so that the SIDs of these groups are considered too.
    - If the current mailbox is a member, give '$CurrentMailbox-ismemberof-marketing$' any value. If not, give '$CurrentMailbox-ismemberof-marketing$' no value (NULL or an empty string).
    - You only have to modify three strings right at the beginning:

      ```
      # Check if current mailbox is member of group 'EXAMPLEDOMAIN\Marketing' and set $ReplaceHash['$CurrentMailbox-ismemberof-marketing$'] accordingly
      #
      # Replace 'EXAMPLEDOMAIN Marketing' with the domain and group you are searching for. Use 'EntraID' or 'AzureAD' instead of 'EXAMPLEDOMAIN' to only search Entra ID/Graph
      # Replace '$CurrentMailbox-ismemberof-marketing$' with the replacement variable that should be used
      # Replace 'CurrentMailbox' with 'CurrentUser' if you do not want to check the current mailbox group SIDs, but the group SIDs of the current user's mailbox
      #
      # The 'GroupsSIDs' attribute is available for the current mailbox and the current user, but not for the managers of these two
      #   It contains the mailboxes' SID and SIDHistory, the SID and SIDHistory of all groups the mailbox belongs to (nested), and also considers group membership (nested) across trusts.
      #   Attention on-prem users: If Active Directory groups of the Domain Local type are queried, you need to set the `IncludeMailboxForestDomainLocalGroups` parameter to `true` when running Set-OutlookSignatures, so that the SIDs of these groups are considered in GroupsSIDs, too.
      @(
        @('CurrentMailbox', '$CurrentMailbox-IsMemberOf-Marketing$', 'EXAMPLEDOMAIN Marketing'), 
        @()
      ) | Where-Object { $_ } | ForEach-Object {
        if ((Get-Variable -Name "ADProps$($_[0])" -ValueOnly).GroupsSids -icontains ResolveToSid($_[2])) {
          $ReplaceHash[$_[1]] = 'yes'
        } else { 
          $ReplaceHash[$_[1]] = $null 
        } 
      }
      ```

  - Insert the image in the template, and add '$CurrentMailbox-IsMemberOf-MarketingDeleteempty$' to the description of the picture.
    - When using embedded and linked pictures, you can also set the file name to '$CurrentMailbox-IsMemberOf-MarketingDeleteempty$'


### 9.3. Custom image replacement variables
You can fill custom image replacement variables yourself with a byte array: '`$CurrentUserCustomImage[1..10]$'`, '`$CurrentUserManagerCustomImage[1..10]$'`, '`$CurrentMailboxCustomImage[1..10]$'`, '`$CurrentMailboxManagerCustomImage[1..10]$'`.

Use cases: Account pictures from a share, QR code vCard/URL/text/Twitter/X/Facebook/App stores/geo location/email, etc.

Per default, '`$Current[..]CustomImage1$`' is a QR code containing a vCard (in MeCard format) - see file '`.\config\default replacement variables.ps1`' for the code behind it.

The behavior of custom image replacement variables and the possible configuration options are the same as with replacement variables for account pictures from Active Directory/Entra ID.

As practical as QR codes may be, they should contain as little information as possible. The more information they contain, the larger the image needs to be, which often has a negative impact on the layout and always has a negative impact on the size of the email.<br>QR codes with too much information and too small an image size become visually blurred, making them impossible to scan - for DOCX templates, `DocxHighResImageConversion` can help. Consider bigger image size, less content, less error correction, MeCard instead of vCard, and pointing to an URL containing the actual information.


## 10. Outlook on the web  
If the currently logged-in user has configured his personal mailbox in Outlook, the default signature for new emails is configured in Outlook on the web automatically.

If the default signature for new mails matches the one used for replies and forwarded email, this is also set in Outlook.

If different signatures for new and reply/forward are set, only the new signature is copied to Outlook on the web.

If only a default signature for replies and forwards is set, only this new signature is copied to Outlook on the web.

If there is no default signature in Outlook, Outlook on the web settings are not changed.

All this happens with the credentials of the currently logged-in user, without any interaction neccessary.  


## 11. Hybrid and cloud-only support
Set-OutlookSignatures supports three directory environments:
- Active Directory on premises. This requires direct connection to Active Directory Domain Controllers, which usually only works when you are connected to your company network.
- Hybrid. This environment consists of an Active Directory on premises, which is synced with Microsoft Entra ID in the cloud.  
  Make sure that all signature relevant groups (if applicable) are available as well on-prem and in the cloud, and also ensure this for mail related attributes: At least legacyExchangeDN, mail, msExchRecipientTypeDetails, msExchMailboxGuid and proxyAddresses - see [Microsoft's Entra ID attribute synchronization documentation](https://learn.microsoft.com/en-us/azure/active-directory/hybrid/connect/reference-connect-sync-attributes-synchronized) for details. Make sure that the mail attribute in any environment is set to the users primary SMTP address - it may only be empty on the linked user account in the on-prem resource forest scenario.  
  If the software can't make a connection to your on-prem environment, it tries to get required data from the cloud via the Microsoft Graph API.
- Cloud-only. This environment has no Active Directory on premises, or does not sync mail attributes between the cloud and the on-prem enviroment. The software does not connect to your on-prem environment, only to the cloud via the Microsoft Graph API.

The software parameter `GraphOnly` defines which directory environment is used:
- `-GraphOnly false` or not passing the parameter: On-prem AD first, Entra ID only when on-prem AD cannot be reached
- `-GraphOnly true`: Entra ID only, even when on-prem AD could be reached


### 11.1. Basic Configuration
To allow communication between Microsoft Graph and Set-Outlooksignatures, both need to be configured for each other.

The easiest way is to once start Set-OutlookSignatures with a cloud administrator. The administrator then gets asked for admin consent for the correct permissions:
1. Log on with a user that has administrative rights in Entra ID.
2. Run `Set-OutlookSignatures.ps1 -GraphOnly true`
3. When asked for credentials, provide your Entra ID admin credentials
4. For the required permissions, grant consent in the name of your organization

If you don't want to use custom Graph attributes or other advanced configurations, no more configuration in Microsoft Graph or Set-OutlookSignatures is required.

If you prefer using own application IDs or need advanced configuration, follow these steps:  
- In Entra ID, create a new application with the settings described in '`.\config\default graph config.ps1`'.
- In Set-OutlookSignatures, use '`.\config\default graph config.ps1`' as a template for a custom Graph configuration file
  - Set '`$GraphClientID`' to the application ID created by the Graph administrator before, or pass this value using the '`GraphClientID`' parameter.
  - Use the `GraphConfigFile` parameter to make the tool use the newly created Graph configuration file.


### 11.2. Advanced Configuration
The Graph configuration file allows for additional, advanced configuration:
- `$GraphEndpointVersion`: The version of the Graph REST API to use
- `$GraphUserProperties`: The properties to load for each graph user/mailbox. You can add custom attributes here.
- `$GraphUserAttributeMapping`: Graph and Active Directory attributes are not named identically. Set-OutlookSignatures therefore uses a "virtual" account. Use this hashtable to define which Graph attribute name is assigned to which attribute of the virtual account.  
The virtual account is accessible as `$ADPropsCurrentUser[…]` in `.\config\default replacement variables.ps1`, and therefore has a direct impact on replacement variables.


### 11.3. Authentication
In hybrid and cloud-only scenarios, Set-OutlookSignatures automatically tries multiple ways to authenticate the user. Silent methods, also known as non-interactive methods, are preferred as they are invisible to the user.
1. Silent via Integrated Windows Authentication without login hint  
This works in hybrid scenarios when you configured your hybrid connection in Entra Connect accordingly, and when the user is logged-on to a domain- or Entra-ID-joined computer with his domain credentials. The credentials of the currently logged-in user are used to access Microsoft Graph without any further user interaction.  
Integrated Windows Authentication only works for federated users (users created in Active Directory and then synced to Entra ID), not for managed users (users created in Entra ID and then synced to Entra ID).  
Integrated Windows Authentication only works for domains with the authentication type "federated". You can check the authentication type for your domains with the '`Get-MgDomain`' cmdlet from the Microsoft.Graph.Identity.DirectoryManagement PowerShell module.  
See '`https://aka.ms/msal-net-iwa`' for details.
2. Silent via Integrated Windows Authentication with login hint  
This is the same as the option before, but with a login hint taken from the last known successful authentication. Windows requires this in some scenarios.
3. Silent via Authentication Broker without login hint  
Like Integrated Windows Authentication, this method takes the currently logged-in user and tries to silently authenticate using the Authentication Broker.  
This allows silent authentication in environmentes where Integrated Windows Authentication is not an option, but users are logging on with their Entra ID account.
4. Silent via Authentication Broker with login hint  
The Authentication Broker of the operating system is asked to silently authenticate the user that was used to run Set-OutlookSignatures the last time.
5. Silent via refresh token  
Entra ID is directly asked to silently authenticate the user that was used to run Set-OutlookSignatures the last time. Technically, Entra ID is asked to validate a cached refresh token and to issue an access token.
6. Interactive via Authentication Broker  
The authentication broker of the operating system opens, asks which account to use and takes care of authentication.
7. Interactive via browser  
Authentication via browser. A default browser window with an "Authentication successful" message may open, it can be closed anytime. You can modify the browser message shown, see '.\config\default graph config.ps1' for details.

When all silent authentication methods fail, a dialog informs the user that Set-OutlookSignatures requires interactive authentication. You can change the text displayed in the dialog or disable the dialog using a custom graph configuration file. See '`.\config\default graph config.ps1`' for details and more options related to authentication against the Graph API.

No custom components are used, only the official Microsoft 365 authentication site, the user's default browser and the official Microsoft Authentication Library for .Net (MSAL.Net).

After successful authentication the refresh token is stored for later use by the silent authentication steps described above.
- On Windows, the file is encrypted using the system's Data Protection API (DPAPI) and saved in the file '`$(Join-Path -Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData)) -ChildPath '\Set-OutlookSignatures\MSAL.PS\MSAL.PS.msalcache.bin3')`'.
  - In the rare case that DPAPI is not available, Set-OutlookSignatures informs you and MSAL.Net saves the file unencrypted.
- On Linux, the refresh token is stored in the default keyring in the entry named 'Set-OutlookSignatures Microsoft Graph token via MSAL.Net'. If the default keyring is locked, the user is asked to unlock it (the message can be customized in 'default graph config.ps1').
  - Should the default keyring not be available, Set-OutlookSignatures informs you and MSAL.Net saves the refresh token in the file '`$(Join-Path -Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData)) -ChildPath '\Set-OutlookSignatures\MSAL.PS\MSAL.PS.msalcache.bin3')`'.
- On macOS, the refresh token is stored in the default keychain in the entry named 'Set-OutlookSignatures Microsoft Graph token via MSAL.Net'. If the default keychain is locked, the user is asked to unlock it (the message can be customized in 'default graph config.ps1').
  - Should the default keychain not be available, Set-OutlookSignatures informs you and MSAL.Net saves the refresh token in the file '`$(Join-Path -Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData)) -ChildPath '\Set-OutlookSignatures\MSAL.PS\MSAL.PS.msalcache.bin3')`'.

Set-OutlookSignatures always keeps you informed about where and how the token is stored, and how you can delete it to force re-authentication without using the cached refresh token:
- Windows
  - '`Encrypted file '$($cacheFilePath)', delete file to remove cached token`'
  - '`Unencrypted file '$($cacheFilePath)', delete file to remove cached token`'
- Linux
  - '`Encrypted default keyring entry 'Set-OutlookSignatures Microsoft Graph token via MSAL.Net', use keychain app to remove cached token`'
  - '`Unencrypted file '$($cacheFilePath)', delete file to remove cached token`'
- macOS
  - '`Encrypted default keychain entry 'Set-OutlookSignatures Microsoft Graph token via MSAL.Net', use 'security delete-generic-password "Set-OutlookSignatures Microsoft Graph token via MSAL.Net"' to remove cached token`'
  - '`Unencrypted file '$($cacheFilePath)', delete file to remove cached token`'

If you want to see more information around authentication, run Set-OutlookSignatures with the "-verbose" parameter.

If a user executes Set-OutlookSignatures on a client several times in succession and is asked for authentication each time:
- Run Set-OutlookSignatures with the "-verbose" parameter to see details about authentication.
- Check your MFA configuration and Conditional Access Policies in Entra ID. You may have not considered script access in your policies (you should see a hint to that in the error message displayed when run with "-verbose").
-	Ensure that Set-OutlookSignatures is run in the security context of the user, and not in another security context such as SYSTEM (which is a common mistake when using Intune remediation scripts).
- Ensure that the cache file or keyring/keychain entry is not deleted between separate runs of Set-OutlookSignatures for the same user on the same machine.


## 12. Simulation mode  
Simulation mode is enabled when the parameter `SimulateUser` is passed to the software. It answers the question `"What will the signatures look like for user A, when Outlook is configured for the mailboxes X, Y and Z?"`.

Simulation mode is useful for content creators and admins, as it allows to simulate the behavior of the software and to inspect the resulting signature files before going live. Such a dry-run is not only very helpful for running tests in the production environment without affecting anyone, it also greatly supports problem analysis.
  
In simulation mode, Outlook registry entries are not considered and nothing is changed in Outlook and Outlook on the web. The template files are handled just as during a real script run, but the signatures are only saved to the folder defined by the [AdditionalSignaturePath](/parameters#14-additionalsignaturepath) parameter.
  
[SimulateUser](/parameters#16-simulateuser) is a mandatory parameter for simulation mode. This value replaces the currently logged-in user. Use a logon name in the format 'Domain\User' or a Universal Principal Name (UPN, looks like an email address, but is not neecessarily one).

[SimulateMailboxes](/parameters#17-simulatemailboxes) is optional for simulation mode, although highly recommended. It is a comma separated list of email addresses replacing the list of mailboxes otherwise gathered from the registry.

[SimulateTime](/parameters#18-simulatetime) is optional for simulation mode. Simulating a certain time is helpful when time-based templates are used.

An example: Simulate user a@example.com with the additional mailbox x@example.com, and save the results to 'c:\test':

```
& .\Set-OutlookSignatures.ps1 -SimulateUser 'a@example.com' -SimulateMailboxes 'a@example.com', 'x@example.com' -AdditionalSignaturePath 'c:\test'
```

Also see '`.\sample code\SimulationModeHelper.ps1`' for sample code showing how to use simulation mode.