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
Set-OutlookSignatures is the most advanced, secure and versatile free and open-source tool for managing email signatures. The optional [Benefactor Circle add-on](/benefactorcircle) unlocks even more powerful features tailored for business environments.

It delivers everything you'd expect from a modern solution: Centralized management, seamless deployment, and full control across all Outlook editions on all platforms: Classic and New, Android, iOS, Linux, macOS, Web, Windows.

Thanks to its forward-thinking architecture, designed not around a commercial business model but around practical utility, data privacy, and digital sovereignty, it offers unique capabilities that set it apart.


## Features {#features}
With Set-OutlookSignatures and the optional Benefactor Circle add-on, signatures and out-of-office replies can be:
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #3273dc;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>📝</span>
        <div>
          <p><b>Design & Content</b></p>
          <ul>
            <li><b>Template Variety:</b> Generated from <a href="/details#signature-and-oof-template-file-format">templates in DOCX or HTML</a> file format.</li>
            <li><b>Rich Variables:</b> Customized with a <a href="/details#replacement-variables">broad range of variables</a>, including <a href="/details#photos-account-pictures-user-image-from-active-directory-or-entra-id">photos and images</a>, from Entra ID, Active Directory and other sources.</li>
            <li><b>Data Scope:</b> Variables are available for the <a href="/details#replacement-variables">currently logged-on user, the current mailbox, and their managers</a>.</li>
            <li><b>Accessibility:</b> Designed for <a href="/blog/2025/12/03/barrier-free-email-signatures-and-out-of-office-replies">barrier-free accessibility</a> with custom link and image descriptions for screen readers and comparable tools.</li>
            <li><b>Standardized Formatting:</b> <a href="/faq#format-phone-numbers">Phone numbers</a> and <a href="/faq#format-postal-addresses">postal addresses</a> can be formatted by international standards or custom requirements.</li>
            <li><b>Templates Included:</b> <a href="/quickstart#customize">Sample templates</a> for signatures and OOF messages demonstrate many features and are provided as .docx and .htm files.</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #3273dc;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🚀</span>
        <div>
          <p><b>Deployment & Mailbox Support</b></p>
          <ul>
            <li><b>Targeting:</b> Applied to all mailboxes (including <a href="/benefactorcircle#key-features">shared mailboxes</a><a href="#remark-1">¹</a>), specific <a href="/details#template-tags-and-ini-files">mailbox groups</a>, specific <a href="/details#template-tags-and-ini-files">email addresses</a> (including alias and secondary addresses), or specific <a href="/details#template-tags-and-ini-files">user and mailbox properties</a>.</li>
            <li><b>Outlook Support:</b> Works for every mailbox across all Outlook profiles (<a href="/benefactorcircle#key-features">Outlook, New Outlook</a><a href="#remark-1">¹</a>, <a href="/benefactorcircle#key-features">Outlook on the web</a><a href="#remark-1">¹</a>), including <a href="/parameters#signaturesforautomappedandadditionalmailboxes">automapped and additional mailboxes</a><a href="#remark-1">¹</a>.</li>
            <li><b>Template Logic:</b> Created with different names from the same template; <a href="/details#how-to-work-with-ini-files">one template can be used for many mailboxes</a>.</li>
            <li><b>Scheduling:</b> Assigned <a href="/details#allowed-tags">time ranges</a><a href="#remark-1">¹</a> within which they are valid.</li>
            <li><b>Defaults:</b> Set as <a href="/details#allowed-tags">default signature</a> for new emails, replies, and forwards, or as <a href="/details#allowed-tags">default OOF message</a><a href="#remark-1">¹</a> for internal/external recipients.</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>
<div class="columns is-multiline">
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #3273dc;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>💻</span>
        <div>
          <p><b>Platform & Execution</b></p>
          <ul>
            <li><b>Cloud Mirroring:</b> Set in <a href="/parameters#setcurrentuseroutlookwebsignature">Outlook on the web</a><a href="#remark-1">¹</a> for the currently logged-in user, including mirroring signatures to the cloud as <a href="/parameters#mirrorcloudsignatures">roaming signatures</a><a href="#remark-1">¹</a> (Linux/macOS/Windows, Classic and New Outlook<a href="#remark-1">¹</a>).</li>
            <li><b>User Control:</b> Signatures can be centrally managed only<a href="#remark-1">¹</a>, or <a href="/parameters#deleteusercreatedsignatures">exist along user-created signatures</a>.</li>
            <li><b>Add-in Integration:</b> Automatically added to new emails, reply emails and appointments with the <a href="/outlookaddin">Outlook add-in</a><a href="#remark-1">¹</a>.</li>
            <li><b>Mobile & Third-Party:</b> Copied to an <a href="/parameters#additionalsignaturepath">additional path</a><a href="#remark-1">¹</a> for easy access on mobile devices or use with Apple Mail, Google Gmail, Samsung Mail, Mozilla Thunderbird, GNOME Evolution, KDE KMail, and others.</li>
            <li><b>Drafts API Fallback:</b> Create an <a href="/parameters#signaturecollectionindrafts">email draft containing all available signatures</a><a href="#remark-1">¹</a> in HTML and plain text for mail clients without a signatures API.</li>
            <li><b>Security:</b> <a href="/details#allowed-tags">Write protected</a> (Outlook on Windows signatures only).</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
  <div class="column is-half-desktop is-half-tablet is-full-mobile">
    <div class="box has-background-white-bis has-text-black" style="height: 100%; border-top: 4px solid #3273dc;">
      <div class="cell" style="display: flex; align-items: flex-start; gap: 0.5em;">
        <span>🛡️</span>
        <div>
          <p><b>Architecture & Infrastructure</b></p>
          <ul>
            <li><b>Execution Flexibility:</b> <a href="/details#architecture-considerations">Run by users on Windows, Linux and macOS clients (including shared devices/terminal servers) — or on a central system with a service account</a><a href="#remark-1">¹</a>.</li>
            <li><b>Deployment Versatility:</b> Run via logon script, scheduled task, or user demand—<a href="/faq#how-do-i-start-the-software-from-the-command-line-or-a-scheduled-task">whatever your software deployment mechanism allows</a>.</li>
            <li><b>Testing:</b> <a href="/details#simulation-mode">Simulation mode</a> allows content creators and admins to inspect resulting files before going live.</li>
            <li><b>Zero-Touch:</b> <a href="/details#creating-signatures-and-out-of-office-replies">SimulateAndDeploy</a><a href="#remark-1">¹</a> allows deployment <a href="/details#creating-signatures-and-out-of-office-replies">without any client deployment or end user interaction</a> (roaming signatures for Exchange Online).</li>
            <li><b>Environment Support:</b> Works <a href="/details#hybrid-and-cloud-only-support">on-prem, hybrid, and cloud-only</a>; designed for <a href="/implementationapproach">big and complex environments</a> (AD trusts, multi-level subdomains, cross-tenant/multitenant).</li>
            <li><b>Global Clouds:</b> All <a href="/parameters#cloudenvironment">public, national, and sovereign clouds are supported</a>: Public, US Gov (GCC, GCC High, DoD), China, Bleu, Delos, GovSG, and more.</li>
            <li><b>No Installation:</b> Requires no installation on servers or clients; only a standard SMB file share and optionally Office on clients.</li>
            <li><b>Data Sovereignty:</b> No telemetry, no "calling home", and data is not routed through 3rd party data centers; DNS records (SPF) and mail flow remain unchanged.</li>
            <li><b>Enterprise Scaling:</b> <a href="/faq#can-multiple-script-instances-run-in-parallel">Multi-instance capable</a> and includes a <a href="/implementationapproach">documented implementation approach</a> for 5-digit mailbox counts.</li>
            <li><b>Open Source:</b> <a href="/faq#why-the-tagline">Free and Open-Source (FOSS)</a> under the European Union Public License (EUPL). After a certain period, a tagline is appended which can be easily removed<a href="#remark-1">¹</a>.</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>


## Feature comparison {#feature-comparison}
### Pricing Benchmark {#pricing}
<div style="display: grid;">
    <div class="table-container">
        <table class="table is-bordered is-striped is-hoverable">
            <thead>
                <tr>
                    <th class="has-text-weight-bold is-nowrap" style="min-width: 10em; white-space: nowrap;">Mailboxes (1 Year)</th>
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
        <table class="table is-bordered is-striped is-hoverable">
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
                    <td class="has-text-weight-bold">Support for Microsoft roaming signatures (multiple signatures in Outlook on the web and New Outlook)</td>
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
    ¹ Some features are exclusive to the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a>.
</p>


<p class="is-italic has-text-centered">
  The <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle</span></a> license funds the open-source mission, ensuring the core engine remains free and peer-reviewable for the global community.
</p>