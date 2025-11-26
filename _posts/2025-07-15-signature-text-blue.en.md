---
layout: "post"
lang: "en"
locale: "en"
title: "Why does text sometimes turn blue instead of staying black?"
description: "Ever noticed your email signature text mysteriously changing color, especially in replies or forwards?"
published: true
tags: 
slug: "signature-text-blue"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
Ever noticed your email signature text mysteriously changing color, especially in replies or forwards?

Here's what's going on: By default, Outlook uses black text for new emails and blue text for replies and forwards. These defaults also apply to signatures - sometimes by design, sometimes by surprise.

There are two key factors at play:
1️⃣ Outlook's default formatting:
You can configure default text colors for new messages and replies/forwards via Outlook settings, registry keys, or Group Policy.

2️⃣ The hidden twist: 'Automatic' text color:
When designing signatures in Word or Outlook, you might unknowingly apply a color called 'Automatic'. It looks like black, but it's not.
- Text set to 'Automatic' adapts to Outlook's default colors (black for new, blue for replies).
- Text set to 'Black' stays black, always.

And here's the kicker: Some Outlook versions struggle to interpret 'Automatic' correctly, especially when switching signatures mid-draft or using the preview pane.

With Set-OutlookSignatures, you can standardize signature formatting across your organization. No surprises, no color shifts, just consistent branding.

## Interested in learning more or seeing our solution in action?
[Contact us](/support) or explore further on our [website](/). We look forward to connecting with you!