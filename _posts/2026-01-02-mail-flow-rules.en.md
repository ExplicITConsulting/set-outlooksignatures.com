---
layout: "post"
lang: "en"
locale: "en"
title: "Mail flow rules fail for professional email signatures"
description: "Mail flow rules in Exchange are outdated and inflexible compared to specialized email signature solutions."
published: true
tags:
show_sidebar: true
slug: "mail-flow-rules"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

For many years, we have repeatedly read and heard that specialized solutions for the central management and distribution of email signatures are unnecessary because this can be done directly in Exchange Server and Exchange Online using [mail flow rules](https://learn.microsoft.com/en-us/exchange/policy-and-compliance/mail-flow-rules/signatures) (also known as transport rules).

The first impression may be positive. However, mail flow rules are only useful in practice for the lowest signature requirements and if you want to disappoint your users, your marketing department, and the recipients of emails.

In a nutshell:

- Microsoft has not updated mail flow rules for years.
- Users do not see signatures while writing an email.
- The assignment of signatures to specific mailboxes, groups, or users is inflexible.
- Signatures are inserted at the end of the entire thread, not at the end of the last email. This means that signatures do not appear where they belong, but are collected at the end of the conversation – where hardly anyone notices them.
- It is not possible to distinguish between new emails and replies/forwards.
- The available placeholder variables refer almost exclusively to the sender. There are no variables for the sender's manager or the ability to distinguish between variables for the actual sender and the sending mailbox.
- Placeholder variables cannot be customized.
- Due to [mail flow rule limits](https://learn.microsoft.com/en-us/office365/servicedescriptions/exchange-online-service-description/exchange-online-limits#journal-transport-and-inbox-rule-limits-1), the HTML code of signatures is restricted in size, and images can typically only be linked, not embedded. This conflicts with two behaviors of Outlook:
  - Externally linked content is blocked by default for security reasons. The user must instruct Outlook to download the images, otherwise placeholders appear that look like error messages.
  - When replying, linked images are downloaded and embedded—but the resolution is scaled down, resulting in blurry and pixelated images.

## Conclusion

Mail flow rules are a stopgap solution that does not meet the requirements of modern brand communication or user expectations.

If you want professional, consistent, and visually appealing signatures, there is no way around specialized solutions.

## Turn every small email moment into a professional advantage

Email signatures and out-of-office replies may seem minor, but think about how often people see them.

We help organizations centrally manage and standardize these touchpoints across all users — **unified Outlook branding everywhere, with zero external data exposure.** No manual effort, no inconsistencies, no data leaving your environment. With Set-OutlookSignatures, every email becomes a consistent, secure, and fully controlled brand experience.

👉 See what’s possible for your email setup  
→ [See how it works (2 min)](/)

👉 Want to try it yourself?  
→ [Quickstart](/quickstart)

_Not responsible for email setup in your company?_  
Share this page with your IT department or marketing team, they’ll thank you for it.
