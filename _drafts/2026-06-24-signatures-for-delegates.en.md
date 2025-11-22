---
layout: "post"
lang: "en"
locale: "en"
title: "How to deploy signatures for mailbox delegates but not the owner"
description: "This is a common request in boss-secretary or assistant scenarios: Assign a signature to everyone with access to userA@example.com, but not to UserA."
published: true
tags: 
slug: "signatures-for-delegates"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
This is a common request in boss-secretary or assistant scenarios: "Assign a signature to everyone with access to userA@example.com, but not to UserA."

With Set-OutlookSignatures, this is easy to implement:
```
[delegate template name.docx]
# Assign the template to everyone having userA@example.com as mailbox in Outlook
userA@example.com
# Do not assign the template to the actual user owning the mailbox userA@example.com
-CURRENTUSER:userA@example.com
```

That’s it. Simple and effective.

Now let’s take it one step further. You can use a single delegate template across your entire organization to cover all delegate scenarios.

Just make sure the template uses \$CurrentUser[...]\$ and \$CurrentMailbox[...]\$ correctly. Then reuse the template in your .ini file with different signature names:
```
[Company EN external formal delegate.docx]
userA@example.com
-CURRENTUSER:userA@example.com
OutlookSignatureName = Company EN external formal userA@

[Company EN external formal delegate.docx]
userX@example.com
-CURRENTUSER:userX@example.com
OutlookSignatureName = Company EN external formal UserX@
```

## Interested in learning more or seeing our solution in action?
[Contact us](/contact) or explore further on our [website](/). We look forward to connecting with you!