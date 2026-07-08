---
layout: "post"
lang: "en"
locale: "en"
title: "How do you deploy signatures for Send As and Send On Behalf?"
description: "In static environments, this is usually straightforward. But in dynamic organizations, it can quickly become a challenge."
slug: "sendas-sendonbehalf"
published: true
tags:
show_sidebar: true
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

In small and static environments, signatures for "Send As" and "Send on Behalf Of" are usually straightforward. However, in dynamic environments, this can quickly become a challenge: delegation scenarios change frequently, especially when users grant temporary permissions during holiday or sick leave.

The combination of [Export-RecipientPermissions](https://explicitconsulting.at/open-source/export-recipientpermissions) and Set-OutlookSignatures automates the process:

- Export-RecipientPermissions documents and compares mailbox permissions. You can automatically notify users about the permissions they have granted or received.
- Set-OutlookSignatures can use this data via the parameter "[VirtualMailboxConfigFile](/parameters#virtualmailboxconfigfile)". This allows users to receive signatures for authorised mailboxes even if they have not added them as mailboxes in Outlook. Of course, the signatures are also removed again when authorisation is no longer granted.

The result is fully automated, up-to-date signatures that adapt to actual usage. No manual tracking, no outdated configurations.

## Turn every small email moment into a professional advantage

Email signatures and out-of-office replies may seem minor, but think about how often people see them.

We help organizations centrally manage and standardize these touchpoints across all users — **unified Outlook branding everywhere, with zero external data exposure.** No manual effort, no inconsistencies, no data leaving your environment. With Set-OutlookSignatures, every email becomes a consistent, secure, and fully controlled brand experience.

👉 See what’s possible for your email setup  
→ [See how it works (2 min)](https://set-outlooksignatures.com/)

👉 Want to try it yourself?  
→ [Quickstart](https://set-outlooksignatures.com/quickstart)

_Not responsible for email setup in your company?_  
Share this article with your IT department or marketing team, they’ll thank you for it.

