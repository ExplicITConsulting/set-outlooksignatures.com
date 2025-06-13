---
layout: page
title: |
  <span class="title is-2 has-text-white">
    Quick Start Guide
  </span>
subtitle: |
  <span class="subtitle is-4 has-text-white">
    Deploy your first signatures in less than an hour
  </span>
description: |
  Quick Start Guide. Implementation help. Deploy your first signatures in less than an hour.
image:
  path: "/assets/images/set-outlooksignatures benefactor circle opengraph1200x630.png"
  height: 1200
  width: 630
  alt: "Set-OutlookSignatures Benefactor Circle"
redirect_from:
  - /quick
  - /quick-start
  - /quickstartguide
  - /quickstart-guide
  - /quick-start-guide
---

## Deploy your first signatures in less than an hour
Follow the easy 4-step-process to deploy your first signatures, get a glimpse of what Set-OutlookSignatures can do, and create a robust starting point for your own customizations.


## Step 1: Check Prerequisites
For a first test run, it is recommended to log on with a test user on a Windows system with Word and Outlook installed, and Outlook being configured with at least the test user's mailbox. This way, you get results fast and can experience the biggest set of features.

For full Linux and macOS support, the <a href="/benefactorcircle"><span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent; text-decoration: underline;">Benefactor Circle add-on</span></a> is required and the mailboxes need to be hosted in Exchange Online.

When some or all of your mailboxes are in Exchange Online, you need a 'Global Admin' or 'Application Administrator' user for one-time preparations.


## Step 2: Download Set-OutlookSignatures
Download Set-OutlookSignatures and extract the archive to a local folder.

<p><a id="download-link" href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" target="_blank"><button class="button mtrcs-external-link is-link is-normal is-hover has-text-black has-text-weight-bold" style="background-color: lawngreen">➔ Download&nbsp;<span class="version-text">the latest release</span>&nbsp;as ZIP file</button></a></p>

On Windows and macOS, unblock the file 'Set-OutlookSignatures.ps1'. You can use the PowerShell cmdlet 'Unblock-File' for this, or right-click the file in File Explorer, select Properties and check 'Unblock'. This removes the "mark of the web", which can prevent script execution when the PowerShell execution policy is set to RemoteSigned.

If you use AppLocker or a comparable solution (Defender, CrowdStrike, Ivanti, and others), you may need to add the existing digital file signature to your allow list, or define additional settings in your security software.


## Step 3: Prepare Entra ID
When some or all of your mailboxes are in Exchange Online, you need to register an Entra ID app first, because Set-OutlookSignatures needs permissions to access the Graph API.

To create the Entra ID app, ask a 'Global Admin' or 'Application Administrator' to run
```
.\sample code\Create-EntraApp.ps1 -AppType 'Set-OutlookSignatures' -AppName 'Set-OutlookSignatures'
```
and follow the instructions.

The code in the script file is well documented, containing all details about the required Entra ID app settings, permissions, and why they are needed.


## Step 4: Run Set-OutlookSignatures
- **If all mailboxes are in Exchange on-prem**
  ```
  powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1"
  ```

- **If some or all mailboxes are in Exchange Online**
  ```
  powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1" -GraphOnly true -GraphClientId "<GraphClientId from step 3>"
  ```
  The '-GraphOnly true' parameter makes sure that on-prem Active Directory is ignored and only Graph/Entra ID is used to find mailboxes and their attributes.

If you are not using the public Microsoft cloud but a national cloud, add the following parameter:
```
-CloudEnvironment [AzureUSGovernment|AzureUSGovernmentDoD|AzureChina]
```

Set-OutlookSignatures now deploys your first signatures using default settings and sample templates.

Open Outlook and have a look at the newly created signatures, especially to the showcase signature named 'Test all default replacement variables'.


## Start customizing
When everything runs fine with default settings, it is time for you to start customizing the software behavior to your needs. For example:
- Create a folder with your own template and signature configuration files.  
  It is a good idea to begin by copying the folder '.\sample templates' and modifying it's contents.  
  Make sure to tell Set-OutlookSignatures where to find your custom configuration by adding the parameters 'SignatureTemplatePath', 'SignatureIniFile', 'OOFTemplatePath' and 'OOFIniFile'.
- Adapt other [parameters](/parameters) you may find useful.
- Start using [simulation mode](/parameters/#16-simulateuser).

The [feature list](/features) and the [parameter documentation](/parameters) show what's possible.

The [FAQ section](/faq) helps you find answer to the most popular questions we get asked. For a deep dive, our [help and support center](/help) has great ressources.


## Looking for help or more features?
Set-OutlookSignatures is very well documented, which inevitably brings with it a lot of content.

If you are looking for someone with experience who can quickly train you and assist with evaluation, planning, implementation and ongoing operations: Our partner <a href="https://explicitconsulting.at" target="_blank">ExplicIT Consulting</a> offers first-class [fee-based support](/support), and their <a href="/benefactorcircle"><span style="font-weight: bold; background-image: linear-gradient(to right, darkgoldenrod, goldenrod, darkgoldenrod, goldenrod, darkgoldenrod); background-clip: text; color: transparent; text-decoration: underline;">Benefactor Circle add-on</span></a> adds more enterprise-grade features.


<script>
  fetch('https://api.github.com/repos/Set-OutlookSignatures/Set-OutlookSignatures/releases/latest')
    .then(response => response.json())
    .then(data => {
      document.querySelectorAll('.version-text').forEach(span => {
        span.textContent = data.tag_name;
      });

      document.getElementById('download-link').href = 
        `https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases/download/${data.tag_name}/Set-OutlookSignatures_${data.tag_name}.zip`;
    })
    .catch(error => {
      console.error('Error fetching release info:', error);
    });
</script>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    const lang = navigator.language || navigator.userLanguage || 'en';
    const path = window.location.pathname;
    const search = window.location.search;
    const hash = window.location.hash;

    const isGerman = lang.toLowerCase().startsWith('de');
    const isAlreadyInDe = path.startsWith('/de');

    if (isGerman && !isAlreadyInDe) {
      const targetUrl = '/de' + path + search;

      fetch(targetUrl, { method: 'HEAD' })
        .then(response => {
          if (response.ok) {
            window.location.href = targetUrl + hash;
          } else {
            window.location.href = '' + path + search + hash;
          }
        })
        .catch(() => {
          window.location.href = '' + path + search + hash;
        });
    } else if (!isGerman && isAlreadyInDe) {
      // Optional: redirect non-German users away from /de
      const newPath = path.replace(/^\/de/, '') || '/';
      window.location.href = newPath + search + hash;
    }
  });
</script>
