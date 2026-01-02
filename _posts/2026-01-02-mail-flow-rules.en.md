---
layout: "post"
lang: "en"
locale: "en"
title: "Mail flow rules fail for professional email signatures"
description: "Mail flow rules in Exchange are outdated and inflexible compared to specialized email signature solutions."
published: true
tags: 
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


## Interested in learning more or seeing our solution in action?
[Contact us](/support) or explore further on our [website](/). We look forward to connecting with you!