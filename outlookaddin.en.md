---
layout: "page"
lang: "en"
locale: "en"
title: "The Outlook add-in"
subtitle: "Signatures for Outlook on Android and iOS, advanced features for all platforms"
description: "Extend Outlook with the Set-OutlookSignatures add-in. Automatic email signatures for iOS, Android, and all platforms. Self-hosted, secure, and enterprise-ready."
hide_gh_sponsor: true
permalink: "/outlookaddin"
redirect_from:
  - "/outlookaddin/"
sitemap_priority: 0.8
sitemap_changefreq: weekly
---
## The Outlook add-in<!-- omit in toc -->
- [1. Overview](#1-overview)
- [2. Usage](#2-usage)
- [3. Requirements](#3-requirements)
  - [3.1. Outlook clients](#31-outlook-clients)
  - [3.2. Web server and domain](#32-web-server-and-domain)
  - [3.3. Set-OutlookSignatures](#33-set-outlooksignatures)
  - [3.4. Entra ID app](#34-entra-id-app)
- [4. Configuration and deployment to the web server](#4-configuration-and-deployment-to-the-web-server)
- [5. Deployment to mailboxes](#5-deployment-to-mailboxes)
  - [5.1. Individual installation through users](#51-individual-installation-through-users)
  - [5.2. Microsoft 365 Centralized Deployment or Integrated Apps](#52-microsoft-365-centralized-deployment-or-integrated-apps)
- [6. Remarks](#6-remarks)
  - [6.1. General](#61-general)
  - [6.2. Outlook for Android](#62-outlook-for-android)
  - [6.3. Outlook for iOS](#63-outlook-for-ios)
  - [6.4. Outlook for Mac](#64-outlook-for-mac)
  - [6.5. Outlook Web on-prem](#65-outlook-web-on-prem)
  - [6.6. Classic Outlook for Windows](#66-classic-outlook-for-windows)


## 1. Overview
With a [Benefactor Circle](/benefactorcircle) license, you also have access to the Set-OutlookSignatures add-in for Outlook.

It makes signatures, which have been created by Set-OutlookSignatures in client or SimulateAndDeploy mode before, available on platforms where Set-OutlookSignatures itself can not be run: Outlook for iOS and Outlook for Android.

The add-in is also a great way to make signatures available to users on Outlook editions which do not yet support roaming signatures, and can be of great help in BYOD (bring your own device) scenarios. For mailboxes hosted on premises, this is like having your own implementation of cloud roaming signatures.

The Outlook add-in has a taskpane that allows the user to preview a selected signature, and to add the signature to the email or appointment that is currently being written.

The add-in can also automatically set signatures as soon as a new email or appointment is created, which is very useful on Outlook for Android and Outlook for iOS. It automatically chooses the correct signature based on sender address and if the element is a new email or appointment, or a reply email.

The Outlook add-in is self-hosted by you. Compared to using a solution hosted by a 3rd party, this has several advantages:
- Client specific configuration
- You have full control over the version that is used
- Keeps license costs low
- Is the preferred method from a data protection and privacy perspective

The add-in code is downloaded by the Outlook client and executed locally, in the security context of the mailbox. There are no middleware or proxy servers involved. Data is only transferred between your Outlook client, your authentication system (Entra ID for Exchange Online) and your mailbox servers.


## 2. Usage
From an end user perspective, basically nothing needs to be done or configured: When writing a new email, answering an email, or creating a new appointment, the add-in automatically adds the corresponding default signature.

For advanced usage and debug logging, a taskpane is available in all Outlook versions supporting this feature.

In compose mode, the taskpane allows to manually choose a signature, set the selected signature, and to temporarily override admin-defined settings for debug logging and Outlook host restrictions.

In message read mode, the taskpane cannot set signatures, of course. But it is very useful to check if the add-in is deployed correctly, and if it can access signatures. This is especially useful on mobile devices, in situations where enabling the debug mode is not wanted, and for basic tests when launch events are not triggered by Outlook.

The taskpane can be accessed through:
- Outlook Web (Exchange Online), New Outlook for Windows, New Outlook for Mac:
  - New mail, reply mail, read mail: "Message" tab, "Apps" icon
  - New appointment: Ribbon, "…" menu
- Outlook Web (on-prem):
  - New mail, reply mail: Lower right corner of the compose window
  - New appointment: At the right of the menu bar at the top of the compose window
  - Read mail: Left to the reply button
- Classic Outlook for Windows, Classic Outlook for Mac:
  - New mail, reply mail, read mail: "Message" tab, "All apps" icon
  - New appointment: "Appointment" or "Meeting" tab, "All apps" icon
- Outlook for iOS, Outlook for Android
  - These platforms do not support taskpanes for new mails, reply mails and appointments.
  - Read mail: Three dots ("…" or "⋮")in the email header

## 3. Requirements
### 3.1. Outlook clients
The Outlook add-in works for all Outlook clients that are supported by Microsoft. See the '`Remarks`' chapter in this section for possible limitations that may apply due to platform specific Microsoft restrictions.

The add-in always runs in the context of the user that is used by Outlook to access a mailbox. Delegate scenarios are supported. This means the following:
- User A has the Outlook add-in installed. The Outlook add-in can access all signature information that the Benefactor Circle add-on or the SimulateAndDeploy mode of Set-OutlookSignatures has written to the mailbox of user A. The add-in can be used in the mailbox of user A and in all other mailboxes that user A accesses with his own credentials.
- When user A has added a mailbox with separate credentials, such as adding shared mailbox B using shared mailbox B's credentials, the add-in installed in user A's mailbox will not work for shared mailbox B. Shared mailbox B needs to have the add-in installed, too, and the add-in only has access to signature information that the Benefactor Circle add-on or the SimulateAndDeploy mode of Set-OutlookSignatures has written to the shared mailbox B. For shared mailbox B, delegate scenarios are supported, too.


### 3.2. Web server and domain
Whatever web server you choose, the requirements are low:
- Reachable from mobile devices via the public internet.
- Use a dedicated host name ("https://outlookaddin01.example.com"), do not use subdirectories ("https://addins.example.com/outlook01").
- A valid TLS certificate.<br>Self-signed certificates can be used for development and testing, as long as the certificate is trusted by the client used for testing.<br>Certificates from [Let's Encrypt](https://letsencrypt.org/) are a good free alternative, especially when used together with an [ACME client](https://letsencrypt.org/docs/client-options/) that auto-renews them.
- In production, the server hosting the images shouldn't return a Cache-Control header specifying no-cache, no-store, or similar options in the HTTP response.

[Static website hosting in Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website) is an uncomplicated, cheap and fast alternative. It comes with a *.web.core.windows.net hostname and a Microsoft-issued certificate, even in the free tier.

We recommend to use use two separate dedicated hostnames, such as "https://outlookaddin.example.com" and "https://outlookaddin-test.example.com". This way, you can use one for testing and one for production. For tests, sideloading is the preferred method, while Microsoft 365 Centralized Deployment or Integrated Apps are ideal for mass deployment.


### 3.3. Set-OutlookSignatures
The Outlook add-in can add existing signatures, but is not able to create them itself on the fly. The Benefactor Circle add-on prepares signature data in a way that it can be used by the Outlook add-in.


### 3.4. Entra ID app
When mailboxes are hosted in Exchange Online, the Outlook add-in needs an Entra ID app to access the mailbox.

Creating a separate Entra ID app for the Outlook add-in is strongly recommended over modifying an existing app.

You can run the following command to automatically create the Entra ID app. You need an Entra ID account with 'Application Administrator' or 'Global Admin' permissions.

```
& '.\sample code\Create-EntraApp.ps1' -AppType 'OutlookAddIn' -AppName 'Set-OutlookSignatures Outlook Add-In' -OutlookAddInUrl '<https address to your web server>'
```

If you want to create the Entra ID app manually, the required minimum settings for the Entra ID app are:
- A name of your choice.
- A supported account type (it is strongly recommended to only allow access from users of your tenant).
- Authentication platform '`Single-page application`' with a redirect URI of '`brk-multihub://<your_deployment_domain>`'.
  If your DEPLOYMENT_URL is 'https://outlook-addin-01.example.com', the redirect URI must be '`brk-multihub://outlook-addin-01.example.com`'.
- Access to the following '`delegated`' (not application!) '`Graph API`' permissions:
  - '`Mail.Read`'  
    Allows to read emails in mailbox of the currently logged-on user (and in no other mailboxes).  
    Required because of Microsoft restrictions accessing roaming signatures.
  - '`GroupMember.Read.All`'  
    Allows the app to list groups, read basic group properties and read membership of all groups the signed-in user has access to.  
    Required to find and check license groups.
  - '`User.Read.All`'  
    Allows the app to read the full set of profile properties, reports, and managers of other users in your organization, on behalf of the signed-in user.  
    Required to get the UPN for a given SMTP email address.
- Grant admin consent for all permissions


## 4. Configuration and deployment to the web server
With every new release of Set-OutlookSignatures, [Benefactor Circle](/benefactorcircle) members not only receive an updated Benefactor Circle license file, but also an updated Outlook add-in.

With every new release of the Outlook add-in, you need to update your add-in deployment (sideloading M365 Centralized Deployment, M365 Integrated Apps) so that Outlook can download and use the newest code.

It is recommended to use use two separate dedicated hostnames, one for testing and one for production, such as "https://outlookaddin.example.com" and "https://outlookaddin-test.example.com".

To configure the add-in and deploy it to your web server:
- Open '`run_before_deployment.ps1`' and follow the instructions in it to configure the add-in to your needs.
- You can configure the following settings:
  - The version number.
    Outlook add-ins have four version number parts. The first three parts match the version number of Set-OutlookSignatures, the last part is up to you.
  - The URL you deploy the add-in to.
  - On which Outlook hosts and platforms signatures shall be added automatically for new emails and email replies.
  - On which Outlook hosts and platforms signatures shall be added automatically for new appointments.
  - If you want or do not want to disable client signatures configured by your users.
  - Your cloud environment and the ID of the Entra ID app (required for Exchange Online mailboxes only).
  - Enable or disable debug logging.
  - Add custom code to the add-in so you can directly influence which signature it will set.  
    For example, you can set a specific signature…
      - …when there are only internal recipients, or another signature when there are external recipients
      - …depending on the from email address
      - …when a specific customer is in the To field
      - …when the current item is a mail or an appointment
      - …when the current item is a new mail, or another signature when it is a reply or a forward
      - …depending on the subject
      - …or any other condition derived from the information available in the customRulesProperties object

      You can even create your own signature at runtime, without choosing one previously deployed with Set-OutlookSignatures.

      See '`.\sample code\CustomRulesCode.js`' in the Outlook add-in folder for details.
- Run '`run_before_deployment.ps1`' in PowerShell.
- Upload the content of the '`publish`' folder to your web server.


When the '`manifest.xml`' file, the configuration or another part of the Outlook add-in changes, you not only need to update the files on the web server, you also need to tell your mailboxes that an updated version or configuration is available and must be downloaded from the web server. The "[Deployment to mailboxes](#5-deployment-to-mailboxes)" chapter describes the available deployment options for add-ins.


## 5. Deployment to mailboxes
When the '`manifest.xml`' file, the configuration or another part of the Outlook add-in changes, you need to tell your mailboxes that an updated version or configuration is available and must be downloaded. Due to caching mechanisms, especially in Classic Outlook for Windows, this does not happen automatically.

This is required when:
- A new release of the Outlook add-in is published by <a href="https://explicitconsulting.at">ExplicIT Consulting</a>.
- You change a configuration option in the '`run_before_deployment.ps1`' file which is marked to require an updated deployment.
- You modify the '`manifest.xml`' file manually.


You can choose from three different ways to deploy the Outlook add-in to your mailboxes.

For tests, sideloading is the preferred method, while Microsoft 365 Centralized Deployment or Integrated Apps are ideal for mass deployment.

### 5.1. Individual installation through users
This method is also called sideloading. It is ideal for test scenarios.

For mailboxes in Exchange Online:
- Open 'https://outlook.cloud.microsoft/mail/inclientstore'.
- Click on 'My add-ins'.
- Below 'Custom Addins', click on 'Add a custom add-in' and on 'Add from file'.
- In the file selection dialog, enter the manifest.xml file URL as file name and click on 'Open'.
- Click on 'Install'.
- Refresh the browser window.

For mailboxes hosted on-prem:
- Open 'https://YourMailServer.example.com/owa/#path=/options/manageapps'.
- Click on the plus sign to add an add-in, and choose 'Add from file'.
- In the file selection dialog, enter the manifest.xml file URL as file name and click on 'Open'.
- Click on 'Install'.
- Refresh the browser window.

Sideloading of add-ins may have been disabled by your administrators.

Do not use the URLs mentioned above to remove custom add-ins, as this fails most times. Instead, use one of the following options:
- Open Outlook for the web, draft a new mail, click on the 'Apps' button, right-click the Set-OutlookSignatures add-in and select 'Uninstall'.
- Remove the custom add-in in Outlook for Android or Outlook for iOS.


### 5.2. Microsoft 365 Centralized Deployment or Integrated Apps
Microsoft 365 Centralized Deployment and deployment via Integrated Apps both provide the following benefits:
- An admin can deploy and assign an Outlook add-in directly to a mailbox, to multiple mailboxes via a group, or to ever mailbox in the organization.
- When Outlook starts, it automatically downloads the assigned add-in. If the add-in supports it, it appears in Outlooks ribbon.
- An add-in is automatically removed from a mailbox when an admin disables or deletes the add-in assignment, or if the mailbox is removed from a group that the add-in is assigned to.

Both methods, Microsoft 365 Centralized Deployment and deployment via Integrated Apps, are ideal for mass deployment in production environments. They are usually too slow and too much overhead for test scenarios, in which sideloading is the preferred method.

If the Integrated Apps feature is not yet available in your sovereign and government cloud tenant, you have to use Centralized Deployment instead. see the following links for details about each method and instructions on how to use them:
- [Integrated Apps](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/test-and-deploy-microsoft-365-apps?view=o365-worldwide)
- [Microsoft 365 Centralized Deployment](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/centralized-deployment-of-add-ins?view=o365-worldwide)


## 6. Remarks
### 6.1. General
- Microsoft is actively blocking access to roaming signatures for Outlook add-ins. The add-in will be updated when this block has been removed. In the meantime, the add-in has access to the data of the last run of Set-OutlookSignatures v4.14.0 and higher.
- The Microsoft APIs only allow access to online content. There is no way to access offline mailbox content or the file system. This means that the Outlook add-in only works when Outlook has an online connection to the user's mailbox.
- The easiest way to test the add-in and its basic functionality is to use the taskpane (see 'Usage' for details). For specific debugging on Android and iOS, you need to use the DEBUG option in '`run_before_deployment.ps1`'.
- The add-in can run automatically when one of the following launch events is triggered by Outlook: OnNewMessageCompose, OnNewAppointmentOrganizer, OnMessageFromChanged, OnAppointmentFromChanged, OnMessageRecipientsChanged, OnAppointmentAttendeesChanged.
  - Not all these events are supported on all platforms and editions of Outlook, see [this Microsoft article](https://learn.microsoft.com/en-us/office/dev/add-ins/outlook/autolaunch#supported-events) for an up-to-date list.
  - While not publicly documented, [Outlook currently does not support add-ins on calendar invite responses](https://github.com/OfficeDev/office-js/issues/4094#issuecomment-1923444325).
- Microsoft dynamically updates the local copy of the office.js framework, there is no 1:1 relation between the version of Outlook and the version of the framework. This may lead to problems that suddenly appear although neither Outlook nor the add-in have changed. For example, the add-in may suddenly no longer work for shared mailboxes in Classic Outlook for Windows on some devices, while it does on others and in Outlook Web.
  - Where available, use the taskpane as a workaround. The taskpane is basically the same code with an additional graphical interface.
  - Use the DEBUG option in '`run_before_deployment.ps1`' to find out if the root cause is in Outlook or in the add-in. When there is no debug output, the launch event it not triggered by Outlook. When there is debug output, it will show where and with which error the add-in fails.


### 6.2. Outlook for Android
- Only mailboxes hosted in Exchange Online are supported. This is because Microsoft's mobile APIs do not allow programmatic access to mailboxes hosted on-prem.
- Setting the signature on new appointments is not yet supported by Microsoft.
- The Microsoft mobile APIs do not allow an add-in to show a taskpane when a new email, reply email or an appointment is created.


### 6.3. Outlook for iOS
- Only mailboxes hosted in Exchange Online are supported. This is because Microsoft's mobile APIs do not allow programmatic access to mailboxes hosted on-prem.
- Setting the signature on new appointments is not yet supported by Microsoft.
- The Microsoft mobile APIs do not allow an add-in to show a taskpane when a new email, reply email or an appointment is created.
- Microsoft will add support for iPads later (see [here](https://learn.microsoft.com/en-us/javascript/api/requirement-sets/common/nested-app-auth-requirement-sets?view=common-js-preview)).


### 6.4. Outlook for Mac
- Use the New Outlook for Mac whenever possible, as Classic Outlook for Mac (a.k.a Legacy Outlook for Mac) is at the end of its lifecycle.
- While the Microsoft APIs required for the Set-OutlookSignatures Outlook add-in are available in Classic Outlook for Mac, they are very unstable. Therefore, we only offer best-effort support for the add-in on Classic Outlook for Mac.


### 6.5. Outlook Web on-prem
- Launch events are not supported by Microsoft APIs, so only the taskpane works.
- Images are replaced with their alternate description. This will work as soon as Microsoft fixes a bug in their office.js API framework. If you are interested in a workaround, please let us know!


### 6.6. Classic Outlook for Windows
- Things work fine for mailboxes in Exchange Online, but the same Microsoft APIs seem to be unstable for on-prem mailboxes, especially regarding launch events (adding signatures automatically). When in doubt, use the taskpane.
- For Exchange Online mailboxes, the version used must support Nested App Authentication (see [here](https://learn.microsoft.com/en-us/office/dev/add-ins/outlook/faq-nested-app-auth-outlook-legacy-tokens#when-is-naa-generally-available-for-my-channel)).
  - Microsoft disabled legacy Exchange Online tokens, and they cannot be re-enabled since October 2025 due to security reasons.