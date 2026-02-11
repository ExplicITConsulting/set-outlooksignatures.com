---
layout: "post"
lang: "en"
locale: "en"
title: "How do you deploy signatures for Send As and Send On Behalf?"
description: "In static environments, this is usually straightforward. But in dynamic organizations, it can quickly become a challenge."
published: true
tags: 
slug: "sendas-sendonbehalf"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
In small and static environments, signatures for "Send As" and "Send on Behalf Of" are usually straightforward. However, in dynamic environments, this can quickly become a challenge: delegation scenarios change frequently, especially when users grant temporary permissions during holiday or sick leave.

The combination of Export-RecipientPermissions and Set-OutlookSignatures automates the process:
- Export-RecipientPermissions documents and compares mailbox permissions. You can automatically notify users about the permissions they have granted or received.
- Set-OutlookSignatures can use this data via the parameter "[VirtualMailboxConfigFile](/parameters#virtualmailboxconfigfile)". This allows users to receive signatures for authorised mailboxes even if they have not added them as mailboxes in Outlook. Of course, the signatures are also removed again when authorisation is no longer granted.

The result is fully automated, up-to-date signatures that adapt to actual usage. No manual tracking, no outdated configurations.


## Interested in learning more or seeing our solution in action?
[Contact us](/support) or explore further on our [website](/). We look forward to getting to know you!