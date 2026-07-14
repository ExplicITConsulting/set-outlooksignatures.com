---
layout: "post"
lang: "en"
locale: "en"
title: "Stop Outlook Signatures Turning Blue in Replies"
description: "Outlook can recolour signature text in replies. Learn why Automatic font colour causes it and how to keep branding consistent."
slug: "signature-text-colour"
published: true
tags:
show_sidebar: true
redirect_from:
  - "/blog/2025/07/15/signature-text-blue"
  - "/blog/2025/07/15/signature-text-blue/"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

A marketing team approves a signature with black contact details, IT deploys it across Microsoft 365, and every test in a new message looks correct. The problem appears after deployment: when users reply to or forward a message, parts of the same signature turn blue, leaving brand owners with screenshots of an inconsistency that nobody saw during approval.

## Why black text can become blue

Outlook can use different default font settings for new messages and for replies and forwards. A common configuration is black text for new messages and blue text for replies and forwards, and those defaults can affect signature content as well as the message body.

The decisive detail is the colour assigned to the text in the signature template. Word and Outlook offer a font colour named `Automatic`, which usually appears black while the template is being edited. It is not the same as an explicitly assigned black colour.

Text set to `Automatic` can follow Outlook’s default colour for the current message type:

- In a new message, the default may be black, so the signature appears correct.
- In a reply or forward, the default may be blue, so the signature changes with it.
- Text assigned an explicit black colour remains black instead of following the message default.

The fault is easy to miss because the template itself does not necessarily look wrong. The colour change depends on the Outlook context in which the signature is inserted, so an approval process based only on new messages does not test the behaviour that causes the problem.

## Fix the template, then test each message context

Treat signature colours as fixed brand values rather than allowing Outlook to choose them. In the source template, select the affected text and assign the intended colour explicitly; for black text, choose a defined black value rather than `Automatic`.

The relevant difference in the generated HTML is whether the text has a fixed colour declaration. Explicit black can be represented as follows:

```html
<span style="color: #000000;">Finance Department</span>
```

The exact HTML produced from a Word template may differ. The required behaviour remains the same: the final signature must contain a defined colour rather than a colour setting that follows Outlook’s formatting for the current message.

After correcting the template, test it in every Outlook situation included in the organisation’s normal workflow:

1. Create a new message and insert the signature.
2. Reply to a received message.
3. Forward a received message.
4. Switch between available signatures while composing.
5. Check the result in the Outlook editions covered by the deployment.

The review should not stop at the compose window. Check the sent message as well, because that is the version recipients see and the version colleagues will use when reporting a branding fault.

> 💡 **Best Practice:** Assign every brand-sensitive signature colour explicitly, then include new messages, replies, forwards and signature switching in the template acceptance test.

## Apply the correction at the template source

Correcting one user’s local signature does not address the source of the problem. If employees use separate copies of the same template, local repairs create several versions whose formatting can diverge again when the next address, disclaimer or campaign element changes.

Set-OutlookSignatures allows the corrected template to be managed centrally and assigned through user attributes, groups and rules. IT can distribute the approved version across the Microsoft 365 tenant, while Marketing controls the visual specification and Compliance reviews the same template used for deployment.

This also makes the test repeatable. A template owner can verify the explicit colour, test the relevant Outlook message types, and release the approved version through the established deployment process. Users do not need to diagnose why one line turned blue or repair their own signatures, and later content changes do not require the same correction mailbox by mailbox.

The operational rule is simple: if a signature element must retain a particular colour, do not leave that colour set to `Automatic`. Store the intended value in the centrally managed template and test the rendered signature wherever Outlook applies different message defaults.

<!--
LinkedIn Post:

Outlook replies turn approved black signature text blue. The signature looked correct in every new-message test, but its Automatic font colour followed Outlook’s reply formatting as soon as users answered or forwarded an email.

That small template setting creates a tenant-wide contradiction: Marketing approves a fixed brand colour, while Outlook treats the same text as dependent on the message type. The source appears black, the deployment succeeds, and the visible result still changes.

The unresolved question is whether the signature owns its colour or inherits whatever Outlook decides for that compose window: https://set-outlooksignatures.com/blog/2026/07/14/signature-text-colour
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
