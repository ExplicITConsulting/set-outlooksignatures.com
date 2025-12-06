---
layout: "page"
lang: "en"
locale: "en"
title: "Organizational implementation approach"
subtitle: "Implementation in a complex environment with a five-digit number of mailboxes"
description: "Discover our implementation approach for complex multi-client environments with thousands of mailboxes—real-world experience for smooth deployment."
permalink: "/implementationapproach"
redirect_from:
  - "/implementationapproach/"
sitemap_priority: 0.8
sitemap_changefreq: weekly
---
<!-- omit in toc -->
## What organizational approach do we recommend for implementing the software? {#recommended-approach}
For most companies, the <a href="/quickstart">quick start guide</a> is the most efficient way to get started. With it, you deploy your first signatures within minutes and create a robust starting point for your own customizations.

You prefer to be guided through organizational topics, the setup and customization process instead of working through the documentation yourself? ExplicIT Consulting offers <a href="/support#professional-support">implementation support from A to Z</a>.

<p>
  <div class="buttons">
    <a href="/quickstart" class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-color: LawnGreen">Quick Start Guide</a>
    <a href="/support#professional-support" class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-color: LawnGreen">Support</a>
  </div>
</p>

This document is intended for organizations that need to ensure formal processes and traceability in addition to efficiency. It contains a structured example of how implementation can be approached in environments where traceability and compliance are essential, such as in high-security or highly regulated environments. It shows how rapid implementation can be combined with strict governance requirements.

The content is based on practical experience with deploying the solution in multi-tenant environments with tens of thousands of mailboxes. The document is intended for IT service providers, internal IT teams, and business departments responsible for email and client systems.

The topics covered span the entire lifecycle, from initial consultation and planning to testing, pilot phases, and rollout. This is followed by operation, administration, support, and training. The goal is to provide a practical reference that helps companies implement the solution effectively while meeting strict requirements.

This is not a detailed guide for technicians, but rather an organizational overview. Technical details can be found [here](/details).


## 1. Task {#task}
As a multinational corporation, we are required to find a flexible solution for the automatic management of signatures. The requirements for this come from several areas:
- The marketing department wants to ensure that corporate identity and corporate design are also maintained in emails. Signatures should be able to be updated quickly by the marketing department itself so that campaigns can be started and ended at short notice. This should not require any technical knowledge.
- The legal department insists on implementing the requirement for an imprint in emails in the form of a signature, which is applicable in many countries.
- Management at all levels supports the wishes of the other departments as long as this does not lead to additional work for their employees, but rather relieves them where possible and gives them more time for their tasks.
- CISOs want to ensure that all data protection and information security regulations are complied with and that data remains in its original systems as far as possible.
- IT managers do not want to have to worry about the content of signatures and updating them. Nor should any new dependencies on our email system be created, as these inevitably increase the complexity of the overall system and operating costs.

There are also various other factors to consider:
- The solution must offer clear added value from a financial perspective. A purchase will only be considered if the cost-benefit analysis is positive.
- As a group, we are subject to a certain dynamic. Some subsidiaries are very closely linked to the group in organizational and technical terms, while others are very loosely connected. In all constellations, there can be intensive cooperation. In the context of mergers and acquisitions, it must be possible to quickly integrate individual companies or groups of companies or remove them from the group.

- Accordingly, the technical implementation is very diverse: multiple independent Exchange environments in on-premises, hybrid, and cloud-only configurations, multiple AD forests in different trust configurations, multiple M365/Entra ID tenants with and without connections to each other.

This document aims to clarify whether the desired requirements regarding signatures can be met and what a practical implementation might look like.

The word "signature” in this document always refers to a textual signature and should not be confused with a digital signature, which is used to encrypt emails and authenticate the sender.


## 2. Options for Signature Maintenance {#signature-maintenance-options}
### 2.1. Manual Signature Maintenance {#manual-signature-maintenance}
With manual maintenance, a template for the textual signature is provided to the user, e.g., via the intranet. Only this template is centrally maintained; there is no further automation.

Each user sets up their own signature. Depending on the technical configuration of the client, signatures may migrate when switching computers or need to be reconfigured.

If the mailbox is not in the cloud or "roaming signatures" have been disabled, the user must also maintain their signature in Outlook Web.

Without third-party software, signatures must also be manually maintained separately on Android, iOS, and macOS.

### 2.2. Automatic Signature Maintenance {#automatic-signature-maintenance}
With automatic signature maintenance, no actions are required from the end user. All specifications are defined centrally, and signatures update automatically across all devices and systems.

<!-- omit in toc -->
#### 2.2.1. Server-Based Solutions {#server-based-signature-solutions}
The biggest advantage of a server-based solution is that every email is processed based on a defined set of rules, regardless of the application or device used to send it.

Since the signature is appended on the server, the user does not see which signature is used while composing the email.

Defining the rules quickly becomes complex, and users have virtually no influence over the signature used.

After the signature is appended on the server, the modified email must be re-downloaded by the client to be correctly displayed in the "Sent Items" folder. This generates additional network traffic.

If a message is digitally signed or encrypted during creation, the textual signature cannot be added server-side without breaking the digital signature and encryption. Alternatively, the message is modified so that the content consists only of the textual signature, and the original unchanged message is sent as an attachment.

This creates a new dependency of the mail system on the signature solution, and there are hardly any suitable solutions available for on-premises Exchange operations.

Cloud-based solutions require that all internal and external emails, as well as data from Entra ID, be redirected to a third-party data center for rule analysis and signature application.

We therefore advise against server-based solutions.

<!-- omit in toc -->
#### 2.2.2. Client-Based Signatures {#client-based-signature-solutions}
With client-based solutions, the definition of templates and optionally their distribution is done centrally, while the signature is added to the email on the client side.

The biggest disadvantage of client-based solutions compared to server-based ones is their dependency on specific email clients. In practice, this is of little relevance, as Microsoft Outlook is usually used for reasons of maintainability and consistency. Outlook is available for Android, iOS, macOS, and Windows, and additionally as a web application on virtually all other platforms.

The user sees the signature while composing the email and can help decide which signature is used.

Encryption and digital signing of messages pose no problems on either the client or server side.

Unlike server-based solutions, there are alternatives here that do not require the transmission of emails and data from Entra ID to third-party data centers.

We therefore recommend using a client-based solution.

## 3. Required Feature Set {#required-feature-set}
Based on the previously mentioned conditions and discussions with all involved parties, the following catalog of required features has been derived:

**Signatures and out-of-office messages should:**
- Be creatable from templates in common formats such as DOCX or HTML.
- Be customizable using variables from directory services (e.g., Active Directory, Entra ID) and other data sources, including photos and images.
- Support variables for the current user, mailbox, and manager.
- Be designed to be accessible, e.g., with alternative text for links and images.
- Be flexibly assignable: to all mailboxes, groups, alias addresses, based on attributes.
- Be reusable: one template for many mailboxes, with individual signature names.
- Be usable on a scheduled basis (valid during specific time periods).
- Be set as the default signature for new emails or replies.
- Be usable as the default out-of-office message for internal and external recipients.
- Be synchronized in Outlook Web and as roaming signatures.
- Be centrally managed, but also allow parallel user signatures.
- Be automatically inserted into new emails, replies, forwards, and calendar events.
- Be made available for other email clients besides Outlook. If not automatically, then at least for manual integration (e.g., Apple Mail).

**Deployment and execution should:**
- Be possible on Windows, Linux, and macOS clients, including terminal servers or shared devices.
- Work without installation on servers or clients.
- Be executable via central shares and standard mechanisms such as login scripts, scheduled tasks, or manual execution.
- Optionally be available directly for web users without client deployment.
- Function in hybrid, cloud, and on-premises environments.
- Be suitable for large and complex environments (e.g., multiple AD domains, trusts, multi-tenant setups).
- Allow multiple instances through separate configurations.

**Security and data protection:**
- No telemetry or external data transmission.
- No changes to DNS or email traffic required.
- Data remains within the existing infrastructure.

**Additional requirements:**
- Documented best practices for implementation and operation.
- Preference for open-source options or transparent licensing terms.


## 4. Comparison of Different Solutions {#feature-comparison}
Based on the required feature set, various solutions were evaluated, tested, and compared:

<div class="table-container">
    <table class="table is-bordered is-striped is-hoverable is-fullwidth">
        <thead>
            <tr>
                <th style="text-align:left">Feature</th>
                <th style="text-align:left">Set-OutlookSignatures<br>with the <span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></th>
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
            <tr>
                <td style="text-align:left">Direct procurement without public tender</td>
                <td style="text-align:left">🟢 Unique features, exclusive manufacturer availablity</td>
                <td style="text-align:left">🔴 No unique features, no exclusive manufacturer availablity</td>
                <td style="text-align:left">🔴 No unique features, no exclusive manufacturer availablity</td>
                <td style="text-align:left">🔴 No unique features, no exclusive manufacturer availablity</td>
            </tr>
        </tbody>
    </table>
</div>

## 5. Recommendation: Set-OutlookSignatures {#recommendation}
After gathering customer requirements and testing several server- and client-based products, we recommend using the free open-source software **Set-OutlookSignatures** with the paid **"Benefactor Circle"** extension.

### 5.1. General Description {#general-description}
<a href="/">Set-OutlookSignatures</a> is a free open-source product with a paid add-on for advanced enterprise features.

It supports all variants of Outlook and Exchange as target platforms: Windows, macOS, Android, iOS, Linux, and Web. Both classic and new Outlook. On-premises, hybrid, and cloud-only. By optionally storing signatures in the mailbox, they are also available in other email clients.

Signature management is centralized and can be fully or partially delegated, e.g. to marketing, on a per-template basis. Only Microsoft Word is required for management; HTML knowledge is optional.

Signature generation and distribution can be done in three combinable ways:
- Locally on clients: This is the preferred method, as most unused computing power is available on clients (Windows, Linux, macOS).
- On one or more servers: Signatures are pre-generated centrally and written into users' mailboxes. This method requires high central computing power and cannot account for client-side settings. It is the preferred method for users who only use Outlook on the web, iOS, Android, or other email clients.
- Via the Outlook Add-In: This allows access to signatures created by the other methods, and also enables independent signature creation and insertion. This mode supports granular rules based on many properties of the current item (e.g., recipients, sender, subject, and more).

All three methods support all types of email encryption, and integration into clients secured with AppLocker and other mechanisms (e.g., Microsoft Purview Information Protection) is technically and organizationally straightforward using established practices such as digitally signed PowerShell scripts.

The architecture ensures that no data leaves existing system, there is no transmission to external providers.

Any number of independent instances can be operated, which is beneficial for phased rollouts or for companies loosely affiliated with a corporate group.

### 5.2. Licensing Model and Cost-Benefit Analysis {#licensing-and-cost-benefit}

The free part of the software is licensed under the "European Union Public License (EUPL) 1.2", which is recognized by international organizations as a full open-source license and is compatible with many other comparable licenses.

The Benefactor Circle add-on is licensed based on the number of mailboxes intended to use it. There is no need to name mailboxes individually.

By avoiding tiered pricing and discounts, the <a href="/benefactorcircle#financial-benefits">cost-benefit ratio</a> is already favorable even for a small number of mailboxes.


## 6. Support from the IT Service Provider {#support-it-service-provider}
As an IT service provider, we not only recommend Set-OutlookSignatures, but also offer comprehensive support to our clients.

We share our experience gained during the definition of requirements for a signature solution, the evaluation and comparison of different products, and the implementation of Set-OutlookSignatures and the Benefactor Circle add-on.

For companies within the group that wish to implement the solution independently, we recommend starting with the <a href="/quickstart">Quick Start Guide</a>. Thanks to the extensive documentation, clients can usually implement Set-OutlookSignatures and the Benefactor Circle add-on on their own in a short amount of time.

We offer support to all group companies in the form of workshops and training sessions. The following list represents the maximum scope, both in terms of content and time, within a full preparation and implementation project. **Complete <a href="/support#professional-support">implementation support</a> in a "train the trainer" format rarely takes more than half a day.**

### 6.1. Consulting and Imp/lementation Phase {#consulting-implementation-phase}
#### Initial Alignment on Textual Signatures <!-- omit in toc -->
**Participants**  
- Client: Corporate Communications, Marketing, Client Management, Project Coordinator  
- IT Service Provider: Mail Product Management, Mail Operations, or Mail Architecture  

**Content and Objectives**  
- Client: Presentation of desired features for textual signatures  
- IT Service Provider: Brief overview of general possibilities for textual signatures, pros and cons of different approaches, rationale for the recommended product  
- Alignment of client requirements with technical and organizational capabilities  
- Live demonstration of the product considering client requirements  
- Definition of next steps  

**Duration**  
- 2 hours  

#### Template Manager Training <!-- omit in toc -->
**Participants**  
- Client: Template Managers (Corporate Communications, Marketing), optionally Client Management, Project Coordinator  
- IT Service Provider: Mail Product Management, Mail Operations, or Mail Architecture  

**Content and Objectives**  
- Summary of the previous "Initial Alignment" session, focusing on desired and feasible features  
- Introduction to the structure of the template directories, focusing on:  
  - Naming conventions  
  - Application order (general, group-specific, mailbox-specific, alphabetically within each group)  
- Definition of default signatures for new emails and for replies/forwards  
- Definition of out-of-office messages for internal and external recipients  
- Definition of template validity periods  
- Use of variables and user photos in templates  
- Differences between DOCX and HTML formats  
- Options for including disclaimers  
- Collaborative creation of initial templates based on existing templates and client requirements  
- Live demonstration on a standard client with a test user and test mailboxes (see prerequisites)  

**Duration**  
- 2 hours  

**Prerequisites**  
- Standard client with Outlook and Word available  
- Screen content must be projectable via beamer or displayed on a sufficiently large monitor  
- Client provides a test user who must:  
  - Be allowed to download files from the internet (github.com) once (alternatively, a BitLocker-encrypted USB stick can be used)  
  - Be allowed to execute signed PowerShell scripts in Full Language Mode  
  - Have a mail mailbox  
  - Have full access to various test mailboxes (personal or group mailboxes), ideally members of various groups or distribution lists. Access can be granted via permissions or by providing credentials.  

#### IT Team Training <!-- omit in toc -->
**Participants**  
- Client: IT, optionally an Active Directory administrator, optionally a File Server and/or SharePoint administrator, optionally Corporate Communications and Marketing, Project Coordinator  
- IT Service Provider: Mail Product Management, Mail Operations, or Mail Architecture, optionally a representative from the client team  

**Content and Objectives**  
- Summary of the previous "Initial Alignment" session, focusing on desired and feasible features  
- Overview of software operation  
- Client system requirements (Office, PowerShell, AppLocker, digital signature of software, network ports)  
- Server system requirements (template storage)  
- Integration options (logon script, scheduled task, desktop shortcut)  
- Software parameterization, including:  
  - Template folder paths  
  - Consider Outlook Web?  
  - Consider out-of-office messages?  
  - Which trusts to include?  
  - How to define additional variables?  
  - Allow user-created signatures?  
  - Store signatures in an additional path?  
- Joint testing based on previously created templates and client requirements  
- Definition of next steps  

**Duration**  
- 2 hours  

**Prerequisites**  
- Client provides a standard client with Outlook and Word  
- Screen content must be projectable via beamer or displayed on a sufficiently large monitor  
- Client provides a test user who must:  
  - Be allowed to download files from the internet (github.com) once (alternatively, a BitLocker-encrypted USB stick can be used)  
  - Be allowed to execute signed PowerShell scripts in Full Language Mode  
  - Have a mail mailbox  
  - Have full access to various test mailboxes (personal or group mailboxes), ideally members of various groups or distribution lists. Access can be granted via permissions or by providing credentials  
- Client provides at least one central SMB share or SharePoint document library for template storage  
- Client provides a central SMB file share for storing the software and its components  

### 6.2. Testing, Pilot Operation, Rollout {#testing-pilot-rollout}
Planning and coordination of testing, pilot operation, and rollout is handled by the client's project lead.

The actual technical implementation is carried out by the client. If the client's IT service provider also manages the client systems, the client team supports integration of the software (logon script, scheduled task, desktop shortcut).

In case of fundamental technical issues, the mail product management team assists with root cause analysis, develops solution proposals, and, if necessary, establishes contact with the software vendor.

Creating and maintaining templates is the responsibility of the client.

#### System Requirements <!-- omit in toc -->
**Client**
- Outlook and Word (when using DOCX templates and/or RTF-format signatures), version 2010 or newer  
- The software must run in the security context of the currently logged-in user  
- The software must be executed in "Full Language Mode"; "Constrained Language Mode" is not supported  
- If AppLocker or similar solutions are used, the software is already digitally signed  
- Network access requirements:  
  - Ports 389 (LDAP) and 3268 (Global Catalog), both TCP and UDP, must be open between the client and all domain controllers. If not, signature-related information and variables cannot be retrieved. The software checks access on each run  
  - For access to the SMB file share containing software components, the following ports are required: 137 UDP, 138 UDP, 139 TCP, 445 TCP (see <a href="https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc731402(v=ws.11)">this MicrosoftrePoint document libraries, port 443 TCP is required. Firewalls and proxies must not block WebDAV HTTP extensions  

**Server**
- An SMB file share where the software and its components are stored. All users must have read access to this share and its contents  
- One or more SMB file shares or SharePoint document libraries where templates for signatures and out-of-office messages are stored and managed  

If templates use variables (e.g., first name, last name, phone number), the corresponding values must exist in Active Directory. In the case of linked mailboxes, attributes of the current user and the mailbox (which may reside in different AD forests) can be distinguished.

As described in the system requirements, the software and its components must be stored on an SMB file share. Alternatively, it can be distributed to clients via any mechanism and executed locally.

All users need read access to the software and its components.

As long as these requirements are met, any SMB file share can be used, for example:
- The NETLOGON share of Active Directory  
- A share on a Windows server (single server or cluster, classic share or DFS in any variation)  
- A share on a Windows client  
- A share on any non-Windows system, e.g., via SAMBA  

As long as all clients use the same version of the software and configure it only via parameters, a central storage location for the software components is sufficient.

For maximum performance and flexibility, we recommend that each client stores the software in its own SMB file share and replicates it across locations if needed.

Unlike templates and configurations, storing the software itself on SharePoint Online is not supported.

**Template Storage**  
As described in the system requirements, templates for signatures and out-of-office messages can be stored on SMB file shares or SharePoint document libraries, similar to the software itself.

SharePoint document libraries offer the advantage of optional file versioning, allowing template managers to quickly restore a previous version in case of errors.

We recommend at least one share per client, with separate subdirectories for signature and out-of-office templates.

Users need read access to all templates.

By simply assigning write permissions to the entire template folder or individual files, the creation and management of signature and out-of-office templates can be delegated to a defined group of people. Typically, templates are defined, created, and maintained by Corporate Communications and Marketing departments.

For maximum performance and flexibility, we recommend that each client stores the software in their own SMB file share and replicates it across locations if needed.

Templates and configuration files can also be stored on SharePoint Online.

**Template Management and Delegation**  
By assigning write permissions to the template folder or individual files, the creation and management of signature and out-of-office templates can be delegated to a defined group of people. Typically, templates are defined, created, and maintained by Corporate Communications and Marketing departments.

The software can process templates in DOCX or HTML format. For initial use, DOCX format is recommended. The reasons for this recommendation and the pros and cons of each format are described in the software's `README` file.

The included `README` file provides an overview of how templates should be managed so that they:
- Apply only to specific groups or mailboxes  
- Are set as default signatures for new emails or replies and forwards  
- Are used as internal or external out-of-office messages  
- And much more  

The `README` and sample templates also describe:
- Replaceable variables  
- Extension with custom variables  
- Handling of photos from Active Directory  

The included sample file **"Test all signature replacement variables.docx"** contains all standard variables. Additional custom variables can be defined as needed.

**Executing the Software**  
The software can be executed using any mechanism, for example:
- At user login, as part of the logon script or as a standalone script  
- Via Task Scheduler at fixed times or triggered by specific events  
- Manually by the user, e.g., via a desktop shortcut  
- Through a client management tool  

Since Set-OutlookSignatures is primarily a PowerShell script, it is executed like any other script of this type:

```
powershell.exe <PowerShell-Parameter> -file "<Pfad zu Set-OutlookSignatures.ps1>" <Script-Parameter>  
```

**Parameterization**  
The behavior of the software can be controlled via parameters. Particularly relevant are SignatureTemplatePath and OOFTemplatePath, which specify the path to the signature and out-of-office templates.

Below is an example where the signature templates are located on an SMB file share and the out-of-office templates in a SharePoint document library:
```
powershell.exe -file "\\example.com\netlogon\set-outlooksignatures\set-outlooksignatures.ps1" –SignatureTemplatePath "\\example.com\DFS-Share\Common\Templates\Signatures Outlook" –OOFTemplatePath "https://sharepoint.example.com/CorporateCommunications/Templates/Out-of-office templates"
```
At the time of writing this document, additional parameters were available. Below is a brief overview of the options; for details, refer to the software documentation in the README file:
- SignatureTemplatePath: Path to the signature templates. Can be an SMB share or a SharePoint document library.
- ReplacementVariableConfigFile: Path to the file where custom variables deviating from the default are defined. Can be an SMB share or a SharePoint document library.
- TrustsToCheckForGroups: By default, all trusts are queried for mailbox information. This parameter allows specific domains to be excluded and non-trusted domains to be added.
- DeleteUserCreatedSignatures: Should user-created signatures be deleted? By default, this does not happen.
- SetCurrentUserOutlookWebSignature: By default, a signature is set in Outlook Web for the logged-in user. This can be disabled with this parameter.
- SetCurrentUserOOFMessage: By default, the text of the out-of-office messages is set. This behavior can be changed with this parameter.
- OOFTemplatePath: Path to the out-of-office templates. Can be an SMB share or a SharePoint document library.
- AdditionalSignaturePath: Path to an additional share where all signatures should be copied, e.g., for access from a mobile device and to simplify configuration of clients not supported by the software. Can be an SMB share or a SharePoint document library.
- UseHtmTemplates: By default, templates in DOCX format are processed. This switch allows switching to HTML (.htm).

The README file contains additional parameters.

**Runtime and visibility of the software**  
The software is designed for fast execution and minimal network load, but its runtime still depends on many parameters:
- general performance of the client (CPU, RAM, HDD)
- number of mailboxes configured in Outlook
- number of trusted domains
- response time of domain controllers and file servers
- response time of Exchange servers (setting signatures in Outlook Web, out-of-office messages)
- number of templates and complexity of variables (e.g., photos)

Under the following conditions, a reproducible runtime of approximately 30 seconds was measured:
- standard client
- connected to the corporate network via VPN
- 4 mailboxes
- querying all AD domains connected via trust
- 9 signature templates to process, all with variables and graphics (but without user photos), some restricted to groups and mail addresses
- 8 out-of-office templates to process, all with variables and graphics (but without user photos), some restricted to groups and mail addresses
- setting the signature in Outlook Web on-prem
- no copying of signatures to an additional network path

Since the software requires no user interaction, it can be executed minimized or hidden using standard mechanisms. This makes the runtime practically irrelevant.

**Use of Outlook and Word during runtime**  
The software does not start Outlook; all queries and configurations are performed via the file system and registry.

Outlook can be started, used, or closed at any time during the software's execution.

All changes to signatures and out-of-office messages are immediately visible and usable by the user, with one exception: if the name of the default signature for new emails or for replies and forwards changes, this change only takes effect after restarting Outlook. If only the content changes but not the name of a default signature, the change is immediately available.

Word can also be started, used, or closed at any time during the software's execution.

The software uses Word to replace variables in DOCX templates and to convert DOCX and HTML to RTF. Word is started as a separate invisible process. This process is practically unaffected by the user and does not interfere with Word processes started by the user.

### 6.3. Ongoing Operations
As an IT service provider, we also support our group companies in the ongoing operation of Set-OutlookSignatures with our full expertise. This includes, for example, questions about:
- Creating and maintaining templates
- Creating and maintaining storage shares for templates and software components
- Setting and maintaining AD attributes or attributes in other data sources
- Configuration adjustments
- General questions regarding day-to-day operations
