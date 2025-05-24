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

## Quick Start Guide
Deploy your first signatures in less than an hour!

1. For a first test run, it is recommended to log on with a test user on a Windows system with Word and Outlook installed, and Outlook being configured with at least the test user's mailbox. This way, you get results fast and can experience the biggest set of features.
   - For full Linux and macOS support, the Benefactor Circle add-on (see <a href="/benefactorcircle" target="_blank">'.\docs\Benefactor Circle'</a> and is required and the mailboxes need to be hosted in Exchange Online.
2. Download Set-OutlookSignatures and extract the archive to a local folder
   - On Windows and macOS, unblock the file 'Set-OutlookSignatures.ps1'. You can use the PowerShell cmdlet 'Unblock-File' for this, or right-click the file in File Explorer, select Properties and check 'Unblock'. This removes the "mark of the web", which can prevent script execution when the PowerShell execution policy is set to RemoteSigned.
3. If you use AppLocker or a comparable solution (Defender, CrowdStrike, Ivanti, and others), you may need to add the existing digital file signature to your allow list, or define additional settings in your security software.
4. Now it is time to run Set-OutlookSignatures for the first time
   - **If _all mailboxes_ are in Exchange _on-prem only_ and the logged-in user has access to the on-prem Active Directory:**<br>Just run 'Set-OutlookSignatures.ps1' in PowerShell.<br>For best results, don't run the software by double clicking it in File Explorer, or via right-click and 'Run'. Instead, run the following command:
   
      ```batch
      powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1"
      ```

   - **If _some or all mailboxes_ are in Exchange _Online_:**
     1. You need to register an Entra ID app first, because Set-OutlookSignatures needs permissions to access the Graph API.
          - To create the Entra ID app, run '`.\sample code\Create-EntraApp.ps1 -AppType 'Set-OutlookSignatures' -AppName 'Set-OutlookSignatures'`' and follow the instructions. You will need an Entra ID user with 'Global Admin' or 'Application Administrator' permissions.
          - See '`.\config\default graph config.ps1`' for details about the required application settings, permissions, and why they are needed.
     2. Run Set-OutlookSignatures
        - **If _all mailboxes_ are in Exchange _Online_, or you are in a hybrid environment _without_ synchronizing all required Exchange attributes to on-prem** (mail, legacyExchangeDN, msExchRecipientTypeDetails, msExchMailboxGuid, proxyAddresses):

          ```batch
          powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1" -GraphOnly true -GraphClientId "<GraphClientId from step 1>"
          ```

          Always choose this option if you are in **hybrid mode and directly create new mailboxes in Exchange Online**, as at least the required attribute msExchMailboxGuid is not synchronized to on-prem in this case. See https://learn.microsoft.com/en-US/exchange/troubleshoot/move-mailboxes/migrationpermanentexception-when-moving-mailboxes for details and two possible workarounds.

          The '`-GraphOnly true`' parameter makes sure that on-prem Active Directory is ignored and only Graph/Entra ID is used to find mailboxes and their attributes.
        - **If _all mailboxes_ are in a hybrid environment _with_ synchronizing all required Exchange attributes to on-prem** (mail, legacyExchangeDN, msExchRecipientTypeDetails, msExchMailboxGuid, proxyAddresses):

          ```batch
          powershell.exe -noexit -file "c:\test\Set-OutlookSignatures.ps1" -GraphClientId "<GraphClientID from step 1>"
          ```

          This runs Set-OutlookSignatures with default parameters, preferring on-prem Active Directory to find mailboxes and their attributes, and only using Graph/Entra ID when neccessary.
        - If you are not using the public Microsoft Cloud, add the parameter '`-CloudEnvironment [AzureUSGovernment|AzureUSGovernmentDoD|AzureChina]`' parameter.
<p></p>
Set-OutlookSignatures now runs using default settings and sample templates.<br>Because of the '`-noexit`' parameter, the window hosting Set-OutlookSignatures will not close after the software completed. This is helpful for debugging and learning.<br><br>

Next, check the script output for errors, displayed in red in the PowerShell console.
- If there are no errors, switch to Outlook and have a look at the newly created signatures, especially to the showcase signature named '`Test all default replacement variables`'.
- If there is an error:
  1. Read the message carefully as it may contain hints on how to resolve the issue.  
  2. Check if the README file contains a hint.
  3. Check if someone has already reported the problem as and issue on [GitHub](https://github.com/Set-OutlookSignatures/Set-OutlookSignatures/issues?q=is%3Aissue), and create a new one if you can't find any hint on how to solve it. You can also switch to the fast lane: [ExplicIT Consulting](https://explicitconsulting.at) offers first-class fee-based support.

When everything runs fine with default settings, it is time to start customizing the software behavior to your needs:
- Create a folder with your own template files and signature configuration file.
  - Start with DOCX templates. See the FAQ '`Should I use .docx or .htm as file format for templates?`' for details.
  - See the following chapters for instructions:
    - Signature and OOF file format
    - Signature template file naming
    - Template tags and INI files
  - Make sure to pass the parameters '`SignatureTemplatePath`', '`SignatureIniFile`', '`OOFTemplatePath`' and '`OOFIniFile`' to Set-OutlookSignatures.
- Adapt other parameters you may find useful, or start experimenting with simulation mode.<br>The feature list and the parameter documentation show what's possible.<br><br>

It is strongly recommended to not change any Set-OutlookSignatures files and keep them as they are. If you consequently work with script parameters and keep customized configuration files in a separate folder, upgrading to a new version is basically just a file copy operation (drop-in replacement).

Regarding configuration files: Besides the template configuration files for signatures and OOF messages, there are the Graph configuration file and the replacement variable configuration file.  
It is rarely needed to change the configuration within these files.<br>The configuration files themselves contain specific information on how to use them.<br>The configuration files are referenced in the documentation whenever there is a need or option to change them.

You also have access to '`.\docs\Implementation approach`', a document covering the organizational aspects of introducing Set-OutlookSignatures.
The content is based on real life experiences implementing the software in multi-client environments with a five-digit number of mailboxes.  
It contains proven procedures and recommendations for product managers, architects, operations managers, account managers and email and client administrators. It is suited for service providers as well as for clients.  
It covers several general overview topics, administration, support, training across the whole lifecycle from counselling to tests, pilot operation and rollout up to daily business.

**Set-OutlookSignatures is very well documented, which inevitably brings with it a lot of content.** If you are looking for someone with experience who can quickly train you and assist with evaluation, planning, implementation and ongoing operations: Our partner [ExplicIT Consulting](https://explicitconsulting.at) offers first-class fee-based support and the [Benefactor Circle add-on](https://set-outlooksignatures.com/benefactorcircle), adding more enterprise-grade features.