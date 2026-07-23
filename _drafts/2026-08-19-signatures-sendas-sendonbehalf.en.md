---
layout: "post"
lang: "en"
locale: "en"
title: Signatures for Send As Permissions
description: Deploy Outlook signatures for Send As and Send on Behalf scenarios, including shared mailboxes, distribution lists and delegated identities.
slug: sendas-signatures
published: true
tags:
show_sidebar: true
redirect_from:
  - "/blog/2025/08/19/signatures-sendas-sendonbehalf"
  - "/blog/2025/08/19/signatures-sendas-sendonbehalf/"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

When users send email using **Send As** or **Send on Behalf** permissions, the mailbox they send from is often not a primary Outlook mailbox. This matters because Outlook only fully supports signatures for primary mailboxes, and Set-OutlookSignatures follows the same mailbox model when determining where signatures can be managed.

By default, the software processes primary mailboxes only. These are mailboxes added to Outlook as separate accounts. This behaviour mirrors Outlook itself, which does not provide full signature support for mailboxes added through **Open these additional mailboxes** or for sender identities that are only selected through the **From** field.

### Shared mailboxes, additional mailboxes and delegated senders

There are several common Microsoft 365 scenarios where administrators want mailbox-specific signatures even though the mailbox is not configured as a primary account:

- Shared mailboxes connected through automapping
- Additional mailboxes added manually
- Mailboxes used only through Send As permissions
- Mailboxes used only through Send on Behalf permissions
- Distribution lists with delegated sending rights

These scenarios are fundamentally different from a user's primary mailbox because Outlook has no mechanism to assign default signatures to many of these sender identities.

### Supporting automapped and additional mailboxes

If you want Set-OutlookSignatures to detect automapped and additional mailboxes, just enable the according feature using the `-SignaturesForAutomappedAndAdditionalMailboxes true` parameter.

Once enabled, the software can deploy signatures for these mailbox types.

However, it is important to understand the Outlook limitation involved. Signatures can be deployed, but they cannot be configured as default signatures because Outlook itself does not support default signature assignment for these non-primary mailboxes. The [Outlook add-in](https://set-outlooksignatures.com/outlookaddin) can easily overcome this Outlook limitation.

### The challenge with Send As and Send on Behalf

A more complex scenario occurs when users send from identities that are never connected as mailboxes in Outlook.

Examples include:

- A shared mailbox where users only have Send As permission
- A mailbox where users have Send on Behalf permission
- A distribution list with delegated sending rights

In these cases, users simply choose an alternative sender address in the **From** field. The mailbox or distribution group may not exist in Outlook as an account at all.

Consider the following example:

Members of the group `Example\Group` are allowed to send as:

- `m@example.com`
- `dg@example.com`

The organisation wants dedicated signatures for both sender identities.

Two practical problems appear immediately:

- `dg@example.com` is a distribution group and cannot be added to Outlook as a mailbox.
- `m@example.com` is typically not connected as a primary mailbox because most users have Send As permission but not Full Access permission. Some users simply select the address as a sender without connecting the mailbox at all.

### Solution A: Assign signatures through the delegated permissions group

The most broadly applicable approach is to assign signature templates to the same group that has been granted delegated sending rights.

```ini
[External English formal m@example.com.docx]
Example Group

[External English formal dg@example.com.docx]
Example Group
```

When Set-OutlookSignatures processes the user's primary mailbox, it evaluates group membership. If the user belongs to the delegated permissions group, the matching signatures become available.

This approach works for both mailboxes and distribution groups because it does not depend on the target sender identity being connected in Outlook.

The key limitation is that `$CurrentMailbox[...]$` variables still refer to the user's own mailbox because that is the mailbox currently being processed.

### Solution B: Use a virtual mailbox

The second option is available only for mailboxes, not distribution groups.

Using the **Benefactor Circle add-on**, a mailbox can be treated as a virtual mailbox regardless of whether it has been added to Outlook. This is controlled through the `VirtualMailboxConfigFile` parameter.

The signature can then be assigned directly to the mailbox itself:

```ini
[External English formal SendAs m@example.com.docx]
m@example.com

## Do not deploy the signature if m@example.com is the personal mailbox of the logged-on user

-CURRENTUSER:m@example.com
```

With this approach, Set-OutlookSignatures processes the mailbox as a virtual mailbox, allowing signature assignment even when users only send from the address through delegated permissions.

An additional advantage is that both mailbox-specific and user-specific replacement variables become available:

- `$CurrentUser[...]$`
- `$CurrentMailbox[...]$`

This provides greater flexibility when signature content needs to combine information from both the sender's account and the delegated mailbox.

### Before and after implementation

Before deployment:

- Users select an alternative sender address.
- The mailbox may not exist in Outlook as a primary account.
- Distribution groups cannot be added as mailboxes at all.
- Signature assignment becomes difficult or inconsistent.

After deployment:

- Delegated sender identities can receive dedicated signatures.
- Shared mailbox signatures remain available even when the mailbox is not connected.
- Distribution groups can be covered through group-based assignment.
- Administrators can align signature deployment with Microsoft 365 permission structures.

> 💡 **Best Practice:** For Send As and Send on Behalf scenarios, assign signatures to the same security or Microsoft 365 group that grants sending permissions. This keeps permission management and signature targeting synchronised and avoids mailbox-specific maintenance.

Where mailbox-specific replacement variables are required, use the Benefactor Circle virtual mailbox feature for mailbox identities that may not be connected to Outlook. This enables consistent signature deployment while working within Outlook's technical limitations.

<!--
LinkedIn Post:

Send As and Send on Behalf scenarios create a specific signature deployment problem in Outlook: the sender identity is often not a primary mailbox. It may be an automapped mailbox, an additional mailbox, a mailbox selected only through the From field, or a distribution list that cannot be added as a mailbox at all.

That distinction matters because Outlook does not treat these sender identities like primary mailboxes for signature purposes. A user can have permission to send from a shared mailbox or distribution group, while the signature assignment still needs to be handled through a permissions group, a detected additional mailbox, or a virtual mailbox definition.

The practical question is not only who may send from the address, but which object should receive the signature assignment. If that mapping is wrong, the sender address and the signature logic remain disconnected.

https://set-outlooksignatures.com/blog/2026/08/19/sendas-signatures
-->


## Turn every small email moment into a professional advantage

Email signatures and out-of-office replies may seem minor, but think about how often people see them.

We help organizations centrally manage and standardize these touchpoints across all users — **unified Outlook branding everywhere, with zero external data exposure.** No manual effort, no inconsistencies, no data leaving your environment. With Set-OutlookSignatures, every email becomes a consistent, secure, and fully controlled brand experience.

👉 See what’s possible for your email setup  
→ [See how it works (2 min)](https://set-outlooksignatures.com/)

👉 Want to try it yourself?  
→ [Quickstart](https://set-outlooksignatures.com/quickstart)

_Not responsible for email setup in your company?_  
Share this article with your IT department or marketing team, they’ll thank you for it.
