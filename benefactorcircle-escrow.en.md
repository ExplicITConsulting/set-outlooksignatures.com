---
layout: "page"
lang: "en"
locale: "en"
title: "Benefactor Circle add-on Software Escrow and Project Stewardship"
subtitle: "Public Software Fallback Framework for the Benefactor Circle add-on"
description: "Official continuity guarantees, technical deposit models, and stewardship covenants for the Set-OutlookSignatures Benefactor Circle add-on."
hero_link: "#governance-resource-index"
hero_link_text: "<span><b>Review Framework Documents</b></span>"
hero_link_style: |
  style="color: black; background-image: linear-gradient(160deg, darkgoldenrod, goldenrod, palegoldenrod, goldenrod, darkgoldenrod);"
hero_link2: "https://github.com/Set-OutlookSignatures/benefactor-circle-add-on-proof-of-escrow"
hero_link2_text: "<span><b>View Public Proof Repository</b></span>"
hero_link2_style: |
  style="color: black; background-image: linear-gradient(160deg, darkgoldenrod, goldenrod, palegoldenrod, goldenrod, darkgoldenrod);"
image:
  path: "/assets/images/set-outlooksignatures benefactor circle opengraph1200x630.png"
  width: 1200
  height: 630
  alt: "Set-OutlookSignatures Benefactor Circle"
hide_gh_sponsor: true
permalink: "/benefactorcircle-escrow"
redirect_from:
  - /benefactorcircle-escrow/
sitemap_priority: 0.8
sitemap_changefreq: weekly
---

## Public Software Fallback and Stewardship Framework

**Ensuring the operational continuity of the Set-OutlookSignatures Benefactor Circle add-on.**

ExplicIT Consulting GmbH acknowledges the structural importance of the open source [Set-OutlookSignatures](https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/, https://set-outlooksignatures.com) project. To guarantee the technical and organizational durability of the commercial Benefactor Circle add-on, we have established a public stewardship framework. This proposal details the mechanism used to maintain fallback safety for both project administrators and enterprise subscribers.

## Framework Overview

This initiative is structured as a public unilateral covenant. It provides direct protections that the project community and administrators can rely upon. Under this framework, the underlying source code, build configuration, and documentation will transition to the Open Source Project Administrators if specific trigger events occur.

### Core Technical Pillars

- **Release Synchronized Deposits:** A complete Deposit Package is updated within ten business days after every production release of the add-on.
- **Cryptographic Proofs:** Each deposit archive has its SHA-256 hash calculated. The hash, along with a manifest file and a hash verification file, is published directly to the [Public Proof Repository](https://github.com/Set-OutlookSignatures/benefactor-circle-add-on-proof-of-escrow).
- **Quarterly Verification Rights:** Project Administrators maintain the right to view a technical demonstration every calendar quarter, or after any repository update, to verify that the secret repository exists, is accessible, and builds a fully operational product.

### Scope of the Deposit Package

As specified in the technical architecture documentation, the escrow deposit is strictly categorized to balance proprietary security with operational continuity.

- **Included Materials:** This includes the full source code of the add-on, compilation instructions, dependency manifests (SBOM), configuration schema definitions, validation tests, and architecture notes.
- **Excluded Materials:** This explicitly excludes user or customer databases, active credentials or passwords, private keys and certificates, and private corporate financial data.

## Trigger Conditions and Transition Process

The code transition process is governed by strict verification protocols to prevent unauthorized exposure of intellectual property.

### Authorized Trigger Events

A transition can only be initiated under two conditions:

1. Express written discontinuation or withdrawal of product maintenance by ExplicIT Consulting GmbH without an appointed successor.
2. Definitive business continuity failures, such as corporate dissolution, removal from the commercial register, or a product transfer where the new entity fails to adopt these covenant obligations in writing.

### Verification Timeline

Except for cases of immediate effect via express cancellation, a standard waiting period of 90 calendar days applies. Project Administrators must submit a formal trigger notice to the proof repository. If the notice is not disputed with substantiated reasons within 90 days, the trigger becomes legally effective.

### Code Autonomy and Open Source Rights

Upon an effective trigger, ExplicIT Consulting GmbH grants the project a worldwide, royalty-free, perpetual, irrevocable, and non-exclusive license to the code package. The Project Administrators hold the authority to maintain the product privately or to release it publicly under a recognized open source software license.

## Governance Resource Index {#governance-resource-index}

The framework relies on standardized documents maintained in the [Proof Repository](https://github.com/Set-OutlookSignatures/benefactor-circle-add-on-proof-of-escrow) to manage transparency and succession:

- **Covenant:** The legal foundation defining rights, scopes, and liabilities.
- **Technical Spec:** The engineering definitions outlining how deposits are built and how quarterly system demonstrations are conducted.
- **Successor Assumption:** The documentation used by an acquiring entity to adopt these continuity commitments without initiating a trigger.
- **Trigger Notice:** The formal assertion document utilized by Project Administrators to log an active continuity claim.
