---
layout: page
title: Frequently Asked Questions (FAQ)
subtitle: Topics that are addressed regularly
description: "Get answers to common Set-OutlookSignatures questions: setup, templates, deployment, roaming signatures, and advanced configuration."
page_id: "faq"
permalink: /faq/
---
<!-- omit in toc -->
## Many roads lead to Rome
<p>Set-OutlookSignatures is designed to be highly flexible and extensively configurable. Its transparent documentation reflects this versatility: Many configuration goals can be achieved in multiple ways.</p>
<p>This FAQ highlights common topics and clarifies typical points of confusion. If your question isn’t covered or you need tailored advice, additional resources are available:</p>
<p>
  <div class="buttons">
    <a href="/parameters/" class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-color: limegreen">Parameters</a>
    <a href="/support/" class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-color: limegreen">Support</a>
  </div>
</p>


<!-- omit in toc -->
## Frequently Asked Questions (FAQ)
- [1. Where can I find the changelog?](#1-where-can-i-find-the-changelog)
- [2. How can I contribute, propose a new feature or file a bug?](#2-how-can-i-contribute-propose-a-new-feature-or-file-a-bug)
- [3. How is the account of a mailbox identified?](#3-how-is-the-account-of-a-mailbox-identified)
- [4. How is the personal mailbox of the currently logged-in user identified?](#4-how-is-the-personal-mailbox-of-the-currently-logged-in-user-identified)
- [5. Which ports are required?](#5-which-ports-are-required)
- [6. Why is out-of-office abbreviated OOF and not OOO?](#6-why-is-out-of-office-abbreviated-oof-and-not-ooo)
- [7. Should I use .docx or .htm as file format for templates? Signatures in Outlook sometimes look different than my templates.](#7-should-i-use-docx-or-htm-as-file-format-for-templates-signatures-in-outlook-sometimes-look-different-than-my-templates)
- [8. How can I log the software output?](#8-how-can-i-log-the-software-output)
- [9. How can I get more script output for troubleshooting?](#9-how-can-i-get-more-script-output-for-troubleshooting)
- [10. How can I start the software only when there is a connection to Active Directory?](#10-how-can-i-start-the-software-only-when-there-is-a-connection-to-active-directory)
- [11. Can multiple script instances run in parallel?](#11-can-multiple-script-instances-run-in-parallel)
- [12. How do I start the software from the command line or a scheduled task?](#12-how-do-i-start-the-software-from-the-command-line-or-a-scheduled-task)
  - [12.1. Start Set-OutlookSignatures in hidden/invisible mode](#121-start-set-outlooksignatures-in-hiddeninvisible-mode)
- [13. How to create a shortcut to the software with parameters?](#13-how-to-create-a-shortcut-to-the-software-with-parameters)
- [14. What is the recommended approach for implementing the software?](#14-what-is-the-recommended-approach-for-implementing-the-software)
- [15. What is the recommended approach for custom configuration files?](#15-what-is-the-recommended-approach-for-custom-configuration-files)
- [16. Isn't a plural noun in the software name against PowerShell best practices?](#16-isnt-a-plural-noun-in-the-software-name-against-powershell-best-practices)
- [17. The software hangs at HTM/RTF export, Word shows a security warning!?](#17-the-software-hangs-at-htmrtf-export-word-shows-a-security-warning)
- [18. How to avoid blank lines when replacement variables return an empty string?](#18-how-to-avoid-blank-lines-when-replacement-variables-return-an-empty-string)
- [19. Is there a roadmap for future versions?](#19-is-there-a-roadmap-for-future-versions)
- [20. How to deploy signatures for "Send As", "Send On Behalf" etc.?](#20-how-to-deploy-signatures-for-send-as-send-on-behalf-etc)
- [21. Can I centrally manage and deploy Outook stationery with this script?](#21-can-i-centrally-manage-and-deploy-outook-stationery-with-this-script)
- [22. Why is dynamic group membership not considered on premises?](#22-why-is-dynamic-group-membership-not-considered-on-premises)
  - [22.1. Entra ID](#221-entra-id)
  - [22.2. Active Directory on premises](#222-active-directory-on-premises)
- [23. Why is no admin or user GUI available?](#23-why-is-no-admin-or-user-gui-available)
- [24. What if a user has no Outlook profile or is prohibited from starting Outlook?](#24-what-if-a-user-has-no-outlook-profile-or-is-prohibited-from-starting-outlook)
- [25. What if Outlook is not installed at all?](#25-what-if-outlook-is-not-installed-at-all)
- [26. What about the roaming signatures feature in Exchange Online?](#26-what-about-the-roaming-signatures-feature-in-exchange-online)
- [27. Why does the text color of my signature change sometimes?](#27-why-does-the-text-color-of-my-signature-change-sometimes)
- [28. How to make Set-OutlookSignatures work with Microsoft Purview Information Protection?](#28-how-to-make-set-outlooksignatures-work-with-microsoft-purview-information-protection)
- [29. Images in signatures have a different size than in templates, or a black background](#29-images-in-signatures-have-a-different-size-than-in-templates-or-a-black-background)
- [30. How do I alternate banners and other images in signatures?](#30-how-do-i-alternate-banners-and-other-images-in-signatures)
- [31. How can I deploy and run Set-OutlookSignatures using Microsoft Intune?](#31-how-can-i-deploy-and-run-set-outlooksignatures-using-microsoft-intune)
  - [31.1. Application package](#311-application-package)
  - [31.2. Remediation script](#312-remediation-script)
- [32. Why does Set-OutlookSignatures run slower sometimes?](#32-why-does-set-outlooksignatures-run-slower-sometimes)
  - [32.1. Windows power mode](#321-windows-power-mode)
  - [32.2. Malware protection](#322-malware-protection)
  - [32.3. Time of execution](#323-time-of-execution)
  - [32.4. Script and Word process priority](#324-script-and-word-process-priority)
- [33. Keep users from adding, editing and removing signatures](#33-keep-users-from-adding-editing-and-removing-signatures)
  - [33.1. Outlook](#331-outlook)
  - [33.2. Outlook Web](#332-outlook-web)
- [34. What is the recommended folder structure for script, license, template and config files?](#34-what-is-the-recommended-folder-structure-for-script-license-template-and-config-files)
- [35. How to disable the tagline in signatures?](#35-how-to-disable-the-tagline-in-signatures)
  - [35.1. Why the tagline?](#351-why-the-tagline)
  - [35.2. Not sure if Set-OutlookSignatures is the right solution for your company?](#352-not-sure-if-set-outlooksignatures-is-the-right-solution-for-your-company)
- [36. Why is the out-of-office assistant not activated automatically?](#36-why-is-the-out-of-office-assistant-not-activated-automatically)
- [37. When should I refer on-prem groups and when Entra ID groups?](#37-when-should-i-refer-on-prem-groups-and-when-entra-id-groups)
- [38. Why are signatures and out-of-office replies recreated even when their content has not changed?](#38-why-are-signatures-and-out-of-office-replies-recreated-even-when-their-content-has-not-changed)
- [39. Empty lines contain an underlined space character](#39-empty-lines-contain-an-underlined-space-character)
- [40. What about Microsoft turning off Exchange Web Services for Exchange Online?](#40-what-about-microsoft-turning-off-exchange-web-services-for-exchange-online)
- [41. Roaming signatures in Classic Outlook for Windows look different](#41-roaming-signatures-in-classic-outlook-for-windows-look-different)
- [42. Does it support cross-tenant access and Multitenant Organizations?](#42-does-it-support-cross-tenant-access-and-multitenant-organizations)
- [43. Can I change the case (uppercase/lowercase) of replacement variables in templates?](#43-can-i-change-the-case-uppercaselowercase-of-replacement-variables-in-templates)
- [44. What can I learn from the code of Set-OutlookSignatures?](#44-what-can-i-learn-from-the-code-of-set-outlooksignatures)
  - [44.1. Active Directory group membership enumeration without compromises](#441-active-directory-group-membership-enumeration-without-compromises)
  - [44.2. Microsoft Graph authentication and re-authentication](#442-microsoft-graph-authentication-and-re-authentication)
  - [44.3. Graph cross-tenant and multitenant-organization access](#443-graph-cross-tenant-and-multitenant-organization-access)
  - [44.4. Deploy and run software using desired state configuration (DSC)](#444-deploy-and-run-software-using-desired-state-configuration-dsc)
  - [44.5. Parallel code execution](#445-parallel-code-execution)
  - [44.6. Create desktop icons cross-platform](#446-create-desktop-icons-cross-platform)
  - [44.7. Create and configure apps in Entra ID, grant admin consent](#447-create-and-configure-apps-in-entra-id-grant-admin-consent)
  - [44.8. Test Active Directory trusts](#448-test-active-directory-trusts)
  - [44.9. Start only if working Active Directory connection is available](#449-start-only-if-working-active-directory-connection-is-available)
  - [44.10. Prohibit system sleep](#4410-prohibit-system-sleep)
  - [44.11. Detect exit signals](#4411-detect-exit-signals)
  - [44.12. Format phone numbers](#4412-format-phone-numbers)
  - [44.13. Format postal addresses](#4413-format-postal-addresses)
  - [44.14. Bringing hidden treasures to light](#4414-bringing-hidden-treasures-to-light)
  - [44.15. Detect and convert encodings](#4415-detect-and-convert-encodings)


## 1. Where can I find the changelog?
The changelog is located in the `.\docs` folder, along with other documents related to Set-OutlookSignatures.


## 2. How can I contribute, propose a new feature or file a bug?
If you have an idea for a new feature or have found a problem, please <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/issues">create an issue on GitHub</a>.

If you want to contribute code, please have a look at `.\docs\CONTRIBUTING` for a rough overview of the proposed process.


## 3. How is the account of a mailbox identified?
The legacyExchangeDN attribute is the preferred method to find the account of a mailbox, as this also works in specific scenarios where the mail and proxyAddresses attribute is not sufficient:
- Separate Active Directory forests for users and Exchange mailboxes: In this case, the mail attribute is usually set in the user forest, although there are no mailboxes in this forest.
- One common email domain across multiple Exchange organizations: In this case, the address book is very like synchronized between Active Directory forests by using contacts or mail-enabled users, which both will have the SMTP address of the mailbox in the proxyAddresses attribute.

The legacyExchangeDN search considers migration scenarios where the original legacyExchangeDN is only available as X500 address in the proxyAddresses attribute of the migrated mailbox, or where the the mailbox in the source system has been converted to a mail enabled user still having the old legacyExchangeDN attribute.

If Outlook does not have information about the legacyExchangeDN of a mailbox (for example, when accessing a mailbox via protocols such as POP3 or IMAP4), the account behind a mailbox is searched by checking if the email address of the mailbox can be found in the proxyAddresses attribute of an account in Active Directory/Graph.

If the account behind a mailbox is found, group membership information can be retrieved and group specific templates can be applied.
If the account behind a mailbox is not found, group membership cannot be retrieved, and group and replacement variable specific templates cannot be applied. Such mailboxes can still receive common and mailbox specific signatures and OOF messages.  


## 4. How is the personal mailbox of the currently logged-in user identified?
The personal mailbox of the currently logged-in user is preferred to other mailboxes, as it receives signatures first and is the only mailbox where the Outlook Web signature can be set.

The personal mailbox is found by simply checking if the Active Directory mail attribute of the currently logged-in user matches an SMTP address of one of the mailboxes connected in Outlook.

If the mail attribute is not set, the currently logged-in user's objectSID is compared with all the mailboxes' msExchMasterAccountSID. If there is exactly one match, this mailbox is used as primary one.
  
Please consider the following caveats regarding the mail attribute:  
- When Active Directory attributes are directly modified to create or modify users and mailboxes (instead of using Exchange Admin Center or Exchange Management Shell), the mail attribute is often not updated and does not match the primary SMTP address of a mailbox. Microsoft strongly recommends that the mail attribute matches the primary SMTP address.  
- When using linked mailboxes, the mail attribute of the linked account is often not set or synced back from the Exchange resource forest. Technically, this is not necessary. From an organizational point of view it makes sense, as this can be used to determine if a specific user has a linked mailbox in another forest, and as some applications (such as "scan to email") may need this attribute anyhow.  


## 5. Which ports are required?
For communication with the user's own Active Directory forest, trusted domains, and their sub-domains, the following ports are usually required:
- 88 TCP/UDP (Kerberos authentication)
- 389 TCP/UPD (LDAP)
- 636 TCP (LDAPS)
- 3268 TCP (Global Catalog)
- 3269 TCP (Global Catalog TLS)
- 49152-65535 TCP (high ports)

The client needs the following ports to access a SMB file share on a Windows server (see <a href="https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc731402(v=ws.11)">this Microsoft article</a> for details):
- 137 UDP
- 138 UDP
- 139 TCP
- 445 TCP

The client needs port 443 TCP to access a SharePoint document library. When not using SharePoint Online with Graph, firewalls and proxies must not block WebDAV HTTP extensions.  


## 6. Why is out-of-office abbreviated OOF and not OOO?
Back in the 1980s, Microsoft had a UNIX OS named Xenix… But read yourself <a href="https://techcommunity.microsoft.com/t5/exchange-team-blog/why-is-oof-an-oof-and-not-an-ooo/ba-p/610191">here</a>.  


## 7. Should I use .docx or .htm as file format for templates? Signatures in Outlook sometimes look different than my templates.
The software uses DOCX as default template format, as this is the easiest way to delegate the creation and management of templates to departments such as Marketing or Corporate Communications:  
- Not all Word formatting options are supported in HTML, which can lead to signatures looking a bit different than templates. For example:
  - Images may be placed at a different position in the signature compared to the template - this is because the Outlook HTML component only supports the "in line with text" text wrapping option, while Word offers more options.
  - When using a text style from the Word Styles Gallery, you still may want to set the font and its properties. Else, your fonts and formatting may adapt to identically named styles of the recipient. To avoid this, set the font manually, so that Word does not show "Calibri (Body)" or "Calibri (Heading)" in the font selection, but only "Calibri".
- On the other hand, the Outlook HTML renderer works better with templates in the DOCX format: The Outlook HTML renderer does not respect the HTML image tags "width" and "height" and displays all images in their original size. When using DOCX as template format, the images are resized when exported to the HTM format.
  
It is recommended to start with .docx as template format and to only use .htm when the template maintainers have really good HTML knowledge.

With the parameter `UseHtmTemplates`, the software searches for .htm template files instead of DOCX.

The requirements for .htm files these files are harder to fulfill as it is the case with DOCX files:  
- The template must have the file extension .htm, .html is not supported
- The template must be UTF-8 encoded (without BOM), or at least only contain UTF-8 compatible characters
- The character set must be set to UTF-8 with a meta tag: '`<meta http-equiv=Content-Type content="text/html; charset=utf-8">`'
- The template should be a single file, additional files and folders are not recommended (but possible, see below)
- Images can either reference a public URL, a relative local path (preferred) or be part of the template as Base64 encoded string
- When storing images in a relative local path:
  - Only one subfolder is allowed
  - The subfolder must be named '\<name of the HTM file without extension>\<suffix>'
    - The suffix must be one from the following list (as defined by Microsoft Office): '.files', '_archivos', '_arquivos', '_bestanden', '_bylos', '_datoteke', '_dosyalar', '_elemei', '_failid', '_fails', '_fajlovi', '_ficheiros', '_fichiers', '_file', '_files', '_fitxategiak', '_fitxers', '_pliki', '_soubory', '_tiedostot', '-Dateien', '-filer'
  - Example: The file 'My signature.htm' has images in the subfolder 'My signature.files'
  
Possible approaches for fulfilling these requirements are:  
- Design the template in a HTML editor that supports all features required  
- Design the template in Outlook  
  - Paste it into Word and save it as `"Website, filtered"`. The `"filtered"` is important here, as any other web format will not work.  
  - Run the resulting file through a script that converts the Word output to a single UTF-8 encoded (without BOM) HTML file. Alternatively, but not recommended, you can copy the .htm file and the associated folder containing images and other HTML information into the template folder.

The sample templates delivered with this script represent all possible formats:  
- `.\sample templates\Out-of-Office DOCX` and `.\sample templates\Signatures DOCX` contain templates in the DOCX format  
- `.\templates\Out-of-Office HTML` and `.\sample templates\Signatures HTML` contain templates in HTML format.  


## 8. How can I log the software output?
The software has a built-in logging option. Logs are saved in the folder '`$(Join-Path -Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData)) -ChildPath '\Set-OutlookSignatures\Logs')`', the files follow the naming scheme '`$("Set-OutlookSignatures_Log_yyyyMMddTHHmmssffff.txt")`', and files older than 14 days are deleted with every run.

To centrally define for which users or computers verbose logging should be enabled, you can use the following simple approach:

```
& '\\server\share\folder\Set-OutlookSignatures.ps1' -verbose:$(([Environment]::UserName -iin @('UserA', 'UserB')) -or ([Environment]::MachineName -iin @('ComputerA', 'ComputerB')))
```

If you want your own additional logging, you can, for example, use PowerShell's `Start-Transcript` and `Stop-Transcript` commands to create a logging wrapper around Set-OutlookSignatures.ps1:

```
Start-Transcript -LiteralPath 'c:\path\to\your\logfile.txt'

& '\\server\share\folder\Set-OutlookSignatures.ps1' # Optionally add: -verbose:$(([Environment]::UserName -iin @('UserA', 'UserB')) -or ([Environment]::MachineName -iin @('ComputerA', 'ComputerB')))

Stop-Transcript
```


## 9. How can I get more script output for troubleshooting?
Start the software with the '-verbose' parameter to get the maximum output for troubleshooting.


## 10. How can I start the software only when there is a connection to Active Directory?
Per default, Set-OutlookSignatures tries to get the required information from Active Directory. When no Active Directory server can be reached, the Graph API is used to get the required information from Entra ID.

To use only Entra ID, you set the '`GraphOnly`' parameter to '`true`'.

There is no direct way to disable the use of Entra ID. When you do not have Entra ID but run Set-OutlookSignatures when there is (yet) no connection to Active Directory, this can lead to users complaining about pop-up windows regarding authentication because no Entra ID app has been set-up yet. This can also be required when Set-OutlookSignatures is run every time a VPN connection is established, but the client firewall is too slow opening the required ports.

With the code from '`.\sample code\Start-IfADAvailable.ps1`', you can make sure that Set-OutlookSignatures is only run when a connection to Active Directory is available.


## 11. Can multiple script instances run in parallel?
The software is designed for being run in multiple instances at the same. You can combine any of the following scenarios:  
- One user runs multiple instances of the software in parallel  
- One user runs multiple instances of the software in simulation mode in parallel  
- Multiple users on the same machine (e.g. Terminal Server) run multiple instances of the software in parallel  

Please see `.\sample code\SimulateAndDeploy.ps1` for an example how to run multiple instances of Set-OutlookSignatures in parallel in a controlled manner. Don't forget to adapt path names and variables to your environment.


## 12. How do I start the software from the command line or a scheduled task?
Passing arguments to PowerShell.exe from the command line or task scheduler can be very tricky when spaces are involved. You have to be very careful about when to use single quotes or double quotes.

A working example:

```
PowerShell.exe -Command "& '\\server\share\directory\Set-OutlookSignatures.ps1' -SignatureTemplatePath '\\server\share\directory\templates\Signatures DOCX' -OOFTemplatePath '\\server\share\directory\templates\Out-of-Office DOCX' -ReplacementVariableConfigFile '\\server\share\directory\config\default replacement variables.ps1'"
```

You will find lots of information about this topic on the internet. The following links provide a first starting point:  
- <a href="https://stackoverflow.com/questions/45760457/how-can-i-run-a-powershell-script-with-white-spaces-in-the-path-from-the-command">https://stackoverflow.com/questions/45760457/how-can-i-run-a-powershell-script-with-white-spaces-in-the-path-from-the-command</a>
- <a href="https://stackoverflow.com/questions/28311191/how-do-i-pass-in-a-string-with-spaces-into-powershell">https://stackoverflow.com/questions/28311191/how-do-i-pass-in-a-string-with-spaces-into-powershell</a>
- <a href="https://stackoverflow.com/questions/10542313/powershell-and-schtask-with-task-that-has-a-space">https://stackoverflow.com/questions/10542313/powershell-and-schtask-with-task-that-has-a-space</a>
  
If you have to use the PowerShell.exe `-Command` or `-File` parameter depends on details of your configuration, for example AppLocker in combination with PowerShell. You may also want to consider the `-EncodedCommand` parameter to start Set-OutlookSignatures.ps1 and pass parameters to it.
  
If you provided your users a link so they can start Set-OutlookSignatures.ps1 with the correct parameters on their own, you may want to use the official icon: `.\logo\Set-OutlookSignatures Icon.ico`

Please see `.\sample code\Set-OutlookSignatures.cmd` for an example. Don't forget to adapt path names to your environment.

### 12.1. Start Set-OutlookSignatures in hidden/invisible mode
Even when the `hidden` parameter is passed to PowerShell, a window is created and minimized. Although this only takes some tenths of a second, it is not only optically disturbing, but the new window may also steal the keyboard focus.

The only workaround is to start PowerShell from another program, which does not need an own console window. Some examples for such programs are:
- Rob van der Woude's <a href="https://www.robvanderwoude.com/csharpexamples.php#RunNHide">RunNHide</a>
- NTWind Software's <a href="https://www.ntwind.com/software/hstart.html">HStart</a>
- wenshui2008's <a href="https://github.com/wenshui2008/RunHiddenConsole">RunHiddenConsole</a>
- stax76's <a href="https://github.com/stax76/run-hidden">run-hidden</a>
- Nir Sofer's <a href="https://www.nirsoft.net/utils/nircmd.html">NirCmd</a>
- As Microsoft has marked Visual Basic Script (VBS) as deprecated and will remove it completely from future Windows releases, the use of Windows Script Host (WSH) is not recommended. If you want to try it anyway, here is a working example:
  - Create a .vbs (Visual Basic Script) file, paste and adapt the following code into it:

    ```
    command = "PowerShell.exe -Command ""& '\\server\share\directory\Set-OutlookSignatures.ps1' -SignatureTemplatePath '\\server\share\directory\templates\Signatures DOCX' -OOFTemplatePath '\\server\share\directory\templates\Out-of-Office DOCX' -ReplacementVariableConfigFile '\\server\share\directory\config\default replacement variables.ps1'"" "

    set shell = CreateObject("WScript.Shell")

    shell.Run command, 0
    ```

  - Then, run the .vbs file directly, without specifying cscript.exe as host (just execute `start.vbs` or `wscript.exe start.vbs`, but not `cscript.exe start.vbs`).
- If your Windows installation comes with the '`conhost.exe`' console host, you may want to try one of its undocumented parameters:

  ```
  conhost.exe --headless powershell.exe -File "\\server\share\directory\Set-OutlookSignatures.ps1" -SignatureTemplatePath "\\server\share\directory\templates\Signatures DOCX" -OOFTemplatePath "\\server\share\directory\templates\Out-of-Office DOCX" -ReplacementVariableConfigFile "\\server\share\directory\config\default replacement variables.ps1"
  ```


## 13. How to create a shortcut to the software with parameters?
You may want to provide a link on the desktop or in the start menu, so they can start the software on their own.

The Windows user interface does not allow you to create a shortcut with a combined length of full target path and arguments greater than 259 characters.

You can overcome this user interface limitation by using PowerShell to create a shortcut (.lnk file). See '`.\sample code\Create-DesktopIcon.ps1`' for a cross-platform example.

**Attention**: When editing the shortcut created with the code above in the Windows user interface, the command to be executed is shortened to 259 characters without further notice. This already happens when just opening the properties of the created .lnk file, changing nothing and clicking OK.

See `.\sample code\CreateDesktopIcon.ps1` for a code example. Don't forget to adapt path names to your environment. 


## 14. What is the recommended approach for implementing the software?
The Quick Start Guide in this document is a good overall starting point for beginners.

For the organizational aspects around Set-OutlookSignatures, read the "Implementation Approach" document. The content is based on real life experiences implementing the software in multi-client environments with a five-digit number of mailboxes.

It contains proven procedures and recommendations for product managers, architects, operations managers, account managers and email and client administrators. It is suited for service providers as well as for clients.

It covers several general overview topics, administration, support, training across the whole lifecycle from counselling to tests, pilot operation and rollout up to daily business.

The document is available in English and German language.  


## 15. What is the recommended approach for custom configuration files?
You should not change the default configuration files `.\config\default replacement variable.ps1` and `.\config\default graph config.ps1`, as they might be changed in a future release of Set-OutlookSignatures. In this case, you would have to sort out the changes yourself.

The following steps are recommended:
1. Create a new custom configuration file in a separate folder.
2. The first step in the new custom configuration file should be to load the default configuration file, `.\config\default replacement variable.ps1` in this example:

   ```
   # Loading default replacement variables shipped with Set-OutlookSignatures
   . ([System.Management.Automation.ScriptBlock]::Create((Get-Content -LiteralPath $(Join-Path -Path $(Get-Location).ProviderPath -ChildPath '\config\default replacement variables.ps1') -Raw)))
   ```

3. After importing the default configuration file, existing replacement variables can be altered with custom definitions and new replacement variables can be added.
4. Start Set-OutlookSignatures with the parameter `ReplacementVariableConfigFile` pointing to the new custom configuration file.


## 16. Isn't a plural noun in the software name against PowerShell best practices?
Absolutely. PowerShell best practices recommend using singular nouns, but Set-OutlookSignatures contains a plural noun.

We intentionally decided not to follow the singular noun convention, as another language as PowerShell was initially used for coding and the name of the tool was already defined. If this was a commercial enterprise project, marketing would have overruled development.


## 17. The software hangs at HTM/RTF export, Word shows a security warning!?
When using a signature template with account pictures (linked and embedded), conversion to HTM hangs at "Export to HTM format" or "Export to RTF format". In the background, there is a window "Microsoft Word Security Notice" with the following text:

> Microsoft Office has identified a potential security concern.  
> 
> This document contains fields that can share data with external files and websites. It is important that this file is from a trustworthy source.

The message seems to come from a new security feature of Word versions published around August 2021. You will find several discussions regarding the message in internet forums, but we are not aware of any official statement from Microsoft.

The behavior can be changed in at least two ways:
- Group Policy: Enable "User Configuration\Administrative Templates\Microsoft Word 2016\Word Options\Security\Don’t ask permission before updating IncludePicture and IncludeText fields in Word"
- Registry: Set "HKCU\SOFTWARE\Microsoft\Office\16.0\Word\Security\DisableWarningOnIncludeFieldsUpdate" (DWORD_32) to 1

Set-OutlookSignatures reads the registry key `HKCU\SOFTWARE\Microsoft\Office\<current Word version>\Word\Security\DisableWarningOnIncludeFieldsUpdate` at start, sets it to 1 just before a conversion to HTM or RTF takes place and restores the original state as soon as the conversion is finished.

This way, the warning usually gets suppressed.

Be aware that this does not work when the setting is configured via group policies, as group policy settings are prioritized over user configured settings.


## 18. How to avoid blank lines when replacement variables return an empty string?
Not all users have values for all attributes, e. g. a mobile number. These empty attributes can lead to blank lines in signatures, which may not look nice.

Follow these steps to avoid blank lines:
1. Use a custom replacement variable config file.
2. Modify the value of all attributes that should not leave an blank line when there is no text to show:
    - When the attribute is empty, return an empty string
    - Else, return a newline (`Shift+Enter` in Word, `` `n `` in PowerShell, `<br>` in HTML) or a paragraph mark (`Enter` in Word, `` `r`n `` in PowerShell, `<p>` in HTML), and then the attribute value.  
3. Place all required replacement variables on a single line, without a space between them. The replacement variables themselves contain the required newline or paragraph marks.
4. Use the ReplacementVariableConfigFile parameter when running the software.

Be aware that text replacement also happens in hyperlinks (`tel:`, `mailto:` etc.).  
Instead of altering existing replacement variables, it is recommended to create new replacement variables with modified content.  
Use the new one for the pure textual replacement (including the newline), and the original one for the replacement within the hyperlink.  

The following example describes optional preceeding text combined with an optional replacement variable containing a hyperlink.  
The internal variable `$UseHtmTemplates` is used to automatically differentiate between DOCX and HTM line breaks.
- Custom replacement variable config file

  ```
  $ReplaceHash['$CurrentUserTelephone-prefix-noempty$'] = $(if (-not $ReplaceHash['$CurrentUserTelephone$']) { '' } else { $(if ($UseHtmTemplates) { '<br>' } else { "`n" }) + 'Telephone: ' } )
  
  $ReplaceHash['$CurrentUserMobile-prefix-noempty$'] = $(if (-not $ReplaceHash['$CurrentUserMobile$']) { '' } else { $(if ($UseHtmTemplates) { '<br>' } else { "`n" }) + 'Mobile: ' } )
  ```

- Word template:  
  <pre><code>email: <a href="mailto:$CurrentUserMail$">$CurrentUserMail$</a>$CurrentUserTelephone-prefix-noempty$<a href="tel:$CurrentUserTelephone$">$CurrentUserTelephone$</a>$CurrentUserMobile-prefix-noempty$<a href="tel:$CurrentUserMobile$">$CurrentUserMobile$</a></code></pre>

  Note that all variables are written on one line and that not only `$CurrentUserMail$` is configured with a hyperlink, but `$CurrentUserPhone$` and `$CurrentUserMobile$` too:
  - `mailto:$CurrentUserMail$`
  - `tel:$CurrentUserTelephone$`
  - `tel:$CurrentUserMobile$`
- Results
  - Telephone number and mobile number are set.  
  The paragraph marks come from `$CurrentUserTelephone-prefix-noempty$` and `$CurrentUserMobile-prefix-noempty$`.  
    <pre><code>email: <a href="mailto:first.last@example.com">first.last@example.com</a>
    Telephone: <a href="tel:+43xxx">+43xxx</a>
    Mobile: <a href="tel:+43yyy">+43yyy</a></code></pre>
  - Telephone number is set, mobile number is empty.  
  The paragraph mark comes from `$CurrentUserTelephone-prefix-noempty$`.  
    <pre><code>email: <a href="mailto:first.last@example.com">first.last@example.com</a>
    Telephone: <a href="tel:+43xxx">+43xxx</a></code></pre>
  - Telephone number is empty, mobile number is set.  
  The paragraph mark comes from `$CurrentUserMobile-prefix-noempty$`.  
    <pre><code>email: <a href="mailto:first.last@example.com">first.last@example.com</a>
    Mobile: <a href="tel:+43yyy">+43yyy</a></code></pre>


## 19. Is there a roadmap for future versions?
There is no binding roadmap for future versions, although we maintain a list of ideas in the 'Contribution opportunities' chapter of '.\docs\CONTRIBUTING'.

Fixing issues has priority over new features, of course.


## 20. How to deploy signatures for "Send As", "Send On Behalf" etc.?
The software only considers primary mailboxes, these are mailboxes added as separate accounts. This is the same way Outlook handles mailboxes from a signature perspective: Outlook cannot handle signatures for non-primary mailboxes (added via "Open these additional mailboxes").

If you want to deploy signatures for non-primary mailboxes, set the parameter `SignaturesForAutomappedAndAdditionalMailboxes` to `true` to allow the software to detect automapped and additional mailboxes. Signatures can be deployed for these types of mailboxes, but they cannot be set as default signatures due to technical restrictions in Outlook.

If you want to deploy signatures for
- mailboxes you don't add to Outlook but just use an assigned "Send As" or "Send on Behalf" right by choosing a different "From" address,
- distribution lists, for which you use an assigned "Send As" or "Send on Behalf" right by choosing a different "From" address,

create a group specific signature, where the group does not refer to the mailbox or distribution group the email is sent from, but rather the user or group who has the right to send from this mailbox or distribution group.

An example:
Members of the group "Example\Group" have the right to send as mailbox m<area>@example.com and as the distribution group dg<area>@example.com.

You want to deploy signatures for the mailbox m<area>@example.com and the distribution group dg<area>@example.com.
- Problem 1: dg<area>@example.com can't be added as a mailbox to Outlook, as it is a distribution group.
- Problem 2: The mailbox m<area>@example.com is configured as non-primary maibox on most clients, because most of the users have the "Send as" permission, but not the "Full Access" permissions. Some users even don't connect the mailbox at all, they just choose m<area>@example.com as "From" address.

**Solution option A**  
Create signature templates for the mailbox m<area>@example.com and the distribution group dg<area>@example.com and **assign them to the group that has been granted the "send as" permission**:

```
[External English formal m@example.com.docx]
Example Group

[External English formal dg@example.com.docx]
Example Group
```

This works as long as the personal mailbox of a member of "Example\Group" is connected in Outlook as primary mailbox (which usually is the case). When this personal mailbox is processed by Set-OutlookSignatures, the software recognizes the group membership and the signature assigned to it.

Caveat: The `$CurrentMailbox[…]$` replacement variables refer to the user's personal mailbox in this case, not to m<area>@example.com.

**Solution option B**  
This option only works for mailboxes, not for distribution groups.

Create signature templates for the mailbox m<area>@example.com and **assign them to m<area>@example.com**. Use the virtual mailbox feature of the Benefactor Circle add-on to make sure that m<area>@example.com is always treated as if it were added to Outlook, not matter if it has been added or not (see '`VirtualMailboxConfigFile`' in this document for details).

```
[External English formal SendAs m@example.com.docx]
m@example.com
## Do not deploy the signature if m@example.com is the personal mailbox of the logged-on user
-CURRENTUSER:m@example.com
```

You can now use replacement variables of both the `$CurrentUser[…]$` and the `$CurrentMailbox[…]$` namespace.

Hint: You can also use the VirtualMailboxConfigFile to dynamically define signature INI file entries. See '`VirtualMailboxConfigFile`' in this document for details.


## 21. Can I centrally manage and deploy Outook stationery with this script?
Outlook stationery describes the layout of emails, including font size and color for new emails and for replies and forwards.

The default email font, size and color are usually an integral part of corporate design and corporate identity. CI/CD typically also defines the content and layout of signatures.

Set-OutlookSignatures has no features regarding deploying Outlook stationery, as there are better ways for doing this.  
Outlook stores stationery settings in `HKCU\Software\Microsoft\Office\<Version>\Common\MailSettings`. You can use a logon script or group policies to deploy these keys, on-prem and for managed devices in the cloud.  
Unfortunately, Microsoft's group policy templates (ADMX files) for Office do not seem to provide detailed settings for Outlook stationery, so you will have to deploy registry keys. 


## 22. Why is dynamic group membership not considered on premises?
Membership in dynamic groups, no matter if they are of the security or distribution type, is considered only when using Microsoft Graph.

Dynamic group membership is not considered when using an on premises Active Directory. 

The reason for this is that Graph and on-prem AD handle dynamic group membership differently:

### 22.1. Entra ID
Entra ID caches information about dynamic group membership at the group as well as at the user level. It regularly runs the LDAP queries defining dynamic groups and updates existing attributes with member information.

Dynamic groups in Entra ID are therefore not strictly dynamic in terms of running the defining LDAP query every time a dynamic group is used and thus providing near real-time member information - they behave more like regularly updated static groups, which makes handling for scripts and applications much easier.

For the use in Set-OutlookSignatures, there is no difference between a static and a dynamic group in Entra ID:
- Querying the `transitiveMemberOf` attribute of a user returns static as well as dynamic group membership.
- Querying the `members` attribute of a group returns the group's members, no matter if the group is static or dynamic.

### 22.2. Active Directory on premises
Active Directory on premises does not cache any information about membership in dynamic groups at the user level, so dynamic groups do not appear in attributes such as `memberOf` and `tokenGroups`.

Active Directory on premises also does not cache any information about members of dynamic groups at the group level, so the group attribute `members` is always empty.

If dynamic groups would have to be considered, the only way would be to enumerate all dynamic groups, to run the LDAP query that defines each group, and to finally evaluate the resulting group membership.  
The LDAP queries defining dynamic groups are deemed expensive due to the potential load they put on Active Directory and their resulting runtime.  
Microsoft does not recommend against dynamic groups on-prem, only not to use them heavily.  
This is very likely the reason why dynamic groups cannot be granted permissions on Exchange mailboxes and other Exchange objects, and why each dynamic group can be assigned an expansion server executing the LDAP query (expansion times of 15 minutes or more are not rare in the field).

Taking all these aspects into account, Set-OutlookSignatures will not consider membership in dynamic groups on premises until a reliable and efficient way of querying a user's dynamic group membership is available.

A possible way around this restriction is replacing dynamic groups with regularly updated static groups (which is what Entra ID does automatically in the background):
- An Identity Management System (IDM) or a script regularly executes the LDAP query, which would otherwise define a dynamic group, and updates the member list of a static group.
- These updates usually happen less frequent than a dynamic group is used. The static group might not be fully up-to-date when used, but other aspects outweigh this disadvantage most of the time:
  - Reduced load on Active Directory (partially transferred to IDM system or server running a script)
  - Static groups can be used for permissions
  - Changes in static group membership can be documented more easily
  - Static groups can be expanded to its members in email clients
  - Membership in static groups can easily be queried
  - Overcoming query parameter restrictions, such as combining the results of multiple LDAP queries


## 23. Why is no admin or user GUI available?
From an admin perspective, Set-OutlookSignatures has been designed to work with on-board tools wherever possible and to make managing and deploying signatures intuitive.

This "easy to set up, easy to understand, easy to maintain" approach is why
- there is no need for a dedicated server, a database or a setup program
- Word documents are supported as templates in addition to HTML templates
- there is the clear hierarchy of common, group specific and email address specific template application order

For an admin, the most complicated part is bringing Set-OutlookSignatures to his users by integrating it into the logon script, deploy a desktop icon or start menu entry, or creating a scheduled task. Alternatively, an admin can use a signature deployment method without user or client involvement.  
Both tasks are usually neccessary only once, sample code and documentation based on real life experiences are available.  
Anyhow, a basic GUI for configuring the software is accessible via the following built-in PowerShell command:

```
Show-Command '.\Set-OutlookSignatures.ps1'
```

For a template creator/maintainer, maintaining the INI files defining template application order and permissions is the main task, in combination with tests using simulation mode.  
These tasks typically happen multiple times a year. A graphical user interface might make them more intuitive and easier; until then, documentation and examples based on real life experiences are available.

From an end user perspective, Set-OutlookSignatures should not have a GUI at all. It should run in the background or on demand, but there should be no need for any user interaction.


## 24. What if a user has no Outlook profile or is prohibited from starting Outlook?
Mailboxes are taken from the first matching source:
  1. Simulation mode is enabled: Mailboxes defined in SimulateMailboxes
  2. Outlook is installed and has profiles, and New Outlook is not set as default: Mailboxes from Outlook profiles
  3. New Outlook is installed: Mailboxes from New Outlook (including manually added and automapped mailboxes for the currently logged-in user)
  4. If none of the above matches: Mailboxes from Outlook Web (including manually added mailboxes, automapped mailboxes follow when Microsoft updates Outlook Web to match the New Outlook experience)

Default signatures cannot be set locally or in Outlook Web until an Outlook profile has been configured, as the corresponding settings are stored in registry paths containing random numbers, which need to be created by Outlook.


## 25. What if Outlook is not installed at all?
If Outlook is not installed at all, Set-OutlookSignatures will still be useful: It determine the logged-in users email address, create the signatures for his personal mailbox in a temporary location, set a default signature in Outlook Web as well as the out-of-office replies.


## 26. What about the roaming signatures feature in Exchange Online?
Set-OutlookSignatures can handle roaming signatures since v4.0.0. See `MirrorCloudSignatures` in this document for details.

Set-OutlookSignatures supports romaing signatures independent from the Outlook version used. Roaming signatures are also supported in scenarios where only Outlook Web in the cloud or New Outlook is used.

As there is no Microsoft official API yet, this feature is to be used at your own risk.

Storing signatures in the mailbox is a good idea, as this makes signatures available across devices and apps.

As soon as Microsoft makes available a public API, more email clients will get support for this feature - which will close a gap, Set-OutlookSignatures cannot fill because it is not running on exchange servers: Adding signatures to mails sent from apss besides Outlook for Windows, Outlook Web and New Outlook.

Roaming signatures will very likely never be available for mailboxes on-prem, and it seems that it also will not be available for shared mailboxes in the cloud.

Until an API is available, you can disable the feature with a registry key - you can still use the feature via Set-OutlookSignatures. This key forces Outlook for Windows to use the well-known file based approach and ensure full compatibility with Set-OutlookSignatures, until a public API is released and incorporated into the software. For details, please see <a href="https://support.microsoft.com/en-us/office/outlook-roaming-signatures-420c2995-1f57-4291-9004-8f6f97c54d15?ui=en-us&rs=en-us&ad=us">this Microsoft article</a>.

Microsoft is already supporting the feature in Outlook Web for more and more Exchange Online tenants. Currently, this breaks PowerShell commands such as Set-MailboxMessageConfiguration. If you want to temporarily disable the feature for Outlook Web in your Exchange Online, you can do this with the command `Set-OrganizationConfig -PostponeRoamingSignaturesUntilLater $false`.


## 27. Why does the text color of my signature change sometimes?
Set-OutlookSignatures does not change text color. Very likely, your template files and your Outlook installation are configured for this color change:
- Per default, Outlook uses black text for new emails, and blue text for replies and forwarded emails
- Word and the signature editor integrated in Outlook have a specific color named "Automatic"

When using DOCX templates with parts of the text formatted in the "Automatic" color, Outlook changes the color of these parts to black for new emails, and to blue for replies and forwards.

This behavior is very often wanted, so that the greeting formula, which usually is part of the signature, has the same color as the preceding text of the email.

The default colors can be configured in Outlook.  
Outlook seems to have problems with this in certain patch levels when creating a reply in the preview pane, popping out the draft to its own window and then switching to another signature.


## 28. How to make Set-OutlookSignatures work with Microsoft Purview Information Protection?
Set-OutlookSignatures does work well with Microsoft Purview Information Protection, when configured correctly.

If you do not enforce setting sensitivity labels or exclude DOCX and RTF file formats, no further actions are required.

If you enforce setting sensitivity labels:
- When using DOCX templates, just set the desired sensitivity label on all your template files.
  - It is recommended to use a label without encryption or watermarks, often named 'General' or 'Public':
    - Outlook signatures and out-of-office replies usually only contain information which is intended to be shared publicly by design.
    - The templates themselves usually do not contain sensitive data, only placeholder variables.
    - Documents labeled this way can be opened without having the Information Protection Add-In for Office installed. This is useful when not all of your Set-OutlookSignatures users are also Information Protection users and have the Add-In installed.
  - When using a template with an other sensitivity label, every client Set-OutlookSignatures runs on needs the Information Protection Add-In for Office installed, and the user running Set-OutlookSignatures needs permission to access the protected file.
  - The RTF signature file will be created with the same sensitivity label as the template. This is only relevant for the user composing a new email in RTF format, as the composing user needs to be able to open the RTF document and copy the content from it - the actual signature in the email does not have Information Protection applied.
  - The .HTM and .TXT signature files will be created without a sensitivity label, as these documents cannot be protected by Microsoft Information Protection.
  - If you do not set a sensitivity label, Word will prompt the user to choose one each time the unlabeled local copy of a template is converted to .htm, .rtf or .txt.
    - The DOCX sample template files that come with Set-OutlookSignatures do not have a sensitivity label set.
- When using HTM templates, no further actions are required.
  - HTM files cannot be assigned a sensitivity label, and converting HTM files to RTF is possible even when sensitivity labels are enforced.
  - Converting HTM files to TXT is also no problem, as both file formats cannot be assigned a sensitivity label. 

Additional information that might be of interest for your Information Protection configuration:
- Template files are copied to the local temp directory of the user (PowerShell: `[System.IO.Path]::GetTempPath()`) for further use, with a randomly generated GUID as name. The extension is the one of the template (.docx or .htm).
- The local copy of a template file is opened for variable replacement, saved back to disk, and then re-opened for each file conversion (to .htm if neccessary, and optionally to .rtf and/or .txt). 
- Converted files are also stored in the temp directory, using the same GUID as the original file as file name but a different file extension (.htm, .rtf, .txt).
- After all variable replacements and conversions are completed for a template, the converted files (HTM mandatory, RTF and TXT optional) are copied to the Outlook signature folder. The path of this folder is language and version dependent (Registry: `HKCU:\Software\Microsoft\Office\<Outlook Version>\Common\General\Signatures`).
- All temporary files mentioned are deleted by Set-OutlookSignatures as part of the clean-up process.


## 29. Images in signatures have a different size than in templates, or a black background
The size of images in signatures may differ to the size of the very same image in a template. This may have observable in several ways:
- Images are already displayed too big or too small when composing a message. Not all signatures with images need to be affected, and the problem does not need to be bound to specific users or client computers.
- Images are displayed correctly when composing and sending an email, but are shown in different sizes at the recipient.

In both cases, usually only emails composed HTML format are affected, but not emails in RTF format.

When only the recipient is affected, it is very likely that the problem is to be found within the email client of the recipient, as it very likely does not respect or interpret HTML width and height attributes correctly.  
- This problem cannot be solved on the sending side, only on the recipient side. But the sender side can implement a workaround: Do not scale images in templates (by resizing them in Word or using HTML width and height tags), but use the original size of the image. It may be neccessary to resize the images with tools like GIMP before using them in templates.

When the problem can already be seen when composing a message, there may be different root causes and according solutions or workarounds.

To find the root cause:
- Use the same signature template to create individual signatures for all the following steps.
- Find out if the problem is user or computer related. Let affected users log on to non-affected computer, and vice versa, to test this.
- Find out if only Outlook displays the image in the wrong size. Open the signature HTM file in Word, Chrome, Edge and Firefox for comparison.
- Copy the affected HTM signature file (the signature, not the template) and let a non-affected user use it in Outlook to see if the problem exists there, too.
- Compare the 'img' tag between the signature (from the same template) of an affected and a non-affected user. If they are identical, the root cause is not the generated HTML code, but its interpretation and display in Outlook (therefore, the problem can't be in Set-OutlookSignatures).
- Collect the following data for a number of affected and non-affected users and computer to help you find the root cause:
  - User name
  - Computer name
  - Windows version including build number
  - Word version including build number
  - Outlook version including build number
  - Does Chrome display the image in the correct size?
  - Does Edge display the image in the correct size?
  - Does Firefox display the image in the correct size?
  - Does Outlook display the image in the correct size?
  - Does Word display the image in the correct size?

Two workarounds are available when you do not want to or can't find and solve the root cause of the problem:
- Do not scale images in templates (by resizing them in Word, or using HTML width and height attributes), but use the original size of the image. It may be neccessary to resize the images with tools like GIMP before using them in templates.
- The problem may only appear when templates are converted to signatures on computers configured with a display scaling higher than 100 %. In this case, the problem is in the Word conversion module or the HTML rendering engine of Word (which is used by Outlook). The registry key described in <a href="https://learn.microsoft.com/en-US/outlook/troubleshoot/user-interface/graphics-file-attachment-grows-larger-in-recipient-email">this Microsoft article</a> may help here. After setting the registry key according to the article, Outlook and Word need to be restarted and Set-OutlookSignatures needs to run again.  
Starting with v4.0.0, Set-OutlookSignatures sets the `DontUseScreenDpiOnOpen` registry key to the recommended value. 

Nonetheless, some scaling and display problems simply cannot be solved in the HTML code of the signature, because the problem is in the Word HRML rendering engine used by Outlook: For example, some Word builds ignore embedded image width and height attributes and always scale these images at 100% size, or sometimes display them with inverted colors or a black background.  
In this case, you can influence how images are displayed and converted from DOCX to HTM with the parameters `EmbedImagesInHtml` and `DocxHighResImageConversion`:

| Parameter                  | Default value                                                                                                                                                                                                       | Alternate<br>configuration A                                                                                                                                                                                                                                                                                               | Alternate<br>configuration B                                                                                                                                                                                              | Alternate<br>configuration C                                                                                                                                                                                                                                                                                      |
| :------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| EmbedImagesInHtml          | false                                                                                                                                                                                                               | true                                                                                                                                                                                                                                                                                                                       | true                                                                                                                                                                                                                      | false                                                                                                                                                                                                                                                                                                             |
| DocxHighResImageConversion | true                                                                                                                                                                                                                | false                                                                                                                                                                                                                                                                                                                      | true                                                                                                                                                                                                                      | false                                                                                                                                                                                                                                                                                                             |
| Influence on images        | HTM signatures with images consist of multiple files<br><br>Make sure to set the Outlook registry value "Send Pictures With Document" to 1, as described in the documentation of the `EmbedImagesInHtml` parameter. | HTM signatures with images consist of a single file<br><br>Office 2013 can't handle embedded images<br><br>Some versions of Office/Outlook/Word (some Office 2016 builds, for example) show embedded images wrongly sized<br><br>Images can look blurred and pixelated, especially on systems with high display resolution | HTM signatures with images consist of a single file<br><br>Office 2013 can't handle embedded images<br><br>Some versions of Office/Outlook/Word (some Office 2016 builds, for example) show embedded images wrongly sized | HTM signatures with images consist of multiple files<br><br>Images can look blurred and pixelated, especially on systems with high display resolution<br><br>Make sure to set the Outlook registry value "Send Pictures With Document" to 1, as described in the documentation of the EmbedImagesInHtml parameter |
| Recommendation             | This configuration should be used as long as there is nothing to the contrary                                                                                                                                       | This configuration should not be used due to the low graphic quality                                                                                                                                                                                                                                                       | This configuration may lead to wrongly sized images or images with black background due to a bug in some Office versions                                                                                                  | This configuration should not be used due to the low graphic quality                                                                                                                                                                                                                                              |

The parameter `MoveCSSInline` may also influence how signatures are displayed. Not all clients support the same set of CSS features, and there are clients not or not fully supporting CSS classes.  
The Word HTML rendering engine used by Outlook is rather conservative regarding CSS support, which is good from a sender perspective.  
When the `MoveCSSInline` parameter is enabled, which it is by default, cross-client compatibility is even more enhanced: All the formatting defined in CSS classes is intellegently moved to inline CSS formatting, which supported by a higher number of clients. This is a best practive in email marketing.


## 30. How do I alternate banners and other images in signatures?
Let's say, your marketing campaign has three different banners to avoid viewer fatigue. It will be very hard to instruct your users to regularly rotate between these banners in signatures.

You can automate this with Set-OutlookSignatures in two simple steps:
1. Create a customer replacement variable for each banner and randomly only assign one of these variables a value:

    ```
    $tempBannerIdentifiers = @(1, 2, 3)

    $tempBannerIdentifiers | Foreach-Object {
      $ReplaceHash["CurrentMailbox_Banner$($_)"] = $null
    }

    $ReplaceHash["CurrentMailbox_Banner$($tempBannerIdentifiers | Get-Random)"] = $true

    Remove-Variable -Name 'tempBannerIdentifiers'
    ```

2. Add all three banners to your template and define an alternate text  
Use `$CurrentMailbox_Banner1DELETEEMPTY$` for banner 1, `$CurrentMailbox_Banner2DELETEEMPTY$` for banner 2, and so on.  
The DELETEEMPTY part deletes an image when the corresponding replacement variable does not contain a value.

Now, with every run of Set-OutlookSignatures, a different random banner from the template is chosen and the other banners are deleted.


You can enhance this even further:
- Use banner 1 twice as often as the others. Just add it to the code multiple times:

  ```
  $tempBannerIdentifiers = @(1, 1, 2, 3)
  ```

- Assign banners to specific users, departments, locations or any other attribute
- Restrict banner usage by date or season
- You could assign banners based on your share price or expected weather queried from a web service
- And much more, including any combination of the above


## 31. How can I deploy and run Set-OutlookSignatures using Microsoft Intune?
There are multiple ways to integrate Set-OutlookSignatures in Intune, depending on your configuration.

When not using an Always On VPN, place your configuration and template files in a SharePoint document library that can be accessed from the internet.

### 31.1. Application package
The classic way is to deploy an application package. You can use tools such as [IntuneWin32App](https://github.com/MSEndpointMgr/IntuneWin32App) for this.

As Set-OutlookSignatures does not have a classic installer, you will have to create a small wrapper script that simulates an installer. You will have to update the package or create a new one with every new release you plan to use - just as with any other application you want to deploy.

Deployment is only the first step, as the software needs to be run regularly. You have multiple options for this: Let the user run it via a start menu entry or a desktop shortcut, use scheduled tasks, a background service, or a remediation script (which is probably the most convenient way to do it).

### 31.2. Remediation script
With remediation, you have two scripts: One checking for a certain status, and another one running when the detection script exits with an error code of 1.

Remediation scripts can easily be configured to run in the context of the current user, which is required for Set-OutlookSignatures, and you can define how often they should run.

For Set-OutlookSignatures, you could use the following scripts, which do not require the creation and deployment of an application package as an additional benefit.

The detection script could look like the sample code '.\sample code\Intune-SetOutlookSignatures-Detect.ps1':
- Check for existence of a log file
- If the log file does not exist or is older than a defined number of hours, start the remediation script

The remediation script could look like the sample code '.\sample code\Intune-SetOutlookSignatures-Remediate.ps1':
- If Set-OutlookSignatures is not available locally in the defined version, download the defined version from GitHub
- Start Set-OutlookSignatures with defined parameters
- Log all actions to a file that the detection script can check at its next run


## 32. Why does Set-OutlookSignatures run slower sometimes?
There are multiple factors influencing the execution speed of Set-OutlookSignatures.

Set-OutlookSignatures is written with efficiency in mind, reducing the number of operations where possible. Nonetheless, you may see huge differences when comparing processing times, even on the same client.

For example: Calling Set-OutlookSignatures with the same configuration, we have measured processing times varying from 27 to 113 seconds on the very same client. With longer runtimes, all individual steps require more time, whereby file system activities are usually particularly slow.

This is not because different code is being executed, but because of multiple factors outside of Set-OutlookSignatures. The most important ones are described below.

Please don't forget: Set-OutlookSignatures usually runs in the background, without the user even noticing it. From this point of view, processing times do not really matter - slow execution may even be wanted, as it consumes less resources which in turn are available for interactive applications used in the foreground.

### 32.1. Windows power mode
Windows has power plans and, in newer versions, power modes. These can have a huge impact, as the following test result shows:
- Best power efficiency: 113 seconds
- Balanced: 32 seconds
- Best performance: 27 seconds

### 32.2. Malware protection
Malware protection is an absolute must, but security typically comes with a drawback in terms of comfort: Malware protection costs performance.

We do not recommend to turn off malware protection, but to optimize it for your environment. Some examples:
- Place Set-OutlookSignatures and template files on a server share. When the files are scanned on the server, you may consider to exclude the server share from scanning on the client.
- Your anti-malware may have an option to not scan digitally signed files every time they are executed. Set-OutlookSignatures and its dependencies are digitally signed with an Extend Validation (EV) certificate for tamper protection and easy integration into locked-down environments. You can sign the executables with your own certificate, too.

### 32.3. Time of execution
The time of execution can have a huge impact.
- Consider not running Set-OutlookSignatures right at logon, but maybe a bit later. Logon is resource intensive, as not only the user environment is created, but all sorts of automatisms kick off: Autostarting applications, file synchronisation, software updates, and so on.
- Consider not executing all tasks and scripts at the same time, but starting them in groups or one after the other.
- Set-OutlookSignatures relies on network connections. At times with higher network traffic, such as on a Monday morning with all users starting their computers and logging on within a rather short timespan, things may just be a bit slower.
- Do not run Set-OutlookSignatures for all your users at the same time. Instead of "Every two hours, starting at 08:00", use a more varied interval such as "Every two hours after logon".

### 32.4. Script and Word process priority
As mentioned before, Set-OutlookSignatures usually runs in the background, without the user even noticing it.

From this point of view, processing times do not really matter - slow execution may even be wanted, as it consumes less resources which in turn are available for interactive applications used in the foreground.

You can define the process priority with the `ScriptProcessPriority` and `WordProcessPriority` priority.


## 33. Keep users from adding, editing and removing signatures
### 33.1. Outlook
You can disable GUI elements so that users cannot add, edit and remove signatures in Outlook by using the 'Do not allow signatures for email messages' Group Policy Object (GPO) setting.

Caveats are:
- Users can still add, edit and remove signatures in the file system
- Default signatures are no longer automatically added when a new email is created, or you forward/reply an email. Users have to choose the correct signature manually.
- The GPO setting seems not ot work with some newer versions of Outlook. In this case, set the registry key directly.

As an alternative, you may consider one or both of the following alternatives:
- Run Set-OutlookSignatures regularly (every two hours, for example) and use the 'WriteProtect' option in the INI file
- Use the 'Disable Items in User Interface' Group Policy Object (GPO) setting, and consider the following values to disable specific signature-related parts of the user interface:
  - 5608: 'SignatureInsertMenu', the dropdown list/button allowing you to select an existing signature to add to an email, and to open the 'SignatureGallery'.
  - 22965: 'SignatureGallyery', the list of signatures in the 'SignatureInsertMenu'. Prohibits selecting another signature than the default one to add to an email, but still allows access to 'SignaturesStationeryDialog'.
  - 3766: 'SignaturesStationeryDialog', the GUI allowing users to add, edit and remove signatures. Also disables access to 'Personal Stationary' and 'Stationary and Fonts' - these settings should be controlled centrally anyway in order to comply with the corporate identity/corporate design guidelines.

There is one thing you cannot disable: Outlook always allows users to edit the copy of the signature after it was added to an email.

### 33.2. Outlook Web
Unfortunately, Outlook Web cannot be configured as granularly as Outlook. In Exchange Online as well as in Exchange on-prem, the `Set-OwaMailboxPolicy` cmdlet does not allow you to configure signature settings in detail, but only to disable or enable signature features via the `SignaturesEnabled` parameter for specific groups of mailboxes.

There is no option to write protect signatures, or to keep users from from adding, editing and removing signatures without disabling all signature-related features.

As an alternative, run Set-OutlookSignatures regularly (every two hours, for example).


## 34. What is the recommended folder structure for script, license, template and config files?
Choosing an unsuitable folder structure for script, license, template and config files can make it hard to upgrade to new versions.

The following structure is recommended, as it separates customized files from script and license files.
- **Root share folder**  
  For example, '\\\\server\share\folder'
  - **Config**  
    Contains your custom config files (custom Graph config file, custom replacement variable config file, maybe template INI files)
  - **License**  
    Contains the Benefactor Circle add-on
  - **Set-OutlookSignatures**  
    Contains Set-OutlookSignatures
  - **Templates**
    - **OOF**  
      Contains out-of-office templates, and the corresponding INI file (if not placed in 'Config' folder)
    - **Signatures**  
      Contains signature templates, and the corresponding INI file (if not placed in 'Config' folder)

When you want to upgrade to a new release, you basically just have to delete the content of the 'Set-OutlookSignatures' and 'Set-OutlookSignatures license' folders and copy the new files to them.

Never add new files to or modify existing files in the 'Set-OutlookSignatures' and 'Config' folders.

If you want to use a custom Graph config file or a custom replacement variable file, follow the instructions in the default files.

Alternative options for storing files:
-  Set-OutlookSignatures files do not need to be centrally hosted on a file server. You can write a script that downloads a specific version and keeps it on your clients. Search this document for 'Intune' to find a sample script doing this.
-  License, config and template files do not need to be stored on a file server. They can also be made available in a SharePoint document library.
-  Some clients do not use on-prem file servers, but use SMB file shares in Azure Files, as they can be made available from on-prem as well via internet.


## 35. How to disable the tagline in signatures?
Set-OutlookSignatures appends a small, subtle attribution to signatures: 'Free and open-source Set-OutlookSignatures'

This unobtrusive text may also be called tagline, footer message, nag text, outreach snippet, upgrade nudge, or reminder blurb.

Signatures for mailboxes with a [Benefactor Circle](/benefactorcircle/) license automatically remove this attribution.

### 35.1. Why the tagline?
In the words of Markus Gruber, the creator of Set-OutlookSignatures:

> Set-OutlookSignatures is my way of giving back to the community. Since it was first released in 2021 as a demonstrator showcasing the practical use of efficient Active Directory queries, many reusable code snippets have been added: Read about them in the FAQ '[What can I learn from the code of Set-OutlookSignatures?](#44-what-can-i-learn-from-the-code-of-set-outlooksignatures)'.
>
> Today, Set-OutlookSignatures is more than just a vehicle for demonstrating PowerShell techniques. It has evolved into the most sophisticated and versatile free and open-source tool for managing email signatures and out-of-office replies.
>
> Developing and testing it has taken thousands of hours of spare time and considerable financial investment in cross-platform test environments. I intend to continue developing and maintaining Set-OutlookSignatures, and to keep its core free and open-source.
>
> If you're an Exchange or client administrator, you're part of the community I want to support. I don’t expect or request thank-yous, as our community thrives on mutual support. Your feedback, bug reports, and shared use cases help improve the tool for everyone.
>
> That said, it’s important to ensure the relationship isn’t one-sided when companies benefit significantly. The tagline added to each signature reminds organizations that they benefit from open-source software and that continued open-source availability depends on financial support, which also unlocks additional useful features.
>
> A note to companies: Open-source software is often misunderstood. It can include closed-source components. Open source does not automatically mean free usage or even free access to the code. And it does not imply free support.
> 
> In this spirit: **Dear companies,**
> - **Invest** in the free and open-source software you depend on. Contributors work behind the scenes to make it better for everyone. Support them.
> - **Sponsor** the tools your teams rely on. Funding these projects improves performance, reliability, and stability across your software supply chain.
>
> By choosing Set-OutlookSignatures, your company can significantly reduce costs compared to commercial alternatives, all while benefiting from a powerful, open-source solution. And by upgrading to the Benefactor Circle add-on, you help secure the future of Set-OutlookSignatures.

### 35.2. Not sure if Set-OutlookSignatures is the right solution for your company?

The core of Set-OutlookSignatures is available free of charge as open-source software and can be used indefinitely and for as many mailboxes as your company requires.

All documentation is publicly available. You can get free community support on GitHub, or opt for first-class professional support, training, workshops, and more from [ExplicIT Consulting](/support/).

For a small annual fee per mailbox, the [Benefactor Circle add-on](/benefactorcircle/) offers additional enterprise-grade features. Companies can test all premium features at no cost during a free 14-day trial.

Unsure whether the add-on will deliver value for your company?  
The chapter '[Financial Benefits](/benefactorcircle/#financial-benefits)' shows how to calculate the value based on your company’s specific needs.  
If your company concludes that the add-on does not provide sufficient value, it can still use the free and open-source version of Set-OutlookSignatures.


## 36. Why is the out-of-office assistant not activated automatically?
OOF templates are only applied if the out-of-office assistant is currently disabled. If it is currently active or scheduled to be automatically activated in the future, OOF templates are not applied.

The user has to activate the out-of-office assistant manually. Through the use of templates, the user only has to make no to only little changes to the text (such as the return date, possibly).

The reason for this is that there is no generic way to detect when a user will be absent, when he will come back and how much in advance the out-of-office assistant should be activated. While you may have defined clear rules in your company and your users fully adhere to these rules, the rules and their usage may be handled completely different in other companies.


## 37. When should I refer on-prem groups and when Entra ID groups?
The following is valid for using groups in INI files as well as for Benefactor Circle licensing groups:
- When using the '-GraphOnly true' parameter, prefer Entra ID groups ('EntraID <…>'). You may also use on-prem groups ('<DNS or NetBIOS name of AD domain> <…>') as long as they are synchronized to Entra ID.
- In hybrid environments without using the '-GraphOnly true' parameter, prefer on-prem groups ('<DNS or NetBIOS name of AD domain> <…>') synchronized to Entra ID. Pure entra ID groups ('EntraID <…>') only make sense when all mailboxes covered by Set-OutlookSignatures are hosted in Exchange Online.
- Pure on-prem environments: You can only use on-prem groups ('<DNS or NetBIOS name of AD domain> <…>'). When moving to a hybrid environment, you do not need to adapt the configuration as long as you synchronize your on-prem groups to Entra ID.


## 38. Why are signatures and out-of-office replies recreated even when their content has not changed?
Signatures and out-of-office replies are deliberately recreated each time Set-OutlookSignatures runs. The effort required to check whether anything has changed since the last run would be greater than actually creating them new.

Changes affecting signatures and out-of-office replies may have been made on the user's client, in the users's mailbox, in Entra ID or Active Directory, in template files, and in configuration files.

The only reliable way to detect changes in an environment where things can be modified in so many places would be to calculate what the new signatures would look like with current values and then compare these with the existing ones - but if you already have the new signatures and out-of-office replies anyway, overwriting the existing ones is faster than comparing them.

## 39. Empty lines contain an underlined space character
Outlook, especially the Web version, sometimes does not show an empty line but a line with a single underlined space character:

```
<a hyperlink>
_
<some text>
```

instead of

```
<a hyperlink>

<some text>
```

This usually happens when the text before the empty line ends with a hyperlink.

To avoid this, add a non-breaking space character to the empty line in your template and to the end of the preceeding line:
- Word: Insert, Symbol, More Symbols, Special Character, Nonbreaking Space
- HTML: '`&nbsp;`'

This trick also helps when text separating two hyperlinks is underlined:

```
<a hyperlink>_<another hyperlink>
```

instead of

```
<a hyperlink> <another hyperlink>
```

The root cause is unknown, but it seems to be related to the HTML parser of the office.js framework, which is used by Outlook for all platforms to perform specific tasks.


## 40. What about Microsoft turning off Exchange Web Services for Exchange Online?
Microsoft will turn of Exchange Web Services (EWS) for Exchange Online. This is announced to happen in October 2026. This only affects Exchange in the cloud, not Exchange hosted on premises.

Set-OutlookSignatures, the Benefactor Circle add-on and the Outlook add-in are prepared for this since the end of 2023, when Microsoft made their first announcement about this.

Unfortunately, the Graph API does not yet offer the same feature set as EWS. This affects the following features for mailboxes hosted in Exchange Online (and only in Exchange Online):
- Setting the classic Outlook Web signature<br>The classic Outlook Web signature can only be seen when using Outlook Web on a browser in mobile view. This only affects a vanishingly small number of users, the trend is downwards, and it is not yet clear if Microsoft will ever bring this feature to the Graph API.<br>Roaming signatures are not affected. Exchange on-prem is not affected.
- Getting additional mailboxes from Outlook Web<br>This affects all editions of Outlook which are not the Classic Outlook for Windows - in other words: New Outlook for Windows, any Outlook for macOS, and running Set-OutlookSignatures on Linux.<br>It is very likely that Microsoft will update the Graph API to support this feature. The timeline is unknown.<br>Detecting automapped mailboxes is not affected. Exchange on-prem is not affected.


## 41. Roaming signatures in Classic Outlook for Windows look different
When letting Classic Outlook for Windows sync roaming signatures itself, you very likely run into multiple problems.

The most disturbing one is that the encoding of characters within the signatures is wrong.

Here is how you can test if the current patch level of Classic Outlook for Windows is affected:
1. Ensure that the system codepage of your Windows client is not set to UTF-8, but to a local codepage as Windows does per default (such as Windows-1252 in Western Europe). Setting the codepage to UTF-8 is possible, but it is still an optional beta feature. 
2. Ensure that Classic Outlook for Windows is configured to use roaming signatures.
3. Create a new signature in Outlook Web (not in any other Outlook) with the following content:

    ```
    Test signature with UTF-8 characters
    ä (a with umlaut)
    ö (o with umlaut)
    ü (u with umlaut)
    𝄞 (musical symbol G clef)
    😃 (grinning face with big eyes)
    😞 (disappointed face)
    🧩 (puzzle piece)
    ⭐ (star)
    ```

4. Wait until Classic Outlook for Windows has downloaded the signature locally.
5. Add the freshly downloaded signature to a new email in Classic Outlook for Windows or open the downloaded file directly in a browser.
6. You will notice that the UTF-8 characters are not displayed correctly.

This is because Classic Outlook for Windows performs a wrong codepage conversion. Microsoft knows about this error since roaming signatures have been introduced multiple years ago, but it has not yet been fixed.

Some other problems with the internal roaming signature sync mechanism of classic Outlook for Windows are that you cannot reliably trigger the sync and that it can take hours until a changed or new signature is downloaded.

The sync mechanism included in the Benefactor Circle add-on does not have these problems.

This can be a problem, especially when using Set-OutlookSignatures in SimulateAndDeploy mode. If you really cannot switch to running Set-OutlookSignatures on the clients of your users, the Outlook add-in that comes with the Benefactor Circle license may be an alternative to the erronous internal roaming signature sync mechanism of Classic Outlook for Windows.


## 42. Does it support cross-tenant access and Multitenant Organizations?
Yes, Set-OutlookSignatures and the Benefactor Circle add-on support cross-tenant access. This allows to deploy signatures to mailboxes that are not hosted in the users home tenant, with all the properties and replacement variables being fully available.

Cross-tenant access is not limited to what Microsoft calls [Multitenant Organization](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/overview), it can be established between any two tenants allowing cross-tenant access for the other.

See the description of the parameter '`GraphClientID`' for details.


## 43. Can I change the case (uppercase/lowercase) of replacement variables in templates?
Yes. Replacement variables can be displayed in uppercase, lowercase, or capitalized form depending on your formatting needs and the type of template you're using:
- When using DOCX templates, you can use Word’s formatting options, such as "all caps", which is then translated to CSS 'text-transform'.
- When using HTML templates, you can use the CSS 'text-transform' property directly to control text casing.

In rare cases, email clients may ignore this CSS property or render it inconsistently.

To ensure consistent results across all platforms, use a custom replacement variable config file ('`ReplacementVariableConfigFile`' parameter) to create a new replacement variable or modify an existing one to your needs. This ensures the same appearance across all mail clients and often is more flexible than a pure formatting option.

## 44. What can I learn from the code of Set-OutlookSignatures?
Set-OutlookSignatures is not just a tool for managing Outlook signatures and out-of-office replies. It is free and open-source because I want to give something back to the community that has helped me so often over the years.

The code is, of course, full of stuff related to getting reliable information about the current user and its manager from different sources, reading and interpreting the Outlook configuration from the registry, and automating Word for document manipulation. Thanks to open-source, you can have a look at it and actively help make it better.

The following gives you an overview which other scripting techniques you can learn from Set-OutlookSignatures.  
Beside the big learning topics mentioned in this FAQ, main and supporting files of Set-OutlookSignatures are sprinkled with small code snippets and comments you may find useful. Chances are good that you will stumble across some small gems of code by just browsing through it.

You have found some lines of code that you can use for yourself? Great, that's exactly how it's meant to be. My pleasure!<br>One small request: If you have a minute, please <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/discussions?discussions_q=">let me know</a> which part of the code you were able to reuse.

### 44.1. Active Directory group membership enumeration without compromises
That's how it all started, so I'll back up a bit. In 2021, two software companies competing in a product evaluation blamed a complicated but perfectly fine Active Directory setup for the non-functioning and 20-minute-timeouts of their software, until they were shown that a hundred lines of PowerShell code with the correct LDAP queries can do the job in 1.2 seconds.

I decided to share my code with the public, as I already had the urge to give back something to the community that already had helped me so often before. But I did not want to share just the code, I wanted to showcase it as part of solving a common challenge: Managing and deploying Outlook signatures.

That's how Set-OutlookSignatures was born, as a showcase for querying Active Directory group membership efficiently.

I got in contact with Active Directory some time before it was released, was deeply involved for almost two decades, and have seen a bit. There is a lot that can be misconfigured or go wrong, but the number one problem from my experience is querying Active Directory efficiently.

There is so much bad LDAP query code out there that one can only pay respect to the Microsoft Active Directory core team for creating a system that can handle so much of it without crashing (and sometimes even correcting the query on the fly).

The root causes for ineffecient queries typically are:
- Not being fully aware of what Domain Controllers and Global Catalog servers really do.
- Not fully understanding the data model used by Active Directory.
- Not using LDAP extensible match rules.

Enumerating direct and indirect (a.k.a nested, recursive, transitive) group members or group membership of a user is one of the top required queries in the wild. There are literally thousands of scripts available in the internet, described in hundreds of blog articles sharing the same "tips" and "secrets" - but nearly all of them are overly complicated, perform poorly, do not consider all group types, do not respect SID history, and do not even care about trusts.

The code in Set-OutlookSignatures used to determine group membership is as feature complete and efficient as Active Directory allows, making it the go-to code for this purpose.

Files:
- '`.\Set-OutlookSignatures.ps1`'
- '`MemberOfRecurse.ps1`' from [Export-RecipientPermissions](https://github.com/GruberMarkus/Export-RecipientPermissions)

### 44.2. Microsoft Graph authentication and re-authentication
Sounds easy, doesn't it? Well, it isn't: Silent authentication, integrated windows authentication, authentication brokers, managed vs federated users, browser fallback, permission scopes, refresh tokens, encrypted storage, keyrings and keychains, cross-platform compatiblity, support for public and national (GCC High, GCC DoD, China) clouds, and more don't make it easy.

Set-OutlookSignatures therefore comes with an authentication module, making it easy to use the official Microsoft Authentication Library (MSAL) and covering everything mentioned above, and some more, such as cross-tenant and multi-tenant organization access. Cross-platform and up to the highest security standards, of course.

Files:
- '`.\Set-OutlookSignatures.ps1`'
- '`.\bin\MSAL.PS`'

### 44.3. Graph cross-tenant and multitenant-organization access
The function '`GraphDomainToTenantID`' takes a DNS domain name, an email address, a URL or a tenant ID and tells you the tenant ID and the cloud it belongs to. It keeps a cache for fast lookups.

The function '`GraphSwitchContext`' manages the authentication tokens for different tenant IDs and allows you to easily switch between them by accepting the same input as '`GraphDomainToTenantID`'.

As all code of Set-OutlookSignatures, these functions not only work with the public cloud but also with national clouds (GCC High, GCC DoD, China).

Files:
- '`.\Set-OutlookSignatures.ps1`'

### 44.4. Deploy and run software using desired state configuration (DSC)
Deploy software without having to create a software package, and run it on a schedule without having to work with scheduled tasks?

More and more Enterprise Mobility Management (EMM) products, such as Microsoft Intune, provide exactly this with a feature named desired state configuration (DSC). The idea is simple: A script periodically checks if a desired state exists and in reality, and takes action when real and desired state differ.

Set-OutlookSignatures includes code that shows how to use this feature to deploy Set-OutlookSignatures and schedule its execution without having to package it. The scripts are tailored for Microsoft Intune, but they work in other EMM systems with no or only little changes.

Files:
- '`.\sample code\Intune-SetOutlookSignatures-Detect.ps1`'
- '`.\sample code\Intune-SetOutlookSignatures-Remediate.ps1`'

### 44.5. Parallel code execution
PowerShell 7 has made parallel code execution much easier with '`Foreach-Object -Parallel`' and background jobs, but they lack some features and are not available at all or only with a reduced feature set for PowerShell 5.

Set-OutlookSignatures uses parallel code execution in multiple places to speed up operations and to solve DLL/module dependency problems. For maximum comfort and compatibility, runspaces are used for this.

The code teaches you how to create and use runspaces, how to share data between different runspaces, how to report progress, and much more.

Files:
- '`.\Set-OutlookSignatures.ps1`'
- '`.\sample code\SimulateAndDeploy.ps1`'
- '`.\sample code\Test-ADTrust.ps1`'

### 44.6. Create desktop icons cross-platform
Creating desktop icons seems to be a trivial task: Create the shortcut on a sample client and then deploy it.

It gets more of a challenge when you want to create the shortcut based on parameters, as Microsoft does not deeply document the required file format, and as there is no built-in cmdlet in PowerShell.

Set-OutlookSignatures not only includes code showing how it is done on Windows, but also for Linux and macOS.

Files:
- '`.\sample code\Create-DesktopIcon.ps1`'

### 44.7. Create and configure apps in Entra ID, grant admin consent
Basically every interaction with Microsoft 365, Microsoft Azure, and Entra ID requires an Entra ID app in the background. This is an integral part of the design of the Graph API, providing higher security as permissions have to be defined in detail and, in many cases, must be granted use by administrators.

Although Entra ID apps are used all the time by all products interacting with Microsoft could products, administrators generally only have very little knowledge about how Entra ID apps work in detail, or why they are even required.

Set-OutlookSignatures documents in detail which Entra ID apps it requires, how they need to be configured, and why they need to be configured this way. The required permissions are documented very well and strictly follow the "least privilege" and "need to know" principles.

With this documentation, Set-OutlookSignatures has since passed every security and governance audit. And these can be tough, as Set-OutlookSignatures not only works in public M365, but also in GCC High (US government), GCC DoD (US defence and military), and China national clouds.

The included code shows how to fully automate the creation and configuration of Entra ID apps, including how to automatically grant admin consent.

Files:
- '`.\sample code\Create-EntraApp.ps1`'

### 44.8. Test Active Directory trusts
Active Directory has been introduced nearly 30 years ago, but one still comes across environments with misconfigured DNS servers and firewalls. It becomes even more problematic when trusts are involved - although the requirements are well documented and firewalls typically have built-in filters.

For such cases, Set-OutlookSignatures includes code to check AD trusts and AD connectivity from a client computer.

The connection is tested for every combination of
- DNS name of domain and domain controllers
- IP address of domain and domain controllers
- Protocols LDAP and GC, with and without encryption

Cross-forest trusts are supported, too.

This code is also a good example for parallel code execution in PowerShell.

Files:
- '`.\sample code\Test-ADTrust.ps1`'

### 44.9. Start only if working Active Directory connection is available
This a much simpler and faster variant of '`.\sample code\Test-ADTrust.ps1`', intenden for a simpler use case: Quickly check if a working connection to Active Directory can be established, and only run Set-OutlookSignatures when Active Directory answers.

This is useful when, for example, you use a VPN connection event trigger to start Set-OutlookSignatures, but your client firewall takes some time to update its dynamic ruleset.

This code would not be worth nothing if it did not consider some typical caveats: Getting the current user, querying a Domain Controller and a Global Catalog, checking if the user is locked, quickly testing if intraforest-trusts work, retry and timeout mechanisms.

Sounds complicated, but is straightforward and highly reusable for any software with similar requirements.

Files:
- '`.\sample code\Start-IfADAvailable.ps1`'

### 44.10. Prohibit system sleep
Blocking a system from going to sleep is not a big challenge, making it configurable on Windows, and work cross-platform on Linux and macOS is already a bit harder.

The '`BlockSleep`' function of Set-OutlookSignatures makes it easy to block and allow system sleep as you wish.

Files:
- '`.\Set-OutlookSignatures.ps1`'

### 44.11. Detect exit signals
It is hard for long-running scripts to detect exit signals and even harder to react with a graceful exit in-time.

The '`WatchCatchableExitSignal`' family of functions makes this much easier. They detect
- logoff, reboot and shutdown messages on Windows
- catchable POSIX signals (SIGINT, SIGTERM, SIGQUIT, SIGHUP) on Linux and macOS
via a separate parallel thread and make them available to the whole PowerShell session.

A long-running script can then check regularly for these signals, and react accordingly. Set-OutlookSignatures and the Benefactor Circle add-on perform these checks more than 500 times throughout their code.

Files:
- '`.\Set-OutlookSignatures.ps1`'

### 44.12. Format phone numbers
Just like postal addresses, phone numbers seem like child's play: You simply type them into your phone and - voilà - it rings at the other end.

This only works because the dialer software on our phones performs hundreds of calculations to convert the numbers you type into a correct technical format. Phone numbers seem to be easy because:
- We think they are just numbers, but they are strings with mandatory and optional characters with special meanings.
- We think in local numbers, not in international ones. Converting them is much more than prefixing a '+' and the country code.
- We think there is only one phone number format that rules them all.

If you still think phone number formatting is an easy task, reading the article '[Falsehoods Programmers Believe About Phone Numbers](https://github.com/google/libphonenumber/blob/master/FALSEHOODS.md)' will change your mind.

Google has created probably the best phone number formatter, made it free and open-source, and maintains it regularly. It covers all countries and regions, includes all the public data that is available about country codes, and all the experience from the Android number dialer.

Set-OutlookSignatures makes the .Net port of this library available. The function '`FormatPhoneNumber`' allows any given phone number with optional or indirect country information to be formatted in the four relevant technical formats, as well as in a fully customizable format.

With only one input, you get a perfectly formatted number for national dialing, international dialing, `'tel:'`-links and more. Extensions are supported, too, when being made technically distinguishable.

Files:
- '`.\Set-OutlookSignatures.ps1`'
- '`.\config\default replacement variables.ps1`'

### 44.13. Format postal addresses
Just like phone numbers, postal addresses seem like child's play. This is true for national addressing because we are used to writing addresses for our own country.

But: Different countries, different customs. Read the article '[Falsehoods programmers believe about addresses](https://www.mjt.me.uk/posts/falsehoods-programmers-believe-about-addresses/)' to get a glimpse of what is possible. Three cheers for all the mailmen around the world!

Since all attempts to remedy the cause of this chaos have failed, there is a global community of people and companies that maintain a collection of country-specific address formats, rules, and conditions and describe them in a standardized technical format.

These address formatting templates are then made accessible by free and open-source software implementations. As there has been none for .Net or PowerShell, I created one.

The '`AddressFormatter`' module comes with the '`Format-PostalAddress`' cmdlet. The cmdlet takes named standard address components - there are more than 20 of them! - and the coutry code as input, and returns the correctly formatted address string.

A real relief for any multinational company or when sending letters to recipients in different countries!

Files:
- '`.\Set-OutlookSignatures.ps1`'
- '`.\config\default replacement variables.ps1`'
- '`https://github.com/GruberMarkus/AddressFormatter`'

### 44.14. Bringing hidden treasures to light
As a member of the .Net platform, PowerShell has access to a lot of great software published by other open-source enthusiasts.

Set-OutlookSignatures shows how to integrate features from open-source software others share with the community. **A big thank you to all fellow open-source developers!**
- Parse HTML with [HTML Agility Pack](https://github.com/zzzprojects/html-agility-pack)
- Inline CSS with [PreMailer.Net](https://github.com/milkshakesoftware/PreMailer.Net)
- Create QR codes with [QRCoder](https://github.com/Shane32/QRCoder)
- Detect file encodings with [UTF Unknown](https://github.com/CharsetDetector/UTF-unknown)
- Parse YAML files with [YamlDotNet](https://github.com/aaubry/YamlDotNet)
- Format phone numbers with [libphonenumber-csharp](https://github.com/twcclegg/libphonenumber-csharp)
- Format postal addresses with [address-formatting templates](https://github.com/opencagedata/address-formatting)

In this spirit: **Dear companies,**
- **Invest** in the free and open-source software you depend on. Contributors work behind the scenes to make it better for everyone. Support them.
- **Sponsor** the tools your teams rely on. Funding these projects improves performance, reliability, and stability across your software supply chain.

### 44.15. Detect and convert encodings
The history of encoding began long before IT. Even the first alphabets were attempts to translate spoken language into visual symbols. Whether cuneiform, hieroglyphics, or the Latin alphabet, every culture developed its own systems for encoding information and preserving it across time and space. 

With the advent of computers, encoding became a technical challenge. Characters had to be translated into bytes, resulting in over 140 different character encodings that modern operating systems and frameworks still support today. ASCII, ISO-8859, Windows-1252, Shift-JIS—each encoding has its own characteristics and limitations.

Unicode was and is a milestone: A universal system designed to represent all characters in all languages. Unfortunately, even Unicode is not a universal solution. It exists in several variants (UTF-8, UTF-16, UTF-32), with and without BOM, and with partially incompatible implementations.

HTML makes it even more complicated by distinguishing between internal encoding and external encoding.

The free and open-source PowerShell function ConvertEncoding, part of Set-OutlookSignatures, makes the powerful and also free and open-source library UTF.Unknown really easy to use.

ConvertEncoding enables reliable detection of encodings via BOMs, HTML metadata, and heuristic analysis, and converts content to other formats as needed. Even HTML files are correctly adjusted, including meta tags. This makes different encodings easy to manage.

Files:
- '`.\Set-OutlookSignatures.ps1`'
