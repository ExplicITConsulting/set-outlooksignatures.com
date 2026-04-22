---
layout: "page"
lang: "en"
locale: "en"
title: "Features and feature comparison"
subtitle: "Our solution at a glance and in benchmark"
description: "Compare features and benefits of our solution at a glance with clear benchmarks for informed decisions."
hero_link: "#features"
hero_link_text: "<span><b>Features: </b>What our solution is able to do</span>"
hero_link_style:
hero_link2: "#feature-comparison"
hero_link2_text: "<span><b>Feature comparison </b>with competitors</span>"
hero_link2_style:
hero_link3: "/quickstart"
hero_link3_text: "<span><b>Quickstart: </b>Signatures in minutes</span>"
hero_link3_style:
permalink: "/features"
redirect_from:
  - "/features/"
sitemap_priority: 0.9
sitemap_changefreq: weekly
---
## Overview {#overview}
Set-OutlookSignatures is the most advanced, secure and versatile free and open-source tool for managing email signatures. The optional <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a> unlocks even more powerful features tailored for business environments.

It delivers everything you'd expect from a modern solution: Centralized management, seamless deployment, and full control across all Outlook editions on all platforms: Classic and New, Android, iOS, Linux, macOS, Web, Windows.

Thanks to its forward-thinking architecture, designed not around a commercial business model but around practical utility, data privacy, and digital sovereignty, it offers unique capabilities that set it apart.


## Features {#features}
With Set-OutlookSignatures and the optional <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a>, signatures and out-of-office replies can be:
<div class="columns is-multiline">
    <div class="column is-half-desktop is-half-tablet is-full-mobile">
        <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Blue;">
            <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
                <span>📝</span>
                <div>
                    <p><b>Design & Content</b></p>
                    <p class="mb-2"><b>Template Variety:</b> Generated from <a href="/details#signature-and-oof-template-file-format">templates in DOCX or HTML</a> file format.</p>
                    <p class="mb-2"><b>Rich Variables:</b> Customized with a <a href="/details#replacement-variables">broad range of variables</a>, including photos and images, from Entra ID, Active Directory and other sources.</p>
                    <p class="mb-2"><b>Data Scope:</b> Variables are available for the <a href="/details#replacement-variables">currently logged-on user, the current mailbox, and their managers</a>.</p>
                    <p class="mb-2"><b>Accessibility:</b> Designed for <a href="/blog/2025/12/03/barrier-free-email-signatures-and-out-of-office-replies">barrier-free accessibility</a> with custom link and image descriptions for screen readers and comparable tools.</p>
                    <p class="mb-2"><b>Standardized Formatting:</b> <a href="/faq#format-phone-numbers">Phone numbers</a> and <a href="/faq#format-postal-addresses">postal addresses</a> can be formatted by international standards or custom requirements.</p>
                    <p class="mb-2"><b>Templates Included:</b> <a href="/quickstart#customize">Sample templates</a> for signatures and OOF messages demonstrate many features and are provided as .docx and .htm files.</p>
                </div>
            </div>
        </div>
    </div>
    <div class="column is-half-desktop is-half-tablet is-full-mobile">
        <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid Yellow;">
            <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
                <span>🚀</span>
                <div>
                    <p><b>Deployment & Mailbox Support</b></p>
                    <p class="mb-2"><b>Targeting:</b> Applied to all mailboxes (including <a href="/benefactorcircle#key-features">shared mailboxes</a><a href="#remark-1" style="color: var(--benefactor-circle-color);"><sup>(1)</sup></a>), specific <a href="/details#ini-files-and-template-tags">mailbox groups</a>, specific <a href="/details#ini-files-and-template-tags">email addresses</a> (including alias and secondary addresses), or specific <a href="/details#ini-files-and-template-tags">user and mailbox properties</a>.</p>
                    <p class="mb-2"><b>Outlook Support:</b> Works for every mailbox across all Outlook profiles (<a href="/benefactorcircle#key-features">Outlook, New Outlook</a><a href="#remark-1" style="color: var(--benefactor-circle-color);"><sup>(1)</sup></a>, <a href="/benefactorcircle#key-features">Outlook for the web</a><a href="#remark-1" style="color: var(--benefactor-circle-color);"><sup>(1)</sup></a>), including <a href="/parameters#signaturesforautomappedandadditionalmailboxes">automapped and additional mailboxes</a><a href="#remark-1" style="color: var(--benefactor-circle-color);"><sup>(1)</sup></a>.</p>
                    <p class="mb-2"><b>Template Logic:</b> Created with different names from the same template; <a href="/details#how-to-work-with-ini-files">one template can be used for many mailboxes</a>.</p>
                    <p class="mb-2"><b>Scheduling:</b> Assigned <a href="/details#allowed-tags-common-cases">time ranges</a><a href="#remark-1" style="color: var(--benefactor-circle-color);"><sup>(1)</sup></a> within which they are valid.</p>
                    <p class="mb-2"><b>Defaults:</b> Set as <a href="/details#allowed-tags-common-cases">default signature</a> for new emails, replies, and forwards, or as <a href="/details#allowed-tags-common-cases">default OOF message</a><a href="#remark-1" style="color: var(--benefactor-circle-color);"><sup>(1)</sup></a> for internal/external recipients.</p>
                </div>
            </div>
        </div>
    </div>
    <div class="column is-full">
        <div class="box has-background-white-bis has-text-black" style="border-top: 4px solid LimeGreen;">
            <div style="display: flex; align-items: flex-start; gap: 0.75em;">
                <span>🛡️</span>
                <div>
                    <p><b>Platform, Architecture & Security</b></p>
                    <p class="mb-2"><b>Multi-Platform Sync:</b> Set signatures in <a href="/parameters#setcurrentuseroutlookwebsignature">Outlook Web</a><a href="#remark-1" style="color: var(--benefactor-circle-color);"><sup>(1)</sup></a> and mirror them as <a href="/parameters#mirrorcloudsignatures">roaming signatures</a><a href="#remark-1" style="color: var(--benefactor-circle-color);"><sup>(1)</sup></a> across Windows, macOS, and Linux.</p>
                    <p class="mb-2"><b>Flexible Execution:</b> Run via logon script, scheduled task, or as a <a href="/details#architecture-considerations">central service</a><a href="#remark-1" style="color: var(--benefactor-circle-color);"><sup>(1)</sup></a>—no client installation or end-user interaction required.</p>
                    <p class="mb-2"><b>Hybrid Support:</b> Works natively on-prem, hybrid, and in all M365 clouds (Public, GCC High, China, Bleu, etc.).</p>
                    <p class="mb-2"><b>Add-in & Mobile:</b> Integration for appointments via <a href="/outlookaddin">Outlook add-in</a><a href="#remark-1" style="color: var(--benefactor-circle-color);"><sup>(1)</sup></a> and access for mobile/third-party clients via <a href="/parameters#additionalsignaturepath">additional paths</a><a href="#remark-1" style="color: var(--benefactor-circle-color);"><sup>(1)</sup></a>.</p>
                    <p class="mb-2"><b>Zero-Touch Deployment:</b> <a href="/details#step-1-create-signatures-and-out-of-office-replies">SimulateAndDeploy</a><a href="#remark-1" style="color: var(--benefactor-circle-color);"><sup>(1)</sup></a> enables full automation without touching the end-user's device.</p>
                    <p class="mb-2"><b>Data Sovereignty:</b> No telemetry, no "calling home," and no 3rd party data routing; your DNS records and mail flow remain untouched.</p>
                    <p class="mb-2"><b>Enterprise Scaling:</b> <a href="/faq#can-multiple-script-instances-run-in-parallel">Multi-instance capable</a> and optimized for complex environments with 5-digit mailbox counts.</p>
                    <p class="mb-2"><b>Security & Testing:</b> Includes <a href="/details#simulation-mode">simulation mode</a> for safe testing and <a href="/details#allowed-tags-common-cases">write protection</a> for Outlook for Windows signatures.</p>
                    <p class="mb-2"><b>Open Source (FOSS):</b> Set-OutlookSignatures is licensed under the European Union Public License (EUPL). The core engine is peer-reviewable, ensuring transparency and digital sovereignty.</p>
                    <p class="mb-0"><b>Drafts API Fallback:</b> Supports clients without a signature API by creating <a href="/parameters#signaturecollectionindrafts">centralized HTML/Plain Text drafts</a><a href="#remark-1" style="color: var(--benefactor-circle-color);"><sup>(1)</sup></a>.</p>
                </div>
            </div>
        </div>
    </div>
</div>
<p>After a certain period of use, the <a href="/faq#how-to-disable-the-tagline-in-signatures">subtle note "Free and open-source Set-OutlookSignatures" is appended to signatures</a>. This tagline can be easily removed<a href="#remark-1" style="color: var(--benefactor-circle-color);"><sup>(1)</sup></a>.</p>


## Feature comparison {#feature-comparison}
### Pricing Benchmark {#pricing}
<p><strong>Set-OutlookSignatures is and will always be free.</strong> What began as a technology demonstrator is now the most secure and versatile open-source tool for managing email signatures. Learn more about <a href="/faq#why-the-tagline">the story behind the code</a>.</p>
<p>The <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a> unlocks advanced features — for <strong>just EUR 0.25 per mailbox/month</strong> (EUR 3.00 per year). Billed annually, no auto-renewal.</p>
<p><strong>The add-on is an investment that pays off from day one, certainly for you as well!</strong> Facts, not guesswork: Calculate your specific savings in just five minutes with our <a href="/benefactorcircle#financial-benefits">business case</a>.<br>
Thanks to its unique features and exclusive manufacturer availability, direct procurement in compliance with legal requirements is generally possible without a public tender.</p>
<div style="display: grid;">
    <div class="table-container">
        <table class="table is-bordered is-striped is-hoverable mx-auto">
            <thead>
                <tr>
                    <th class="has-text-weight-bold is-nowrap" style="min-width: 10em; white-space: nowrap;">Mailboxes (1 year)</th>
                    <th class="has-text-weight-bold" style="min-width: 10em; white-space: nowrap;">Set-OutlookSignatures with<br><a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a></th>
                    <th class="has-text-weight-bold is-nowrap" style="min-width: 10em; white-space: nowrap;">Competitor A</th>
                    <th class="has-text-weight-bold is-nowrap" style="min-width: 10em; white-space: nowrap;">Competitor B</th>
                    <th class="has-text-weight-bold is-nowrap" style="min-width: 10em; white-space: nowrap;">Competitor C</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="has-text-weight-bold">100 Mailboxes</td>
                    <td>🟢 <b>EUR 300</b></td>
                    <td>🔴 approx. EUR 1,600</td>
                    <td>🟡 approx. EUR 1,300</td>
                    <td>🔴 approx. EUR 1,600</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">250 Mailboxes</td>
                    <td>🟢 <b>EUR 750</b></td>
                    <td>🔴 approx. EUR 4,000</td>
                    <td>🟡 approx. EUR 2,700</td>
                    <td>🔴 approx. EUR 3,600</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">500 Mailboxes</td>
                    <td>🟢 <b>EUR 1,500</b></td>
                    <td>🔴 approx. EUR 8,000</td>
                    <td>🟡 approx. EUR 4,400</td>
                    <td>🟡 approx. EUR 6,200</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">1,000 Mailboxes</td>
                    <td>🟢 <b>EUR 3,000</b></td>
                    <td>🔴 approx. EUR 15,700</td>
                    <td>🟡 approx. EUR 8,700</td>
                    <td>🟡 approx. EUR 10,500</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">10,000 Mailboxes</td>
                    <td>🟢 <b>EUR 30,000</b></td>
                    <td>🔴 approx. EUR 110,000</td>
                    <td>🟡 approx. EUR 65,000</td>
                    <td>🟡 approx. EUR 41,000</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

### Detailed Comparison Benchmark {#detailed-benchmark}
<div style="display: grid;">
    <div class="table-container">
        <table class="table is-bordered is-striped is-hoverable mx-auto">
            <thead>
                <tr>
                    <th class="has-text-weight-bold is-nowrap" style="min-width: 10em; white-space: nowrap;"></th>
                    <th class="has-text-weight-bold" style="min-width: 10em; white-space: nowrap;">Set-OutlookSignatures with<br><a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a></th>
                    <th class="has-text-weight-bold is-nowrap" style="min-width: 10em; white-space: nowrap;">Competitor A</th>
                    <th class="has-text-weight-bold is-nowrap" style="min-width: 10em; white-space: nowrap;">Competitor B</th>
                    <th class="has-text-weight-bold is-nowrap" style="min-width: 10em; white-space: nowrap;">Competitor C</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="has-text-weight-bold" style="white-space: nowrap;">Free and Open-Source core</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Emails stay in your environment (no re-routing to 3rd party datacenters)</td>
                    <td>🟢</td>
                    <td>🟡 Optional, causes reduced feature set</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Is hosted and runs in environments that you already trust and for which you have established security and management structures</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Entra ID and Active Directory permissions</td>
                    <td>🟢 User (delegated) permissions, least privilege principle, clearly documented and justified</td>
                    <td>🔴 Application permissions, transfer all directory data, transfer all emails</td>
                    <td>🔴 Application permissions, transfer all directory data, transfer all emails</td>
                    <td>🔴 Application permissions, transfer all directory data, transfer all emails</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Entra ID and Active Directory data stays in your environment (no transfer to 3rd party datacenters)</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Does not require configuring Exchange adding a dependency to it</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Multiple independent instances can be run in the same environment</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">No telemetry or usage data collection, direct or indirect</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">No auto-renewing subscription</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">IT can delegate signature management, e.g. to marketing</td>
                    <td>🟢</td>
                    <td>🟢</td>
                    <td>🟡 Not at signature level</td>
                    <td>🟡 Not at signature level</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Apply signatures to all emails</td>
                    <td>🟡 Outlook clients only</td>
                    <td>🟢 With email re-routing to a 3rd party datacenter</td>
                    <td>🟢 With email re-routing to a 3rd party datacenter</td>
                    <td>🟢 With email re-routing to a 3rd party datacenter</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Apply signature based on recipients</td>
                    <td>🟡 Highly customizable, 10+ properties. Same signature for all recipients.</td>
                    <td>🟡 Internal, external, group membership, email address. Different signature for each recipient via email re-routing to a 3rd party datacenter.</td>
                    <td>🟡 Internal or external. Same signature for all recipients.</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Additional data sources besides Active Directory and Entra ID</td>
                    <td>🟢</td>
                    <td>🟡</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Supports on-prem and all M365 clouds (public, national, sovereign, hybrid)</td>
                    <td>🟢 Public, US Government (GCC, GCC High, DoD), China, sovereign clouds Bleu, Delos, GovSG, and more</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Supports cross-tenant access and multitenant organizations</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Support for Microsoft roaming signatures (multiple signatures in Outlook for the web and New Outlook)</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Number of templates</td>
                    <td>🟢 Unlimited</td>
                    <td>🔴 1, more charged extra</td>
                    <td>🟢 Unlimited</td>
                    <td>🟢 Unlimited</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Targeting and exclusion</td>
                    <td>🟢</td>
                    <td>🔴 Charged extra</td>
                    <td>🟢</td>
                    <td>🟢</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Scheduling</td>
                    <td>🟢</td>
                    <td>🔴 Charged extra</td>
                    <td>🟢</td>
                    <td>🟢</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Banners</td>
                    <td>🟢 Unlimited</td>
                    <td>🔴 1, more charged extra</td>
                    <td>🟢 Unlimited</td>
                    <td>🟢 Unlimited</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">QR codes and vCards</td>
                    <td>🟢</td>
                    <td>🔴 Charged extra</td>
                    <td>🔴 Charged extra</td>
                    <td>🟢</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Signature visible while writing</td>
                    <td>🟢</td>
                    <td>🟡</td>
                    <td>🟡</td>
                    <td>🟡</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Signature visible in Sent Items</td>
                    <td>🟢</td>
                    <td>🟡 Cloud mailboxes only</td>
                    <td>🟡 Cloud mailboxes only</td>
                    <td>🟡 Cloud mailboxes only</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Out-of-office reply messages</td>
                    <td>🟢</td>
                    <td>🔴 Charged extra</td>
                    <td>🟡 Same for internal and external senders</td>
                    <td>🔴 Charged extra</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">User-controlled email signatures</td>
                    <td>🟢</td>
                    <td>🟡</td>
                    <td>🟡</td>
                    <td>🟡</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Signatures for encrypted messages</td>
                    <td>🟢</td>
                    <td>🟡</td>
                    <td>🟡</td>
                    <td>🟡</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Signatures for delegates, shared, additional and automapped mailboxes</td>
                    <td>🟢</td>
                    <td>🟡 No mixing of sender and delegate replacement variables</td>
                    <td>🟡 No mixing of sender and delegate replacement variables</td>
                    <td>🟡 No mixing of sender and delegate replacement variables</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Outlook add-in</td>
                    <td>🟢 No on-prem mailboxes on Android and iOS. Highly customizable with rules, own code and runtime-generated signatures.</td>
                    <td>🟡 No on-prem mailboxes on Android and iOS, not for appointments</td>
                    <td>🟡 No on-prem mailboxes on Android and iOS, not for appointments</td>
                    <td>🔴 No on-prem mailboxes</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Support pricing model</td>
                    <td>🟢 Charged per support hour</td>
                    <td>🔴 Charged if used or not</td>
                    <td>🔴 Charged if used or not</td>
                    <td>🔴 Charged if used or not</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Software escrow</td>
                    <td>🟢 To the free and open-source Set-OutlookSignatures project</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Phone number formatting</td>
                    <td>🟢 E164, international, national, RFC3966, regex, custom</td>
                    <td>🟡 Regex</td>
                    <td>🔴</td>
                    <td>🟡 RegEx</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Postal address formatting</td>
                    <td>🟢 Templates for more than 200 countries/regions, custom</td>
                    <td>🟡 Regex</td>
                    <td>🔴</td>
                    <td>🟡 RegEx</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Direct procurement without public tender</td>
                    <td>🟢 Unique features, exclusive manufacturer availablity</td>
                    <td>🔴 No unique features, no exclusive manufacturer availablity</td>
                    <td>🔴 No unique features, no exclusive manufacturer availablity</td>
                    <td>🔴 No unique features, no exclusive manufacturer availablity</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>


<p id="remark-1" class="mt-6 is-italic has-text-centered">
    <span style="color: var(--benefactor-circle-color);"><sup>(1)</sup></span> Some features are exclusive to the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a>.
</p>


<p class="is-italic has-text-centered">
  The <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle</span></a> license funds the open-source mission, ensuring the core engine remains free and peer-reviewable for the global community.
</p>