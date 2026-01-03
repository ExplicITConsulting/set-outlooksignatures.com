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

On Windows and macOS, unblock the file 'Set-OutlookSignatures.ps1'. You can use the PowerShell cmdlet 'Unblock-File' for this, or right-click the file, select Properties and check 'Unblock'. This removes the 'mark of the web', which can prevent script execution in PowerShell.


## Step 2: One-time preparations {#step-2}
###### Client and user {#step-2-client-and-user}
For a first test run, it is recommended to log on with a test user on a Windows system with Word and Classic Outlook on Windows installed, and Classic Outlook on Windows being configured with at least the test user's mailbox. If you use your own user, existing signatures will be overwritten in the worst case.

For full Linux, macOS and New Outlook support, the <a href="/benefactorcircle"><span style="font-weight: bold; color: var(--benefactor-circle-color);">Benefactor Circle add-on</span></a> is required and the mailboxes need to be hosted in Exchange Online.

If you cannot test with Classic Outlook on Windows, or do not want your signature setup changed, you can use simulation mode, which is described in a later step.

###### Entra ID {#step-2-entra-id}
When some or all of your mailboxes are in Exchange Online, you need to register an Entra ID app first. This is because Set-OutlookSignatures needs permissions to access the Graph API.

For governance and security audits, the required configurations for the Entra ID app, including its permissions and the reasons why they are necessary, are documented in '.\sample code\Create-EntraApp.ps1'.

To create the Entra ID app manually, follow the instructions in '.\config\default graph config.ps1'.  
To create the Entra ID app per script, ask your Entra ID 'Global Admin' or 'Application Administrator' to run the following:
```
powershell.exe -noexit -file "c:\test\sample code\Create-EntraApp.ps1" -AppType "Set-OutlookSignatures" -AppName "Set-OutlookSignatures"
```
If you are not using the public Microsoft cloud but a national cloud, just add the parameter '`-CloudEnvironment [AzureUSGovernment|AzureUSGovernmentDoD|AzureChina]`'.

###### Endpoint security {#step-2-endpoint-security}
If the environment requires PowerShell script to be signed with select certificates, or solutions such as AppLocker, Defender, CrowdStrike, Ivanti, and others are used, you may need to specifically allow Set-OutlookSignatures to be run and to load libraries from the TEMP folder (to avoid locking files in their original location).

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

If you are not using the public Microsoft cloud but a national cloud, just add the parameter '`-CloudEnvironment [AzureUSGovernment|AzureUSGovernmentDoD|AzureChina]`'.

Set-OutlookSignatures now adds signatures based on default settings and sample templates to your Classic Outlook.

Open Classic Outlook and take a look at the newly created signatures. 'Formal', 'Informal' and the particularly comprehensive 'Test all default replacement variables'.

If you do not have access to Classic Outlook on Windows for your tests, or do not want your signature setup changed, you can simply use the integrated [simulation mode](/details#11-simulation-mode) instead:
- Run Set-OutlookSignatures in a new PowerShell session and add the additional parameters '`-SimulateUser a@example.com -SimulateMailboxes a@example.com`' (replace 'a@example.com' with your own email address or any other email address from your environment).
- Instead of modifying Outlook, your 'Documents' folder now contains new subfolder called 'Outlook Signatures', which in turn contains the signatures of the simulated user.

Congratulations, you now have a robust starting point for your own customizations!

## Customize settings {#customize}
You can now start with your own customizations. Here are a few popular examples:

###### Simulation mode {#customize-simulation-mode}
Would you like to see what the sample signatures provided look like for another user? Then simply use the integrated [simulation mode](/details#11-simulation-mode):
- Select the email address of any user in your system.
- Run Set-OutlookSignatures in a new PowerShell session and add the additional parameters '`-SimulateUser a@example.com -SimulateMailboxes a@example.com`' (replace 'a@example.com' with the email address you selected earlier).

Your 'Documents' folder now contains new subfolder called 'Outlook Signatures', which in turn contains the signatures of the simulated user.

The [simulation mode](/details#11-simulation-mode) can do much more and is therefore very well suited for testing and analysis in production environments.

###### Use your own templates {#customize-use-your-own-templates}
No sample signature is as beautiful as your own. So let's let Set-OutlookSignatures work with your own templates!

- Create a folder with your own templates and configurations. Follow the FAQ '[What is the recommended folder structure for script, license, template and config files?](/faq#34-what-is-the-recommended-folder-structure-for-script-license-template-and-config-files)', as separating source code and customizations makes administration and version upgrades much easier.
  - To get started, simply copy the '.\sample templates' folder and customize the templates and the INI file it contains.
- Run Set-OutlookSignatures again and specify where to find the new templates:
  - '`-SignatureTemplatePath 'c:\your_signature_template_path'`' for the folder where your signature templates are located.
  - '`-SignatureIniFile 'c:\your_signature_template_path\_Signatures.ini'`' for the path to the signature configuration file.
  - If you have customized the HTML templates instead of the DOCX templates, also use '`-UseHtmTemplates true`'.

Does your own signature look good in Outlook? With the [simulation mode](/details#11-simulation-mode), you can quickly find out how it looks for another mailbox.

## And now you! {#and-now-you}
Adjust other [parameters](/parameters) that you find useful. The [list of features](/features) and [parameter documentation](/parameters) show what is possible.

You can find answers to the most frequently asked questions on our [FAQ page](/faq). For more in-depth information, our [Help and Support Center](/help) offers excellent documentation.

When planning your rollout, make sure to read the following documents first:
- '[Organizational implementation approach](/implementationapproach)' basically covers the whole organizational product lifecycle from defining requirements to operational responsibilities.
- '[Technical details, requirements and usage](/details)' describes what Set-OutlookSignatures needs, how it works and how to use it. Its 'Architecture options and considerations' chapter is essential for understanding its different operation modes and choosing the ideal configuration for your environment.

###### Show what you've created {#show-what-you-created}
We know that some of you have built visually stunning email signatures, crafted clever out-of-office replies, implemented custom replacement variables, and even integrated third-party systems in ways that go far beyond the basics.

We're looking for:
- Final versions or templates of your email signatures
- Examples of out-of-office replies
- Snippets of custom code or integration logic
- A short statement about your experience with Set-OutlookSignatures or the Benefactor Circle add on
- Your name, role, and company, along with a photo and company logo for your showcase

Just [get in touch](/support) with us!
