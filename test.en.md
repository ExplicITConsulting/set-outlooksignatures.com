---
layout: "page"
lang: "en"
locale: "en"
title: "Link check test: Maximum Stress"
subtitle: "The ultimate edge-case library for crawler validation"
description: "Comprehensive battery of links including Punycode, deep nesting, and obfuscated paths."
permalink: "/test"
---

<head>
    <link rel="canonical" href="https://explicitconsulting.at/test">
    <link rel="alternate" hreflang="de" href="https://explicitconsulting.at/de/test">
    <meta property="og:image" content="https://set-outlooksignatures.com/og-preview.png">
</head>

<section id="top">
    <h2>1. Fragments, Spaces & Encoding</h2>
    <ul>
        <li><a href="#Section%20With%20Spaces">Valid: Encoded Space (%20)</a></li>
        <li><a href="#Section With Spaces">Valid: Raw Space (Stress Test)</a></li>
        <li><a href="#special-chars-@!$*">Valid: Special Characters</a></li>
        <li><a href="#top">Valid: The 'Top' Alias</a></li>
        <li><a href="#does-not-exist">Invalid: 404 Anchor</a></li>
    </ul>
</section>

<hr>

<h2>2. External Domain & Resource Matrix</h2>
<table border="1" style="width:100%; border-collapse: collapse;">
    <thead>
        <tr>
            <th>Category</th>
            <th>set-outlooksignatures.com</th>
            <th>explicitconsulting.at</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><strong>Standard Nav</strong></td>
            <td><a href="https://set-outlooksignatures.com/features">Features</a></td>
            <td><a href="https://explicitconsulting.at/legal">Legal</a></td>
        </tr>
        <tr>
            <td><strong>Lazy Loading</strong></td>
            <td><img data-src="https://set-outlooksignatures.com/lazy.jpg" alt="Lazy"></td>
            <td><img data-srcset="https://explicitconsulting.at/img1.jpg 1x, https://explicitconsulting.at/img2.jpg 2x"></td>
        </tr>
        <tr>
            <td><strong>Functional</strong></td>
            <td><form action="https://set-outlooksignatures.com/api/send"></form></td>
            <td><video poster="https://explicitconsulting.at/poster.jpg"></video></td>
        </tr>
    </tbody>
</table>

<hr>

<h2>3. Obfuscation & Edge Cases</h2>
<ul>
    <li><a href="https://xn--exmple-cua.com">Punycode (exämple.com)</a></li>
    <li><a href="hTTpS://explicitconsulting.at/legal">Mixed-Case Protocol (hTTpS)</a></li>
    <li><a href="//set-outlooksignatures.com/features">Protocol-Relative (//)</a></li>
    <li><a href="https://explicitconsulting.at:8443/legal">Custom Port (8443)</a></li>
    <li><a href="https://example.com/404-path">Non-existing Path (example.com)</a></li>
    <li><blockquote cite="https://example.com/source">Citation Link</blockquote></li>
</ul>

<hr>

<h2>4. Hidden & Inline Links</h2>
<svg width="100" height="100">
    <a href="https://explicitconsulting.at/svg-target">
        <circle cx="50" cy="50" r="40" fill="red" />
    </a>
</svg>

<div style="background: url('https://set-outlooksignatures.com/bg-test.jpg');">Inline CSS Link</div>

<div data-href="https://explicitconsulting.at/js-link">Clickable Data-Href</div>

<div style="margin-top: 2000px;">
    <h3 id="Section With Spaces">Target: Section With Spaces</h3>
    <h3 id="special-chars-@!$*">Target: Special Characters</h3>
</div>