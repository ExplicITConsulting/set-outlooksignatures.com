---
layout: "post"
lang: "en"
locale: "en"
title: "Current state and future of roaming signatures"
description: "When Microsoft announced roaming signatures back in 2020, it sounded like a game-changer."
published: true
tags: 
slug: "current-state-and-future-of-roaming-signatures"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
## A game changer with a downside
When Microsoft announced roaming signatures back in 2020, it sounded like a game-changer. No more local signature storage. A consistent experience across devices. And finally, a solution to the one-signature limitation in on-prem Outlook Web.

That was the theory.

Fast forward to mid-2024, and while most tenants now have roaming signatures enabled, the reality is more complicated:
- There's still no public API.
- Some persistent bugs remain unresolved ([encoding conversion](/faq#41-roaming-signatures-in-classic-outlook-for-windows-look-different), for example).
- Outlook doesn't support roaming signatures on all platforms.

At Set-OutlookSignatures and ExplicIT, we're convinced that roaming signatures are the future. But Microsoft's slow rollout and limited communication have made adoption tricky. That's why we've invested heavily in supporting this feature within Set-OutlookSignatures - offering capabilities no other solution on the market can match.

Our recommendation for most clients:
- Enable roaming signatures in your tenant.
- Disable them on the client side.
- Let Set-OutlookSignatures handle the rest.

If you cannot or do not want to run Set-OutlookSignatures on your clients, distribute signatures from a central location using ‘[SimulateAndDeploy](/parameters#19-simulateanddeploy)’.

## And what about mobile support?
Today, it's a pain point, often requiring expensive server-side rerouting just to apply a signature. But once Microsoft releases an official API, that changes.

In the meantime, the [Outlook add-in](/outlookaddin), part of the [Benefactor Circle add-on](/benefactorcircle), closes this gap - and more - not only for Android and iOS but for all platforms Outlook supports.

## Interested in learning more or seeing our solution in action?
[Contact us](/support) or explore further on our [website](/). We look forward to connecting with you!