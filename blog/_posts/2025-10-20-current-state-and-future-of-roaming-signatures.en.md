---
layout: post
lang: en
locale: en
title: "Current state and future of roaming signatures"
description:
published: true
author: Markus Gruber
tags: 
slug: "current-state-and-future-of-roaming-signatures"
permalink: /blog/:year/:month/:day/:slug/
---
## A game changer with a downside
When Microsoft announced roaming signatures back in 2020, it sounded like a game-changer. No more local signature storage. A consistent experience across devices. And finally, a solution to the one-signature limitation in on-prem Outlook Web.

That was the theory.

Fast forward to mid-2024, and while most tenants now have roaming signatures enabled, the reality is more complicated:
- There's still no public API.
- Some persistent bugs remain unresolved.
- Outlook doesn’t support roaming signatures on all platforms.

At Set-OutlookSignatures and ExplicIT, we’re convinced that roaming signatures are the future. But Microsoft's slow rollout and limited communication have made adoption tricky. That's why we’ve invested heavily in supporting this feature within Set-OutlookSignatures - offering capabilities no other solution on the market can match.

Our recommendation for most clients:
- Enable roaming signatures in your tenant
- Disable them on the client side
- Let Set-OutlookSignatures handle the rest

## And what about mobile support?
Today, it's a pain point, often requiring expensive server-side rerouting just to apply a signature. But once Microsoft releases an official API, that changes. In the meantime, the Outlook add-in - part of the Benefactor Circle add-on - closes this gap.

## Interested in learning more or seeing our solution in action?
[Contact us](/contact/) or explore further on our [website](/). We look forward to connecting with you!