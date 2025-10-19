---
layout: page
title: Features and feature comparison
subtitle: Our solution at a glance and in benchmark
description: Features and feature comparison. Our solution at a glance and in benchmark.
hero_link: "#features"
hero_link_text: "<span><b>Features: </b>What our solution is able to do</span>"
hero_link_style: |
  style="background-color: LimeGreen;"
hero_link2: "#feature-comparison"
hero_link2_text: "<span><b>Feature comparison </b>with peers</span>"
hero_link2_style: |
  style="background-color: LimeGreen;"
hero_link3: "/quickstart"
hero_link3_text: "<span><b>Quick Start Guide: </b>Deploy signatures within minutes</span>"
hero_link3_style: |
  style="background-color: LimeGreen;"
image:
  path: "/assets/images/set-outlooksignatures benefactor circle opengraph1200x630.png"
  height: 1200
  width: 630
  alt: "Set-OutlookSignatures Benefactor Circle"
page_id: "features"
permalink: /features/
---
## Features {#features}
With Set-OutlookSignatures, signatures and out-of-office replies can be:
- Generated from **templates in DOCX or HTML** file format.
- Customized with a **broad range of variables**, including **photos and images**, from Entra ID, Active Directory and other sources.
- Variables are available for the **currently logged-on user, the current mailbox, and their managers**.
- Designed for **barrier-free accessibility** with custom link and image descriptions for screen readers and comparable tools.
- Applied to all **mailboxes (including shared mailboxes¹)**, specific **mailbox groups**, specific **email addresses** (including alias and secondary addresses), or specific **user or mailbox properties**, for **every mailbox across all Outlook profiles (Outlook, New Outlook¹, Outlook Web¹)**, including **automapped and additional mailboxes**¹.
- Created with different names from the same template, **one template can be used for many mailboxes**.
- Assigned **time ranges** within which they are valid¹.
- Set as **default signature** for new emails, or for replies and forwards (signatures only).
- Set as **default OOF message** for internal or external recipients (OOF messages only).
- Set in **Outlook Web**¹ for the currently logged-in user, including mirroring signatures to the cloud as **roaming signatures**¹ (Linux/macOS/Windows, Classic and New Outlook¹).
- Signature can be centrally managed only¹, or **exist along user-created signatures**.
- Automatically added to new emails, reply emails and appointments with the **Outlook add-in**¹.
- Copied to an **additional path**¹ for easy access to signatures on mobile devices or for use with email clients and apps besides Outlook: Apple Mail, Google Gmail, Samsung Mail, Mozilla Thunderbird, GNOME Evolution, KDE KMail, and others.
- Create an **email draft containing all available signatures** in HTML and plain text for easy access in mail clients that do not have a signatures API.
- **Write protected** (Outlook for Windows signatures only).

Set-OutlookSignatures can be **run by users on Windows, Linux and macOS clients, including shared devices and terminal servers - or on a central system with a service account**¹.<br>On clients, it can run as part of the logon script, as scheduled task, or on user demand via a desktop icon, start menu entry, shortcut or any other way of starting a program - **whatever your software deployment mechanism allows**.

**Sample templates** for signatures and OOF messages demonstrate many features and are provided as .docx and .htm files.

**Simulation mode** allows content creators and admins to simulate the behavior of the software for a specific user at a specific point in time, and to inspect the resulting signature files before going live.

**SimulateAndDeploy**¹ allows to deploy signatures and out-of-office replies to Outlook Web¹/New Outlook¹ (when based on Outlook Web) **without any client deployment or end user interaction**, making it ideal for users that only log on to web services but never to a client (users with a Microsoft 365 F-license, for example).

It works **on premises, in hybrid and in cloud-only environments**. The software is **designed to work in big and complex environments**: Exchange resource forest scenarios, AD trusts, multi-level AD subdomains, cross-tenant and multitenant scenarios.  
All **national clouds are supported**: Public (AzurePublic), US Government L4 (AzureUSGovernment), US Government L5 (AzureUSGovernment DoD), China (AzureChinaCloud operated by 21Vianet).

It is **multi-instance capable** by using different template paths, configuration files and script parameters.

Set-OutlookSignatures requires **no installation on servers or clients**. You only need a standard SMB file share on a central system, and optionally Office on your clients.

There is also **no telemetry** and no "calling home". Emails and directory data are **not routed through a 3rd party data center or cloud service**, and there is **no need to change DNS records (MX, SPF) or email flow**.

A **documented implementation approach**, based on real life experiences implementing the software in multi-client environments with a five-digit number of mailboxes, contains proven procedures and recommendations for product managers, architects, operations managers, account managers and email and client administrators.

The software core is **Free and Open-Source Software (FOSS)**. It is published under the European Union Public License, which is approved, among others, by the Free Software Foundation (FSF) and the Open Source Initiative (OSI), and is compatible with the General Public License (GPL) and other popular licenses.

Footnote 1 (¹): **Some features are exclusive to the <a href="/benefactorcircle">Benefactor Circle add-on</a>.** The optional <a href="/benefactorcircle"><span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle add-on</span></a> extends Set-OutlookSignatures with powerful enterprise features, prioritized support, and direct access to new capabilities. It also ensures that the core of Set-OutlookSignatures can remain Free and Open-Source Software (FOSS) and continues to evolve.


## Feature comparison {#feature-comparison}

<div class="table-container">
    <table class="table is-bordered is-striped is-hoverable is-fullwidth">
        <thead>
            <tr>
                <th style="text-align:left">Feature</th>
                <th style="text-align:left">Set-OutlookSignatures<br>with the <span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle add-on</span></th>
                <th style="text-align:left">Peer&nbsp;A</th>
                <th style="text-align:left">Peer&nbsp;B</th>
                <th style="text-align:left">Peer&nbsp;C</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td style="text-align:left">Free and Open-Source core</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Emails stay in your environment (no re-routing to 3rd party datacenters)</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡 Optional, causes reduced feature set</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Is hosted and runs in environments that you already trust and for which you have
                    established security and management structures</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Entra ID and Active Directory permissions</td>
                <td style="text-align:left">🟢 User (delegated) permissions, least privilege principle</td>
                <td style="text-align:left">🔴 Application permissions, read all directory data (and transfer all emails)
                </td>
                <td style="text-align:left">🔴 Application permissions, read all directory data (and transfer all emails)
                </td>
                <td style="text-align:left">🔴 Application permissions, read all directory data (and read all emails)</td>
            </tr>
            <tr>
                <td style="text-align:left">Entra ID and Active Directory data stays in your environment (no transfer to 3rd
                    party datacenters)</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Does not require configuring Exchange adding a dependency to it</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Multiple independent instances can be run in the same environment</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">No telemetry or usage data collection, direct or indirect</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">No auto-renewing subscription</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">IT can delegate signature management, e.g. to marketing</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡 Not at signature level</td>
                <td style="text-align:left">🟡 Not at signature level</td>
            </tr>
            <tr>
                <td style="text-align:left">Apply signatures to all emails</td>
                <td style="text-align:left">🟡 Outlook clients only</td>
                <td style="text-align:left">🟢 With email re-routing to a 3rd party datacenter</td>
                <td style="text-align:left">🟢 With email re-routing to a 3rd party datacenter</td>
                <td style="text-align:left">🟢 With email re-routing to a 3rd party datacenter</td>
            </tr>
            <tr>
                <td style="text-align:left">Apply signature based on recipients</td>
                <td style="text-align:left">🟡 Highly customizable, 10+ properties. Same signature for all recipients.</td>
                <td style="text-align:left">🟡 Internal, external, group membership, email address. Different signature for each recipient via email re-routing to a 3rd party datacenter.</td>
                <td style="text-align:left">🟡 Internal or external. Same signature for all recipients.</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Additional data sources besides Active Directory and Entra ID</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Supports Microsoft national clouds</td>
                <td style="text-align:left">🟢 Global/Public, US Government L4 (GCC, GCC High), US Government L5 (DOD),
                    China operated by 21Vianet</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Supports cross-tenant access and multitenant organizations</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Support for Microsoft roaming signatures (multiple signatures in Outlook Web and
                    New Outlook)</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Number of templates</td>
                <td style="text-align:left">🟢 Unlimited</td>
                <td style="text-align:left">🔴 1, more charged extra</td>
                <td style="text-align:left">🟢 Unlimited</td>
                <td style="text-align:left">🟢 Unlimited</td>
            </tr>
            <tr>
                <td style="text-align:left">Targeting and exclusion</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴 Charged extra</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟢</td>
            </tr>
            <tr>
                <td style="text-align:left">Scheduling</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴 Charged extra</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟢</td>
            </tr>
            <tr>
                <td style="text-align:left">Banners</td>
                <td style="text-align:left">🟢 Unlimited</td>
                <td style="text-align:left">🔴 1, more charged extra</td>
                <td style="text-align:left">🟢 Unlimited</td>
                <td style="text-align:left">🟢 Unlimited</td>
            </tr>
            <tr>
                <td style="text-align:left">QR codes and vCards</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴 Charged extra</td>
                <td style="text-align:left">🔴 Charged extra</td>
                <td style="text-align:left">🟢</td>
            </tr>
            <tr>
                <td style="text-align:left">Signature visible while writing</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡</td>
                <td style="text-align:left">🟡</td>
                <td style="text-align:left">🟡</td>
            </tr>
            <tr>
                <td style="text-align:left">Signature visible in Sent Items</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡 Cloud mailboxes only</td>
                <td style="text-align:left">🟡 Cloud mailboxes only</td>
                <td style="text-align:left">🟡 Cloud mailboxes only</td>
            </tr>
            <tr>
                <td style="text-align:left">Out-of-office reply messages</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🔴 Charged extra</td>
                <td style="text-align:left">🟡 Same for internal and external senders</td>
                <td style="text-align:left">🔴 Charged extra</td>
            </tr>
            <tr>
                <td style="text-align:left">User-controlled email signatures</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡</td>
                <td style="text-align:left">🟡</td>
                <td style="text-align:left">🟡</td>
            </tr>
            <tr>
                <td style="text-align:left">Signatures for encrypted messages</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡</td>
                <td style="text-align:left">🟡</td>
                <td style="text-align:left">🟡</td>
            </tr>
            <tr>
                <td style="text-align:left">Signatures for delegates, shared, additional and automapped mailboxes</td>
                <td style="text-align:left">🟢</td>
                <td style="text-align:left">🟡 No mixing of sender and delegate replacement variables</td>
                <td style="text-align:left">🟡 No mixing of sender and delegate replacement variables</td>
                <td style="text-align:left">🟡 No mixing of sender and delegate replacement variables</td>
            </tr>
            <tr>
                <td style="text-align:left">Outlook add-in</td>
                <td style="text-align:left">🟢 No on-prem mailboxes on mobile devices. Highly customizable with rules, own code and runtime-generated signatures.</td>
                <td style="text-align:left">🟡 No on-prem mailboxes on mobile devices, not for appointments</td>
                <td style="text-align:left">🟡 No on-prem mailboxes on mobile devices, not for appointments</td>
                <td style="text-align:left">🔴 No on-prem mailboxes</td>
            </tr>
            <tr>
                <td style="text-align:left">Support pricing model</td>
                <td style="text-align:left">🟢 Charged per support hour</td>
                <td style="text-align:left">🔴 Charged if used or not</td>
                <td style="text-align:left">🔴 Charged if used or not</td>
                <td style="text-align:left">🔴 Charged if used or not</td>
            </tr>
            <tr>
                <td style="text-align:left">Software escrow</td>
                <td style="text-align:left">🟢 To the free and open-source Set&#8209;OutlookSignatures project</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🔴</td>
            </tr>
            <tr>
                <td style="text-align:left">Phone number formatting</td>
                <td style="text-align:left">🟢 E164, international, national, RFC3966, regex, custom</td>
                <td style="text-align:left">🟡 Regex</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🟡 RegEx</td>
            </tr>
            <tr>
                <td style="text-align:left">Postal address formatting</td>
                <td style="text-align:left">🟢 Templates for more than 200 countries/regions, custom</td>
                <td style="text-align:left">🟡 Regex</td>
                <td style="text-align:left">🔴</td>
                <td style="text-align:left">🟡 RegEx</td>
            </tr>
            <tr>
                <td style="text-align:left">License cost for 100 mailboxes, 1 year</td>
                <td style="text-align:left">🟢 300&nbsp;€</td>
                <td style="text-align:left">🔴 ca. 1,600&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 1,300&nbsp;€</td>
                <td style="text-align:left">🔴 ca. 1,600&nbsp;€</td>
            </tr>
            <tr>
                <td style="text-align:left">License cost for 250 mailboxes, 1 year</td>
                <td style="text-align:left">🟢 750&nbsp;€</td>
                <td style="text-align:left">🔴 ca. 4,000&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 2,700&nbsp;€</td>
                <td style="text-align:left">🔴 ca. 3,600&nbsp;€</td>
            </tr>
            <tr>
                <td style="text-align:left">License cost for 500 mailboxes, 1 year</td>
                <td style="text-align:left">🟢 1,500&nbsp;€</td>
                <td style="text-align:left">🔴 ca. 8,000&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 4,400&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 6,200&nbsp;€</td>
            </tr>
            <tr>
                <td style="text-align:left">License cost for 1,000 mailboxes, 1 year</td>
                <td style="text-align:left">🟢 3,000&nbsp;€</td>
                <td style="text-align:left">🔴 ca. 15,700&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 8,700&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 10,500&nbsp;€</td>
            </tr>
            <tr>
                <td style="text-align:left">License cost for 10,000 mailboxes, 1 year</td>
                <td style="text-align:left">🟢 30,000&nbsp;€</td>
                <td style="text-align:left">🔴 ca. 110,000&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 65,000&nbsp;€</td>
                <td style="text-align:left">🟡 ca. 41,000&nbsp;€</td>
            </tr>
        </tbody>
    </table>
</div>