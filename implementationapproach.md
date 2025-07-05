---
layout: page
lang: en
title: Implementation approach
subtitle: Real-life experience implementing the software in multi-client environments with a five-digit number of mailboxes
description: Real-life experience implementing the software in multi-client environments with a five-digit number of mailboxes
image:
  path: "/assets/images/set-outlooksignatures benefactor circle opengraph1200x630.png"
  height: 1200
  width: 630
  alt: "Set-OutlookSignatures Benefactor Circle"
---


## What is the recommended approach for implementing the software? <!-- omit in toc -->
There is certainly no definitive generic recommendation, but this document should be a good starting point.

The content is based on real-life experience implementing the software in multi-client environments with a five-digit number of mailboxes.

It contains proven procedures and recommendations for product managers, architects, operations managers, account managers and mail and client administrators. It is suited for service providers as well as for clients.

It covers several general overview topics, administration, support, training across the whole lifecycle from counselling to tests, pilot operation and rollout up to daily business.


## Table of Contents  <!-- omit in toc -->
- [1. Overview](#1-overview)
- [2. Manual maintenance of signatures](#2-manual-maintenance-of-signatures)
  - [2.1. Signatures in Outlook](#21-signatures-in-outlook)
  - [2.2. Signature in Outlook Web](#22-signature-in-outlook-web)
- [3. Automatic maintenance of signatures](#3-automatic-maintenance-of-signatures)
  - [3.1. Server-based signatures](#31-server-based-signatures)
  - [3.2. Client-based signatures](#32-client-based-signatures)
- [4. Criteria](#4-criteria)
- [5. Synchronizing signatures between different devices](#5-synchronizing-signatures-between-different-devices)
- [6. Recommendation: Set-OutlookSignatures](#6-recommendation-set-outlooksignatures)
  - [6.1. Common description, license model](#61-common-description-license-model)
  - [6.2. Features](#62-features)
- [7. Administration](#7-administration)
  - [7.1. Client](#71-client)
  - [7.2. Server](#72-server)
  - [7.3. Storage of templates](#73-storage-of-templates)
  - [7.4. Template management](#74-template-management)
  - [7.5. Running the software](#75-running-the-software)
    - [7.5.1. Parameters](#751-parameters)
    - [7.5.2. Runtime and Visibility of the software](#752-runtime-and-visibility-of-the-software)
    - [7.5.3. Use of Outlook and Word during runtime.](#753-use-of-outlook-and-word-during-runtime)
- [8. Support from the service provider.](#8-support-from-the-service-provider)
  - [8.1. Consulting and implementation phase](#81-consulting-and-implementation-phase)
    - [8.1.1. Initial consultation on textual signatures.](#811-initial-consultation-on-textual-signatures)
      - [8.1.1.1. Participants](#8111-participants)
      - [8.1.1.2. Content and objectives](#8112-content-and-objectives)
      - [8.1.1.3. Duration](#8113-duration)
    - [8.1.2. Training of template administrators](#812-training-of-template-administrators)
      - [8.1.2.1. Participants](#8121-participants)
      - [8.1.2.2. Content and objectives](#8122-content-and-objectives)
      - [8.1.2.3. Duration](#8123-duration)
      - [8.1.2.4. Prerequisites](#8124-prerequisites)
    - [8.1.3. Client management training](#813-client-management-training)
      - [8.1.3.1. Participants](#8131-participants)
      - [8.1.3.2. Content and objectives](#8132-content-and-objectives)
      - [8.1.3.3. Duration](#8133-duration)
      - [8.1.3.4. Prerequisites](#8134-prerequisites)
  - [8.2. Tests, pilot operation, rollout](#82-tests-pilot-operation-rollout)
- [9. Operations](#9-operations)
  - [9.1. Creating and maintaining templates](#91-creating-and-maintaining-templates)
  - [9.2. Creating and maintaining storage shares for templates and software components](#92-creating-and-maintaining-storage-shares-for-templates-and-software-components)
  - [9.3. Setting and maintaining AD attributes](#93-setting-and-maintaining-ad-attributes)
  - [9.4. Configuration adjustments](#94-configuration-adjustments)
  - [9.5. Problems and questions during operation](#95-problems-and-questions-during-operation)
  - [9.6. Supported versions](#96-supported-versions)
  - [9.7. New versions](#97-new-versions)
  - [9.8. Adaptations to the code of the product](#98-adaptations-to-the-code-of-the-product)


## 1. Overview  
Textual signatures are not only an essential aspect of corporate identity, but together with the disclaimer usually a legal necessity.

This document provides a general overview of signatures, instructions for end users, and details of the service provider's recommended solution for centralised management and automated distribution of textual signatures.

In this document, the word "signature" should always be understood as a textual signature and should not be confused with a digital signature, which serves to encrypt emails and/or legitimise the sender.  


## 2. Manual maintenance of signatures  
In manual maintenance, a template for the textual signature is made available to the user, e.g. via the intranet.

Each user sets up the signature himself. Depending on the technical configuration of the client, signatures move with it when the computer used is changed or have to be set up again.

There is no central maintenance.
### 2.1. Signatures in Outlook  
In Outlook, practically any number of signatures can be created per mailbox. This is practical, for example, to distinguish between internal and external emails or emails in different languages.

In addition, a default signature for new emails and one for replies and forwards can be set per mailbox.
### 2.2. Signature in Outlook Web
If you also work with Outlook on the Web, you must set up your signature in Outlook on the Web independently of your signature on the client.

In Outlook on the Web, only one signature is possible unless the mailbox is in Exchange Online and the Roaming Signatures feature has been enabled.


## 3. Automatic maintenance of signatures  
The service provider recommends a solution with central administration and extended client-side functionality, which is free and open-source in the core and can be operated and maintained by the customers themselves with the support of the service provider. For details see "Recommendation: Set-OutlookSignatures Benefact Circle".  
### 3.1. Server-based signatures  
The biggest advantage of a server-based solution is that every email is captured using a defined rule set, regardless of the application or device from which it was sent.

Since the signature is only attached at the server, the user does not see which signature is used during the creation of an email.

After the signature has been appended at the server, the now modified email must be re-downloaded by the client so that it appears correctly in the Sent Items folder. This generates additional network traffic.

If a message is already digitally signed or encrypted when it is created, the textual signature cannot be added on the server side without breaking the digital signature and encryption. Alternatively, the message is adapted so that the content consists only of the textual signature and the unchanged original message is sent as an attachment.
### 3.2. Client-based signatures  
In client-based solutions, templates and application rules for textual signatures are defined in a central repository. A component on the client checks the central configuration during automated or manual invocation and applies it locally.

Client-based solutions, in contrast to server-based solutions, are bound to specific email clients and specific operating systems.

The user already sees the signature during the creation of the email and can adjust it if necessary.

Encryption and digital signing of messages are not a problem on either the client or server side.


## 4. Criteria
When evaluating products, the following aspects, among others, should be checked:  
- Can the product handle the number of AD and mail objects in the environment without reproducible crashes or incomplete search results?  
- Does the product have to be installed directly on the mail servers? This means additional dependencies and sources of errors, and can have a negative impact on the availability and reliability of the AD and mail system.  
- Can the administration of the products be delegated directly on the mail servers without granting significant rights?
- Can customers be authorised separately from each other?  
- Can variables in the signatures only be replaced with values of the current user, or also with values of the current mailbox and the respective manager?
- Can a template file be used under different signature names?
- Can templates be distributed in a targeted manner? Generally, by group membership, by email address? Can only be assigned or also forbidden?
- Can the solution handle shared mailboxes?
- Can the solution handle additional mailboxes distributed e.g. by automapping?
- Can images in signatures be shown and hidden under attribute control?
- Can the solution handle roaming signatures in Exchange Online?
- How high are the acquisition and maintenance costs? Are these above the tender limit?
- Do emails have to be redirected to a cloud of the manufacturer?
- Does the SPF record in the DNS need to be adjusted?


## 5. Synchronizing signatures between different devices  
The signatures in Outlook, Outlook on the Web and other clients (e.g. in smartphone apps) are not synchronised and must therefore be set up separately.

Depending on the client configuration, Outlook signatures may or may not travel with the user between different Windows devices, please contact your local IT for details.

The client-based tool recommended by the service provider can set signatures in Outlook as well as in Outlook on the Web and also offers the user an easy way to transfer existing signatures to other email clients.

The recommended product already supports the roaming signatures of Exchange Online. It can be assumed that mail clients (e.g. smartphone apps) will follow suit in the foreseeable future.


## 6. Recommendation: Set-OutlookSignatures  
The service provider recommends the free open source software Set-OutlookSignatures with the chargeable "Benefactor Circle" extension after a survey of the customer requirements and tests of several server- and client-based products and offers its customers support during introduction and operation.  

This document provides an overview of the functional scope and administration of the recommended solution, support of the service provider during introduction and operation, as well as associated expenses.
### 6.1. Common description, license model  
<a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures">Set-OutlookSignatures</a> is a free open-source product with a chargeable extension for company-relevant functions.

The product is used for the central administration and local distribution of textual signatures and out-of-office replies to clients. Outlook on Windows, Outlook Web and New Outlook are supported as targets.

Integration into the client, which is secured with the help of AppLocker and other mechanisms such as Microsoft Purview Informatoin Protection, is technically and organisationally simple thanks to established measures (such as the digital signing of PowerShell scripts).
### 6.2. Features
With Set-OutlookSignatures, signatures and out-of-office replies can be:
- Generated from **templates in DOCX or HTML** file format  
- Customized with a **broad range of variables**, including **photos**, from Active Directory and other sources
  - Variables are available for the **currently logged-on user, this user's manager, each mailbox and each mailbox's manager**
  - Images in signatures can be **bound to the existence of certain variables** (useful for optional social network icons, for example)
- Applied to all **mailboxes (including shared mailboxes)**, specific **mailbox groups**, specific **email addresses** (including alias and secondary addresses), or specific **user or mailbox properties**, for **every mailbox across all Outlook profiles (Outlook, New Outlook, Outlook Web)**, including **automapped and additional mailboxes**  
- Created with different names from the same template (e.g., **one template can be used for multiple shared mailboxes**)
- Assigned **time ranges** within which they are valid  
- Set as **default signature** for new emails, or for replies and forwards (signatures only)  
- Set as **default OOF message** for internal or external recipients (OOF messages only)  
- Set in **Outlook Web** for the currently logged-in user, including mirroring signatures the the cloud as **roaming signatures**  
- Centrally managed only or **exist along user-created signatures** (signatures only)  
- Copied to an **alternate path** for easy access on mobile devices not directly supported (signatures only)
- **Write protected** (Outlook signatures only)

Set-OutlookSignatures can be **run by users on Windows, Linux and macOS, as well as on terminal servers - or on a central system without client deployment and end user interaction**.  
On clients, it can run as part of the logon script, as scheduled task, or on user demand via a desktop icon, start menu entry, link or any other way of starting a program.  
Signatures and OOF messages can also be created and deployed centrally, without end user or client involvement.

**Sample templates** for signatures and OOF messages demonstrate all available features and are provided as .docx and .htm files.

**Simulation mode** allows content creators and admins to simulate the behavior of the software and to inspect the resulting signature files before going live.

**SimulateAndDeploy** allows to deploy signatures to Outlook Web/New Outlook (when based on Outlook Web) without any client deployment or end user interaction, making it ideal for users that only log on to web services but never to a client (users with a Microsoft 365 F-license, for example).

The software is **designed to work in big and complex environments** (Exchange resource forest scenarios, across AD trusts, multi-level AD subdomains, many objects). It works **on premises, in hybrid and cloud-only environments**.  
All **national clouds are supported**: Public (AzurePublic), US Government L4 (AzureUSGovernment), US Government L5 (AzureUSGovernment DoD), China (AzureChinaCloud operated by 21Vianet).

It is **multi-client capable** by using different template paths, configuration files and script parameters.

Set-OutlookSignatures requires **no installation on servers or clients**. You only need a standard SMB file share on a central system, and optionally Office on your clients.  
There is also **no telemetry** or "calling home", emails are **not routed through a 3rd party data center or cloud service**, and there is **no need to change DNS records (MX, SPF) or mail flow**.

A **documented implementation approach**, based on real life experiences implementing the software in multi-client environments with a five-digit number of mailboxes, contains proven procedures and recommendations for product managers, architects, operations managers, account managers and email and client administrators.  
The implementation approach is **suited for service providers as well as for clients**, and covers several general overview topics, administration, support, training across the whole lifecycle from counselling to tests, pilot operation and rollout up to daily business.

The software core is **Free and Open-Source Software (FOSS)**. It is published under a license which is approved, among others, by the Free Software Foundation (FSF) and the Open Source Initiative (OSI), and is compatible with the General Public License (GPL) and other popular licenses. Please see `.\LICENSE.txt` for copyright and license details.

**Some features are exclusive to Benefactor Circle members.** Benefactor Circle members have access to an extension file enabling exclusive features. This extension file is chargeable, and it is distributed under a proprietary, non-free and non-open-source license. See <a href="/benefactorcircle">Benefactor Circle</a> for details.  


## 7. Administration  
### 7.1. Client  
- Outlook and Word (when using DOCX templates, and/or signatures in RTF format), each from version 2010  
- the software must run in the security context of the user currently logged in.  
- The software must be executed in "Full Language Mode". The "Constrained Language Mode" is not supported, as certain functions such as Base64 conversions are not available in this mode or require very slow alternatives.  
- If AppLocker or comparable solutions are used, the software is already digitally signed.  
- Network unlocks:  
  - Ports 389 (LDAP) and 3268 (Global Catalog), TCP and UDP respectively, must be enabled between the client and all domain controllers. If this is not the case, signature-relevant information and variables cannot be retrieved. the software checks with each run whether access is possible.
- To access the SMB share with the software components, the following ports are needed: 137 UDP, 138 UDP, 139 TCP, 445 TCP (details <a href="https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc731402(v=ws.11)">in this Microsoft article</a>).  
  - For access to SharePoint document libraries, port 443 TCP is needed. When not using SharePoint Online with Graph, firewalls and proxies must not block WebDAV HTTP extensions.

### 7.2. Server  
Required are:
- An SMB file share in which the software and its components are stored. All users must have read access to this file share and its contents.  
- One or more SMB file shares or SharePoint document libraries in which the templates for signatures and out-of-office replies are stored and managed.

If variables (e.g. first name, last name, phone number) are used in the templates, the corresponding values must be available in the Active Directory. In the case of Linked Mailboxes, a distinction can be made between the attributes of the current user and the attributes of the mailbox located in different AD forests.  

As described in the system requirements, the software and its components must be stored on an SMB file share. Alternatively, it can be distributed to the clients by any mechanism and executed from there.

All users need read access to the software and all its components.

As long as these requirements are met, any SMB file share can be used, for example  
- the NETLOGON share of an Active Directory  
- a share on a Windows server in any architecture (single server or cluster, classic share or DFS in all variations)  
- a share on a Windows client  
- a share on any non-Windows system, e.g. via SAMBA.

As long as all clients use the same version of the software and only configure it via parameters, a central repository for the software components is sufficient.

For maximum performance and flexibility, it is recommended that each client stores the software in its own SMB file share and, if necessary, replicates this across locations on different servers.
### 7.3. Storage of templates  
As described in the system requirements, templates for signatures and out-of-office replies can be stored on SMB file shares or SharePoint document libraries analogous to the software itself.

SharePoint document libraries have the advantage of optional versioning of files, so that in the event of an error, template administrators can quickly restore an earlier version of a template.

At least one share per client with separate subdirectories for signature and absence templates is recommended.

Users need read access to all templates.

By simply granting write access to the entire template folder or to individual files within it, the creation and management of signature and absence templates is delegated to a defined group of people. Typically, templates are defined, created and maintained by the Corporate Communications and Marketing departments.

For maximum performance and flexibility, it is recommended that each client places the software in its own SMB file share and replicates this across sites to different servers if necessary.  
### 7.4. Template management  
By simply assigning write permissions to the template folder or to individual files within it, the creation and management of signature and absence templates is delegated to a defined group of people. Typically, the templates are defined, created and maintained by the Corporate Communications and Marketing departments.

The software can process templates in DOCX or HTML format. For a start, the use of the DOCX format is recommended; the reasons for this recommendation and the advantages and disadvantages of each format are described in the software's `README' file.

The `README` file supplied with the software provides an overview of how to administer templates so that they are  
- apply only to certain groups or mailboxes  
- be set as the default signature for new mails or replies and forwards  
- be set as an internal or external out-of-office message
- and much more

In `README` and the sample templates, the replaceable variables, the extension with user-defined variables and the handling of photos from the Active Directory are also described.

The sample file "Test all signature replacement variables.docx" provided contains all variables available by default; in addition, custom variables can be defined.
### 7.5. Running the software  
The software can be executed via any mechanism, for example  
- when the user logs in as part of the logon script or as a separate script  
- via the task scheduling at fixed times or at certain events  
- by the user himself, e.g. via a shortcut on the desktop  
- by a tool for client administration

Since Set-OutlookSignatures is mainly a pure PowerShell script, it is called like any other script of this file type:

```
powershell.exe <PowerShell parameter> -file "<path to Set-OutlookSignatures.ps1>" <Script parameter>  
```

#### 7.5.1. Parameters  
The behaviour of the software can be controlled via parameters. Particularly relevant are SignatureTemplatePath and OOFTemplatePath, which are used to specify the path to the signature and absence templates.

The following is an example where the signature templates are on an SMB file share and the out-of-office provider templates are in a SharePoint document library:  

```
powershell.exe -file "\netlogon\set-outlooksignatures\set-outlooksignatures.ps1" -SignatureTemplatePath "\DFS-Share\Common\Templates\Signatures Outlook" -OOFTemplatePath "https://sharepoint.example.com/CorporateCommunications/Templates/Out-of-office templates"  
```

At the time of writing, other parameters were available. The following is a brief overview of the possibilities, for details please refer to the documentation of the software in the `README` file:  
- SignatureTemplatePath: path to the signature templates. Can be an SMB share or SharePoint document library.  
- ReplacementVariableConfigFile: Path to the file in which variables deviating from the standard are defined. Can be an SMB share or SharePoint document library.  
- TrustsToCheckForGroups: By default, all trusts are queried for mailbox information. This parameter can be used to remove specific domains and add non-trusted domains.  
- DeleteUserCreatedSignatures: Should signatures created by the user be deleted? This is not done by default.  
- SetCurrentUserOutlookWebSignature: By default, a signature is set in Outlook on the web for the logged-in user. This parameter can be used to prevent this.  
- SetCurrentUserOOFMessage: By default, the text of the out-of-office replies is set. This parameter can be used to change this behaviour.  
- OOFTemplatePath: Path to the absence templates. Can be an SMB share or SharePoint document library.  
- AdditionalSignaturePath: Path to an additional share to which all signatures should be copied, e.g. for access from a mobile device and for simplified configuration of clients not supported by the software. Can be an SMB share or SharePoint document library.  
- UseHtmTemplates: By default, templates are processed in DOCX format. This switch can be used to switch to HTML (.htm).  
The 'README' file contains further parameters.
#### 7.5.2. Runtime and Visibility of the software  
The software is designed for fast runtime and minimal network load. Nevertheless, the runtime of the software depends on many parameters:  
- general speed of the client (CPU, RAM, HDD)  
- Number of mailboxes configured in Outlook  
- Number of trusted domains  
- Response time of the domain controllers and file servers  
- Response time of Exchange servers (setting signatures in Outlook Web, out-of-office notifications)  
- Number of templates and complexity of variables in them (e.g. photos)

Under the following general conditions, a reproducible runtime of approx. 30 seconds was measured:  
- Standard client  
- Connected to the company network via VPN  
- 4 mailboxes  
- Query of all domains connected via trust  
- 9 signature templates to be processed, all with variables and graphics (but without user photos), partly restricted to groups and mail addresses  
- 8 absence templates to be processed, all with variables and graphics (but without user photos), partly restricted to groups and mail addresses  
- Setting the signature in Outlook on the web  
- No copying of signatures to an additional network path
  
Since the software does not require any user interaction, it can be minimised or hidden using the usual mechanisms. This makes the runtime of the software almost irrelevant.
#### 7.5.3. Use of Outlook and Word during runtime.  
The software does not start Outlook, all queries and configurations are done via the file system and the registry.

Outlook can be started, used or closed at will while the software is running.

All changes to signatures and out-of-office notifications are immediately visible and usable for the user, with one exception: If the name of the default signature to be used for new emails or for replies and forwardings changes, this change will only take effect the next time Outlook is started. If only the content changes, but not the name of one of the default signatures, this change is available immediately.

Word can be started, used or closed at will while the software is running.

The software uses Word to replace variables in DOCX templates and to convert DOCX and HTML to RTF. Word is started as a separate invisible process. This process can practically not be influenced by the user and does not affect Word processes started by the user.


## 8. Support from the service provider.  
The service provider not only recommends the Set-OutlookSignatures software, but also offers its customers defined support free of charge.

Additional support can be obtained after prior agreement for a separate charge.

The central point of contact for all kinds of questions is Mail Product Management.  
### 8.1. Consulting and implementation phase  
The following services are covered by the product price:  
#### 8.1.1. Initial consultation on textual signatures.  
##### 8.1.1.1. Participants  
- Customer: corporate communications, marketing, client management, project coordinator  
- Service provider: mail product management, mail operations management or mail architecture  
##### 8.1.1.2. Content and objectives  
- Customer: Presentation of own wishes regarding textual signatures  
- Service provider: Brief description of the basic options for textual signatures, advantages and disadvantages of the different approaches, reasons for deciding on the recommended product.  
- Comparison of customer requirements with technical and organizational possibilities  
- Live demonstration of the product, taking customer requirements into account  
- Determination of the next steps  
##### 8.1.1.3. Duration  
4 hours
#### 8.1.2. Training of template administrators  
##### 8.1.2.1. Participants  
- Customer: template administrators (corporate communications, marketing, analysts), optional client management, project coordinator.  
- Service provider: mail product management, mail operations management, or mail architecture.  
##### 8.1.2.2. Content and objectives  
- Summary of the previous meeting "Initial coordination on textual signatures", with focus on desired and feasible functions  
- Presentation of the structure of the template directories, with focus on  
- naming conventions  
- Application order (general, group-specific, mailbox-specific, alphabetical in each group)  
- Definition of default signatures for new emails and for replies and forwards  
- Definition of out-of-office texts for internal and external recipients.  
- Determination of the temporal validity of templates  
- Variables and user photos in templates  
- Differences between DOCX and HTML formats  
- Possibilities for the integration of a disclaimer  
- Joint development of initial templates based on existing templates and customer requirements  
- Live demonstration on a standard client with a test user and test mailboxes of the customer (see requirements)  
##### 8.1.2.3. Duration  
4 hours
##### 8.1.2.4. Prerequisites  
- The customer provides a standard client with Outlook and Word.  
- The screen content of the client must be able to be projected by a beamer or displayed on an appropriately large monitor for collaborative work.  
- The customer provides a test user. This test user must be able to run script files on the standard client  
  - be allowed to download script files from the Internet (github.com) once (alternatively, the customer can provide a BitLocker-encrypted USB stick for data transfer).  
  - be allowed to run signed PowerShell scripts in full language mode  
  - have a mailbox  
  - have full access to various test mailboxes (personal mailboxes or group mailboxes) that are, if possible, direct or indirect members of various groups or distribution lists. For full access, the user may be authorized to the other mailboxes accordingly, or username and password of the additional mailboxes are known.  
#### 8.1.3. Client management training  
##### 8.1.3.1. Participants  
- Customer: client management, optionally an administrator of the Active Directory, optionally an administrator of the file server and/or SharePoint server, optionally corporate communications and marketing, coordinator of the project  
- Service Provider: mail product management, mail operations management, or mail architecture, a representative of the client team at appropriate clients
##### 8.1.3.2. Content and objectives  
- Summary of the previous meeting "Initial agreement on textual signatures", with focus on desired and feasible functions  
- Presentation of the possibilities with focus on  
- Basic flow of the software  
- System requirements client (Office, PowerShell, AppLocker, digital signature of the software, network ports)  
- System requirements server (storage of the templates)  
- Possibilities of product integration (logon script, scheduled task, desktop shortcut)  
- Parameterization of the software, among others:  
- Disclosure of template folders  
- Consider Outlook on the web?  
- Consider out-of-office replies?  
- Which trusts to take into account?  
- How to define additional variables?  
- Allow user-created signatures?  
- Place signatures on an additional path?  
- Joint testing based on templates previously developed by the customer and customer requirements.  
- Definition of next steps  
##### 8.1.3.3. Duration  
4 hours 
##### 8.1.3.4. Prerequisites  
- The customer provides a standard client with Outlook and Word.  
- The screen content of the client must be able to be projected via beamer or displayed on an appropriately large monitor for collaborative work.  
- The customer provides a test user. This test user must be able to run on the standard client  
  - be allowed to download script files from the Internet (github.com) once (alternatively, the customer can provide a BitLocker-encrypted USB stick for data transfer).  
  - be allowed to run signed PowerShell scripts in full language mode
  - have a mailbox  
  - have full access to various test mailboxes (personal mailboxes or group mailboxes) that are, if possible, direct or indirect members of various groups or distribution lists. For full access, the user may be authorized to the other mailboxes accordingly, or the user name and password of the additional mailboxes are known.  
- Customer shall provide at least one central SMB share or SharePoint document library for template storage.  
- Customer shall provide a central SMB file share for the storage of the software and its components.
### 8.2. Tests, pilot operation, rollout  
The customer's project manager is responsible for planning and coordinating tests, pilot operation and rollout.

The concrete technical implementation is carried out by the customer. If, in addition to mail, the client is also supported by service providers, the client team will assist with the integration of the software (logon script, scheduled task, desktop shortcut).

In the event of fundamental technical problems, the Mail product management team provides support in researching the causes, prepares proposals for solutions and, if necessary, establishes contact with the manufacturer of the product.

The creation and maintenance of templates is the responsibility of the customer.

For the procedure for adjustments to the code or the release of new functions, see the "Ongoing Operations" chapter.


## 9. Operations  
### 9.1. Creating and maintaining templates  
Creating and maintaining templates is the responsibility of the customer.  
Mail Product Management is available to advise on feasibility and impact issues.
### 9.2. Creating and maintaining storage shares for templates and software components  
The creation and maintenance of storage shares for templates and software components is the responsibility of the customer.

Mail Product Management is available to advise on feasibility and implications.  
### 9.3. Setting and maintaining AD attributes  
Setting and maintaining AD attributes related to textual signatures (e.g., attributes for variables, user photos, group memberships) is the customer's responsibility.

Mail Product Management is available to advise on feasibility and impact issues.
### 9.4. Configuration adjustments  
Configuration adjustments explicitly provided for by the developers of the software are supported at any time.

Mail product management is available to advise on the feasibility and impact of desired customizations.

The planning and coordination of tests, pilot operation and rollout in connection with configuration adjustments is carried out by the customer, as is the concrete technical implementation.

If, in addition to mail, the client is also supported by the service provider, the client team provides support with the integration of the software (logon script, scheduled task, desktop shortcut).  
### 9.5. Problems and questions during operation  
In the event of fundamental technical problems, Mail Product Management provides support in researching the causes, works out proposed solutions and, if necessary, establishes contact with the manufacturer of the product.

Mail product management is also available to answer general questions about the product and its possible applications.
### 9.6. Supported versions  
The version numbers of the product follow the specifications of Semantic Versioning and are therefore structured according to the "Major.Minor.Patch" format.  
- "Major" is incremented when there is no compatibility with previous versions.  
- "Minor" is incremented when new features compatible with previous versions are introduced.  
- "Patch" is incremented when changes include only bug fixes compatible with previous versions.  
- Additionally, pre-release and build metadata identifiers are available as attachments to the "Major.Minor.Patch" format, e.g. "-Beta1".

Service Provider Supported Versions:  
- The highest version of the product released by the service provider, regardless of its release date.  
- Support for a released version automatically ends three months after a higher version is released.

This means that customers have three months after a new version is released to upgrade to that version before service provider support for previously released versions expires.

This means that no more than one update is ever required in a 3-month period. This protects both customers and service providers from gross errors in product development.
### 9.7. New versions  
When new versions of the product are released, Mail Product Management informs customer-defined contacts of the changes associated with that version, potential impacts on the existing configuration, and identifies upgrade options.

Planning and coordination of the rollout of the new version is done by the customer contact.

The concrete technical implementation is also carried out by the customer. If, in addition to mail, the client is also supported by service providers, the client team provides support in integrating the software (logon script, scheduled task, desktop shortcut).

In the event of fundamental technical problems, Mail product management provides support in researching the causes, works out proposals for solutions and, if necessary, establishes contact with the manufacturer of the product.
### 9.8. Adaptations to the code of the product  
If adjustments to the product's code are desired, the associated effort will be estimated and charged separately after commissioning.

In accordance with the open source nature of the Product, the code adjustments will be submitted to the developers of the Product as a suggestion for improvement.

To ensure the maintainability of the product, the service provider can only support code that is also officially adopted into the product. Each customer is free to customize the product's code themselves, but in this case the service provider can no longer provide support. For details, see "Supported versions".
