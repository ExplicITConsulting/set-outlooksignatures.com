---
layout: "page"
lang: "en"
locale: "en"
title: "Quick Start Guide"
subtitle: "Deploy signatures within minutes"
description: "Quick Start Guide. Deploy signatures within minutes."
permalink: "/quickstart"
redirect_from:
  - "/quickstart/"
sitemap_priority: 0.8
sitemap_changefreq: weekly
---
## Step 1: Download Set-OutlookSignatures {#step-1}
Download Set-OutlookSignatures and extract the archive to a local folder.

<p>
  <div class="buttons">
    <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="button sos-download-link is-link is-normal is-hovered has-text-black has-text-weight-bold mtrcs-download" style="background-color: LawnGreen">Download software</a>
    <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" class="sos-download-link mtrcs-download no-external-link-icon"><img src="https://img.shields.io/github/downloads/Set-OutlookSignatures/Set-OutlookSignatures/total?style=flat" alt="Number of downloads" loading="lazy"></a>
    <a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/issues?q=" class="no-external-link-icon"><img src="https://img.shields.io/github/issues/Set-OutlookSignatures/Set-OutlookSignatures?style=flat" alt="Number of open issues and link to issue list" loading="lazy"></a>
  </div>
</p>

On Windows and macOS, unblock the file 'Set-OutlookSignatures.ps1'. You can use the PowerShell cmdlet 'Unblock-File' for this, or right-click the file in File Explorer, select Properties and check 'Unblock'. This removes the 'mark of the web', which can prevent script execution in PowerShell.


## Step 2: One-time preparations {#step-2}
**Client and user**  
For a first test run, it is recommended to log on with a test user on a Windows system with Word and Classic Outlook for Windows installed, and Classic Outlook for Windows being configured with at least the test user's mailbox. If you use your own user, existing signatures will be overwritten in the worst case.

For full Linux, macOS and New Outlook support, the <a href="/benefactorcircle"><span style="font-weight: bold; color: darkgoldenrod;">Benefactor Circle add-on</span></a> is required and the mailboxes need to be hosted in Exchange Online.

If you cannot test with Classic Outlook on Windows, or do not want your signature setup changed, you can use simulation mode, which is described in a later step.

**Entra ID**  
When some or all of your mailboxes are in Exchange Online, you need to register an Entra ID app first. This is because Set-OutlookSignatures needs permissions to access the Graph API.

To create the Entra ID app, ask your Entra ID 'Global Admin' or 'Application Administrator' to run the following and follow the instructions:
```
powershell.exe -noexit -file "c:\test\sample code\Create-EntraApp.ps1" -AppType "Set-OutlookSignatures" -AppName "Set-OutlookSignatures"
```

The code in the script file is well documented, containing all details about the required Entra ID app settings, permissions, and why they are needed.

**Endpoint security**  
If you require PowerShell script to be signed with select certificates, use AppLocker or a comparable solution such as Defender, CrowdStrike, Ivanti, and others, you may need to specifically allow Set-OutlookSignatures to be run and to load libraries from the TEMP folder (which is used to not lock files in their original location).

Ask your endpoint security administrator to trust software signed with ExplicIT Consulting's certificate. All PS1 and DLL files that come with the Set-OutlookSignatures download in step 2 are signed with this certificate.


## Step 3: Run Set-OutlookSignatures {#step-3}
- **If all mailboxes are in Exchange on-prem**
  ```
  powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1"
  ```

- **If some or all mailboxes are in Exchange Online**
  ```
  powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1" -GraphOnly true -GraphClientId "<GraphClientId from step 1 Entra ID>"
  ```
  The '`-GraphOnly true`' parameter makes sure that on-prem Active Directory is ignored and only Graph/Entra ID is used to find mailboxes and their attributes.

If you are not using the public Microsoft cloud but a national cloud, add the following parameter: '`-CloudEnvironment [AzureUSGovernment|AzureUSGovernmentDoD|AzureChina]`'

Set-OutlookSignatures now adds signatures based on default settings and sample templates to your Classic Outlook.

Open Classic Outlook and take a look at the newly created signatures. 'Formal', 'Informal' and the particularly comprehensive 'Test all default replacement variables'.

If you do not have access to Classic Outlook for Windows for your tests, or do not want your signature setup changed, you can simply use the integrated [simulation mode](/details#11-simulation-mode) instead:
- Run Set-OutlookSignatures in a new PowerShell session and add the additional parameters '`-SimulateUser a@example.com -SimulateMailboxes a@example.com`' (replace 'a@example.com' with your own email address or any other email address from your environment).
- Instead of modifying Outlook, your 'Documents' folder now contains new subfolder called 'Outlook Signatures', which in turn contains the signatures of the simulated user.

Congratulations, you now have a robust starting point for your own customizations!

## Customize settings {#customize}
You can now start with your own customizations. Here are a few popular examples:

**Simulation mode**  
Would you like to see what the sample signatures provided look like for another user? Then simply use the integrated [simulation mode](/details#11-simulation-mode):
- Select the email address of any user in your system.
- Run Set-OutlookSignatures in a new PowerShell session and add the additional parameters '`-SimulateUser a@example.com -SimulateMailboxes a@example.com`' (replace 'a@example.com' with the email address you selected earlier).

Your 'Documents' folder now contains new subfolder called 'Outlook Signatures', which in turn contains the signatures of the simulated user.

The [simulation mode](/details#11-simulation-mode) can do much more and is therefore very well suited for testing and analysis in production environments.

**Use your own templates**  
No sample signature is as beautiful as your own. So let's let Set-OutlookSignatures work with your own templates!

- Create a folder with your own templates and configurations. Follow the FAQ '[What is the recommended folder structure for script, license, template and config files?](/faq#34-what-is-the-recommended-folder-structure-for-script-license-template-and-config-files)', as separating source code and customizations makes administration and version upgrades much easier.
  - To get started, simply copy the '.\sample templates' folder and customize the templates and the INI file it contains.
- Run Set-OutlookSignatures again and specify where to find the new templates:
  - '`-SignatureTemplatePath 'c:\your_signature_template_path'`' for the folder where your signature templates are located.
  - '`-SignatureIniFile 'c:\your_signature_template_path\_Signatures.ini'`' for the path to the signature configuration file.
  - If you have customized the HTML templates instead of the DOCX templates, also use '`-UseHtmTemplates true`'.

Does your own signature look good in Outlook? With the [simulation mode](/details#11-simulation-mode), you can quickly find out how it looks for another mailbox.

**And now you!**  
Adjust other [parameters](/parameters) that you find useful.

The [list of features](/features) and [parameter documentation](/parameters) show what is possible.

You can find answers to the most frequently asked questions on our [FAQ page](/faq). For more in-depth information, our [Help and Support Center](/help) offers excellent documentation.

## Show what you've created {#show-what-you-created}
We know that some of you have built visually stunning email signatures, crafted clever out-of-office replies, implemented custom replacement variables, and even integrated third-party systems in ways that go far beyond the basics.

We're looking for:
- Final versions or templates of your email signatures
- Examples of out-of-office replies
- Snippets of custom code or integration logic
- A short statement about your experience with Set-OutlookSignatures or the Benefactor Circle add on
- Your name, role, and company, along with a photo and company logo for your showcase

Just [get in touch](/support) with us!

## Looking for help or more features? {#support}
Set-OutlookSignatures is very well documented, which inevitably brings with it a lot of content.

If you are looking for someone with experience who can quickly train you and assist with evaluation, planning, implementation and ongoing operations: Our partner <a href="https://explicitconsulting.at">ExplicIT Consulting</a> offers first-class [professional support](/support), and their <a href="/benefactorcircle"><span style="font-weight: bold; color: darkgoldenrod;">Benefactor Circle add-on</span></a> adds more enterprise-grade features.

<p>
  <div class="buttons">
    <a href="/support" class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-color: LawnGreen">Support</a>
    <a href="/benefactorcircle" class="button is-link is-normal is-hovered has-text-black has-text-weight-bold" style="background-image: linear-gradient(to bottom right, darkgoldenrod, goldenrod, goldenrod, goldenrod, darkgoldenrod)">The Benefactor Circle add-on</a>
  </div>
</p>
