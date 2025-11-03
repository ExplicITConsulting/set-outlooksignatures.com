---
layout: "post"
lang: "en"
locale: "en"
title: "Detect and convert encodings"
description:
published: true
author: Markus Gruber
tags: 
slug: "detect-and-convert-encodings"
permalink: "/blog/:year/:month/:day/:slug/"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
The history of encoding began long before IT. Even the first alphabets were attempts to translate spoken language into visual symbols. Whether cuneiform, hieroglyphics, or the Latin alphabet, every culture developed its own systems for encoding information and preserving it across time and space. 

With the advent of computers, encoding became a technical challenge. Characters had to be translated into bytes, resulting in over 140 different character encodings that modern operating systems and frameworks still support today. ASCII, ISO-8859, Windows-1252, Shift-JIS—each encoding has its own characteristics and limitations.

Unicode was and is a milestone: A system designed to represent (nearly) all characters in all languages. Unfortunately, even Unicode is not a universal solution. It exists in several variants (UTF-8, UTF-16, UTF-32), with and without BOM, and with partially incompatible implementations.

HTML makes it even more complicated by distinguishing between internal encoding and external encoding.

The free and open-source PowerShell function ConvertEncoding, part of Set-OutlookSignatures, makes the powerful and also free and open-source library UTF.Unknown really easy to use.

ConvertEncoding enables reliable detection of encodings via BOMs, HTML metadata, and heuristic analysis, and converts content to other formats as needed. Even HTML files are correctly adjusted, including meta tags. This makes different encodings easy to manage.

## Interested in learning more or seeing our solution in action?
[Contact us](/contact/) or explore further on our [website](/). We look forward to connecting with you!