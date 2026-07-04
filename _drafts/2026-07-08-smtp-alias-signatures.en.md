---
layout: "post"
lang: "en"
locale: "en"
title: "Outlook Signatures for Alias and Secondary SMTP Addresses"
description: "How to apply the right Outlook signature when users send from an alias or secondary SMTP address."
published: true
tags:
show_sidebar: true
slug: "smtp-alias-signatures"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

Many mailboxes have more than one sender address. For example, a user may have the primary SMTP address `first.last@example.com` and an additional sender address such as `first.last@contoso.com`.

IT usually knows this as a secondary SMTP address. Marketing may think of it more simply as an alias address: another email address that represents a brand, company, region, business unit, campaign, or communication identity.

Both views are correct.

The technical term matters because it describes how the address exists on the mailbox. The marketing perspective matters because the address is visible to the recipient. If the sender address changes, the signature often needs to change as well.

That is where Outlook has an important limitation.

Outlook can define default signatures for mailboxes, but not for individual sender addresses on the same mailbox. In other words, Outlook can assign a default signature to the mailbox, but it cannot natively assign one default signature to `first.last@example.com` and another one to `first.last@contoso.com`.

For organizations with multiple brands, business units, regions, acquired companies, or dedicated communication identities, this matters. The selected sender address and the applied email signature should tell the same story.

## The scenario

Consider this mailbox:

- Primary SMTP address: `first.last@example.com`
- Alias address / secondary SMTP address: `first.last@contoso.com`

The requirement is clear:

- Emails sent from `first.last@example.com` should use the regular signature.
- Emails sent from `first.last@contoso.com` should use a signature matching the Contoso identity.

From a branding and compliance perspective, this is exactly what users expect. From a native Outlook configuration perspective, however, it is not available as a standard default-signature setting.

## Why this matters for Marketing and IT

For Marketing, the sender address is part of the visible brand experience. It influences how recipients understand the message: which company is speaking, which brand is represented, and which legal or campaign context applies.

For IT, the same address is a mailbox attribute and a sender identity. It may be technically straightforward to add an alias address / secondary SMTP address to a mailbox, but Outlook does not provide a separate default-signature setting for each address.

That creates a gap between technical mailbox configuration and brand-compliant communication.

The user can select the correct sender address, but the matching signature still needs to follow automatically.

## The solution: use Set-OutlookSignatures and the Outlook add-in

Set-OutlookSignatures creates and deploys the required signatures centrally. The [Outlook add-in](https://set-outlooksignatures.com/outlookaddin), available with the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a>, can then apply the right signature based on the sender address selected in Outlook.

This creates a clean split of responsibilities:

- Marketing defines the correct signature content for each visible sender identity.
- IT deploys the signatures centrally with Set-OutlookSignatures.
- The Outlook add-in detects the sender address used in the current email, and `CUSTOM_RULES_CODE` selects the matching signature based on its configuration.

The result is simple for users: they choose the sender address, and Outlook applies the matching signature.

### Configure the Set-OutlookSignatures INI file

First, create the regular signature for the mailbox. The following example uses a mail-address-specific assignment, but the assignment could also be based on a group.

```ini
# Create signature for mailbox
# Example uses a mail address specific assignment, it could also be a group

[formal.docx]
first.last@example.com
defaultNew
```

This creates the standard signature for the mailbox and configures it as the default signature for new emails.

Next, create separate new and reply signatures for the alias address / secondary SMTP address:

```ini
# Create signature for secondary SMTP address (alias address)

[formal Contoso.docx]
first.last@contoso.com

[informal Contoso.docx]
first.last@contoso.com
```

This makes the address-specific signature available to the user. The automatic selection for the alias address / secondary SMTP address is handled by the Outlook add-in.

### Configure the Outlook add-in

The Outlook add-in supports the `CUSTOM_RULES_CODE` option. This JavaScript code runs every time a launch event triggers the add-in, or when a user clicks `Set selected signature` in the add-in task pane.

The code can inspect the current Outlook item and decide which signature should be applied.

In this example, the add-in checks whether the message is being sent from `first.last@contoso.com`. If it is, it applies a signature for new emails and another signature for replies or forwards.

```javascript
var targetEmail = "first.last@contoso.com";
var sigNew = "formal Contoso";
var sigReply = "informal Contoso";

var targetSignature = customRulesProperties.itemIsNew ? sigNew : sigReply;
var notificationText = "Applied " + targetSignature + " automatically.";

if (customRulesProperties.itemFrom.emailAddress.toLowerCase() === targetEmail.toLowerCase()) {
  if (customRulesProperties.availableSignatures.indexOf(targetSignature) !== -1) {
    customRulesResultSignatureName = targetSignature;
    customRulesResultNotification = notificationText;
  } else {
    await logMessage("Signature '" + targetSignature + "' not found in available signatures.");
  }
}
```

The logic is intentionally easy to understand:

- `targetEmail` is the alias address / secondary SMTP address that should trigger the special signature.
- `sigNew` is the signature for new emails.
- `sigReply` is the signature for replies and forwards.
- `customRulesProperties.itemIsNew` detects whether the current item is a new email.
- `customRulesProperties.itemFrom.emailAddress` contains the sender address selected in Outlook.
- `customRulesProperties.availableSignatures` checks whether the target signature is available.
- `customRulesResultSignatureName` tells the add-in which deployed signature to apply.
- `customRulesResultNotification` shows a short confirmation in Outlook.

If new emails and replies should use different signatures, simply set different values for `sigNew` and `sigReply`.

### When `CUSTOM_RULES_CODE` runs

`CUSTOM_RULES_CODE` runs every time a launch event triggers the Outlook add-in. It also runs when the user clicks `Set selected signature` in the add-in task pane.

That makes the rule context-aware. The add-in can look at the current email, detect the selected sender address, and apply the matching signature.

For alias address / secondary SMTP address scenarios, this is exactly the missing piece: Outlook alone only knows default signatures per mailbox, while the add-in can react to the actual sender address used in the email.

## Final thoughts

Alias addresses / secondary SMTP addresses are often used for good business reasons: brands, companies, regions, business units, campaigns, and special communication contexts. But when the sender address changes, the email signature often needs to change as well.

Outlook alone cannot define separate default signatures per sender address on the same mailbox. It can only define defaults for the mailbox.

By combining Set-OutlookSignatures with the [Outlook add-in](https://set-outlooksignatures.com/outlookaddin) from the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a>, organizations can close this gap. Signatures are still centrally created and deployed, while the add-in applies the right signature based on the sender address selected in Outlook.

Marketing gets consistent branding. IT gets a manageable and automated configuration. Users get the right signature without having to think about it.

## Turn every small email moment into a professional advantage

Email signatures and out-of-office replies may seem minor, but think about how often people see them.

We help organizations centrally manage and standardize these touchpoints across all users — **unified Outlook branding everywhere, with zero external data exposure.** No manual effort, no inconsistencies, no data leaving your environment. With Set-OutlookSignatures, every email becomes a consistent, secure, and fully controlled brand experience.

👉 See what’s possible for your email setup  
→ [See how it works (2 min)](https://set-outlooksignatures.com/)

👉 Want to try it yourself?  
→ [Quickstart](https://set-outlooksignatures.com/quickstart)

_Not responsible for email setup in your company?_  
Share this article with your IT department or marketing team, they’ll thank you for it.
