---
layout: "post"
lang: "en"
locale: "en"
title: Sender-Based Outlook Signatures for SMTP Aliases
description: Apply the correct Outlook signature automatically when users send from alias or secondary SMTP addresses.
published: true
tags:
show_sidebar: true
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

A user sends a message from a shared brand identity using first.last@contoso.com. The email reaches the customer with a signature belonging to first.last@example.com, displaying the wrong company details, branding elements, and legal information. Nobody notices until the recipient replies to the wrong organisation.

# Outlook Cannot Set Default Signatures per Sender Address

Many Microsoft 365 mailboxes have more than one sender identity. A user may work primarily from first.last@example.com while also sending from addresses associated with a subsidiary, acquired company, regional business, campaign mailbox, or separate brand.

The challenge is straightforward: the selected sender address often needs a matching signature.

Outlook can assign default signatures at mailbox level, but it cannot natively assign different default signatures to different sender addresses belonging to the same mailbox. The mailbox receives a default signature, regardless of which alias or secondary SMTP address is selected during message composition.

That limitation creates an operational gap.

Marketing expects each sender identity to present the correct brand. Compliance expects the correct legal wording and contact information. IT can add alias addresses easily enough, but Outlook provides no native mechanism to automatically switch signatures according to the sender address selected by the user.

A mailbox with multiple communication identities therefore risks producing inconsistent outbound email.

# The Real Issue Is Identity Consistency

Consider the following mailbox configuration:

- Primary SMTP address: `first.last@example.com`
- Secondary SMTP address: `first.last@contoso.com`

The requirement is usually non-negotiable:

- Messages sent from `first.last@example.com` should use the standard corporate signature.
- Messages sent from `first.last@contoso.com` should use a Contoso-specific signature.

The sender address visible to recipients influences how the message is interpreted. Recipients use it to determine which organisation is communicating with them, which brand they are engaging with, and which legal entity may be responsible for the communication.

A mismatch between sender identity and signature is more than a cosmetic problem. It introduces confusion, weakens brand governance, and can create unnecessary compliance questions.

> 💡 **Best Practice:** Treat sender addresses as communication identities rather than technical mailbox attributes. If an address represents a different brand, entity, region, or business unit, create a dedicated signature strategy for that identity.

# Applying Signatures Based on the Selected Sender Address

Set-OutlookSignatures centrally creates and deploys the required signatures across Microsoft 365 environments. The <a href="https://set-outlooksignatures.com/outlookaddin">Outlook add-in</a>, available through the <a href="https://set-outlooksignatures.com/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a>, can then apply the to the sender address selected in Outlook.

This creates a practical division of responsibilities.

Marketing defines the signature content for each communication identity. IT manages deployment through Set-OutlookSignatures. The Outlook add-in evaluates the sender address at compose time and selects the appropriate signature through `CUSTOM_RULES_CODE`.

Users continue working normally. They select the required sender address and the matching signature follows automatically.

# Configuration Example

Start by creating the standard mailbox signature.

The following configuration assigns a signature to the primary address and sets it as the default signature for new messages.

```ini
# Create signature for mailbox
# Example uses a mail address specific assignment, it could also be a group
[formal.docx]
first.last@example.com
defaultNew
```

Next, create signatures for the secondary SMTP address.

```ini
# Create signature for secondary SMTP address (alias address)
[formal Contoso.docx]
first.last@contoso.com

[informal Contoso.docx]
first.last@contoso.com
```

After deployment, the signatures become available to the user. The remaining task is selecting the correct one automatically when the sender address changes.

The Outlook add-in can accomplish this with `CUSTOM_RULES_CODE`.

The code below checks the sender address selected in Outlook. If the message originates from `first.last@contoso.com`, a dedicated signature is applied. New messages and replies can use different signatures.

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

The logic follows the actual communication identity being used:

- `targetEmail` defines the sender address that triggers the specialised signature.
- `sigNew` defines the signature for new messages.
- `sigReply` defines the signature for replies and forwards.
- `customRulesProperties.itemIsNew` determines whether the current message is new or existing.
- `customRulesProperties.itemFrom.emailAddress` contains the sender address currently selected in Outlook.
- `customRulesProperties.availableSignatures` confirms the signature exists.
- `customRulesResultSignatureName` instructs the add-in which deployed signature to apply.
- `customRulesResultNotification` displays confirmation to the user.

The code executes whenever the add-in is triggered through a launch event and when a user selects **Set selected signature** within the add-in pane.

That behaviour matters because the decision is based on the current Outlook item rather than on mailbox defaults alone. The add-in can evaluate the active sender identity and apply the corresponding signature at the moment it is needed.

For organisations using multiple brands, subsidiaries, business units, or communication identities from a single mailbox, that closes a limitation Outlook cannot address by itself.

<!--
LinkedIn Post:

An Outlook alias is selected, but the wrong signature appears. The user sends from first.last@contoso.com, yet the email leaves with branding and contact details intended for first.last@example.com. What looks like a simple signature issue is actually a mismatch between sender identity and mailbox-level defaults, because Outlook only assigns default signatures per mailbox rather than per sender address. The result is that the visible sender identity changes while the signature remains tied to a different communication context: https://set-outlooksignatures.com/blog/2026/07/08/smtp-alias-signatures
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
