---
layout: post
lang: en
locale: en
title: "Signatures for Send As and Send on Behalf"
description:
published: true
author: Markus Gruber
tags: 
slug: "signatures-sendas-sendonbehalf"
permalink: /blog/:year/:month/:day/:slug/
---
## How do you deploy signatures for Send As and Send on Behalf scenarios?
You want to assign signatures to mailboxes or distribution lists that users don’t add to Outlook, but use by selecting a different "From" address with Send As or Send on Behalf rights?

With Set-OutlookSignatures, this is straightforward when you follow Microsoft’s best practices for permissions:
- Assign Send As or Send on Behalf permissions to a group, not directly to a user
- Create a signature template and assign it to that group

## Interested in learning more or seeing our solution in action?
[Contact us](/contact) or explore further on our [website](/). We look forward to connecting with you!