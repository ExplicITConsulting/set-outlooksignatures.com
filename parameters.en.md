---
layout: "page"
lang: "en"
locale: "en"
title: "Parameters for customization"
subtitle: "How to customize Set-Outlook&shy;Signatures"
description: "Customize Set-OutlookSignatures to fit your organization's needs. Configure behavior, integrate with Microsoft 365, and tailor signature deployment workflows."
permalink: "/parameters"
redirect_from:
  - "/parameters/"
sitemap_priority: 0.8
sitemap_changefreq: weekly
---
<!-- omit in toc -->
## Many roads lead to Rome
<p>Set-OutlookSignatures is designed to be highly flexible and extensively configurable. Its transparent documentation reflects this versatility: Many configuration goals can be achieved in multiple ways.</p>
<p>This page outlines the available parameters to help you tailor the tool to your specific needs. If you're unsure which approach best suits your scenario, additional resources are available:</p>
<p>
  <div class="buttons">
    <a href="/faq" class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-color: limegreen">Frequently Asked Questions (FAQ)</a>
    <a href="/support" class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-color: limegreen">Support</a>
  </div>
</p>


<!-- omit in toc -->
## Parameters
- [1. SignatureTemplatePath](#1-signaturetemplatepath)
- [2. SignatureIniFile](#2-signatureinifile)
- [3. ReplacementVariableConfigFile](#3-replacementvariableconfigfile)
- [4. GraphClientID](#4-graphclientid)
- [5. GraphConfigFile](#5-graphconfigfile)
- [6. TrustsToCheckForGroups](#6-truststocheckforgroups)
- [7. IncludeMailboxForestDomainLocalGroups](#7-includemailboxforestdomainlocalgroups)
- [8. DeleteUserCreatedSignatures](#8-deleteusercreatedsignatures)
- [9. DeleteScriptCreatedSignaturesWithoutTemplate](#9-deletescriptcreatedsignatureswithouttemplate)
- [10. SetCurrentUserOutlookWebSignature](#10-setcurrentuseroutlookwebsignature)
- [11. SetCurrentUserOOFMessage](#11-setcurrentuseroofmessage)
- [12. OOFTemplatePath](#12-ooftemplatepath)
- [13. OOFIniFile](#13-oofinifile)
- [14. AdditionalSignaturePath](#14-additionalsignaturepath)
- [15. UseHtmTemplates](#15-usehtmtemplates)
- [16. SimulateUser](#16-simulateuser)
- [17. SimulateMailboxes](#17-simulatemailboxes)
- [18. SimulateTime](#18-simulatetime)
- [19. SimulateAndDeploy](#19-simulateanddeploy)
- [20. SimulateAndDeployGraphCredentialFile](#20-simulateanddeploygraphcredentialfile)
- [21. GraphOnly](#21-graphonly)
- [22. CloudEnvironment](#22-cloudenvironment)
- [23. CreateRtfSignatures](#23-creatertfsignatures)
- [24. CreateTxtSignatures](#24-createtxtsignatures)
- [25. MoveCSSInline](#25-movecssinline)
- [26. EmbedImagesInHtml](#26-embedimagesinhtml)
- [27. EmbedImagesInHtmlAdditionalSignaturePath](#27-embedimagesinhtmladditionalsignaturepath)
- [28. DocxHighResImageConversion](#28-docxhighresimageconversion)
- [29. SignaturesForAutomappedAndAdditionalMailboxes](#29-signaturesforautomappedandadditionalmailboxes)
- [30. DisableRoamingSignatures](#30-disableroamingsignatures)
- [31. MirrorCloudSignatures](#31-mirrorcloudsignatures)
- [32. MailboxSpecificSignatureNames](#32-mailboxspecificsignaturenames)
- [33. WordProcessPriority](#33-wordprocesspriority)
- [34. ScriptProcessPriority](#34-scriptprocesspriority)
- [35. SignatureCollectionInDrafts](#35-signaturecollectionindrafts)
- [36. BenefactorCircleID](#36-benefactorcircleid)
- [37. BenefactorCircleLicenseFile](#37-benefactorcirclelicensefile)
- [38. VirtualMailboxConfigFile](#38-virtualmailboxconfigfile)


## 1. SignatureTemplatePath
The parameter SignatureTemplatePath tells the software where signature template files are stored.

Local and remote paths are supported. Local paths can be absolute (`C:\Signature templates`) or relative to the software path (`.\templates\Signatures`).

SharePoint document libraries are supported (https only): `https://server.domain/sites/SignatureSite/SignatureDocLib/SignatureFolder` or `\\server.domain@SSL\sites\SignatureSite\SignatureDocLib\SignatureFolder`

Parameters and SharePoint sharing hints ('/:u:/r', etc.) are removed: 'https://YourTenant.sharepoint.com/:u:/r/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini?SomeParam1=1&SomeParam2=2' -> 'https://yourtenant.sharepoint.com/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini'

On Linux and macOS, only already existing mount points and SharePoint Online paths can be accessed. Set-OutlookSignatures cannot create mount points itself, and access to SharePoint on-prem paths is a Windows-only feature.

For access to SharePoint Online, the Entra ID app needs the Files.Read.All or Files.SelectedOperations.Selected permission, and you need to pass the 'GraphClientID' parameter to Set-OutlookSignatures.

Default value: '.\sample templates\Signatures DOCX' on Windows, '.\sample templates\Signatures HTML' on Linux and macOS

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SignatureTemplatePath '.\sample templates\Signatures DOCX`'  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SignatureTemplatePath '.\sample templates\Signatures DOCX'"`


## 2. SignatureIniFile
Template tags are placed in an INI file.

The file must be UTF-8 encoded (without BOM).

See '.\templates\Signatures DOCX\_Signatures.ini' for a sample file with further explanations.

Local and remote paths are supported. Local paths can be absolute ('C:\Signature templates') or relative to the software path ('.\templates\Signatures')

SharePoint document libraries are supported (https only): 'https://server.domain/sites/SignatureSite/SignatureDocLib/SignatureFolder' or '\\server.domain@SSL\sites\SignatureSite\SignatureDocLib\SignatureFolder'

Parameters and SharePoint sharing hints ('/:u:/r', etc.) are removed: 'https://YourTenant.sharepoint.com/:u:/r/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini?SomeParam1=1&SomeParam2=2' -> 'https://yourtenant.sharepoint.com/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini'

On Linux and macOS, only already existing mount points and SharePoint Online paths can be accessed. Set-OutlookSignatures cannot create mount points itself, and access to SharePoint on-prem paths is a Windows-only feature.

For access to SharePoint Online, the Entra ID app needs the Files.Read.All or Files.SelectedOperations.Selected permission, and you need to pass the 'GraphClientID' parameter to Set-OutlookSignatures.

Default value: '.\templates\Signatures DOCX\_Signatures.ini' on Windows, '.\templates\Signatures HTML\_Signatures.ini' on Linux and macOS

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SignatureIniFile '.\templates\Signatures DOCX\_Signatures.ini`'  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SignatureIniFile '.\templates\Signatures DOCX\_Signatures.ini'"`


## 3. ReplacementVariableConfigFile
The parameter ReplacementVariableConfigFile tells the software where the file defining replacement variables is located.

The file must be UTF-8 encoded (without BOM).

Local and remote paths are supported. Local paths can be absolute (`C:\config\default replacement variables.ps1`) or relative to the software path (`.\config\default replacement variables.ps1`).

SharePoint document libraries are supported (https only): `https://server.domain/SignatureSite/config/default replacement variables.ps1` or `\\server.domain@SSL\SignatureSite\config\default replacement variables.ps1`

Parameters and SharePoint sharing hints ('/:u:/r', etc.) are removed: 'https://YourTenant.sharepoint.com/:u:/r/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini?SomeParam1=1&SomeParam2=2' -> 'https://yourtenant.sharepoint.com/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini'

On Linux and macOS, only already existing mount points and SharePoint Online paths can be accessed. Set-OutlookSignatures cannot create mount points itself, and access to SharePoint on-prem paths is a Windows-only feature.

For access to SharePoint Online, the Entra ID app needs the Files.Read.All or Files.SelectedOperations.Selected permission, and you need to pass the 'GraphClientID' parameter to Set-OutlookSignatures.

Default value: `.\config\default replacement variables.ps1`  

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -ReplacementVariableConfigFile '.\config\default replacement variables.ps1`'  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -ReplacementVariableConfigFile '.\config\default replacement variables.ps1'"`


## 4. GraphClientID
ID of the Entra ID app to use for Graph authentication.

GraphClientID can be defined in two places: As parameter or in a custom '`GraphConfigFile`'.
It is recommended to use the parameter.
The parameter must be used when the parameter '`GraphConfigFile`' points to a SharePoint Online location.

Per default, GraphClientID is not overwritten by the configuration defined in GraphConfigFile, but you can change this in the Graph config file itself.

GraphClientID accepts two input formats:
- A string when used in a single-tenant
- A nested array when used in cross-tenant configuration.

Set-OutlookSignatures and the Benefactor Circle add-on support cross-tenant access. This allows to deploy signatures to mailboxes that are not hosted in the users home tenant, with all the properties, replacement variables and Benefactor Circle being fully available.

Cross-tenant access is not limited to what Microsoft calls [Multitenant Organization](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/overview), it can be established between any two tenants allowing cross-tenant access for the other.

The requirements for cross-tenant access support are:
-	The currently logged-in user must have an external identity in each of the other tenants that should be accessed.
-	These external identities must be of type 'Member', not of type 'Guest'.to ensure that the required Graph API queries can be executed.
-	Make sure that '[Automatic redemption](https://learn.microsoft.com/en-us/entra/external-id/cross-tenant-access-settings-b2b-collaboration)' is enabled in both the source and the target tenants. Else, users will be asked for interactive consent the first time they use cross-tenant access. An app like Set-OutlookSignatures can neither check this setting nor inform the user beforehand.
-	Make sure that authentication can happen silently. This means that the target tenants must trust MFA, compliant devices and Entra hybrid joined devices of the source tenant. If this is not the case, users might be required to authenticate themselves interactively when Set-OutlookSignatures runs.
-	Each tenant must have its own Entra ID app for Set-OutlookSignatures, with identical permissions across tenants. You need to pass the combination of target tenant ID and App ID using the GraphClientID parameter as nested array, including the home tenant of the user. As a tenant identifier, you can use the tenant ID or any of its registered domains ('`-GraphClientID @(@('tenant-a.onmicrosoft.com', '<Tenant-A-App-ID>'), @('tenant-b.example.com', '<Tenant-B-App-ID>'), @('00000000-0000-0000-0000-000000000000', '<Tenant-C-App-ID>'))`')
-	Authentication will happen as soon as Graph access is required for the first time. All tenants defined by the GraphClientID parameter will be authenticated (the order does not matter).
- To use Benefactor Circle features, each tenant must have its own license group, and the license file must contain all of these groups.

Default value: $null

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 GraphClientID '3dc5f201-6c36-4b94-98ca-c66156a686a8'`
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 GraphClientID '3dc5f201-6c36-4b94-98ca-c66156a686a8'"`


## 5. GraphConfigFile
The parameter GraphConfigFile tells the software where the file defining Graph connection and configuration options is located.

The file must be UTF-8 encoded (without BOM).

Local and remote paths are supported. Local paths can be absolute (`C:\config\default graph config.ps1`) or relative to the software path (`.\config\default graph config.ps1`).

SharePoint document libraries are supported (https only): `https://server.domain/SignatureSite/config/default graph config.ps1` or `\\server.domain@SSL\SignatureSite\config\default graph config.ps1`

Parameters and SharePoint sharing hints ('/:u:/r', etc.) are removed: 'https://YourTenant.sharepoint.com/:u:/r/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini?SomeParam1=1&SomeParam2=2' -> 'https://yourtenant.sharepoint.com/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini'

When GraphConfigFile is hosted on SharePoint Online, it is highly recommended to set the `GraphClientID` parameter. Else, access to GraphConfigFile will fail on Linux and macOS, and fall back to WebDAV with a required Internet Explorer authentication cookie on Windows.

On Linux and macOS, only already existing mount points and SharePoint Online paths can be accessed. Set-OutlookSignatures cannot create mount points itself, and access to SharePoint on-prem paths is a Windows-only feature.

For access to SharePoint Online, the Entra ID app needs the Files.Read.All or Files.SelectedOperations.Selected permission, and you need to pass the 'GraphClientID' parameter to Set-OutlookSignatures.

Default value: `.\config\default graph config.ps1`  

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -GraphConfigFile '.\config\default graph config.ps1`'  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 GraphConfigFile '.\config\default graph config.ps1'"`


## 6. TrustsToCheckForGroups
List of domains to check for group membership.

If the first entry in the list is '*', all outgoing and bidirectional trusts in the current user's forest are considered.

If a string starts with a minus or dash ('-domain-a.local'), the domain after the dash or minus is removed from the list (no wildcards allowed).

All domains belonging to the Active Directory forest of the currently logged-in user are always considered, but specific domains can be removed (`*', '-childA1.childA.user.forest`).

When a cross-forest trust is detected by the '*' option, all domains belonging to the trusted forest are considered but specific domains can be removed (`*', '-childX.trusted.forest`).

On Linux and macOS, this parameter is ignored because on-prem Active Directories are not supported (only Graph is supported).

Default value: '*'

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -TrustsToCheckForGroups 'corp.example.com', 'corp.example.net`'  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -TrustsToCheckForGroups 'corp.example.com', 'corp.example.net'"`


## 7. IncludeMailboxForestDomainLocalGroups
Shall the software consider group membership in domain local groups in the mailbox's AD forest?

Per default, membership in domain local groups in the mailbox's forest is not considered as the required LDAP queries are slow and domain local groups are usually not used in Exchange.

Domain local groups across trusts behave differently, they are always considered as soon as the trusted domain/forest is included in TrustsToCheckForGroups.

On Linux and macOS, this parameter is ignored because on-prem Active Directories are not supported (only Graph is supported).

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $false

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -IncludeMailboxForestDomainLocalGroups $false`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -IncludeMailboxForestDomainLocalGroups false`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -IncludeMailboxForestDomainLocalGroups $false"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -IncludeMailboxForestDomainLocalGroups false"`


## 8. DeleteUserCreatedSignatures 
Shall the software delete signatures which were created by the user itself?

This feature requires a Benefactor Circle license.

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $false

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -DeleteUserCreatedSignatures $false`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -DeleteUserCreatedSignatures false`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -DeleteUserCreatedSignatures $false"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -DeleteUserCreatedSignatures false"`


## 9. DeleteScriptCreatedSignaturesWithoutTemplate
Shall the software delete signatures which were created by the software before but are no longer available as template?

This feature requires a Benefactor Circle license.

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $true

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -DeleteScriptCreatedSignaturesWithoutTemplate $false`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -DeleteScriptCreatedSignaturesWithoutTemplate false`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -DeleteScriptCreatedSignaturesWithoutTemplate $false"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -DeleteScriptCreatedSignaturesWithoutTemplate false"`


## 10. SetCurrentUserOutlookWebSignature
Shall the software set the Outlook Web signature of the currently logged-in user?

If the parameter is set to `$true` and the current user's mailbox is not configured in any Outlook profile, the current user's mailbox is considered nevertheless. If no Outlook mailboxes are configured at all, additional mailbox configured in Outlook Web are used. This way, the software can be used in environments where only Outlook Web is used. 

This feature requires a Benefactor Circle license.

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $true  

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SetCurrentUserOutlookWebSignature $true`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SetCurrentUserOutlookWebSignature true`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SetCurrentUserOutlookWebSignature $true"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SetCurrentUserOutlookWebSignature true"`


## 11. SetCurrentUserOOFMessage
Shall the software set the out-of-office (OOF) message of the currently logged-in user?

If the parameter is set to `$true` and the current user's mailbox is not configured in any Outlook profile, the current user's mailbox is considered nevertheless. If no Outlook mailboxes are configured at all, additional mailbox configured in Outlook Web are used. This way, the software can be used in environments where only Outlook Web is used. 

This feature requires a Benefactor Circle license.

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $true  

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SetCurrentUserOOFMessage $true`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SetCurrentUserOOFMessage true`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SetCurrentUserOOFMessage $true"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SetCurrentUserOOFMessage true"`


## 12. OOFTemplatePath
Path to centrally managed out-of-office templates.

Local and remote paths are supported.

Local paths can be absolute (`C:\OOF templates`) or relative to the software path (`.\templates\ Out-of-office `).

SharePoint document libraries are supported (https only): `https://server.domain/SignatureSite/OOFTemplates` or `\\server.domain@SSL\SignatureSite\OOFTemplates`

Parameters and SharePoint sharing hints ('/:u:/r', etc.) are removed: 'https://YourTenant.sharepoint.com/:u:/r/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini?SomeParam1=1&SomeParam2=2' -> 'https://yourtenant.sharepoint.com/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini'

On Linux and macOS, only already existing mount points and SharePoint Online paths can be accessed. Set-OutlookSignatures cannot create mount points itself, and access to SharePoint on-prem paths is a Windows-only feature.

For access to SharePoint Online, the Entra ID app needs the Files.Read.All or Files.SelectedOperations.Selected permission, and you need to pass the 'GraphClientID' parameter to Set-OutlookSignatures.

Default value: '.\templates\Signatures DOCX\_Signatures.ini' on Windows, '.\templates\Signatures DOCX\_Signatures.ini' on Linux and macOS

Default value: `.\templates\Out-of-Office DOCX` on Windows, `.\templates\Out-of-Office DOCX` on Linux and macOS

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -OOFTemplatePath '.\templates\Out-of-Office DOCX`'  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -OOFTemplatePath '.\templates\Out-of-Office DOCX'"`


## 13. OOFIniFile
Template tags are placed in an INI file.

The file must be UTF-8 encoded (without BOM).

See '`.\templates\Out-of-Office DOCX\_OOF.ini`' for a sample file with further explanations.

Local and remote paths are supported. Local paths can be absolute ('C:\Signature templates') or relative to the software path ('.\templates\Signatures')

SharePoint document libraries are supported (https only): 'https://server.domain/sites/SignatureSite/SignatureDocLib/SignatureFolder' or '\\server.domain@SSL\sites\SignatureSite\SignatureDocLib\SignatureFolder'

Parameters and SharePoint sharing hints ('/:u:/r', etc.) are removed: 'https://YourTenant.sharepoint.com/:u:/r/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini?SomeParam1=1&SomeParam2=2' -> 'https://yourtenant.sharepoint.com/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini'

On Linux and macOS, only already existing mount points and SharePoint Online paths can be accessed. Set-OutlookSignatures cannot create mount points itself, and access to SharePoint on-prem paths is a Windows-only feature.

For access to SharePoint Online, the Entra ID app needs the Files.Read.All or Files.SelectedOperations.Selected permission, and you need to pass the 'GraphClientID' parameter to Set-OutlookSignatures.

Default value: `.\templates\Out-of-Office DOCX\_OOF.ini` on Windows, Default value: `.\templates\Out-of-Office HTML\_OOF.ini` on Linux and macOS

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -OOFIniFile '.\templates\Out-of-Office DOCX\_OOF.ini`'  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -OOFIniFile '.\templates\Out-of-Office DOCX\_OOF.ini'"`


## 14. AdditionalSignaturePath
An additional path that the signatures shall be copied to.  
Ideally, this path is available on all devices of the user, for example via Microsoft OneDrive or Nextcloud.

This way, the user can easily copy-paste his preferred preconfigured signature for use in an email app not supported by this script, such as Microsoft Outlook Mobile, Apple Mail, Google Gmail or Samsung Email.

Local and remote paths are supported.

Local paths can be absolute (`C:\Outlook signatures`) or relative to the software path (`.\Outlook signatures`).

SharePoint document libraries are supported (https only, no SharePoint Online): `https://server.domain/User/Outlook signatures` or `\\server.domain@SSL\User\Outlook signatures`

Parameters and SharePoint sharing hints ('/:u:/r', etc.) are removed: 'https://YourTenant.sharepoint.com/:u:/r/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini?SomeParam1=1&SomeParam2=2' -> 'https://yourtenant.sharepoint.com/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini'

The currently logged-in user needs at least write access to the path.

If the folder or folder structure does not exist, it is created.

On Linux and macOS, only already existing mount points and SharePoint Online paths can be accessed. Set-OutlookSignatures cannot create mount points itself, and access to SharePoint on-prem paths is a Windows-only feature.

For access to SharePoint Online, the Entra ID app needs the Files.Read.All or Files.SelectedOperations.Selected permission, and you need to pass the 'GraphClientID' parameter to Set-OutlookSignatures.

Also see related parameter 'EmbedImagesInHtmlAdditionalSignaturePath'.

This feature requires a Benefactor Circle license (when used outside of simulation mode).

Default value: `"$(try { $([IO.Path]::Combine([environment]::GetFolderPath('MyDocuments'), 'Outlook Signatures')) } catch {})"`  

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -AdditionalSignaturePath "$(try { $([IO.Path]::Combine([environment]::GetFolderPath('MyDocuments'), 'Outlook Signatures')) } catch {})"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -AdditionalSignaturePath ""$(try { $([IO.Path]::Combine([environment]::GetFolderPath('MyDocuments'), 'Outlook Signatures')) } catch {})"""`


## 15. UseHtmTemplates
With this parameter, the software searches for templates with the extension .htm instead of .docx.

Templates in .htm format must be UTF-8 encoded (without BOM) and the charset must be set to UTF-8 (`<META content="text/html; charset=utf-8">`).

Each format has advantages and disadvantages, please see `Should I use .docx or .htm as file format for templates? Signatures in Outlook sometimes look different than my templates.` in this document for a quick overview.

Only images in the first subfolder below the template file matching the Windows Connected Files naming convention (https://docs.microsoft.com/en-us/windows/win32/shell/manage#connected-files) are downloaded. Only use relative paths for the src attribute in img tags. All other paths are considered external and are not downloaded.

Also see the documentation for the '`EmbedImagesInHtml`' parameter.

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $false on Windows, $true on Linux and macOS

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -UseHtmTemplates $false`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -UseHtmTemplates false`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -UseHtmTemplates $false"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -UseHtmTemplates false"`


## 16. SimulateUser
SimulateUser is a mandatory parameter for simulation mode. This value replaces the currently logged-in user.

Use a logon name in the format 'Domain\User' or a Universal Principal Name (UPN, looks like an email address, but is not necessarily one).

Default value: $null

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SimulateUser "EXAMPLEDOMAIN\UserA"`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SimulateUser "user.a@example.com"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SimulateUser ""EXAMPLEDOMAIN\UserA"""`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SimulateUser ""user.a@example.com"""`


## 17. SimulateMailboxes
SimulateMailboxes is optional for simulation mode, although highly recommended.

It is a comma separated list of email addresses replacing the list of mailboxes otherwise gathered from the simulated user's Outlook Web.

Default value: $null

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SimulateMailboxes 'user.b@example.com', 'user.b@example.net`'  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SimulateMailboxes 'user.a@example.com', 'user.b@example.net'"`


## 18. SimulateTime
SimulateTime is optional for simulation mode.

Use a certain timestamp for simulation mode. This allows you to simulate time-based templates.

Format: yyyyMMddHHmm (yyyy = year, MM = two-digit month, dd = two-digit day, HH = two-digit hour (0..24), mm = two-digit minute), local time

Default value: $null

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SimulateTime "202312311859"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SimulateTime ""202312311859"""`  


## 19. SimulateAndDeploy
Not only simulate, but also deploy signatures to Outlook Web/New Outlook (when based on New Outlook).

Makes only sense in combination with '.\sample code\SimulateAndDeploy.ps1', do not use this parameter for other scenarios

See '.\sample code\SimulateAndDeploy.ps1' for an example how to use this parameter

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $false

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SimulateAndDeploy $false`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SimulateAndDeploy false`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SimulateAndDeploy $false"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SimulateAndDeploy false"`


## 20. SimulateAndDeployGraphCredentialFile
Path to file containing Graph credential which should be used as alternative to other token acquisition methods.

Makes only sense in combination with `.\sample code\SimulateAndDeploy.ps1`, do not use this parameter for other scenarios.

See `.\sample code\SimulateAndDeploy.ps1` for an example how to create and use this file.

Default value: $null


## 21. GraphOnly
Try to connect to Microsoft Graph only, ignoring any local Active Directory.

The default behavior is to try Active Directory first and fall back to Graph. On Linux and macOS, only Graph is supported.

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $false on Windows, $true on Linux and macOS

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -GraphOnly $false`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -GraphOnly false`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -GraphOnly $false"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -GraphOnly false"`


## 22. CloudEnvironment
The cloud environment to connect to.

Allowed values:
- 'Public' (or: 'Global', 'AzurePublic', 'AzureGlobal', 'AzureCloud', 'AzureUSGovernmentGCC', 'USGovernmentGCC')
- 'AzureUSGovernment' (or: 'AzureUSGovernmentGCCHigh', 'AzureUSGovernmentL4', 'USGovernmentGCCHigh', 'USGovernmentL4')
- 'AzureUSGovernmentDOD' (or: 'AzureUSGovernmentL5', 'USGovernmentDOD', 'USGovernmentL5')
- 'China' (or: 'AzureChina', 'ChinaCloud', 'AzureChinaCloud')

Default value: 'Public'

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -CloudEnvironment "Public"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -CloudEnvironment ""Public"""`  


## 23. CreateRtfSignatures
Should signatures be created in RTF format?

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $false

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -CreateRtfSignatures $false`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -CreateRtfSignatures false`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -CreateRtfSignatures $false"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -CreateRtfSignatures false"`


## 24. CreateTxtSignatures
Should signatures be created in TXT format?

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $true

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -CreateTxtSignatures $true`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -CreateTxtSignatures true`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -CreateTxtSignatures $true"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -CreateTxtSignatures true"`


## 25. MoveCSSInline
Move CSS to inline style attributes, for maximum email client compatibility.

This parameter is enabled per default, as a workaround to Microsoft's problem with formatting in Outlook Web (M365 roaming signatures and font sizes, especially).

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $true

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -MoveCSSInline $true`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -MoveCSSInline true`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -MoveCSSInline $true"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -MoveCSSInline true"`


## 26. EmbedImagesInHtml
Should images be embedded into HTML files?

When using HTML templates: Only images in the first subfolder below the template file matching the Windows Connected Files naming convention (https://docs.microsoft.com/en-us/windows/win32/shell/manage#connected-files) are supported. Only use relative paths for the src attribute in img tags. All other paths are considered external and are not embedded.

Outlook 2016 and newer can handle images embedded directly into an HTML file as BASE64 string (`<img src="data:image/[…]"`).

Outlook 2013 and earlier can't handle these embedded images when composing HTML emails (there is no problem receiving such emails, or when composing RTF or TXT emails).

When setting EmbedImagesInHtml to `$false`, consider setting the Outlook registry value "Send Pictures With Document" to 1 to ensure that images are sent to the recipient (see https://support.microsoft.com/en-us/topic/inline-images-may-display-as-a-red-x-in-outlook-704ae8b5-b9b6-d784-2bdf-ffd96050dfd6 for details). Set-OutlookSignatures does this automatically for the currently logged-in user, but it may be overridden by other scripts or group policies.

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $false

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -EmbedImagesInHtml $false`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -EmbedImagesInHtml false`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -EmbedImagesInHtml $false"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -EmbedImagesInHtml false"`


## 27. EmbedImagesInHtmlAdditionalSignaturePath
Some feature as 'EmbedImagesInHtml' parameter, but only valid for the path defined in AdditionalSignaturePath when not in simulation mode.

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $true

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -EmbedImagesInHtmlAdditionalSignaturePath $true`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -EmbedImagesInHtmlAdditionalSignaturePath true`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -EmbedImagesInHtmlAdditionalSignaturePath $true"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -EmbedImagesInHtmlAdditionalSignaturePath true"`


## 28. DocxHighResImageConversion
Enables or disables high resolution images in HTML signatures.

When enabled, this parameter uses a workaround to overcome a Word limitation that results in low resolution images when converting to HTML. The price for high resolution images in HTML signatures are more time needed for document conversion and signature files requiring more storage space.

Disabling this feature speeds up DOCX to HTML conversion, and HTML signatures require less storage space - at the cost of lower resolution images.

Contrary to conversion to HTML, conversion to RTF always results in high resolution images.

This feature requires a Benefactor Circle license.

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $true

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -DocxHighResImageConversion $true`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -DocxHighResImageConversion true`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -DocxHighResImageConversion $true"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -DocxHighResImageConversion true"`


## 29. SignaturesForAutomappedAndAdditionalMailboxes
Deploy signatures for automapped mailboxes and additional mailboxes.

Signatures can be deployed for these mailboxes, but not set as default signature due to technical restrictions in Outlook.

This feature requires a Benefactor Circle license.

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $true

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SignaturesForAutomappedAndAdditionalMailboxes $true`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SignaturesForAutomappedAndAdditionalMailboxes true`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SignaturesForAutomappedAndAdditionalMailboxes $true"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SignaturesForAutomappedAndAdditionalMailboxes true"`


## 30. DisableRoamingSignatures
Disable signature roaming in Classic Outlook for Windows. Has no effect on signature roaming via the MirrorCloudSignatures parameter.

A value representing true disables roaming signatures, a value representing false enables roaming signatures, any other value leaves the setting as-is.

Attention:
- When Outlook v16 and higher is allowed to sync signatures itself, it may overwrite signatures created by this software with their cloud versions. To avoid this, it is recommended to set the parameters DisableRoamingSignatures and MirrorCloudSignatures to true instead.
- When Classic Outlook for Windows syncs roaming signatures witht its own internal engine, expect problems with character encoding (umlauts, diacritics, emojis, etc.) and more. Until Microsoft provides a sustaining solution, these Outlook-internal problems will come and go depending on the patch level of Outlook. Also see FAQ '`Roaming signatures in Classic Outlook for Windows look different`' in this document.

Only sets HKCU registry key, does not override configuration set by group policy.

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no', $null, ''

Default value: $true

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -DisableRoamingSignatures $true`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -DisableRoamingSignatures true`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -DisableRoamingSignatures $true"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -DisableRoamingSignatures true"`


## 31. MirrorCloudSignatures
Should local signatures be mirrored with signatures in Exchange Online?

Possible for Exchange Online mailboxes:
- Download for every mailbox where the current user has full access
- Upload and set default signaures for the mailbox of the current user

Prerequisites:
- Download
  - Current user has full access to the mailbox
  - When set to '`CurrentUserOnly`': Mailbox is the mailbox of the currently logged-in user and is hosted in Exchange Online
- Upload, set default signatures
  - Script parameter `SetCurrentUserOutlookWebSignature` is set to `true`
  - Mailbox is the mailbox of the currently logged-in user and is hosted in Exchange Online

Please note:
- As there is no Microsoft official API yet, this feature is to be used at your own risk.
- This feature does not work in simulation mode, because the user running the simulation does not have access to the signatures stored in another mailbox.
- For mailboxes in Exchange Online: To delete manually created signatures (signatures that have not been created by Set-OutlookSignatures) you need to use New Outlook for Windows or Classic Outlook for Windows with its own roaming signature sync mechanism enabled, or you delete the signature both locally and in Outlook Web.<br>Else, manually created signatures will be re-downloaded from the cloud or re-uploaded to the cloud because Set-OutlookSignatures technically cannot detect the deletion.
  - When a signature exists in only one of two places, and both places can neither be permanently monitored nor provide an activity log: Has the signature been deleted in the one place, or has it been created in the other? This question cannot be answered. To avoid data loss, Set-OutlookSignatures always assumes the signature has been created.

The process is very simple and straight forward. Set-OutlookSignatures goes through the following steps for each mailbox:
1. Check if all prerequisites are met
2. Download all signatures stored in the Exchange Online mailbox
  - This mimics Outlook's behavior: Roaming signatures are only manipulated in the cloud and then downloaded from there.
  - An existing local signature is only overwritten when the cloud signature is newer and when it has not been processed before for a mailbox with higher priority
3. Go through standard template and signature processing
  - Loop through the templates and their configuration, and convert them to signatures
  - Set default signatures for replies and forwards
  - If configured, delete signatures created by the user
  - If configured, delete signatures created earlier by Set-OutlookSignatures but now no longer have a corresponding central configuration
4. Delete all signatures in the cloud and upload all locally stored signatures to the user's personal mailbox as roaming signatures

There may be too many signatures available in the cloud - in this case, having too many signatures is better than missing some.

Another advantage of this solution is that it makes roaming signatures available in Outlook versions that do not officially support them.

What will not work:
- Download from mailboxes where the current user does not have full access rights. This is not possible because of Microsoft API restrictions.
- Download from and upload to shared mailboxes. This is not possible because of Microsoft API restrictions.
- Uploading signatures other than device specific signatures and such assigned to the mailbox of the current user. Uploading is not implemented, because until now no way could be found that does not massively impact the user experience as soon as the Outlook integrated download process starts (signatures available multiple times, etc.)

Attention: When Outlook v16 and higher is allowed to sync signatures itself, it may overwrite signatures created by this software with their cloud versions. To avoid this, it is recommended to set the parameters DisableRoamingSignatures and MirrorCloudSignatures to true instead. Also see FAQ '`Roaming signatures in Classic Outlook for Windows look different`' in this document.

Consider combining MirrorCloudSignatures with MailboxSpecificSignatureNames.

This feature requires a Benefactor Circle license.

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no', 'CurrentUserOnly'

Default value: $true

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -MirrorCloudSignatures $false`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -MirrorCloudSignatures false`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -MirrorCloudSignatures $false"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -MirrorCloudSignatures false"`


## 32. MailboxSpecificSignatureNames
Should signature names be mailbox specific by adding the email address?

For compatibility with Outlook storing signatures in the file system, Set-OutlookSignatures converts templates to signatures according to the following logic:
1. Get all mailboxes and sort them: Mailbox of logged-on/simulated user, other mailboxes in default Outlook profile or Outlook Web, mailboxes from other Outlook profiles
2. Get all template files, sort them by category (common, group specific, mailbox specific, replacement variable specific), and within each category by SortOrder and SortCulture defined in the INI file
3. Loop through the mailbox list, and for each mailbox loop through the template list.
4. If a template's conditions apply and if the template has not been used before, convert the template to a signature.

The step 4 condition `if the template has not been used before` makes sure that a lower priority mailbox does not replace a signature with the same name which has already been created for a higher priority mailbox.

With roaming signatures (signatures being stored in the Exchange Online mailbox itself) being used more and more, the step 4 condition `if the template has not been used before` makes less sense. By setting the `MailboxSpecificSignatureNames` parameter to `true`, this restriction no longer applies. To avoid naming collisions, the email address of the current mailbox is added to the name of the signature - instead of a single `Signature A` file, Set-OutlookSignatures can create a separate signature file for each mailbox: `Signature A (user.a@example.com)`, `Signature A (mailbox.b@example.net)`, etc.

This naming convention intentionally matches Outlook's convention for naming roaming signatures. Before setting `MailboxSpecificSignatureNames` to `true`, consider the impact on the `DisableRoamingSignatures` and `MirrorCloudSignatures` parameters - it is recommended to set both parameters to `true` to achieve the best user experience and to avoid problems with Outlook's own roaming signature synchronisation.

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $false

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -MailboxSpecificSignatureNames $false`
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -MailboxSpecificSignatureNames false`
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -MailboxSpecificSignatureNames $false"`
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -MailboxSpecificSignatureNames false"`


## 33. WordProcessPriority
Define the Word process priority. With lower values, Set-OutlookSignatures runs longer but minimizes possible performance impact

Allowed values (ascending priority): Idle, 64, BelowNormal, 16384, Normal, 32, AboveNormal, 32768, High, 128, RealTime, 256

Default value: 'Normal' ('32')

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -WordProcessPriority Normal`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -WordProcessPriority 32`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -WordProcessPriority Normal"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -WordProcessPriority 32"`


## 34. ScriptProcessPriority
Define the script process priority. With lower values, Set-OutlookSignatures runs longer but minimizes possible performance impact

Allowed values (ascending priority): Idle, 64, BelowNormal, 16384, Normal, 32, AboveNormal, 32768, High, 128, RealTime, 256

Default value: 'Normal' ('32')

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -ScriptProcessPriority Normal`  
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -ScriptProcessPriority 32`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -ScriptProcessPriority Normal"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -ScriptProcessPriority 32"`


## 35. SignatureCollectionInDrafts
When enabled, this creates and updates an email message with the subject 'My signatures, powered by Set-OutlookSignatures Benefactor Circle' in the drafts folder of the current user, containing all available signatures in HTML and plain text for easy access in mail clients that do not have a signatures API.

This feature requires a Benefactor Circle license.

Allowed values: 1, 'true', '$true', 'yes', 0, 'false', '$false', 'no'

Default value: $true

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SignatureCollectionInDrafts $false`
Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -SignatureCollectionInDrafts false`
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SignatureCollectionInDrafts $false"`
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -SignatureCollectionInDrafts false"`


## 36. BenefactorCircleID
The Benefactor Circle member ID matching your license file, which unlocks exclusive features.

Default value: ''

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -BenefactorCircleID "00000000-0000-0000-0000-000000000000"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -BenefactorCircleID ""00000000-0000-0000-0000-000000000000"""`  


## 37. BenefactorCircleLicenseFile
The Benefactor Circle license file matching your Benefactor Circle ID, which unlocks exclusive features.

Default value: ''

Local and remote paths are supported. Local paths can be absolute ('C:\Signature templates') or relative to the software path ('.\templates\Signatures')

SharePoint document libraries are supported (https only): 'https://server.domain/sites/SignatureSite/SignatureDocLib/SignatureFolder' or '\\server.domain@SSL\sites\SignatureSite\SignatureDocLib\SignatureFolder'

Parameters and SharePoint sharing hints ('/:u:/r', etc.) are removed: 'https://YourTenant.sharepoint.com/:u:/r/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini?SomeParam1=1&SomeParam2=2' -> 'https://yourtenant.sharepoint.com/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini'

On Linux and macOS, only already existing mount points and SharePoint Online paths can be accessed. Set-OutlookSignatures cannot create mount points itself, and access to SharePoint on-prem paths is a Windows-only feature.

For access to SharePoint Online, the Entra ID app needs the Files.Read.All or Files.SelectedOperations.Selected permission, and you need to pass the 'GraphClientID' parameter to Set-OutlookSignatures.

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -BenefactorCircleLicenseFile ".\license.dll"`  
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -BenefactorCircleLicenseFile "".\license.dll"""`  


## 38. VirtualMailboxConfigFile
Path a PowerShell file containing the logic to define virtual mailboxes. You can also use the VirtualMailboxConfigFile to dynamically define signature INI file and out-of-office INI entries.

Virtual mailboxes are mailboxes that are not available in Outlook but are treated by Set-OutlookSignatures as if they were.

This is an option for scenarios where you want to deploy signatures or out-of-office replies with not only the '`$CurrentUser…$`' but also '`$CurrentMailbox…$`' replacement variables for mailboxes that have not been added to Outlook, such as in Send As or Send On Behalf scenarios, where users often only change the from address but do not add the mailbox to Outlook.

See '`.\sample code\VirtualMailboxConfigFile.ps1`' for sample code showing the most relevant use cases.

For maximum automation, use VirtualMailboxConfigFile together with [Export-RecipientPermissions](https://github.com/Export-RecipientPermissions).

This feature requires a Benefactor Circle license.

Local and remote paths are supported. Local paths can be absolute ('C:\VirtualMailboxConfigFile.ps1') or relative to the software path ('.\sample code\VirtualMailboxConfigFile')

SharePoint document libraries are supported (https only): 'https://server.domain/SignatureSite/config/VirtualMailboxConfigFile.ps1' or '\\server.domain@SSL\SignatureSite\config\VirtualMailboxConfigFile.ps1'

Parameters and SharePoint sharing hints ('/:u:/r', etc.) are removed: 'https://YourTenant.sharepoint.com/:u:/r/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini?SomeParam1=1&SomeParam2=2' -> 'https://yourtenant.sharepoint.com/sites/SomeSite/SomeLibrary/SomeFolder/SomeFile.ini'

On Linux and macOS, only already existing mount points and SharePoint Online paths can be accessed. Set-OutlookSignatures cannot create mount points itself, and access to SharePoint on-prem paths is a Windows-only feature.

For access to SharePoint Online, the Entra ID app needs the Files.Read.All or Files.SelectedOperations.Selected permission, and you need to pass the 'GraphClientID' parameter to Set-OutlookSignatures.

Default value: ''

Usage example PowerShell: `& .\Set-OutlookSignatures.ps1 -VirtualMailboxConfigFile '.\sample code\VirtualMailboxConfigFile.ps1'`
Usage example Non-PowerShell: `powershell.exe -command "& .\Set-OutlookSignatures.ps1 -VirtualMailboxConfigFile '.\sample code\VirtualMailboxConfigFile.ps1'"`