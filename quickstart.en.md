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
  <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="button sos-download-link is-link is-normal has-text-weight-bold  mtrcs-download">Download software</a>
  <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="sos-download-link mtrcs-download no-external-link-icon"><img src="https://img.shields.io/github/downloads/Set-OutlookSignatures/Set-OutlookSignatures/total?style=flat" alt="Downloads" loading="lazy"></a>
  <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/issues?q=" class="no-external-link-icon"><img src="https://img.shields.io/github/issues/Set-OutlookSignatures/Set-OutlookSignatures?style=flat" alt="Open issues" loading="lazy"></a>
</div>

## Step 2: One-time Preparations {#step-2}

<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>💻</span>
        <div>
          <p><b>Client and User</b></p>
          <p>Log on with a test user on Windows with Classic Outlook and Word. Running this on your primary account will overwrite signatures named <code>Formal</code> or <code>Informal</code> unless you use simulation mode, which is described later.</p>
          <p>Linux, macOS, and New Outlook require the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a> and Exchange Online hosting.</p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid LimeGreen;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🛡️</span>
        <div>
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
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>☁️</span>
        <div>
          <p><b>Create Entra ID app for Exchange Online</b></p>
          <p>Follow the instructions in <code>.\config\default graph config.ps1</code> for manual setup or have a "Global Administrator" or "Application Administrator" run the provided PowerShell command.</p>
{% highlight batch %}{% raw %}
powershell.exe -NoExit -File "c:\test\sample code\Create-EntraApp.ps1" -AppType "Set-OutlookSignatures" -AppName "Set-OutlookSignatures"
{% endraw %}{% endhighlight %}
          <p>For national or sovereign clouds, add the <a href="/parameters#cloudenvironment"><code>-CloudEnvironment</code></a> parameter.</p>
          <p>Check the required permissions in advance: You can find all the information you need about usage in the files themselves as well as in the chapter <a href="/details#security-considerations">Security considerations</a>.</p>
        </div>
      </div>
    </div>
  </div>
</div>

## Step 3: Run Set-OutlookSignatures {#step-3}

<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>☁️</span>
        <div>
          <p><b>Exchange Online / Hybrid</b></p>
{% highlight batch %}{% raw %}
powershell.exe -NoExit -File "c:\test\Set-OutlookSignatures.ps1" -GraphOnly true -GraphClientId "<Entra ID app client ID>"
{% endraw %}{% endhighlight %}
          <p><small><em><code>-GraphOnly true</code> ensures on-prem AD is ignored. Add the <a href="/parameters#cloudenvironment"><code>-CloudEnvironment</code></a> parameter if using a national or sovereign cloud.</em></small></p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🏢</span>
        <div>
          <p><b>Exchange On-Prem</b></p>
{% highlight batch %}{% raw %}
powershell.exe -NoExit -File "c:\test\Set-OutlookSignatures.ps1"
{% endraw %}{% endhighlight %}
        </div>
      </div>
    </div>
  </div>
  <div class="column is-full">
    <p><small><em>If the script fails to run, right-click Set-OutlookSignatures.ps1 > Properties > check Unblock.</em></small></p>
  </div>
</div>
<details>
  <summary class="has-text-weight-bold" style="cursor: pointer;">
    Click to see the output of a sample run
  </summary>
{% highlight batch %}{% raw %}
Start Set-OutlookSignatures
  Log file: 'C:\Users\bobbybusy\AppData\Local\Set-OutlookSignatures\Logs\Set-OutlookSignatures_Log.txt'
    Ignore log lines starting with 'PS>TerminatingError' or '>> TerminatingError' unless instructed otherwise.

Script notes
  Software: Set-OutlookSignatures
  Version : v4.31.0
  Web     : https://set-outlooksignatures.com
  License : See '.\LICENSE.txt' for details and copyright

Check parameters and script environment
  PowerShell: '5.1.26100.8655', 'Desktop', 'Microsoft Windows NT 10.0.26200.0'
  PowerShell bitness: 64-bit process on a 64-bit operating system
  Script path: 'C:\Demo\Set-OutlookSignatures\Set-OutlookSignatures.ps1'
  Invocation line: '& $ScriptToUse @params'
  Bound parameters: '{"OOFTemplatePath":"..\\Templates\\Out-of-Office DOCX","SignatureIniFile":"..\\Templates\\Signatures DOCX\\_Signatures.ini","ScriptProcessPriority":"High","UseHtmTemplates":false,"SignatureTemplatePath":"..\\Templates\\Signatures DOCX","OOFIniFile":"..\\Templates\\Out-of-Office DOCX\\_OOF.ini","WordProcessPriority":"High","BenefactorCircleID":"e8911c17-de30-0000-0000-000000000001","ReplacementVariableConfigFile":"..\\Config\\custom replacement variables.ps1","BenefactorCircleLicenseFile":"..\\License\\license.dll","GraphClientID":"2bee9349-d720-420a-853f-a93c8bbc2179","GraphOnly":true}'
  Unbound arguments: ''
  TrustsToCheckForGroups: '*'
  IncludeMailboxForestDomainLocalGroups: 'False'
  CloudEnvironment: 'Public'
  GraphClientID: '2bee9349-d720-420a-853f-a93c8bbc2179'
  GraphConfigFile: '.\config\default graph config.ps1'
  SignatureTemplatePath: '..\Templates\Signatures DOCX'
  SignatureIniFile: '..\Templates\Signatures DOCX\_Signatures.ini'
  SetCurrentUserOutlookWebSignature: 'True'
  SetCurrentUserOOFMessage: 'True'
  OOFTemplatePath: '..\Templates\Out-of-Office DOCX'
  OOFIniFile: '..\Templates\Out-of-Office DOCX\_OOF.ini'
  UseHtmTemplates: 'False'
  GraphOnly: 'True'
  SimulateAndDeploy: 'False'
  SimulateAndDeployGraphCredentialFile: ''
  ReplacementVariableConfigFile: '..\Config\custom replacement variables.ps1'
  VirtualMailboxConfigFile: ''
  MoveCSSInline: 'True'
  EmbedImagesInHtml: 'False'
  EmbedImagesInHtmlAdditionalSignaturePath: 'True'
  CreateRtfSignatures: 'False'
  CreateTxtSignatures: 'True'
  DocxHighResImageConversion: 'True'
  DeleteUserCreatedSignatures: 'False'
  DeleteScriptCreatedSignaturesWithoutTemplate: 'True'
  SignaturesForAutomappedAndAdditionalMailboxes: 'True'
  AdditionalSignaturePath: 'C:\Users\bobbybusy\Documents\Outlook Signatures'
  SimulateUser: ''
  SimulateMailboxes: ''
  SimulateTime: ''
  DisableRoamingSignatures: 'True'
  MirrorCloudSignatures: 'True'
  SignatureCollectionInDrafts: 'True'
  MailboxSpecificSignatureNames: 'False'
  WordProcessPriority: 'High' ('128')
  ScriptProcessPriority: 'High' ('128')
  BenefactorCircleLicenseFile: '..\License\license.dll'
  BenefactorCircleID: 'e8911c17-de30-0000-0000-000000000001'

Benefactor Circle license information
  Licensed to Benefactor Circle member
    Set-OutlookSignatures demo tenant
  License groups
    Domain EntraID, SID/Object ID 00000000-0000-0000-0000-000000000000, 100 recursive members
  License expiration date
    2099-12-31T23:59:59Z
  License version
    License version and script version match: v4.31.0
  License validity check
    License is valid

Loading and initializing dependencies
  QRCoder
  libphonenumber-csharp
  AddressFormatter

Get basic Outlook and Word information
  Outlook
    Set 'Send Pictures With Document' registry value to '1'
    Set 'DisableRoamingSignatures' registry value to '1'
    Registry version: 16.0
    File version: 16.0.20131.20126
    Bitness: x64
    Default profile: Outlook
    Is C2R Beta: False
    DisableRoamingSignatures: 1
    UseNewOutlook: False
  New Outlook
    Version: 1.2026.630.300
    Status: Ok
    UseNewOutlook: False
  Word
    Set 'DontUseScreenDpiOnOpen' registry value to '1'
    Registry version: 16.0
    File version: 16.0.20131.20126
    Bitness: x64

Get Outlook signature file path(s)
  'C:\Users\bobbybusy\AppData\Roaming\Microsoft\Signatures'

Enumerate domains
  Parameter GraphOnly set to 'True', ignore user's Active Directory in favor of Graph/Entra ID.

Get properties of currently logged-in user and assigned manager
  Currently logged-in user
    Enforcing Graph because at least one condition is true:
      GraphOnly is true: True
      GraphOnly is false, mailbox is in cloud, SetCurrentUserOOFMessage and/or SetCurrentUserOutlookWebSignature is true: False
      GraphOnly is false and on-prem AD properties of current user are empty: False
      New Outlook is used: False
      The only Benefactor Circle license group is in Entra ID: True
    Graph authentication
      Application (client) ID of the Entra ID app: 2bee9349-d720-420a-853f-a93c8bbc2179
      Load MSAL.PS
      Authentication against Graph
        Silent via Integrated Windows Authentication without login hint
          Failed: Failed to get user name.
        Silent via Integrated Windows Authentication with login hint
          Login hint: ''
          Failed: No login hint found before
        Silent via Authentication Broker without login hint
          Success: 'bobby.busy@setoutlooksignaturesdemo.onmicrosoft.com'
      Authentication against Exchange Online
        Silent via Integrated Windows Authentication without login hint
          Failed: Ignoring because login hint is available.
        Silent via Integrated Windows Authentication with login hint
          Login hint: 'bobby.busy@setoutlooksignaturesdemo.onmicrosoft.com'
          Failed: Integrated Windows Auth is not supported for managed users. See https://aka.ms/msal-net-iwa for details.
        Silent via Authentication Broker without login hint
          Failed: Ignoring because login hint is available.
        Silent via Authentication Broker with login hint
          Login hint: 'bobby.busy@setoutlooksignaturesdemo.onmicrosoft.com'
          Success: 'bobby.busy@setoutlooksignaturesdemo.onmicrosoft.com'
      The permissions of the Entra ID app are not configured ideally.
        Details: https://set-outlooksignatures.com/details#security-considerations
        Info: App does not use the preferred delegated permission Files.SelectedOperations.Selected from the optional set 'Files.SelectedOperations.Selected OR Files.Read.All'.
          Files.SelectedOperations.Selected is harder to implement but more secure.
      Graph token cache: Encrypted file 'C:\Users\bobbybusy\AppData\Local\Set-OutlookSignatures\MSAL.PS\MSAL.PS.msalcache.bin3'
    DistinguishedName:
    UserPrincipalName: bobby.busy@setoutlooksignaturesdemo.onmicrosoft.com
    Mail: bobby.busy@setoutlooksignaturesdemo.onmicrosoft.com
  Manager of currently logged-in user
    DistinguishedName:
    UserPrincipalName: alex.alien@setoutlooksignaturesdemo.onmicrosoft.com
    Mail: alex.alien@setoutlooksignaturesdemo.onmicrosoft.com

Get email addresses
  Get email addresses from Outlook
    Profile 'Outlook'
      bobby.busy@setoutlooksignaturesdemo.onmicrosoft.com
      alex.alien@setoutlooksignaturesdemo.onmicrosoft.com
      executiveboard.office@setoutlooksignaturesdemo.onmicrosoft.com (automapped or additional mailbox)

Get properties of each mailbox and its manager
  bobby.busy@setoutlooksignaturesdemo.onmicrosoft.com
    Search for mailbox user object in Graph
      DistinguishedName:
      UserPrincipalName: bobby.busy@setoutlooksignaturesdemo.onmicrosoft.com
      Mail: bobby.busy@setoutlooksignaturesdemo.onmicrosoft.com
      Manager: alex.alien@setoutlooksignaturesdemo.onmicrosoft.com
        DistinguishedName:
        UserPrincipalName: alex.alien@setoutlooksignaturesdemo.onmicrosoft.com
        Mail: alex.alien@setoutlooksignaturesdemo.onmicrosoft.com
      Get group membership of mailbox
  alex.alien@setoutlooksignaturesdemo.onmicrosoft.com
    Search for mailbox user object in Graph
      DistinguishedName:
      UserPrincipalName: alex.alien@setoutlooksignaturesdemo.onmicrosoft.com
      Mail: alex.alien@setoutlooksignaturesdemo.onmicrosoft.com
      Manager:
      Get group membership of mailbox
  executiveboard.office@setoutlooksignaturesdemo.onmicrosoft.com
    Search for mailbox user object in Graph
      DistinguishedName:
      UserPrincipalName: executiveboard.office@setoutlooksignaturesdemo.onmicrosoft.com
      Mail: execboard.office@setoutlooksignaturesdemo.onmicrosoft.com
      Manager:
      Get group membership of mailbox
  Parameter 'VirtualMailboxConfigFile' is not enabled, skipping task.

Sort mailbox list: User's primary mailbox, mailboxes in default Outlook profile, others
  Mail attribute of currently logged-in or simulated user: 'bobby.busy@setoutlooksignaturesdemo.onmicrosoft.com'
    Matching mailbox found
  Mailbox priority (highest to lowest)
    bobby.busy@setoutlooksignaturesdemo.onmicrosoft.com
    alex.alien@setoutlooksignaturesdemo.onmicrosoft.com
    execboard.office@setoutlooksignaturesdemo.onmicrosoft.com

Get all signature template files and categorize them
  Compare signature INI entries and file system
  Sort template files according to configuration
    'Informal.docx' (signature INI index #1)
      Common template (no group, email address or replacement variable allow tags specified)
      Default signature for replies and forwards
        defaultReplyFwd
    'Formal.docx' (signature INI index #2)
      Common template (no group, email address or replacement variable allow tags specified)
      Default signature for new emails
        defaultNew
    'Test all default replacement variables.docx' (signature INI index #3)
      Common template (no group, email address or replacement variable allow tags specified)
      Mailbox specific exclusions
        -:alex.alien@galactic.test
    'Formal HR.docx' (signature INI index #4)
      Outlook signature name: 'Formal'
      Group specific template
        Example-AD-Domain Name-of-HR-Group
          Not found
      Default signature for new emails
        defaultNew
    'Formal HR Christmas.docx' (signature INI index #5)
      Outlook signature name: 'Formal'
      Time based template
        202412100000-202501062359:
          Current DateTime is not in allowed range
        202512100000-202601062359:
          Current DateTime is not in allowed range
        202612100000-202701062359:
          Current DateTime is not in allowed range
        202712100000-202801062359:
          Current DateTime is not in allowed range
        202812100000-202901062359:
          Current DateTime is not in allowed range
        202912100000-203001062359:
          Current DateTime is not in allowed range
        203012100000-203101062359:
          Current DateTime is not in allowed range
        Current DateTime is not in allowed time ranges, ignore signature template
    'Informal Delegate.docx' (signature INI index #6)
      Outlook signature name: 'Informal Delegate alex.alien'
      Mailbox specific template
        alex.alien@galactic.test
      Mailbox specific exclusions
        -CURRENTUSER:alex.alien@galactic.test
      Default signature for replies and forwards
        defaultReplyFwd
    'Informal Delegate.docx' (signature INI index #7)
      Outlook signature name: 'Informal Delegate fenix.fish'
      Mailbox specific template
        fenix.fish@galactic.test
      Mailbox specific exclusions
        -CURRENTUSER:fenix.fish@galactic.test
      Default signature for replies and forwards
        defaultReplyFwd
    'Informal Delegate.docx' (signature INI index #8)
      Outlook signature name: 'Informal Delegate nat.nuts'
      Mailbox specific template
        nat.nuts@galactic.test
      Mailbox specific exclusions
        -CURRENTUSER:nat.nuts@galactic.test
      Default signature for replies and forwards
        defaultReplyFwd
    'Informal Shared.docx' (signature INI index #9)
      Outlook signature name: 'Informal executiveboard.office'
      Mailbox specific template
        executiveboard.office@galactic.test
      Mailbox specific exclusions
        -CurrentUser:executiveboard.office@galactic.test
      Default signature for replies and forwards
        defaultReplyFwd
    'Formal Shared.docx' (signature INI index #10)
      Outlook signature name: 'Formal executiveboard.office'
      Mailbox specific template
        executiveboard.office@galactic.test
      Mailbox specific exclusions
        -CurrentUser:executiveboard.office@galactic.test
      Default signature for new emails
        defaultNew
    'Formal Delegate.docx' (signature INI index #11)
      Outlook signature name: 'Formal Delegate alex.alien'
      Mailbox specific template
        alex.alien@galactic.test
      Mailbox specific exclusions
        -CURRENTUSER:alex.alien@galactic.test
      Default signature for new emails
        defaultNew
    'Formal Delegate.docx' (signature INI index #12)
      Outlook signature name: 'Formal Delegate fenix.fish'
      Mailbox specific template
        fenix.fish@galactic.test
      Mailbox specific exclusions
        -CURRENTUSER:fenix.fish@galactic.test
      Default signature for new emails
        defaultNew
    'Formal Delegate.docx' (signature INI index #13)
      Outlook signature name: 'Formal Delegate nat.nuts'
      Mailbox specific template
        nat.nuts@galactic.test
      Mailbox specific exclusions
        -CURRENTUSER:nat.nuts@galactic.test
      Default signature for new emails
        defaultNew

Get all OOF template files and categorize them
  Compare OOF INI entries and file system
  Sort template files according to configuration
    'Internal.docx' (OOF INI index #1)
      Common template (no group, email address or replacement variable allow tags specified)
      Default internal OOF message
        Internal
    'Internal no manager.docx' (OOF INI index #2)
      Common template (no group, email address or replacement variable allow tags specified)
      Replacement variable exclusions
        -:$CurrentUserManagerMail$
      Default internal OOF message
        Internal
    'External.docx' (OOF INI index #3)
      Common template (no group, email address or replacement variable allow tags specified)
      Default external OOF message
        External
    'External no manager.docx' (OOF INI index #4)
      Common template (no group, email address or replacement variable allow tags specified)
      Replacement variable exclusions
        -:$CurrentUserManagerMail$
      Default external OOF message
        External
    'Internal Executive Office Board members.docx' (OOF INI index #5)
      Group specific template
        EntraID example-group@galactic.test
          Not found
      Default internal OOF message
        Internal
    'External Executive Office Board members.docx' (OOF INI index #6)
      Group specific template
        Example-AD-Domain Example-Group-Name
          Not found
      Default external OOF message
        External

Start Word background process

Mailbox bobby.busy@setoutlooksignaturesdemo.onmicrosoft.com
  Mailbox is member of license group: True
  Extract SMTP addresses
  Calculate replacement variables
    'C:\Demo\Config\custom replacement variables.ps1'
    Export available images
  Download roaming signatures from Exchange Online
    Download possible, Upload/set defaults possible, enable verbose output for details
    'Formal' -> 'Formal'
    'Formal Delegate alex.alien' -> 'Formal Delegate alex.alien'
    'Formal executiveboard.office' -> 'Formal executiveboard.office'
    'Informal' -> 'Informal'
    'Informal Delegate alex.alien' -> 'Informal Delegate alex.alien'
    'Informal executiveboard.office' -> 'Informal executiveboard.office'
    'Test all default replacement variables' -> 'Test all default replacement variables'
  Process common templates
    'Informal.docx' (Signature INI index #1)
      Check permissions
        Allows
          Common: Template is classified as common template valid for all mailboxes
        Denies
          No group match for current mailbox, checking current user specific denies
          Group: Mailbox and current user are not member of any denied group
          No email address match for current mailbox, checking current user specific denies
          Email address: Mailbox and current user do not have any denied email address
          Replacement variable: No deny replacement variable evaluates to true
        Use template as there is at least one allow and no deny
      Outlook signature name: 'Informal'
      Create temporary file copy
      Replace non-picture variables
      Replace picture variables
      Export to HTM format
        Export high-res images
        Copy HTM image width and height attributes to style attribute
        Move CSS inline
        Remove empty CSS properties from style attributes
        Add marker to final HTM file
        Modify connected folder name
      Export to TXT format
      Upload signature to Exchange Online as roaming signature
        May take longer if images are not already embedded
        'd64551cd-116e-49de-a18b-fc9a9aa7d7bc' -> 'Informal'
      Copy signature files to 'C:\Users\bobbybusy\AppData\Roaming\Microsoft\Signatures'
      Remove temporary files
      Set signature as default for reply/forward messages (Outlook profile 'Outlook')
    'Formal.docx' (Signature INI index #2)
      Check permissions
        Allows
          Common: Template is classified as common template valid for all mailboxes
        Denies
          No group match for current mailbox, checking current user specific denies
          Group: Mailbox and current user are not member of any denied group
          No email address match for current mailbox, checking current user specific denies
          Email address: Mailbox and current user do not have any denied email address
          Replacement variable: No deny replacement variable evaluates to true
        Use template as there is at least one allow and no deny
      Outlook signature name: 'Formal'
      Create temporary file copy
      Replace non-picture variables
      Replace picture variables
      Export to HTM format
        Export high-res images
        Copy HTM image width and height attributes to style attribute
        Move CSS inline
        Remove empty CSS properties from style attributes
        Add marker to final HTM file
        Modify connected folder name
      Export to TXT format
      Upload signature to Exchange Online as roaming signature
        May take longer if images are not already embedded
        'cee4a7b9-3420-423c-af50-820c9cb93653' -> 'Formal'
      Copy signature files to 'C:\Users\bobbybusy\AppData\Roaming\Microsoft\Signatures'
      Remove temporary files
      Set signature as default for new messages (Outlook profile 'Outlook')
    'Test all default replacement variables.docx' (Signature INI index #3)
      Check permissions
        Allows
          Common: Template is classified as common template valid for all mailboxes
        Denies
          No group match for current mailbox, checking current user specific denies
          Group: Mailbox and current user are not member of any denied group
          No email address match for current mailbox, checking current user specific denies
          Email address: Mailbox and current user do not have any denied email address
          Replacement variable: No deny replacement variable evaluates to true
        Use template as there is at least one allow and no deny
      Outlook signature name: 'Test all default replacement variables'
      Create temporary file copy
      Replace non-picture variables
        Template contains much text, replacement may be slow
      Replace picture variables
        Warning: Template contains images or shapes configured as non-inline.
          Set the text wrapping to 'inline with text' to avoid email incompatibilities, such as incorrect positioning.
        Template contains many pictures, replacement may be slow
      Export to HTM format
        Export high-res images
        Copy HTM image width and height attributes to style attribute
        Move CSS inline
        Remove empty CSS properties from style attributes
        Add marker to final HTM file
        Modify connected folder name
      Export to TXT format
      Upload signature to Exchange Online as roaming signature
        May take longer if images are not already embedded
        '0117c845-abd4-46ef-8200-33637a8c7d99' -> 'Test all default replacement variables'
      Copy signature files to 'C:\Users\bobbybusy\AppData\Roaming\Microsoft\Signatures'
      Remove temporary files
  Process group specific templates
    'Formal HR.docx' (Signature INI index #4)
      Check permissions
        Allows
          No group match for current mailbox, checking current user specific allows
          Group: Mailbox and current user are not member of any allowed group
        Do not use template as there is no allow or at least one deny
  Process mailbox specific templates
    'Test all default replacement variables.docx' (Signature INI index #3)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Informal Delegate.docx' (Signature INI index #6)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Informal Delegate.docx' (Signature INI index #7)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Informal Delegate.docx' (Signature INI index #8)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Informal Shared.docx' (Signature INI index #9)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Formal Shared.docx' (Signature INI index #10)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Formal Delegate.docx' (Signature INI index #11)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Formal Delegate.docx' (Signature INI index #12)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Formal Delegate.docx' (Signature INI index #13)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
  Process replacementvariable specific templates
  Set default signature(s) in Outlook for the web
    Set default classic (not roaming) Outlook for the web signature
    Default signature for new emails: 'Formal'
    Default signature for replies and forwards: 'Informal'
    Using 'Formal' for classic Outlook for the web (only one signature possible).
    Set default roaming Outlook for the web signature(s)
      Default signature for new emails: 'Formal'
      Default signature for replies and forwarded emails: 'Informal'
  Process out-of-office (OOF) auto replies
    Process common templates
      'Internal.docx' (OOF INI index #1)
        Check permissions
          Allows
            Common: Template is classified as common template valid for all mailboxes
          Denies
            No group match for current mailbox, checking current user specific denies
            Group: Mailbox and current user are not member of any denied group
            No email address match for current mailbox, checking current user specific denies
            Email address: Mailbox and current user do not have any denied email address
            Replacement variable: No deny replacement variable evaluates to true
          Use template as there is at least one allow and no deny
      'Internal no manager.docx' (OOF INI index #2)
        Check permissions
          Allows
            Common: Template is classified as common template valid for all mailboxes
          Denies
            No group match for current mailbox, checking current user specific denies
            Group: Mailbox and current user are not member of any denied group
            No email address match for current mailbox, checking current user specific denies
            Email address: Mailbox and current user do not have any denied email address
            First replacement variable match: $CurrentUserManagerMail$ evaluates to true
          Do not use template as there is no allow or at least one deny
      'External.docx' (OOF INI index #3)
        Check permissions
          Allows
            Common: Template is classified as common template valid for all mailboxes
          Denies
            No group match for current mailbox, checking current user specific denies
            Group: Mailbox and current user are not member of any denied group
            No email address match for current mailbox, checking current user specific denies
            Email address: Mailbox and current user do not have any denied email address
            Replacement variable: No deny replacement variable evaluates to true
          Use template as there is at least one allow and no deny
      'External no manager.docx' (OOF INI index #4)
        Check permissions
          Allows
            Common: Template is classified as common template valid for all mailboxes
          Denies
            No group match for current mailbox, checking current user specific denies
            Group: Mailbox and current user are not member of any denied group
            No email address match for current mailbox, checking current user specific denies
            Email address: Mailbox and current user do not have any denied email address
            First replacement variable match: $CurrentUserManagerMail$ evaluates to true
          Do not use template as there is no allow or at least one deny
    Process group specific templates
      'Internal Executive Office Board members.docx' (OOF INI index #5)
        Check permissions
          Allows
            No group match for current mailbox, checking current user specific allows
            Group: Mailbox and current user are not member of any allowed group
          Do not use template as there is no allow or at least one deny
      'External Executive Office Board members.docx' (OOF INI index #6)
        Check permissions
          Allows
            No group match for current mailbox, checking current user specific allows
            Group: Mailbox and current user are not member of any allowed group
          Do not use template as there is no allow or at least one deny
    Process mailbox specific templates
    Process replacementvariable specific templates
      'Internal no manager.docx' (OOF INI index #2)
        Check permissions
          Allows
            Replacement variable: No allowed replacement variable evaluates to true
          Do not use template as there is no allow or at least one deny
      'External no manager.docx' (OOF INI index #4)
        Check permissions
          Allows
            Replacement variable: No allowed replacement variable evaluates to true
          Do not use template as there is no allow or at least one deny
    Convert final OOF templates to HTM format
      Internal OOF message: 'Internal.docx'
        Create temporary file copy
        Replace non-picture variables
        Replace picture variables
        Export to HTM format
          Export high-res images
          Copy HTM image width and height attributes to style attribute
          Move CSS inline
          Remove empty CSS properties from style attributes
          Add marker to final HTM file
          Modify connected folder name
        Remove temporary files
      External OOF message: 'External.docx'
        Create temporary file copy
        Replace non-picture variables
        Replace picture variables
        Export to HTM format
          Export high-res images
          Copy HTM image width and height attributes to style attribute
          Move CSS inline
          Remove empty CSS properties from style attributes
          Add marker to final HTM file
          Modify connected folder name
        Remove temporary files
    Set out-of-office (OOF) auto replies

Mailbox alex.alien@setoutlooksignaturesdemo.onmicrosoft.com
  Mailbox is member of license group: True
  Extract SMTP addresses
  Calculate replacement variables
    'C:\Demo\Config\custom replacement variables.ps1'
    Export available images
  Download roaming signatures from Exchange Online
    Download possible, Upload/set defaults possible, enable verbose output for details
    'Formal' -> 'Formal (alex.alien@setoutlooksignaturesdemo.onmicrosoft.com)'
    'Informal' -> 'Informal (alex.alien@setoutlooksignaturesdemo.onmicrosoft.com)'
  Process common templates
    'Informal.docx' (Signature INI index #1)
      Check permissions
        Allows
          Common: Template is classified as common template valid for all mailboxes
        Denies
          No group match for current mailbox, checking current user specific denies
          Group: Mailbox and current user are not member of any denied group
          No email address match for current mailbox, checking current user specific denies
          Email address: Mailbox and current user do not have any denied email address
          Replacement variable: No deny replacement variable evaluates to true
        Use template as there is at least one allow and no deny
      Outlook signature name: 'Informal'
      Signature INI index #1 already processed before with higher priority mailbox
        Not overwriting signature. Consider using parameter MailboxSpecificSignatureNames.
      Set signature as default for reply/forward messages (Outlook profile 'Outlook')
    'Formal.docx' (Signature INI index #2)
      Check permissions
        Allows
          Common: Template is classified as common template valid for all mailboxes
        Denies
          No group match for current mailbox, checking current user specific denies
          Group: Mailbox and current user are not member of any denied group
          No email address match for current mailbox, checking current user specific denies
          Email address: Mailbox and current user do not have any denied email address
          Replacement variable: No deny replacement variable evaluates to true
        Use template as there is at least one allow and no deny
      Outlook signature name: 'Formal'
      Signature INI index #2 already processed before with higher priority mailbox
        Not overwriting signature. Consider using parameter MailboxSpecificSignatureNames.
      Set signature as default for new messages (Outlook profile 'Outlook')
    'Test all default replacement variables.docx' (Signature INI index #3)
      Check permissions
        Allows
          Common: Template is classified as common template valid for all mailboxes
        Denies
          No group match for current mailbox, checking current user specific denies
          Group: Mailbox and current user are not member of any denied group
          First email address match: alex.alien@galactic.test (current mailbox)
          Replacement variable: No deny replacement variable evaluates to true
        Do not use template as there is no allow or at least one deny
  Process group specific templates
    'Formal HR.docx' (Signature INI index #4)
      Check permissions
        Allows
          No group match for current mailbox, checking current user specific allows
          Group: Mailbox and current user are not member of any allowed group
        Do not use template as there is no allow or at least one deny
  Process mailbox specific templates
    'Test all default replacement variables.docx' (Signature INI index #3)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Informal Delegate.docx' (Signature INI index #6)
      Check permissions
        Allows
          First email address match: alex.alien@galactic.test (current mailbox)
        Denies
          No group match for current mailbox, checking current user specific denies
          Group: Mailbox and current user are not member of any denied group
          No email address match for current mailbox, checking current user specific denies
          Email address: Mailbox and current user do not have any denied email address
          Replacement variable: No deny replacement variable evaluates to true
        Use template as there is at least one allow and no deny
      Outlook signature name: 'Informal Delegate alex.alien'
      Create temporary file copy
      Replace non-picture variables
      Replace picture variables
      Export to HTM format
        Export high-res images
        Copy HTM image width and height attributes to style attribute
        Move CSS inline
        Remove empty CSS properties from style attributes
        Add marker to final HTM file
        Modify connected folder name
      Export to TXT format
      Upload signature to Exchange Online as roaming signature
        Requirements are not met, see prior mailbox specific messages for details.
      Copy signature files to 'C:\Users\bobbybusy\AppData\Roaming\Microsoft\Signatures'
      Remove temporary files
      Set signature as default for reply/forward messages (Outlook profile 'Outlook')
    'Informal Delegate.docx' (Signature INI index #7)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Informal Delegate.docx' (Signature INI index #8)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Informal Shared.docx' (Signature INI index #9)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Formal Shared.docx' (Signature INI index #10)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Formal Delegate.docx' (Signature INI index #11)
      Check permissions
        Allows
          First email address match: alex.alien@galactic.test (current mailbox)
        Denies
          No group match for current mailbox, checking current user specific denies
          Group: Mailbox and current user are not member of any denied group
          No email address match for current mailbox, checking current user specific denies
          Email address: Mailbox and current user do not have any denied email address
          Replacement variable: No deny replacement variable evaluates to true
        Use template as there is at least one allow and no deny
      Outlook signature name: 'Formal Delegate alex.alien'
      Create temporary file copy
      Replace non-picture variables
      Replace picture variables
      Export to HTM format
        Export high-res images
        Copy HTM image width and height attributes to style attribute
        Move CSS inline
        Remove empty CSS properties from style attributes
        Add marker to final HTM file
        Modify connected folder name
      Export to TXT format
      Upload signature to Exchange Online as roaming signature
        Requirements are not met, see prior mailbox specific messages for details.
      Copy signature files to 'C:\Users\bobbybusy\AppData\Roaming\Microsoft\Signatures'
      Remove temporary files
      Set signature as default for new messages (Outlook profile 'Outlook')
    'Formal Delegate.docx' (Signature INI index #12)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Formal Delegate.docx' (Signature INI index #13)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
  Process replacementvariable specific templates

Mailbox execboard.office@setoutlooksignaturesdemo.onmicrosoft.com
  Mailbox is member of license group: True
  Extract SMTP addresses
  Calculate replacement variables
    'C:\Demo\Config\custom replacement variables.ps1'
    Export available images
  Download roaming signatures from Exchange Online
    Download possible, Upload/set defaults possible, enable verbose output for details
  Process common templates
    'Informal.docx' (Signature INI index #1)
      Check permissions
        Allows
          Common: Template is classified as common template valid for all mailboxes
        Denies
          No group match for current mailbox, checking current user specific denies
          Group: Mailbox and current user are not member of any denied group
          No email address match for current mailbox, checking current user specific denies
          Email address: Mailbox and current user do not have any denied email address
          Replacement variable: No deny replacement variable evaluates to true
        Use template as there is at least one allow and no deny
      Outlook signature name: 'Informal'
      Signature INI index #1 already processed before with higher priority mailbox
        Not overwriting signature. Consider using parameter MailboxSpecificSignatureNames.
    'Formal.docx' (Signature INI index #2)
      Check permissions
        Allows
          Common: Template is classified as common template valid for all mailboxes
        Denies
          No group match for current mailbox, checking current user specific denies
          Group: Mailbox and current user are not member of any denied group
          No email address match for current mailbox, checking current user specific denies
          Email address: Mailbox and current user do not have any denied email address
          Replacement variable: No deny replacement variable evaluates to true
        Use template as there is at least one allow and no deny
      Outlook signature name: 'Formal'
      Signature INI index #2 already processed before with higher priority mailbox
        Not overwriting signature. Consider using parameter MailboxSpecificSignatureNames.
    'Test all default replacement variables.docx' (Signature INI index #3)
      Check permissions
        Allows
          Common: Template is classified as common template valid for all mailboxes
        Denies
          No group match for current mailbox, checking current user specific denies
          Group: Mailbox and current user are not member of any denied group
          No email address match for current mailbox, checking current user specific denies
          Email address: Mailbox and current user do not have any denied email address
          Replacement variable: No deny replacement variable evaluates to true
        Use template as there is at least one allow and no deny
      Outlook signature name: 'Test all default replacement variables'
      Signature INI index #3 already processed before with higher priority mailbox
        Not overwriting signature. Consider using parameter MailboxSpecificSignatureNames.
  Process group specific templates
    'Formal HR.docx' (Signature INI index #4)
      Check permissions
        Allows
          No group match for current mailbox, checking current user specific allows
          Group: Mailbox and current user are not member of any allowed group
        Do not use template as there is no allow or at least one deny
  Process mailbox specific templates
    'Test all default replacement variables.docx' (Signature INI index #3)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Informal Delegate.docx' (Signature INI index #6)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Informal Delegate.docx' (Signature INI index #7)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Informal Delegate.docx' (Signature INI index #8)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Informal Shared.docx' (Signature INI index #9)
      Check permissions
        Allows
          First email address match: executiveboard.office@galactic.test (current mailbox)
        Denies
          No group match for current mailbox, checking current user specific denies
          Group: Mailbox and current user are not member of any denied group
          No email address match for current mailbox, checking current user specific denies
          Email address: Mailbox and current user do not have any denied email address
          Replacement variable: No deny replacement variable evaluates to true
        Use template as there is at least one allow and no deny
      Outlook signature name: 'Informal executiveboard.office'
      Create temporary file copy
      Replace non-picture variables
      Replace picture variables
      Export to HTM format
        Export high-res images
        Copy HTM image width and height attributes to style attribute
        Move CSS inline
        Remove empty CSS properties from style attributes
        Add marker to final HTM file
        Modify connected folder name
      Export to TXT format
      Upload signature to Exchange Online as roaming signature
        Requirements are not met, see prior mailbox specific messages for details.
      Copy signature files to 'C:\Users\bobbybusy\AppData\Roaming\Microsoft\Signatures'
      Remove temporary files
    'Formal Shared.docx' (Signature INI index #10)
      Check permissions
        Allows
          First email address match: executiveboard.office@galactic.test (current mailbox)
        Denies
          No group match for current mailbox, checking current user specific denies
          Group: Mailbox and current user are not member of any denied group
          No email address match for current mailbox, checking current user specific denies
          Email address: Mailbox and current user do not have any denied email address
          Replacement variable: No deny replacement variable evaluates to true
        Use template as there is at least one allow and no deny
      Outlook signature name: 'Formal executiveboard.office'
      Create temporary file copy
      Replace non-picture variables
      Replace picture variables
      Export to HTM format
        Export high-res images
        Copy HTM image width and height attributes to style attribute
        Move CSS inline
        Remove empty CSS properties from style attributes
        Add marker to final HTM file
        Modify connected folder name
      Export to TXT format
      Upload signature to Exchange Online as roaming signature
        Requirements are not met, see prior mailbox specific messages for details.
      Copy signature files to 'C:\Users\bobbybusy\AppData\Roaming\Microsoft\Signatures'
      Remove temporary files
    'Formal Delegate.docx' (Signature INI index #11)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Formal Delegate.docx' (Signature INI index #12)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
    'Formal Delegate.docx' (Signature INI index #13)
      Check permissions
        Allows
          No email address match for current mailbox, checking current user specific allows
          Email address: Mailbox and current user do not have any allowed email address
        Do not use template as there is no allow or at least one deny
  Process replacementvariable specific templates

Remove old signatures created by this script, which are no longer centrally available

Remove user-created signatures
  Parameter 'DeleteUserCreatedSignatures' is not enabled, skipping task.

Upload local signatures to Exchange Online as roaming signatures for current user
  Delete all signatures in the cloud
  Upload local signatures to the cloud
    May take longer if images are not already embedded
    'Formal' -> 'Formal'
    'Formal Delegate alex.alien' -> 'Formal Delegate alex.alien'
    'Formal executiveboard.office' -> 'Formal executiveboard.office'
    'Informal' -> 'Informal'
    'Informal Delegate alex.alien' -> 'Informal Delegate alex.alien'
    'Informal executiveboard.office' -> 'Informal executiveboard.office'
    'Test all default replacement variables' -> 'Test all default replacement variables'

Prepare data for Outlook add-in
  Required because Microsoft actively blocks Outlook add-ins from using roaming signatures
  Common preparations
  Benefactor Circle specific preparations
    Implement Benefactor Circle specific preparations

Create 'My signatures, powered by Set-OutlookSignatures Benefactor Circle' email draft for current user

Copy signatures to AdditionalSignaturePath
  'C:\Users\bobbybusy\Documents\Outlook Signatures'
  Embedding images

Clean-up

Log file
  'C:\Users\bobbybusy\AppData\Local\Set-OutlookSignatures\Logs\Set-OutlookSignatures_Log.txt'

Exit code
  Code: 0
  Description: Success.

End Set-OutlookSignatures
{% endraw %}{% endhighlight %}
</details>
<p><b>You now find three new signatures in Outlook, based on the integrated sample templates and the attributes of your own user:</b></p>
<ul>
  <li><b><code>Formal</code></b> is ideal for new emails to external recipients.</li>
  <li><b><code>Informal</code></b> is great for replies and forwards and for internal emails.</li>
  <li><b><code>Test all default replacement variables</code></b> gives you an overview of the integrated placeholders and a glimpse of what is possible for images and banners, phone number and address formatting.</li>
</ul>
<div class="columns is-multiline">
  <div class="column is-full">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>💡</span>
        <div>
          <p><b>Pro-Tip: Start Risk-Free with Simulation Mode</b></p>
          <p>If you lack Classic Outlook or want a zero-impact trial of the software, use <a href="/details#simulation-mode">Simulation Mode</a>: This mode creates the exact signatures for the simulated user as files on your disk, without modifying Outlook — the perfect way to verify your configuration without changing any system settings.</p>
          <p>Just add the parameter <code>-SimulateUser a@example.com -SimulateMailboxes a@example.com</code> and see the results in your <code>Documents\Outlook Signatures</code> folder.</p>
        </div>
      </div>
    </div>
  </div>
</div>

## Signatures From Included Sample Templates {#examples}
<p>Let's assume <b>Mr. Bobby Busy</b> works as a secretary in the <i>Office of the Executive Board</i> of <i>Galactic Experiences</i>. He has his own personal mailbox, sends mail on behalf of the CEO, <b>Ms. Alex Alien</b>, and can send as the <b>Exec Board Office</b> shared mailbox.</p>
<p>Company rules define that signatures must not only contain information about the mailbox sent from, but also about the real sender. With the default sample templates and configuration, this yields the following variants automatically:</p>
<div style="display: flex; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 0.75rem;">
  <div class="tabs is-toggle mb-0"><li class="is-active" data-target="sig-formal"><a>Formal</a></li></div>
  <div class="tabs is-toggle mb-0"><li data-target="sig-formal-alex"><a>Formal Delegate alex.alien</a></li></div>
  <div class="tabs is-toggle mb-0"><li data-target="sig-formal-exec"><a>Formal executiveboard.office</a></li></div>
  <div class="tabs is-toggle mb-0"><li data-target="sig-informal"><a>Informal</a></li></div>
  <div class="tabs is-toggle mb-0"><li data-target="sig-informal-alex"><a>Informal Delegate alex.alien</a></li></div>
  <div class="tabs is-toggle mb-0"><li data-target="sig-informal-exec"><a>Informal executiveboard.office</a></li></div>
  <div class="tabs is-toggle mb-0"><li data-target="sig-test-all"><a>Test all default replacement variables</a></li></div>
</div>
<div id="signature-gallery-content" class="p-4 has-background-white" style="border: 1px solid #dbdbdb; border-radius: 4px;">
  <div id="sig-formal" class="tab-content-panel has-text-black">
    <p><i>Formal: Full signature for personal mailbox of Bobby Busy</i></p>
    <iframe src="/assets/signatures from demo/Formal.htm" width="100%" style="border:none; overflow:hidden;"></iframe>
  </div>
  <div id="sig-formal-alex" class="tab-content-panel has-text-black is-hidden">
    <p><i>Formal Delegate alex.alien: Full signature for when Bobby sends on behalf of the CEO, Ms. Alex Alien</i></p>
    <iframe src="/assets/signatures from demo/Formal Delegate alex.alien.htm" width="100%" style="border:none; overflow:hidden;"></iframe>
  </div>
  <div id="sig-formal-exec" class="tab-content-panel has-text-black is-hidden">
    <p><i>Formal executiveboard.office: Full signature for when Bobby sends as the Executive Board Office shared mailbox</i></p>
    <iframe src="/assets/signatures from demo/Formal executiveboard.office.htm" width="100%" style="border:none; overflow:hidden;"></iframe>
  </div>
  <div id="sig-informal" class="tab-content-panel has-text-black is-hidden">
    <p><i>Informal: Short signature for personal mailbox (internal communication, external thread follow-ups)</i></p>
    <iframe src="/assets/signatures from demo/Informal.htm" width="100%" style="border:none; overflow:hidden;"></iframe>
  </div>
  <div id="sig-informal-alex" class="tab-content-panel has-text-black is-hidden">
    <p><i>Informal Delegate alex.alien: Short signature for when Bobby sends on behalf of the CEO, Ms. Alex Alien (internal communication, external thread follow-ups)</i></p>
    <iframe src="/assets/signatures from demo/Informal Delegate alex.alien.htm" width="100%" style="border:none; overflow:hidden;"></iframe>
  </div>
  <div id="sig-informal-exec" class="tab-content-panel has-text-black is-hidden">
    <p><i>Informal executiveboard.office: Short signature for when Bobby sends as the Executive Board Office shared mailbox (internal communication, external thread follow-ups)</i></p>
    <iframe src="/assets/signatures from demo/Informal executiveboard.office.htm" width="100%" style="border:none; overflow:hidden;"></iframe>
  </div>
  <div id="sig-test-all" class="tab-content-panel has-text-black is-hidden">
    <p><i>Test all default replacement variables: Shows all placeholders but also account pictures, conditional banners, QR codes and more</i></p>
    <iframe src="/assets/signatures from demo/Test all default replacement variables.htm" width="100%" style="border:none; overflow:hidden;"></iframe>
  </div>
</div>

<!-- JavaScript to handle the new wrapped button layout -->
<script>
  function resizeIframe(iframe) {
    if (iframe && iframe.contentWindow && iframe.contentWindow.document.body) {
      iframe.style.height = iframe.contentWindow.document.body.scrollHeight + 'px';
    }
  }

  // Look for any list item with a data-target attribute, regardless of its parent container
  const tabElements = document.querySelectorAll('[data-target]');

  tabElements.forEach(tab => {
    tab.addEventListener('click', () => {
      // 1. Toggle Active Class on the clicked element and remove from others
      tabElements.forEach(t => t.classList.remove('is-active'));
      tab.classList.add('is-active');

      // 2. Toggle Active Panel Visibility
      document.querySelectorAll('.tab-content-panel').forEach(panel => panel.classList.add('is-hidden'));
      const targetId = tab.dataset.target;
      const targetPanel = document.getElementById(targetId);
      targetPanel.classList.remove('is-hidden');

      // 3. Force Resize on the newly visible iframe
      const iframe = targetPanel.querySelector('iframe');
      resizeIframe(iframe);
    });
  });

  // Automatically adjust heights once the HTML files finish loading completely
  document.querySelectorAll('.tab-content-panel iframe').forEach(iframe => {
    iframe.addEventListener('load', () => {
      if (!iframe.closest('.tab-content-panel').classList.contains('is-hidden')) {
        resizeIframe(iframe);
      }
    });
  });
</script>

## Customize {#customize}

<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🎨</span>
        <div>
          <p><b>Deploy Your Own Templates</b></p>
          <p>Ready to move beyond samples? Copy <code>.\sample templates</code> to a new folder and start editing. We recommend following our <a href="/faq#folder-structure-recommendation">folder structure recommendation</a> to make future updates a breeze.</p>
          <p>Point the script to your new files using:</p>
{% highlight batch %}{% raw %}
[…] -SignatureTemplatePath "C:\Signatures\Templates" -SignatureIniFile "C:\Signatures\Templates\_Signatures.ini"
{% endraw %}{% endhighlight %}
          <p><small><em>Using HTML templates? Just add <code>-UseHtmTemplates true</code>.</em></small></p>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid LimeGreen;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🎯</span>
        <div>
          <p><b>Expand Your Reach</b></p>
          <p>Once your templates are ready, define who gets which signature.</p>
          <p>Control this centrally using template assignment and INI configuration – for example by assigning templates to mailboxes, groups or attributes, generating multiple variants from one template, and defining defaults for new emails and replies.</p>
          <p>Learn more:</p>
          <ul>
            <li><a href="/details#template-tags-and-ini-files">Template tags and INI files</a></li>
            <li><a href="/parameters">Parameters</a></li>
            <li><a href="/features">Full Feature List</a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>
<div class="columns is-multiline">
  <div class="column is-full">
    <div class="box has-background-white-bis has-text-black" style="border-top: 4px solid #ff3860;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.75em;">
        <span style="font-size: 1.5rem;">✨</span>
        <div>
          <p class="title is-4 has-text-black">Share your Success!</p>
          <p>Did you build something great? Whether it's a visually stunning email signature, clever out-of-office replies, custom replacement variables, or a unique third-party integration — <b>we want to see it.</b></p>
          <div>
            <p>We’re looking to feature:</p>
            <ul>
              <li>Final templates or unique design layouts.</li>
              <li>Creative Out-of-Office (OOF) reply examples.</li>
              <li>Snippets of custom logic or integration scripts.</li>
              <li>A brief testimonial about your experience with Set-OutlookSignatures or the Benefactor Circle add-on.</li>
            </ul>
          </div>
          <p><small><em>Optional: Include your name, role, company logo, or a photo to be featured in our community showcase!</em></small></p>
          <a href="/support" class="button is-danger is-outlined has-text-weight-bold">Get in touch & inspire others!</a>
        </div>
      </div>
    </div>
  </div>
</div>

<p id="remark-1" class="mt-6 is-italic has-text-centered">
  The <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle</span></a> license funds the open-source mission, ensuring the core engine remains free and peer-reviewable for the global community.
</p>
