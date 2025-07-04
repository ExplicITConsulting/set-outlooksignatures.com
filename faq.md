---
layout: page
title: Frequently Asked Questions (FAQ)
subtitle: Topics that are addressed regularly
description: Find answers to common questions about Set-OutlookSignatures. Learn about setup, templates, deployment, roaming signatures, and advanced configuration.
image:
  path: "/assets/images/set-outlooksignatures benefactor circle opengraph1200x630.png"
  height: 1200
  width: 630
  alt: "Set-OutlookSignatures Benefactor Circle"
redirect_from:
---

## Frequently Asked Questions (FAQ)<!-- omit in toc -->
- [1. Where can I find the changelog?](#1-where-can-i-find-the-changelog)
- [2. How can I contribute, propose a new feature or file a bug?](#2-how-can-i-contribute-propose-a-new-feature-or-file-a-bug)
- [3. How is the account of a mailbox identified?](#3-how-is-the-account-of-a-mailbox-identified)
- [4. How is the personal mailbox of the currently logged-in user identified?](#4-how-is-the-personal-mailbox-of-the-currently-logged-in-user-identified)
- [5. Which ports are required?](#5-which-ports-are-required)
- [6. Why is out-of-office abbreviated OOF and not OOO?](#6-why-is-out-of-office-abbreviated-oof-and-not-ooo)
- [7. Should I use .docx or .htm as file format for templates? Signatures in Outlook sometimes look different than my templates.](#7-should-i-use-docx-or-htm-as-file-format-for-templates-signatures-in-outlook-sometimes-look-different-than-my-templates)
- [8. How can I log the software output?](#8-how-can-i-log-the-software-output)
- [9. How can I get more script output for troubleshooting?](#9-how-can-i-get-more-script-output-for-troubleshooting)
- [10. How can I start the software only when there is a connection to the Active Directory on-prem?](#10-how-can-i-start-the-software-only-when-there-is-a-connection-to-the-active-directory-on-prem)
- [11. Can multiple script instances run in parallel?](#11-can-multiple-script-instances-run-in-parallel)
- [12. How do I start the software from the command line or a scheduled task?](#12-how-do-i-start-the-software-from-the-command-line-or-a-scheduled-task)
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
- [23. Why is no admin or user GUI available?](#23-why-is-no-admin-or-user-gui-available)
- [24. What if a user has no Outlook profile or is prohibited from starting Outlook?](#24-what-if-a-user-has-no-outlook-profile-or-is-prohibited-from-starting-outlook)
- [25. What if Outlook is not installed at all?](#25-what-if-outlook-is-not-installed-at-all)
- [26. What about the roaming signatures feature in Exchange Online?](#26-what-about-the-roaming-signatures-feature-in-exchange-online)
- [27. Why does the text color of my signature change sometimes?](#27-why-does-the-text-color-of-my-signature-change-sometimes)
- [28. How to make Set-OutlookSignatures work with Microsoft Purview Information Protection?](#28-how-to-make-set-outlooksignatures-work-with-microsoft-purview-information-protection)
- [29. Images in signatures have a different size than in templates, or a black background](#29-images-in-signatures-have-a-different-size-than-in-templates-or-a-black-background)
- [30. How do I alternate banners and other images in signatures?](#30-how-do-i-alternate-banners-and-other-images-in-signatures)
- [31. How can I deploy and run Set-OutlookSignatures using Microsoft Intune?](#31-how-can-i-deploy-and-run-set-outlooksignatures-using-microsoft-intune)
- [32. Why does Set-OutlookSignatures run slower sometimes?](#32-why-does-set-outlooksignatures-run-slower-sometimes)
- [33. Keep users from adding, editing and removing signatures](#33-keep-users-from-adding-editing-and-removing-signatures)
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
Back in the 1980s, Microsoft had a UNIX OS named Xenix … but read yourself <a href="https://techcommunity.microsoft.com/t5/exchange-team-blog/why-is-oof-an-oof-and-not-an-ooo/ba-p/610191">here</a>.  


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


## 10. How can I start the software only when there is a connection to the Active Directory on-prem?
Per default, Set-OutlookSignatures tries to get the required information from Active Directory. When no Active Directory server can be reached, the Graph API is used to get the required information from Entra ID.

To use only Entra ID, you set the '`GraphOnly`' parameter to '`true`'.

There is no direct way to disable the use of Entra ID, which can result in users complaining about pop-up windows regarding authentication because no Entra ID app has been set-up yet. This can also be required when Set-OutlookSignatures is run every time a VPN connection is established, but the client firewall is too slow opening the required ports.

With the following code, you can make sure that Set-OutlookSignatures is only run when a connection to Active Directory is available:

```
# Only run Set-OutlookSignatures when there is a connection to a Domain Controller.
# Covers the following cases:
#   - At least one DC from the user's domain is pingable
#   - At least one Global Catalog server from the user's domain is reachable via a GC query
#   - The querying user exists and is not locked
#   - All domains in the user's forest are reachable via LDAP and GC queries


$testIntervalSeconds = 5 # Interval between retries
$testTimeoutSeconds = 120 # For how long to retry (in seconds) before giving up


Write-Host 'Start AD connectivity test'

Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$testCurrentUserDN = ([System.DirectoryServices.AccountManagement.UserPrincipal]::Current).DistinguishedName

if (
  $($null -eq $testCurrentUserDN) -or
  $(($testCurrentUserDN -split ',DC=').Count -lt 3)
) {
  Write-Host '  User is not a member of a domain, do not go on with further tests.'
} else {
  $testStartTime = Get-Date
  $testSuccess = $false

  do {
    if (Test-Connection $(($testCurrentUserDN -split ',DC=')[1..999] -join '.') -Count 1 -Quiet) {
      Write-Host '  User on-prem AD can be reached, perform test query against AD.'

      $testCurrentUserADProps = $null

      try {
        $testSearch = New-Object DirectoryServices.DirectorySearcher
        $testSearch.PageSize = 1000
        $testSearch.SearchRoot = "GC://$(($testCurrentUserDN -split ',DC=')[1..999] -join '.')"
        $testSearch.Filter = "((distinguishedname=$($testCurrentUserDN)))"

        $testCurrentUserADProps = $testSearch.FindOne().Properties
      } catch {
        $testCurrentUserADProps = $null
      }

      if ($null -ne $testCurrentUserADProps) {
        Write-Host '  AD query was successful, user is not locked, DC is reachable via GC query: Start Set-OutlookSignatures.'

        # Get all domains of the current user forest, as they must be reachable, too
        Write-Host '  Testing child domains'

        $testCurrentUserForest = (([ADSI]"LDAP://$(($testCurrentUserDN -split ',DC=')[1..999] -join '.')/RootDSE").rootDomainNamingContext -ireplace [Regex]::Escape('DC='), '' -ireplace [Regex]::Escape(','), '.').tolower()

        $testSearch.SearchRoot = "GC://$($testCurrentUserForest)"
        $testSearch.Filter = '(ObjectClass=trustedDomain)'
        $testTrustedDomains = @($testSearch.FindAll())

        $testTrustedDomains = @(
          @() +
          $testCurrentUserForest +
          @(
            @($testTrustedDomains) | Where-Object { (($_.properties.trustattributes -eq 32) -and ($_.properties.name -ine $testCurrentUserForest)) }
          ).properties.name
        ) | Select-Object -Unique

        $testTrustedDomainFailCount = 0

        foreach ($testTrustedDomain in $testTrustedDomains) {
          if ($testTrustedDomainFailCount -gt 0) {
            break
          }

          Write-Host "    $($testTrustedDomain)"

          foreach ($CheckProtocolText in @('LDAP', 'GC')) {
            if ($testTrustedDomainFailCount -gt 0) {
              break
            }

            $testSearch.searchroot = New-Object System.DirectoryServices.DirectoryEntry("$($CheckProtocolText)://$testTrustedDomain")
            $testSearch.filter = '(objectclass=user)'

            try {
              $null = ([ADSI]"$(($testSearch.FindOne()).path)")

              Write-Host "      $($CheckProtocolText): Passed"
            } catch {
              $testTrustedDomainFailCount++

              Write-Host "      $($CheckProtocolText): Failed"
            }
          }
        }

        if ($testTrustedDomainFailCount -eq 0) {
          $testSuccess = $true
        }

        #
        # Start Set-OutlookSignatures here
        #
      } else {
        Write-Host '  AD query failed, user might be locked or DCs can not be reached via GC query: Do not start Set-OutlookSignatures.'
      }

    } else {
      Write-Host '  User on-prem AD can not be reached, do not go on with further tests.'
    }

    if ($testSuccess -ne $true) {
      $testElapsedSeconds = [math]::Ceiling((New-TimeSpan -Start $testStartTime).TotalSeconds)

      if ($testElapsedSeconds -ge $testTimeoutSeconds) {
        Write-Host "  Timeout reached ($($testTimeoutSeconds) seconds). Tests stopped."
        break
      } else {
        Write-Host "  Retrying in $($testIntervalSeconds) seconds. $($testTimeoutSeconds - $testElapsedSeconds) seconds left until timeout."
        Start-Sleep -Seconds $testIntervalSeconds
      }
    }
  } while ($testSuccess -ne $true)
}
```


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

###Start Set-OutlookSignatures in hidden/invisible mode
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

###Entra ID
Entra ID caches information about dynamic group membership at the group as well as at the user level. It regularly runs the LDAP queries defining dynamic groups and updates existing attributes with member information.

Dynamic groups in Entra ID are therefore not strictly dynamic in terms of running the defining LDAP query every time a dynamic group is used and thus providing near real-time member information - they behave more like regularly updated static groups, which makes handling for scripts and applications much easier.

For the use in Set-OutlookSignatures, there is no difference between a static and a dynamic group in Entra ID:
- Querying the `transitiveMemberOf` attribute of a user returns static as well as dynamic group membership.
- Querying the `members` attribute of a group returns the group's members, no matter if the group is static or dynamic.

###Active Directory on premises
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

| Parameter | Default value | Alternate<br>configuration A | Alternate<br>configuration B | Alternate<br>configuration C |
| :- | :- | :- | :- | :- |
| EmbedImagesInHtml | false | true | true | false |
| DocxHighResImageConversion | true | false | true | false |
| Influence on images | HTM signatures with images consist of multiple files<br><br>Make sure to set the Outlook registry value "Send Pictures With Document" to 1, as described in the documentation of the `EmbedImagesInHtml` parameter. | HTM signatures with images consist of a single file<br><br>Office 2013 can't handle embedded images<br><br>Some versions of Office/Outlook/Word (some Office 2016 builds, for example) show embedded images wrongly sized<br><br>Images can look blurred and pixelated, especially on systems with high display resolution | HTM signatures with images consist of a single file<br><br>Office 2013 can't handle embedded images<br><br>Some versions of Office/Outlook/Word (some Office 2016 builds, for example) show embedded images wrongly sized | HTM signatures with images consist of multiple files<br><br>Images can look blurred and pixelated, especially on systems with high display resolution<br><br>Make sure to set the Outlook registry value "Send Pictures With Document" to 1, as described in the documentation of the EmbedImagesInHtml parameter |
| Recommendation | This configuration should be used as long as there is nothing to the contrary | This configuration should not be used due to the low graphic quality | This configuration may lead to wrongly sized images or images with black background due to a bug in some Office versions | This configuration should not be used due to the low graphic quality |

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

###Application package
The classic way is to deploy an application package. You can use tools such as [IntuneWin32App](https://github.com/MSEndpointMgr/IntuneWin32App) for this.

As Set-OutlookSignatures does not have a classic installer, you will have to create a small wrapper script that simulates an installer. You will have to update the package or create a new one with every new release you plan to use - just as with any other application you want to deploy.

Deployment is only the first step, as the software needs to be run regularly. You have multiple options for this: Let the user run it via a start menu entry or a desktop shortcut, use scheduled tasks, a background service, or a remediation script (which is probably the most convenient way to do it).

###Remediation script
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

###Windows power mode
Windows has power plans and, in newer versions, power modes. These can have a huge impact, as the following test result shows:
- Best power efficiency: 113 seconds
- Balanced: 32 seconds
- Best performance: 27 seconds

###Malware protection
Malware protection is an absolute must, but security typically comes with a drawback in terms of comfort: Malware protection costs performance.

We do not recommend to turn off malware protection, but to optimize it for your environment. Some examples:
- Place Set-OutlookSignatures and template files on a server share. When the files are scanned on the server, you may consider to exclude the server share from scanning on the client.
- Your anti-malware may have an option to not scan digitally signed files every time they are executed. Set-OutlookSignatures and its dependencies are digitally signed with an Extend Validation (EV) certificate for tamper protection and easy integration into locked-down environments. You can sign the executables with your own certificate, too.

###Time of execution
The time of execution can have a huge impact.
- Consider not running Set-OutlookSignatures right at logon, but maybe a bit later. Logon is resource intensive, as not only the user environment is created, but all sorts of automatisms kick off: Autostarting applications, file synchronisation, software updates, and so on.
- Consider not executing all tasks and scripts at the same time, but starting them in groups or one after the other.
- Set-OutlookSignatures relies on network connections. At times with higher network traffic, such as on a Monday morning with all users starting their computers and logging on within a rather short timespan, things may just be a bit slower.
- Do not run Set-OutlookSignatures for all your users at the same time. Instead of "Every two hours, starting at 08:00", use a more varied interval such as "Every two hours after logon".

###Script and Word process priority
As mentioned before, Set-OutlookSignatures usually runs in the background, without the user even noticing it.

From this point of view, processing times do not really matter - slow execution may even be wanted, as it consumes less resources which in turn are available for interactive applications used in the foreground.

You can define the process priority with the `ScriptProcessPriority` and `WordProcessPriority` priority.


## 33. Keep users from adding, editing and removing signatures
###Outlook
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

###Outlook Web
Unfortunately, Outlook Web cannot be configured as granularly as Outlook. In Exchange Online as well as in Exchange on-prem, the `Set-OwaMailboxPolicy` cmdlet does not allow you to configure signature settings in detail, but only to disable or enable signature features`SignaturesEnabled` for specific groups of mailboxes.

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
Set-OutlookSignatures adds a tagline to each signature deployed for mailboxes without a [Benefactor Circle](/benefactorcircle) license.

Signatures for mailboxes with a [Benefactor Circle](/benefactorcircle) license do not get this tagline appended.

Dear companies, please do not forget:
- Invest in the free and open-source software you depend on. Contributors are working behind the scenes to make open-source better for everyone. Give them the help and recognition they deserve.
- Sponsor the free and open-source software your teams use to keep your business running. Fund the projects that make up your software supply chain to improve its performance, reliability, and stability.

Being free and open-source software, Set-OutlookSignatures saves your company a remarkable amount of money compared to commercial software.

Buy a Benefactor Circle license to add additional enterprise-grade features: See [`Benefactor Circle`](/benefactorcircle) for details about these features and their benefits for your business.

### 35.1. Why the tagline?
I initially created Set-OutlookSignatures to give back to the community by showing how to correctly script stuff that I have seen being done in wrong and incomplete ways over and over again:
- Efficient queries for nested Active Directory group membership,
- working with SID history,
- working with AD queries in the most complex environments and across trusts,
- parallel code execution in PowerShell,
- working with Graph,
- and, of course, a fresh approach on how to manage and deploy signatures for Outlook.

Since the free version of Set-OutlookSignatures has first been published in 2021, dozens of features have been added. Quickly scroll through the CHANGELOG to get an idea of what I am talking about.<br>I invested more than a thousand hours of my spare time developing them, and I spent a whole lot of money setting up and maintaining different test environments. And I plan to continue doing so and keep the core of Set-OutlookSignatures free and open source software.

You are probably an Exchange or client administrator, and as such you are part of the community I want to give something back to.

I do not expect or request thank yous from fellow admins, as our community lives from both giving and taking.

I draw the line where companies, rather than individuals, benefit one-sidedly. The tagline reminds companies that they benefit from open source software and that there is a way to ensure that Set-OutlookSignatures remains open source and is developed further by supporting it financially and at the same time gaining access to even more useful features.

By the way: Companies often make wrong assumptions about free and open source software. Open source software absolutely can contain closed source code. Also, the term "open source" does not automatically imply free usage or even free access to the code. And the permission to use software for free does not imply free support.

### 35.2. Not sure if Set-OutlookSignatures is the right solution for your company?
The core of Set-OutlookSignatures is available free of charge as open-source software and can be used for as long and for as many mailboxes as your company wants.<br>All documentation is publicly available, and you can get free community support at GitHub or get first-class fee-based support, training, workshops and more from [ExplicIT Consulting](/support).

For a small annual fee per mailbox, the [Benefactor Circle add-on](/benefactorcircle) offers additional enterprise-grade features.<br>All documentation is publicly available, and the free 14-day trial version allows companies to test all additional features at no cost.

Your company is not sure whether the add-on will pay off?<br>The chapter 'Financial benefits' shows how you can do the calculation tailored to the needs of your company.<br>Should your company come to the conclusion that the add-on does not pay off, it can still use the free and open source version of Set-OutlookSignatures.


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