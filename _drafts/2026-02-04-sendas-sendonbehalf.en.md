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
In static environments, this is usually straightforward. But in dynamic organizations, it can quickly become a challenge. Delegate scenarios change often, especially when users grant temporary permissions during vacations or sick leave.

Here’s how the combination of [Export-RecipientPermissions](https://explicitconsulting.at/open-source/export-recipientpermissions) and Set-OutlookSignatures simplifies the process:
- Export-RecipientPermissions documents and compares mailbox permissions. You can automatically notify users about permissions they've granted or received.
- Set-OutlookSignatures uses this data to dynamically assign additional signatures to users who have Send As or Send On Behalf permissions for another mailbox. The easiest way to achieve this is to use the '[VirtualMailboxConfigFile](/parameters#38-virtualmailboxconfigfile)' parameter.

The result is a fully automated, up-to-date signature deployment that adapts to real-world usage. No manual tracking, no outdated configurations.

## Interested in learning more or seeing our solution in action?
[Contact us](/support) or explore further on our [website](/). We look forward to connecting with you!