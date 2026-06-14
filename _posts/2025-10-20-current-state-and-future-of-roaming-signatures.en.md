---
layout: "post"
lang: "en"
locale: "en"
title: "Current state and future of roaming signatures"
description: "When Microsoft announced roaming signatures back in 2020, it sounded like a game-changer."
published: true
tags:
show_sidebar: true
slug: "current-state-and-future-of-roaming-signatures"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

## A game changer with a downside

When Microsoft announced roaming signatures back in 2020, it sounded like a game-changer. No more local signature storage. A consistent experience across devices. And finally, a solution to the one-signature limitation in on-prem Outlook for the web.

That was the theory.

Fast forward to mid-2025, and while most tenants now have roaming signatures enabled, the reality is more complicated:

- There's still no public API.
- Some persistent bugs remain unresolved ([encoding conversion](/faq#roaming-signatures-in-classic-outlook-for-windows-look-different), for example).
- Outlook doesn't support roaming signatures on all platforms.

At Set-OutlookSignatures and ExplicIT, we're convinced that roaming signatures are the future. But Microsoft's slow rollout and limited communication have made adoption tricky. That's why we've invested heavily in supporting this feature within Set-OutlookSignatures - offering capabilities no other solution on the market can match.

Our recommendation for most clients:

- Enable roaming signatures in your tenant.
- Disable them on the client side.
- Let Set-OutlookSignatures handle the rest.

If you cannot or do not want to run Set-OutlookSignatures on your clients, distribute signatures from a central location using ‘[SimulateAndDeploy](/parameters#simulateanddeploy)’.

## And what about mobile support?

Today, it's a pain point, often requiring expensive server-side rerouting just to apply a signature. But once Microsoft releases an official API, that changes.

In the meantime, the [Outlook add-in](/outlookaddin), part of the [Benefactor Circle add-on](/benefactorcircle), closes this gap - and more - not only for Android and iOS but for all platforms Outlook supports.

## Turn every small email moment into a professional advantage

Email signatures and out-of-office replies may seem minor, but think about how often people see them.

We help organizations centrally manage and standardize these touchpoints across all users — **unified Outlook branding everywhere, with zero external data exposure.** No manual effort, no inconsistencies, no data leaving your environment. With Set-OutlookSignatures, every email becomes a consistent, secure, and fully controlled brand experience.

👉 See what’s possible for your email setup  
→ [See how it works (2 min)](https://set-outlooksignatures.com)

👉 Want to try it yourself?  
→ [Quickstart](https://set-outlooksignatures.com/quickstart)

_Not responsible for email setup in your company?_  
Share this page with your IT department or marketing team, they’ll thank you for it.
