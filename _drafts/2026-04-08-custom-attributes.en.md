---
layout: "post"
lang: "en"
locale: "en"
title: "Custom attributes and calculated data in email signatures"
description: "Most of the information used in email signatures comes directly from your directory service. But what about the data that doesn’t have a predefined field?"
published: true
tags: 
slug: "custom-attributes"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
Most of the information used in email signatures comes directly from your directory service. First and last names, job titles, phone numbers, office locations, and even supervisor details are usually already there.

But what about the data that doesn’t have a predefined field? Examples include:
- Job titles in multiple languages
- Academic titles that appear before or after the name
- Working hours for part-time or shift-based roles
- Gender pronouns to support inclusive communication

You can store this data centrally by using custom attributes. In Exchange, 15 custom attributes are available by default. You can also create your own in Active Directory or Entra ID.

Set-OutlookSignatures makes it easy to work with this data:
- Use predefined replacement variables like \$CurrentUserExtAttr1\$ or \$CurrentMailboxManagerExtAttr2\$
- Connect to external data sources such as CSV files, databases, or web services
- Use PowerShell logic to calculate values dynamically

You can also use conditional logic to map internal department names to public-facing ones, or apply seasonal rules to signature content.


## Interested in learning more or seeing our solution in action?
[Contact us](/support) or explore further on our [website](/). We look forward to connecting with you!