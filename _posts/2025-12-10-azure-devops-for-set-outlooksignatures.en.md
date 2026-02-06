---
layout: "post"
lang: "en"
locale: "en"
title: "Azure DevOps for Set-OutlookSignatures"
description: "How AIMTEC has implemented a robust, automated, and dynamic signature management solution using Azure DevOps to work seamlessly with Set-OutlookSignatures."
published: true
tags: 
slug: "azure-devops-for-set-outlooksignatures"
permalink: "/blog/:year/:month/:day/:slug"
sitemap_priority: 0.5
sitemap_changefreq: monthly
---
Hello to the Set-OutlookSignatures community!

My name is Jiří Hrabák, I am an ICT Senior Consultant at [AIMTEC a. s.](https://www.aimtecglobal.com). AIMTEC provides digitalisation, automation, and IT solutions—covering systems like SAP, advanced planning, and end-to-end logistics management.

I'm excited to share how we've implemented a robust, automated, and dynamic signature management solution using Azure DevOps Pipelines to work seamlessly with Set-OutlookSignatures.

We’ve automated the generation and deployment of user signatures and the Outlook Add-in, ensuring consistency and up-to-date information across our organization, all driven by user attributes in Active Directory/Entra ID.

## Our Setup: Signatures as Code via Azure Services
Our solution relies on a well-structured setup involving three Git repositories and Azure cloud services.

1. The Repository Structure
We utilize three distinct repositories within our Git system:
   - MKT_outlook_signatures_templates: Stores our signature templates, with a main branch for production and a test branch for testing new designs.
   - MKT_outlook_signatures: Contains the core PowerShell script for the signature template generator and the license file for the Benefactor Circle add-on.
   - MKT_outlook_signatures_plugin: Holds the source code, Continuous Integration (CI), and pipeline definitions for deploying the Outlook Add-in (plugin).
2. Azure Static App for the Plugin  
  The Outlook Add-in (plugin) is hosted on an Azure Static Web App using the free tier. We use its environment feature for separation:
      - Production: Mapped to a custom domain (e.g., https://outlookaddin.example.com).
      - Development: Uses the generated Azure domain (e.g., https://outlookaddin-development.example.com).

The pipeline handles deployment using environment-specific variables defined in the azure-static-aimoutlooksignatures variable group:
```
variables:
  - ${{ if eq(variables['Build.SourceBranchName'], 'main') }}:
    - name: targetEnvironment
      value: 'Production'
  - ${{ else }}:
    - name: targetEnvironment
      value: 'Development'
```

## Automated signature generation pipeline
The real power of our setup comes from the automated signature generation pipeline, which is triggered automatically based on user changes in our HR system.

### Triggering the Signature Update
Our Human Resources Management (HRM) system updates user attributes in Active Directory/Entra ID.

We use Extension attribute 1 as a trigger: If this attribute is updated from 0 to 1, the pipeline is triggered for that specific user.

### The Signature Generation Process
The template generator pipeline uses a parameterized approach to define the target user (UPN) and the signature template version.
```
  - name: UPN
    type: object
    default: ['xx@yy', 'xx@yy']

  - name: version
    type: string
    default: '4.23.0'
```

The core steps within the job use the powerful SimulateAndDeploy feature:
1. Temporary mailbox permissions  
  The script first connects to Exchange Online. To allow the signature generation service account (signature-service@example.com) to apply the signature, the script temporarily grants Full Access mailbox permission.
    ```
    Add-MailboxPermission -Identity $email -User "signature-service@example.com" -AccessRights "fullaccess" -Confirm:$false
    ```
2. Run Set-OutlookSignatures  
  The pipeline executes the Generate-signatures-devops.ps1 script, which then calls Set-OutlookSignatures.ps1 using the required parameters to deploy the signature directly to the user's mailbox.  
    ```
    $SimulateAndDeployParams = @{
      # Define parameters here
    }
    
    & ./Set-OutlookSignatures_v$version/sample code/SimulateAndDeploy.ps1 @SimulateAndDeployParams
    ```
3. Remove temporary permissions  
  Immediately after deployment, the temporary Full Access permission is revoked for security, and the extension attribute is reset.
    ```
    Remove-MailboxPermission -Identity $email -User "signature-service@example.com" -AccessRights FullAccess -Confirm:$false

    Set-Mailbox -Identity $email -CustomAttribute1 $null
    ```

## Technical Rationale for the Outlook Add-in
The decision to use the Outlook add-in, which is hosted on an Azure Static Web App, is based on two key technical advantages:
- Platform Support (macOS): While Set-OutlookSignatures supports roaming signatures and downloading/uploading them for macOS Outlook, the add-in ensures consistent functionality across all platforms. We do not need to care about the client that is used to access the mailbox.
- Centralized Deployment Efficiency: The add-in is used in combination with the SimulateAndDeploy parameter. This method allows the Azure DevOps pipeline to deploy the signature directly to the user's mailbox without requiring any script or work to be run on the client device. This eliminates client-side execution and is considered a more elegant and less labor-intensive solution.

The add-in manifest is deployed via the pipeline to the Azure Static Web App, using the free tier.
```
- task: AzureStaticWebApp@0
  inputs:
    azure_static_web_apps_api_token: $(deploy-token)
    # ...
    workingDirectory: "$(Pipeline.Workspace)/manifest"
    skip_app_build: true # boolean. Skip app build.
    skip_api_build: true # boolean. Skip api build.
    app_location: "/" # App source code path
    # ...
    deployment_environment: "$(targetEnvironment)"
```

## Conclusion
This dynamic, attribute-driven approach provides a reliable, code-centric solution for signature management, ensuring our signatures are consistent and up-to-date with minimal manual intervention.

Jiří Hrabák, ICT Senior Consultant, [AIMTEC a. s.](https://www.aimtecglobal.com)

## Interested in learning more or seeing our solution in action?
[Contact us](/support) or explore further on our [website](/). We look forward to getting to know you!