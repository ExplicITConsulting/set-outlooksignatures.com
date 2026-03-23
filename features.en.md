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
### 📝 Design & Content
* **Template Variety:** Generated from **[templates in DOCX or HTML](/details#signature-and-oof-template-file-format)** file format.
* **Rich Variables:** Customized with a **[broad range of variables](/details#replacement-variables)**, including **[photos and images](/details#photos-account-pictures-user-image-from-active-directory-or-entra-id)**, from Entra ID, Active Directory and other sources.
* **Data Scope:** Variables are available for the **[currently logged-on user, the current mailbox, and their managers](/details#replacement-variables)**.
* **Accessibility:** Designed for **[barrier-free accessibility](/blog/2025/12/03/barrier-free-email-signatures-and-out-of-office-replies)** with custom link and image descriptions for screen readers and comparable tools.
* **Standardized Formatting:** **[Phone numbers](/faq#format-phone-numbers)** and **[postal addresses](/faq#format-postal-addresses)** can be formatted by international standards or custom requirements.
* **Templates Included:** **[Sample templates](/quickstart#customize)** for signatures and OOF messages demonstrate many features and are provided as .docx and .htm files.

### 🚀 Deployment & Mailbox Support
* **Targeting:** Applied to all **mailboxes (including [shared mailboxes](/benefactorcircle#key-features)<a href="#remark-1">¹</a>)**, specific **[mailbox groups](/details#template-tags-and-ini-files)**, specific **[email addresses](/details#template-tags-and-ini-files)** (including alias and secondary addresses), or specific **[user and mailbox properties](/details#template-tags-and-ini-files)**.
* **Outlook Support:** Works for **every mailbox across all Outlook profiles (Outlook, [New Outlook](/benefactorcircle#key-features)<a href="#remark-1">¹</a>, [Outlook on the web](/benefactorcircle#key-features)<a href="#remark-1">¹</a>)**, including **[automapped and additional mailboxes](/parameters#signaturesforautomappedandadditionalmailboxes)**<a href="#remark-1">¹</a>.
* **Template Logic:** Created with different names from the same template; **[one template can be used for many mailboxes](/details#how-to-work-with-ini-files)**.
* **Scheduling:** Assigned **[time ranges](/details#allowed-tags)**<a href="#remark-1">¹</a> within which they are valid.
* **Defaults:** Set as **[default signature](/details#allowed-tags)** for new emails, replies, and forwards, or as **[default OOF message](/details#allowed-tags)**<a href="#remark-1">¹</a> for internal/external recipients.

### 💻 Platform & Execution
* **Cloud Mirroring:** Set in **[Outlook on the web](/parameters#setcurrentuseroutlookwebsignature)**<a href="#remark-1">¹</a> for the currently logged-in user, including mirroring signatures to the cloud as **[roaming signatures](/parameters#mirrorcloudsignatures)**<a href="#remark-1">¹</a> (Linux/macOS/Windows, Classic and New Outlook<a href="#remark-1">¹</a>).
* **User Control:** Signatures can be centrally managed only<a href="#remark-1">¹</a>, or **[exist along user-created signatures](/parameters#deleteusercreatedsignatures)**.
* **Add-in Integration:** Automatically added to new emails, reply emails and appointments with the **[Outlook add-in](/outlookaddin)**<a href="#remark-1">¹</a>.
* **Mobile & Third-Party:** Copied to an **[additional path](/parameters#additionalsignaturepath)**<a href="#remark-1">¹</a> for easy access on mobile devices or use with Apple Mail, Google Gmail, Samsung Mail, Mozilla Thunderbird, GNOME Evolution, KDE KMail, and others.
* **Drafts API Fallback:** Create an **[email draft containing all available signatures](/parameters#signaturecollectionindrafts)**<a href="#remark-1">¹</a> in HTML and plain text for mail clients without a signatures API.
* **Security:** **[Write protected](/details#allowed-tags)** (Outlook on Windows signatures only).

### 🛡️ Architecture & Infrastructure
* **Execution Flexibility:** **[Run by users on Windows, Linux and macOS clients (including shared devices/terminal servers) — or on a central system with a service account](/details#architecture-considerations)**<a href="#remark-1">¹</a>.
* **Deployment Versatility:** Run via logon script, scheduled task, or user demand—**[whatever your software deployment mechanism allows](/faq#how-do-i-start-the-software-from-the-command-line-or-a-scheduled-task)**.
* **Testing:** **[Simulation mode](/details#simulation-mode)** allows content creators and admins to inspect resulting files before going live.
* **Zero-Touch:** **[SimulateAndDeploy](/details#creating-signatures-and-out-of-office-replies)**<a href="#remark-1">¹</a> allows deployment **[without any client deployment or end user interaction](/details#creating-signatures-and-out-of-office-replies)** (roaming signatures for Exchange Online).
* **Environment Support:** Works **[on-prem, hybrid, and cloud-only](/details#hybrid-and-cloud-only-support)**; designed for **[big and complex environments](/implementationapproach)** (AD trusts, multi-level subdomains, cross-tenant/multitenant).
* **Global Clouds:** All **[public, national, and sovereign clouds are supported](/parameters#cloudenvironment)**: Public, US Gov (GCC, GCC High, DoD), China, Bleu, Delos, GovSG, and more.
* **No Installation:** Requires **no installation on servers or clients**; only a standard SMB file share and optionally Office on clients.
* **Data Sovereignty:** **No telemetry**, no "calling home", and data is **not routed through 3rd party data centers**; **DNS records (SPF) and mail flow remain unchanged**.
* **Enterprise Scaling:** **[Multi-instance capable](/faq#can-multiple-script-instances-run-in-parallel)** and includes a **[documented implementation approach](/implementationapproach)** for 5-digit mailbox counts.
* **Open Source:** **[Free and Open-Source (FOSS)](/faq#why-the-tagline)** under the European Union Public License (EUPL). After a certain period, a tagline is appended which can be easily removed<a href="#remark-1">¹</a>.


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
    ¹ Some features are exclusive to the <a href="/benefactorcircle"><span style="font-weight: bold; color: var<p>(--benefactor-circle-color);">Benefactor Circle add-on</span></a>.
</p>


<p class="is-italic has-text-centered">
  The <a href="https://set-outlooksignatures.com/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle</span></a> license funds the open-source mission, ensuring the core engine remains free and peer-reviewable for the global community.
</p>