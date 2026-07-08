---
layout: "post"
lang: "en"
locale: "en"
title: "How to Keep Users from Adding, Editing, or Removing Signatures"
description: "Learn how to restrict signature changes in Classic Outlook, New Outlook, Web, and Mobile, and discover better alternatives."
slug: "restrict-outlook-signature-changes"
published: true
tags:
show_sidebar: true
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

Maintaining a consistent corporate identity across an entire organization can be a challenge, especially when users frequently modify, use outdated, or completely remove their email signatures. To enforce brand guidelines and ensure legal compliance, IT administrators often need to restrict users from changing their signature settings.

However, the capability to lock down these settings varies significantly depending on which version of Outlook your organization uses. Below is a detailed technical overview of how to restrict signature modifications across different Outlook platforms, the limitations you will encounter, and the best alternative approaches.

### Classic Outlook for Windows

You can disable GUI elements so that users cannot add, edit and remove signatures in Outlook by using the 'Do not allow signatures for email messages' Group Policy Object (GPO) setting.

Caveats are:

- Users can still add, edit and remove signatures in the file system
- Default signatures are no longer automatically added when a new email is created, or you forward/reply an email. Users have to choose the correct signature manually.
- The GPO setting seems not to work with some newer versions of Outlook. In this case, set the registry key directly.

As an alternative, you may consider one or both of the following options:

- Run Set-OutlookSignatures regularly (every two hours, for example) and use the 'WriteProtect' option in the INI file
- Use the 'Disable Items in User Interface' Group Policy Object (GPO) setting, and consider the following values to disable specific signature-related parts of the user interface:
  - 5608: 'SignatureInsertMenu', the dropdown list/button allowing you to select an existing signature to add to an email, and to open the 'SignatureGallery'.
  - 22965: 'SignatureGallery', the list of signatures in the 'SignatureInsertMenu'. Prohibits selecting another signature than the default one to add to an email, but still allows access to 'SignaturesStationeryDialog'.
  - 3766: 'SignaturesStationeryDialog', the GUI allowing users to add, edit and remove signatures. Also disables access to 'Personal Stationary' and 'Stationary and Fonts' - these settings should be controlled centrally anyway in order to comply with the corporate identity/corporate design guidelines.

There is one thing you cannot disable: Outlook always allows users to edit the copy of the signature after it was added to an email.

### Outlook for the web, New Outlook for Windows

Unfortunately, Outlook for the web cannot be configured as granularly as Outlook. In Exchange Online as well as in Exchange on-prem, the `Set-OwaMailboxPolicy` cmdlet does not allow you to configure signature settings in detail, but only to disable or enable signature features via the `SignaturesEnabled` parameter for specific groups of mailboxes.

There is no option to write protect signatures, or to keep users from adding, editing and removing signatures without disabling all signature-related features.

As an alternative, run Set-OutlookSignatures regularly (every two hours, for example).

### Outlook for Android, Outlook for iOS, Outlook for Mac

There is no way to fully prevent users from editing signatures during composition — however, modern approaches allow enforcing the correct signature at send time.

### The Outlook add-in

The [Outlook add-in](/outlookaddin), part of the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a>, includes a feature that allows to ignore or delete user defined signature options.

When the parameter `DISABLE_CLIENT_SIGNATURES` is enabled:

- In Outlook for the web and New Outlook for Windows, the signature option for new mails, replies, and forwards is disabled. A signature that's selected is also disabled.
- In Classic Outlook for Windows and in Outlook for Mac, the signature under the New messages and Replies/forwards sections of the sending account is set to (none).
- In Outlook for Android and Outlook for iOS, the signature saved on the mobile device is deleted.

While disabling client-side signatures removes user-defined options, it still does not guarantee what the final email will look like at the moment it is sent.

For full control, combine this setting with send-time enforcement using `OnMessageSend`. This ensures that even if users attempt to modify or remove content while composing, the correct signature is always applied before delivery.

This leaves one critical gap: ensuring enforcement at the point where it actually matters — when the email is sent.

#### The missing piece: Enforcing signatures at send time

Even with all approaches described above, there has always been one fundamental limitation: Once a signature is inserted into an email, Outlook allows users to modify or remove it before sending.

With the latest versions of the Outlook add-in, this limitation can now be effectively eliminated.

By enabling the launch events:

- `OnMessageSend`
- `OnAppointmentSend`

a defined signature is applied **immediately after the user clicks Send**.

The enforcement happens client-side within Outlook, ensuring that users can see the final applied signature in their Sent Items.

This means:

- Any manual modifications are overridden
- A missing signature is automatically added
- The final message in the Sent Items folder always contains the correct, compliant signature

This approach fundamentally changes how signature governance works:  
👉 Instead of trying to prevent users from editing signatures (which Outlook does not fully allow)  
👉 you enforce the correct, compliant result at the exact moment of sending

This makes `OnMessageSend` and `OnAppointmentSend` the only approach that guarantees a correct signature in every sent email — and therefore the most reliable and future-proof solution available today.

From a governance and compliance perspective, this closes a long-standing gap:

- Legal disclaimers can no longer be removed
- Corporate branding is consistently enforced
- Regulatory requirements are guaranteed at the point of outbound communication

This is especially relevant for organizations operating under strict regulatory or compliance requirements.

In practice, this means that signature compliance no longer depends on user behavior at all.

In other words, signature management evolves from a best-effort configuration task into a fully enforceable control mechanism.

> 💡 **Best practice**
>
> The most effective setup today combines:
>
> - Disabling client-side signature settings (`DISABLE_CLIENT_SIGNATURES`)
> - Central signature generation
> - Send-time enforcement via `OnMessageSend`
>
> This layered approach ensures both a controlled user experience and guaranteed compliance in every sent email.

## Turn every small email moment into a professional advantage

Email signatures and out-of-office replies may seem minor, but think about how often people see them.

We help organizations centrally manage and standardize these touchpoints across all users — **unified Outlook branding everywhere, with zero external data exposure.** No manual effort, no inconsistencies, no data leaving your environment. With Set-OutlookSignatures, every email becomes a consistent, secure, and fully controlled brand experience.

👉 See what’s possible for your email setup  
→ [See how it works (2 min)](https://set-outlooksignatures.com/)

👉 Want to try it yourself?  
→ [Quickstart](https://set-outlooksignatures.com/quickstart)

_Not responsible for email setup in your company?_  
Share this article with your IT department or marketing team, they’ll thank you for it.
