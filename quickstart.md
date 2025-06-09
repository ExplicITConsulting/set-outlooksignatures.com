---
layout: page
title: |
  <p class="has-text-white">
    Quick Start Guide
  </p>
subtitle: |
  <p class="subtitle is-3 has-text-white">
    Deploy your first signatures in less than an hour!
  </p>
description: |
  Quick Start Guide. Implementation help. Deploy your first signatures in less than an hour!
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

## Deploy your first signatures in less than an hour!
Follow the easy 4-step-process to deploy your first signatures, get a glimpse of what Set-OutlookSignatures can do, and create a robust starting point for your own customizations.


## Step 1: Check Prerequisites
For a first test run, it is recommended to log on with a test user on a Windows system with Word and Outlook installed, and Outlook being configured with at least the test user's mailbox. This way, you get results fast and can experience the biggest set of features.

For full Linux and macOS support, the <a href="/benefactorcircle" target="_blank">Benefactor Circle add-on</a> is required and the mailboxes need to be hosted in Exchange Online.

When some or all of your mailboxes are in Exchange Online, you need a 'Global Admin' or 'Application Administrator' user for one-time preparations.


## Step 2: Download Set-OutlookSignatures
Download Set-OutlookSignatures and extract the archive to a local folder.

<p><a id="download-link" href="https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/releases" target="_blank"><button class="button is-link is-normal is-hover">Download&nbsp;<span class="version-text">the latest release</span>&nbsp;as ZIP file</button></a></p>

On Windows and macOS, unblock the file 'Set-OutlookSignatures.ps1'. You can use the PowerShell cmdlet 'Unblock-File' for this, or right-click the file in File Explorer, select Properties and check 'Unblock'. This removes the "mark of the web", which can prevent script execution when the PowerShell execution policy is set to RemoteSigned.

If you use AppLocker or a comparable solution (Defender, CrowdStrike, Ivanti, and others), you may need to add the existing digital file signature to your allow list, or define additional settings in your security software.


## Step 3: Prepare Entra ID
When some or all of your mailboxes are in Exchange Online, you need to register an Entra ID app first, because Set-OutlookSignatures needs permissions to access the Graph API.

To create the Entra ID app, ask a 'Global Admin' or 'Application Administrator' to run '`.\sample code\Create-EntraApp.ps1 -AppType 'Set-OutlookSignatures' -AppName 'Set-OutlookSignatures'`' and follow the instructions.

See '`.\config\default graph config.ps1`' for details about the required application settings, permissions, and why they are needed.


## Step 4: Run Set-Outlook Signatures
- **If _all mailboxes_ are in Exchange _on-prem only_**
  ```batch
  powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1"
  ```

- **If _some or all mailboxes_ are in Exchange _Online_**
  ```batch
  powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1" -GraphOnly true -GraphClientId "<GraphClientId from step 3>"
  ```
  The '`-GraphOnly true`' parameter makes sure that on-prem Active Directory is ignored and only Graph/Entra ID is used to find mailboxes and their attributes.

If you are not using the public Microsoft Cloud, add the parameter '`-CloudEnvironment [AzureUSGovernment|AzureUSGovernmentDoD|AzureChina]`' parameter.

Congratulations! Set-OutlookSignatures now deploys your first signatures using default settings and sample templates.

Open Outlook and have a look at the newly created signatures, especially to the showcase signature named '`Test all default replacement variables`'.


## Start customization
When everything runs fine with default settings, it is time for you to start customizing the software behavior to your needs:
- Create a folder with your own template files and signature configuration file.
  - Your may want to start with DOCX templates, as this is often the easiest way.<br>See the FAQ '`Should I use .docx or .htm as file format for templates?`' for details.
  - See the following chapters for instructions:
    - Signature and OOF file format
    - Signature template file naming
    - Template tags and INI files
  - Make sure to pass the parameters '`SignatureTemplatePath`', '`SignatureIniFile`', '`OOFTemplatePath`' and '`OOFIniFile`' to Set-OutlookSignatures.
- Adapt other parameters you may find useful, or start experimenting with simulation mode. The feature list and the parameter documentation show what's possible.

It is strongly recommended to not change any Set-OutlookSignatures files and keep them as they are. If you consequently work with script parameters and keep customized configuration files in a separate folder, upgrading to a new version is basically just a file copy operation (drop-in replacement).

Regarding configuration files: Besides the template configuration files for signatures and OOF messages, there are the Graph configuration file and the replacement variable configuration file.  
It is rarely needed to change the configuration within these files.  
The configuration files themselves contain specific information on how to use them. They are referenced in the documentation whenever there is a need or option to change them.

You also have access to '`.\docs\Implementation approach`', a document covering the organizational aspects of introducing Set-OutlookSignatures.  
The content is based on real life experiences implementing the software in multi-client environments with a five-digit number of mailboxes.

**Set-OutlookSignatures is very well documented, which inevitably brings with it a lot of content.**  
If you are looking for someone with experience who can quickly train you and assist with evaluation, planning, implementation and ongoing operations: Our partner [ExplicIT Consulting](https://explicitconsulting.at) offers first-class fee-based support, and their [Benefactor Circle add-on](https://set-outlooksignatures.com/benefactorcircle) adds more enterprise-grade features.



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