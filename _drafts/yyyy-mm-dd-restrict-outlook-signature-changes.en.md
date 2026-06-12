---
layout: "post"
lang: "en"
locale: "en"
title: "How to Keep Users from Adding, Editing, or Removing Signatures"
description: "Learn how to restrict signature changes in Classic Outlook, New Outlook, Web, and Mobile, and discover better alternatives."
published: true
tags:
show_sidebar: true
slug: "restrict-outlook-signature-changes"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

## Keep users from adding, editing and removing signatures

Maintaining a consistent corporate identity across an entire organization can be a challenge, especially when users frequently modify, outdated, or completely remove their email signatures. To enforce brand guidelines and ensure legal compliance, IT administrators often need to restrict users from changing their signature settings.

However, the capability to lock down these settings varies significantly depending on which version of Outlook your organization uses. Below is a detailed technical overview of how to restrict signature modifications across different Outlook platforms, the limitations you will encounter, and the best alternative approaches.

### Classic Outlook for Windows

You can disable GUI elements so that users cannot add, edit and remove signatures in Outlook by using the 'Do not allow signatures for email messages' Group Policy Object (GPO) setting.

Caveats are:

- Users can still add, edit and remove signatures in the file system
- Default signatures are no longer automatically added when a new email is created, or you forward/reply an email. Users have to choose the correct signature manually.
- The GPO setting seems not ot work with some newer versions of Outlook. In this case, set the registry key directly.

As an alternative, you may consider one or both of the following alternatives:

- Run Set-OutlookSignatures regularly (every two hours, for example) and use the 'WriteProtect' option in the INI file
- Use the 'Disable Items in User Interface' Group Policy Object (GPO) setting, and consider the following values to disable specific signature-related parts of the user interface:
  - 5608: 'SignatureInsertMenu', the dropdown list/button allowing you to select an existing signature to add to an email, and to open the 'SignatureGallery'.
  - 22965: 'SignatureGallery', the list of signatures in the 'SignatureInsertMenu'. Prohibits selecting another signature than the default one to add to an email, but still allows access to 'SignaturesStationeryDialog'.
  - 3766: 'SignaturesStationeryDialog', the GUI allowing users to add, edit and remove signatures. Also disables access to 'Personal Stationary' and 'Stationary and Fonts' - these settings should be controlled centrally anyway in order to comply with the corporate identity/corporate design guidelines.

There is one thing you cannot disable: Outlook always allows users to edit the copy of the signature after it was added to an email.

### Outlook for the web, New Outlook for Windows

Unfortunately, Outlook for the web cannot be configured as granularly as Outlook. In Exchange Online as well as in Exchange on-prem, the `Set-OwaMailboxPolicy` cmdlet does not allow you to configure signature settings in detail, but only to disable or enable signature features via the `SignaturesEnabled` parameter for specific groups of mailboxes.

There is no option to write protect signatures, or to keep users from from adding, editing and removing signatures without disabling all signature-related features.

As an alternative, run Set-OutlookSignatures regularly (every two hours, for example).

### Outlook for Android, Outlook for iOS, Outlook for Mac

There is no documented way to keep users from adding, edition or removing signatures in these editions of Outlook.

### The Outlook add-in

The [Outlook add-in](/outlookaddin), part of the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a>, includes a feature that allows to ignore or delete user defined signature options.

When the parameter `DISABLE_CLIENT_SIGNATURES` is enabled:

- In Outlook for the web and New Outlook for Windows, the signature option for new mails, replies, and forwards is disabled. A signature that's selected is also disabled.
- In Classic Outlook for Windows and in Outlook for Mac, the signature under the New messages and Replies/forwards sections of the sending account is set to (none).
- In Outlook for Android and Outlook for iOS, the signature saved on the mobile device is deleted.

## Turn every small email moment into a professional advantage

Email signatures and out-of-office replies may seem minor, but think about how often people see them.

We help organizations centrally manage and standardize these touchpoints across all users — **unified Outlook branding everywhere, with zero external data exposure.** No manual effort, no inconsistencies, no data leaving your environment. With Set-OutlookSignatures, every email becomes a consistent, secure, and fully controlled brand experience.

👉 See what’s possible for your email setup  
→ [See how it works (2 min)](/)

👉 Want to try it yourself?  
→ [Quickstart](/quickstart)

_Not responsible for email setup in your company?_  
Share this page with your IT department or marketing team, they’ll thank you for it.
