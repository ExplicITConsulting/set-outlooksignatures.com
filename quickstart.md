---
layout: page
title: Quick Start Guide
subtitle: First signatures in less than an hour
description: First signatures in less than an hour
image:
  path: "/assets/images/set-outlooksignatures benefactor circle opengraph1200x630.png"
  height: 1200
  width: 630
  alt: "Set-OutlookSignatures Benefactor Circle"
page_id: "quickstart"
permalink: /quickstart
---


## Step 1: Download Set-OutlookSignatures {#step-1}
Download Set-OutlookSignatures and extract the archive to a local folder.

<p><a href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-color: limegreen">➔ Download software</button></a></p>

On Windows and macOS, unblock the file 'Set-OutlookSignatures.ps1'. You can use the PowerShell cmdlet 'Unblock-File' for this, or right-click the file in File Explorer, select Properties and check 'Unblock'. This removes the 'mark of the web', which can prevent script execution in PowerShell.


## Step 2: One-time preparations {#step-2}
**Client and user**  
For a first test run, it is recommended to log on with a test user on a Windows system with Word and Outlook installed, and Outlook being configured with at least the test user's mailbox. If you use your own user, existing signatures will be overwritten in the worst case.

For full Linux and macOS support, the <a href="/benefactorcircle"><span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle add-on</span></a> is required and the mailboxes need to be hosted in Exchange Online.

**Entra ID**  
When some or all of your mailboxes are in Exchange Online, you need to register an Entra ID app first. This is because Set-OutlookSignatures needs permissions to access the Graph API.

To create the Entra ID app, ask your Entra ID 'Global Admin' or 'Application Administrator' to run the following and follow the instructions:
```
.\sample code\Create-EntraApp.ps1 -AppType 'Set-OutlookSignatures' -AppName 'Set-OutlookSignatures'
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
  The '-GraphOnly true' parameter makes sure that on-prem Active Directory is ignored and only Graph/Entra ID is used to find mailboxes and their attributes.

If you are not using the public Microsoft cloud but a national cloud, add the following parameter: '-CloudEnvironment \[AzureUSGovernment\|AzureUSGovernmentDoD\|AzureChina\]'

Set-OutlookSignatures now deploys signatures using default settings and sample templates.

Open Outlook and have a look at the newly created signatures, especially to the showcase signature named 'Test all default replacement variables'.


## Start customizing {#customize}
When everything runs fine with default settings, you have a robust starting point for your own customizations.

You can now configure Set-OutlookSignatures to your own needs. For example:
- Create a folder with your own template and signature configuration files.  
  It is a good idea to begin by copying the folder '.\sample templates' and modifying it's contents.  
  Make sure to tell Set-OutlookSignatures where to find your custom configuration by adding the parameters 'SignatureTemplatePath', 'SignatureIniFile', 'OOFTemplatePath' and 'OOFIniFile'.
- Adapt other [parameters](/parameters) you may find useful.
- Start using [simulation mode](/parameters/#16-simulateuser).

The [feature list](/features) and the [parameter documentation](/parameters) show what's possible.

The [FAQ section](/faq) helps you find answer to the most popular questions we get asked. For a deep dive, our [help and support center](/help) has great ressources.


## Looking for help or more features? {#support}
Set-OutlookSignatures is very well documented, which inevitably brings with it a lot of content.

If you are looking for someone with experience who can quickly train you and assist with evaluation, planning, implementation and ongoing operations: Our partner <a href="https://explicitconsulting.at">ExplicIT Consulting</a> offers top-notc [professional support](/support), and their <a href="/benefactorcircle"><span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent;">Benefactor Circle add-on</span></a> adds more enterprise-grade features.

<p><a href="/support"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-color: limegreen">➔ See support options</button></a></p>

<p><a href="/benefactorcircle"><button class="button is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod)">➔ The Benefactor Circle add-on</button></a></p>
