---
layout: "page"
lang: "en"
locale: "en"
title: "Features and feature comparison"
subtitle: "Our solution at a glance and in benchmark"
description: "Compare features and benefits of our solution at a glance with clear benchmarks for informed decisions."
hero_link: "#features"
hero_link_text: "<span><b>Features: </b>What our solution is able to do</span>"
hero_link_style: |
  style="background-color: LawnGreen;"
hero_link2: "#feature-comparison"
hero_link2_text: "<span><b>Feature comparison </b>with competitors</span>"
hero_link2_style: |
  style="background-color: LawnGreen;"
hero_link3: "/quickstart"
hero_link3_text: "<span><b>Quick Start Guide: </b>Deploy signatures within minutes</span>"
hero_link3_style: |
  style="background-color: LawnGreen;"
permalink: "/features"
redirect_from:
  - "/features/"
sitemap_priority: 0.9
sitemap_changefreq: weekly
---
## Overview {#overview}

Set-OutlookSignatures is the most advanced, secure and versatile free and open-source tool for managing email signatures and out-of-office replies. The optional [Benefactor Circle add-on](/benefactorcircle) unlocks even more powerful features tailored for business environments.

It delivers everything you'd expect from a modern solution: Centralized management, seamless deployment, and full control across all Outlook editions on all platforms: Classic and New, Android, iOS, Linux, macOS, Web, Windows.

Thanks to its forward-thinking architecture, designed not around a commercial business model but around practical utility, data privacy, and digital sovereignty, it offers unique capabilities that set it apart.

For a quick overview, check our <a href="#feature-comparison">feature comparison with competitors</a>. If you want to know exactly what is possible, or if you are looking for inspiration for new use cases, you can find the complete list of features here. Warning: It's long!


## Features {#features}
With Set-OutlookSignatures and the optional Benefactor Circle add-on, signatures and out-of-office replies can be:
- Generated from **[templates in DOCX or HTML](/details#signature-and-oof-template-file-format)** file format.
- Customized with a **[broad range of variables](/details#replacement-variables)**, including **[photos and images](/details#photos-account-pictures-user-image-from-active-directory-or-entra-id)**, from Entra ID, Active Directory and other sources.
- Variables are available for the **[currently logged-on user, the current mailbox, and their managers](/details#replacement-variables)**.
- Designed for **[barrier-free accessibility](/blog/2025/12/03/barrier-free-email-signatures-and-out-of-office-replies)** with custom link and image descriptions for screen readers and comparable tools.
- Applied to all **mailboxes (including [shared mailboxes](/benefactorcircle#key-features)¹)**, specific **[mailbox groups](/details#template-tags-and-ini-files)**, specific **[email addresses](/details#template-tags-and-ini-files)** (including alias and secondary addresses), or specific **[user and mailbox properties](/details#template-tags-and-ini-files)**, for **every mailbox across all Outlook profiles (Outlook, [New Outlook](/benefactorcircle#key-features)¹, [Outlook on the web](/benefactorcircle#key-features)¹)**, including **[automapped and additional mailboxes](/parameters#signaturesforautomappedandadditionalmailboxes)**¹.
- Created with different names from the same template, **[one template can be used for many mailboxes](/details#how-to-work-with-ini-files)**.
- Assigned **[time ranges](/details#allowed-tags)**¹ within which they are valid.
- Set as **[default signature](/details#allowed-tags)** for new emails, or for replies and forwards (signatures only).
- Set as **[default OOF message](/details#allowed-tags)**¹ for internal or external recipients (OOF messages only).
- Set in **[Outlook on the web](/parameters#setcurrentuseroutlookwebsignature)**¹ for the currently logged-in user, including mirroring signatures to the cloud as **[roaming signatures](/parameters#mirrorcloudsignatures)**¹ (Linux/macOS/Windows, Classic and New Outlook¹).
- Signature can be centrally managed only¹, or **[exist along user-created signatures](/parameters#deleteusercreatedsignatures)**.
- Automatically added to new emails, reply emails and appointments with the **[Outlook add-in](/outlookaddin)**¹.
- Copied to an **[additional path](/parameters#additionalsignaturepath)**¹ for easy access to signatures on mobile devices or for use with email clients and apps besides Outlook: Apple Mail, Google Gmail, Samsung Mail, Mozilla Thunderbird, GNOME Evolution, KDE KMail, and others.
- Create an **[email draft containing all available signatures](/parameters#signaturecollectionindrafts)** in HTML and plain text for easy access in mail clients that do not have a signatures API.
- **[Write protected](/details#allowed-tags)** (Outlook on Windows signatures only).

Set-OutlookSignatures can be **[run by users on Windows, Linux and macOS clients, including shared devices and terminal servers - or on a central system with a service account](/details#architecture-considerations)**¹.<br>On clients, it can run as part of the logon script, as scheduled task, or on user demand via a desktop icon, start menu entry, shortcut or any other way of starting a program - **[whatever your software deployment mechanism allows](/faq#how-do-i-start-the-software-from-the-command-line-or-a-scheduled-task)**.

**[Sample templates](/quickstart#customize-use-your-own-templates)** for signatures and OOF messages demonstrate many features and are provided as .docx and .htm files.

**[Phone numbers](/faq#format-phone-numbers)** and **[postal addresses](/faq#format-postal-addresses)** can be formatted by international standards or custom requirements.

**[Simulation mode](/details#simulation-mode)** allows content creators and admins to simulate the behavior of the software for a specific user at a specific point in time, and to inspect the resulting signature files before going live.

**[SimulateAndDeploy](/details#creating-signatures-and-out-of-office-replies)**¹ allows to deploy signatures and out-of-office replies **[without any client deployment or end user interaction](/details#creating-signatures-and-out-of-office-replies)**. Signatures are saved to the mailbox as roaming signatures (Exchange Online mailboxes only) and are also made available for the [Outlook add-in](/outlookaddin) (all Exchange mailboxes).

It works **[on premises, in hybrid and in cloud-only environments](/details#hybrid-and-cloud-only-support)**. The software is **[designed to work in big and complex environments](/implementationapproach)**: Exchange resource forest scenarios, AD trusts, multi-level AD subdomains, cross-tenant and multitenant scenarios.  

All **[national clouds are supported](/parameters#cloudenvironment)**: Public (AzurePublic), US Government L4 (AzureUSGovernment), US Government L5 (AzureUSGovernment DoD), China (AzureChinaCloud operated by 21Vianet) - sovereign clouds Bleu, Delos, GovSG, and more coming soon.

It is **[multi-instance capable](/faq#can-multiple-script-instances-run-in-parallel)** by using different template paths, configuration files and script parameters.

Set-OutlookSignatures requires **[no installation on servers or clients](/faq#how-do-i-start-the-software-from-the-command-line-or-a-scheduled-task)**. You only need a standard SMB file share on a central system, and optionally Office on your clients.

There is also **[no telemetry](/features#feature-comparison)** and no "calling home". Emails and directory data are **[not routed through a 3rd party data center or cloud service](/features#feature-comparison)**, and **[DNS records (SPF) and mail flow remain unchanged](/features#feature-comparison)**.

A **[documented implementation approach](/implementationapproach)**, based on real life experiences implementing the software in multi-client environments with a five-digit number of mailboxes, contains proven procedures and recommendations for product managers, architects, operations managers, account managers and email and client administrators.

The software core is **[Free and Open-Source Software (FOSS)](/faq#why-the-tagline)**. It is published under the European Union Public License, which is approved, among others, by the Free Software Foundation (FSF) and the Open Source Initiative (OSI), and is compatible with the General Public License (GPL) and other popular licenses.

After a certain period of use, the **[subtle note 'Free and open-source Set-OutlookSignatures' is appended to signatures](/faq#how-to-disable-the-tagline-in-signatures)**. This tagline can be easily removed¹.

**Remark 1 (¹):** **Some features are exclusive to the <a href="/benefactorcircle">Benefactor Circle add-on</a>.** The optional <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a> extends Set-OutlookSignatures with powerful enterprise features, prioritized support, and direct access to new capabilities. It also ensures that the core of Set-OutlookSignatures can remain Free and Open-Source Software (FOSS) and continues to evolve.


## Feature comparison {#feature-comparison}

<div style="display: grid;">
    <div class="table-container">
        <table class="table is-bordered is-striped is-hoverable">
            <thead>
                <tr>
                    <th class="has-text-weight-bold is-nowrap" style="min-width: 10em; white-space: nowrap;"></th>
                    <th class="has-text-weight-bold" style="min-width: 10em; white-space: nowrap;">Set-OutlookSignatures with<br><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></th>
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
                    <td class="has-text-weight-bold">Is hosted and runs in environments that you already trust and for which you have
                        established security and management structures</td>
                    <td>🟢</td>
                    <td>🔴</td>
                    <td>🔴</td>
                    <td>🔴</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Entra ID and Active Directory permissions</td>
                    <td>🟢 User (delegated) permissions, least privilege principle, clearly documented and justified</td>
                    <td>🔴 Application permissions, transfer all directory data, transfer all emails
                    </td>
                    <td>🔴 Application permissions, transfer all directory data, transfer all emails
                    </td>
                    <td>🔴 Application permissions, transfer all directory data, transfer all emails</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">Entra ID and Active Directory data stays in your environment (no transfer to 3rd
                        party datacenters)</td>
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
                    <td class="has-text-weight-bold">Supports Microsoft national clouds</td>
                    <td>🟢 Global/Public, US Government L4 (GCC, GCC High), US Government L5 (DOD),
                        China operated by 21Vianet - sovereign clouds Bleu, Delos, GovSG, and more coming soon</td>
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
                    <td class="has-text-weight-bold">Support for Microsoft roaming signatures (multiple signatures in Outlook on the web and
                        New Outlook)</td>
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
                    <td>🟢 To the free and open-source Set&#8209;OutlookSignatures project</td>
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
                    <td class="has-text-weight-bold">License cost for 100&nbsp;mailboxes, 1&nbsp;year</td>
                    <td>🟢 300&nbsp;€</td>
                    <td>🔴 ca. 1,600&nbsp;€</td>
                    <td>🟡 ca. 1,300&nbsp;€</td>
                    <td>🔴 ca. 1,600&nbsp;€</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">License cost for 250&nbsp;mailboxes, 1&nbsp;year</td>
                    <td>🟢 750&nbsp;€</td>
                    <td>🔴 ca. 4,000&nbsp;€</td>
                    <td>🟡 ca. 2,700&nbsp;€</td>
                    <td>🔴 ca. 3,600&nbsp;€</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">License cost for 500&nbsp;mailboxes, 1&nbsp;year</td>
                    <td>🟢 1,500&nbsp;€</td>
                    <td>🔴 ca. 8,000&nbsp;€</td>
                    <td>🟡 ca. 4,400&nbsp;€</td>
                    <td>🟡 ca. 6,200&nbsp;€</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">License cost for 1,000&nbsp;mailboxes, 1&nbsp;year</td>
                    <td>🟢 3,000&nbsp;€</td>
                    <td>🔴 ca. 15,700&nbsp;€</td>
                    <td>🟡 ca. 8,700&nbsp;€</td>
                    <td>🟡 ca. 10,500&nbsp;€</td>
                </tr>
                <tr>
                    <td class="has-text-weight-bold">License cost for 10,000&nbsp;mailboxes, 1&nbsp;year</td>
                    <td>🟢 30,000&nbsp;€</td>
                    <td>🔴 ca. 110,000&nbsp;€</td>
                    <td>🟡 ca. 65,000&nbsp;€</td>
                    <td>🟡 ca. 41,000&nbsp;€</td>
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