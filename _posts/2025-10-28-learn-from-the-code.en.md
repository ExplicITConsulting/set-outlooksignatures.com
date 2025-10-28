---
layout: "post"
lang: "en"
locale: "en"
title: "What can I learn from the code of Set-OutlookSignatures?"
description:
published: true
author: Markus Gruber
tags: 
slug: "learn-from-the-code"
permalink: "/blog/:year/:month/:day/:slug/"
---
Set-OutlookSignatures is not just a tool for managing Outlook signatures and out-of-office replies. It is free and open-source because I want to give something back to the community that has helped me so often over the years.

The code is, of course, full of stuff related to getting reliable information about the current user and its manager from different sources, reading and interpreting the Outlook configuration from the registry, and automating Word for document manipulation. Thanks to open-source, you can have a look at it and actively help make it better.

Beside the big learning topics mentioned in the [FAQ](/faq/), the main and support files of Set-OutlookSignatures are sprinkled with small code snippets and comments you may find useful. Chances are good that you will stumble across some small gems of code by just browsing through it.

The following gives you an overview which other scripting techniques you can [learn from Set-OutlookSignatures](/faq/#44-what-can-i-learn-from-the-code-of-set-outlooksignatures).  
- Active Directory group membership enumeration without compromises
- Microsoft Graph authentication and re-authentication
- Deploy and run software using desired state configuration (DSC)
- Parallel code execution
- Create desktop icons cross-platform
- Create and configure apps in Entra ID, grant admin consent
- Test Active Directory trusts
- Start only if working Active Directory connection is available
- Prohibit system sleep
- Detect exit signals
- Format phone numbers
- Format postal addresses
- Detect and convert string and file encodings, including HTML

You have found some lines of code that you can use for yourself? Great, that's exactly how it's meant to be. My pleasure!<br>One small request: If you have a minute, please <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/discussions?discussions\_q=">let me know</a> which part of the code you were able to reuse.

## Interested in learning more or seeing our solution in action?
[Contact us](/contact/) or explore further on our [website](/). We look forward to connecting with you!