---
layout: "post"
lang: "en"
locale: "en"
title: "Delegate Out-of-Office Management with Exchange RBAC"
description: "Delegate mailbox automatic-reply management through scoped Exchange RBAC roles without granting broad administrative access."
slug: "delegate-oof"
published: true
tags:
show_sidebar: true
sitemap_priority: 0.5
sitemap_changefreq: monthly
---

Managing automatic replies for department mailboxes should not require broad Exchange administrator rights. Exchange RBAC can delegate this specific mailbox-options task to selected users while limiting their access to mailboxes within a defined department scope.

This is useful when a shared mailbox needs a temporary response, a mailbox owner is unexpectedly absent, or a department coordinator must update an out-of-office message outside normal support hours. The delegated user needs access to the automatic-reply configuration, but not to unrelated Exchange settings or mailboxes belonging to other departments.

This article shows a practical model for delegating out-of-office management to selected common end users. They are not made Exchange administrators. They only receive the specific RBAC role entries required to manage automatic replies for mailboxes in their department scope.

It also fits well into a broader governance model for signatures and out-of-office replies. Set-OutlookSignatures and the Benefactor Circle add-on can centrally create and deploy out-of-office replies for internal and external recipients using template tags and INI files. This RBAC pattern complements that approach when selected users need controlled manual access to the same mailbox setting. See [Template tags and INI files](https://set-outlooksignatures.com/details#template-tags-and-ini-files).

The target design is:

- create two dedicated roles based on `MyBaseOptions`;
- keep the supporting role entries that Outlook on the web / ECP expects for this mailbox-options scenario;
- use `OOF-Management-FullControl` when delegated users may enable, disable, schedule, and edit automatic-reply text;
- use `OOF-Management-ToggleOnly` when delegated users may only enable, disable, or schedule automatic replies;
- restrict the write scope by the `Department` attribute;
- delegate access through role groups;
- verify the result with PowerShell and Outlook on the web / ECP.

All names, departments, mailboxes, companies, and domains in this article are fictitious. Replace them with values from your own environment.

## Why this uses `MyBaseOptions`

This scenario is not about creating another admin tier. It is about allowing selected end users to perform one mailbox-options task for a controlled set of mailboxes: manage automatic replies.

That is why the roles should be based on `MyBaseOptions`. `MyBaseOptions` is the end-user mailbox options role. In a normal self-service scenario, it allows users to manage basic options for their own mailbox. By creating scoped child roles from `MyBaseOptions`, reducing the available role entries, and assigning those roles through scoped role groups, the same mailbox-options capability can be delegated for a department-limited target set.

The naming pattern in this article uses two final roles only:

- `OOF-Management-FullControl`
- `OOF-Management-ToggleOnly`

A working out-of-office role commonly contains these four role entries:

- `Import-RecipientDataProperty`
- `Get-MailboxAutoReplyConfiguration`
- `Set-ADServerSettings`
- `Set-MailboxAutoReplyConfiguration`

At first glance, only the two auto-reply cmdlets look necessary. In practice, the additional entries are important for the Outlook on the web / ECP mailbox-options experience:

- `Import-RecipientDataProperty` remains from `MyBaseOptions` and is part of the mailbox options role surface.
- `Set-ADServerSettings` supports directory view behavior in the Exchange session.
- `Get-MailboxAutoReplyConfiguration` reads the current automatic-reply state.
- `Set-MailboxAutoReplyConfiguration` writes the automatic-reply state, schedule, audience, and message text.

## When central deployment is the better fit

RBAC delegation is useful when a selected group of users must manually manage automatic replies for specific department mailboxes. It is not the only governance model.

If the goal is to centrally standardize and distribute out-of-office replies across many users or mailboxes, the Benefactor Circle add-on can be the better operational fit. Together with Set-OutlookSignatures, it can use template tags and INI files to deploy out-of-office replies for internal and external recipients from centrally managed templates. See [Template tags and INI files](https://set-outlooksignatures.com/details#template-tags-and-ini-files).

A practical split is:

- use Set-OutlookSignatures and the Benefactor Circle add-on for centralized, template-driven OOF deployment;
- use the RBAC model in this article when selected users need controlled mailbox-level OOF management;
- use department scopes so manual delegation stays limited and auditable.

## Step 1: Create the full-control role

Create the full-control role directly from `MyBaseOptions`.

```powershell
New-ManagementRole -Name "OOF-Management-FullControl" -Parent "MyBaseOptions"
```

Remove everything except the four role entries required for the out-of-office mailbox-options scenario.

```powershell
Get-ManagementRoleEntry "OOF-Management-FullControl\*" |
    Where-Object {
        $_.Name -notin @(
            "Import-RecipientDataProperty",
            "Get-MailboxAutoReplyConfiguration",
            "Set-ADServerSettings",
            "Set-MailboxAutoReplyConfiguration"
        )
    } |
    Remove-ManagementRoleEntry -Confirm:$false
```

Then explicitly set the parameters on `Set-MailboxAutoReplyConfiguration`. This creates the full-control role that can enable, disable, schedule, and edit automatic replies.

```powershell
Set-ManagementRoleEntry "OOF-Management-FullControl\Set-MailboxAutoReplyConfiguration" `
    -Parameters AutoDeclineFutureRequestsWhenOOF,AutoReplyState,Confirm,CreateOOFEvent,Debug,DeclineAllEventsForScheduledOOF,DeclineEventsForScheduledOOF,DeclineMeetingMessage,DomainController,EndTime,ErrorAction,ErrorVariable,EventsToDeleteIDs,ExternalAudience,ExternalMessage,Identity,IgnoreDefaultScope,InternalMessage,OOFEventSubject,OutBuffer,OutVariable,StartTime,Verbose,WarningAction,WarningVariable,WhatIf
```

Example full-control operation:

```powershell
Set-MailboxAutoReplyConfiguration `
    -Identity "shared.operations@example.com" `
    -AutoReplyState Scheduled `
    -StartTime "2026-07-01 08:00" `
    -EndTime "2026-07-15 17:00" `
    -InternalMessage "I am currently out of office." `
    -ExternalMessage "Thank you for your message. I am currently out of office." `
    -ExternalAudience All
```

## Step 2: Create the toggle-only role

Create the toggle-only role directly from `MyBaseOptions`.

```powershell
New-ManagementRole -Name "OOF-Management-ToggleOnly" -Parent "MyBaseOptions"
```

Remove everything except the same four role entries used by the full-control scenario.

```powershell
Get-ManagementRoleEntry "OOF-Management-ToggleOnly\*" |
    Where-Object {
        $_.Name -notin @(
            "Import-RecipientDataProperty",
            "Get-MailboxAutoReplyConfiguration",
            "Set-ADServerSettings",
            "Set-MailboxAutoReplyConfiguration"
        )
    } |
    Remove-ManagementRoleEntry -Confirm:$false
```

Restrict `Set-MailboxAutoReplyConfiguration` to state and schedule parameters only.

```powershell
Set-ManagementRoleEntry "OOF-Management-ToggleOnly\Set-MailboxAutoReplyConfiguration" `
    -Parameters AutoReplyState,StartTime,EndTime,Identity,Confirm,WhatIf,Verbose,Debug,ErrorAction,ErrorVariable,OutBuffer,OutVariable,WarningAction,WarningVariable
```

A toggle-only user should be able to run:

```powershell
Set-MailboxAutoReplyConfiguration `
    -Identity "shared.operations@example.com" `
    -AutoReplyState Enabled
```

And should not be able to run:

```powershell
Set-MailboxAutoReplyConfiguration `
    -Identity "shared.operations@example.com" `
    -InternalMessage "Changed by delegated user"
```

Expected result:

```text
A parameter cannot be found that matches parameter name 'InternalMessage'.
```

If the delegated users are expected to work mainly through Outlook on the web / ECP, prefer the full-control role unless you have tested the toggle-only UI behavior. The UI may submit message fields as part of the save operation.

## Step 3: Confirm the role entries

Check the full-control role.

```powershell
Get-ManagementRoleEntry "OOF-Management-FullControl\*" |
    Select-Object Name,Role,Parameters |
    ConvertTo-Json -Depth 5
```

Check the toggle-only role.

```powershell
Get-ManagementRoleEntry "OOF-Management-ToggleOnly\*" |
    Select-Object Name,Role,Parameters |
    ConvertTo-Json -Depth 5
```

Both roles should contain these entries:

```text
Import-RecipientDataProperty
Get-MailboxAutoReplyConfiguration
Set-ADServerSettings
Set-MailboxAutoReplyConfiguration
```

For `OOF-Management-FullControl`, confirm that `InternalMessage`, `ExternalMessage`, `ExternalAudience`, and the scheduling parameters are present.

For `OOF-Management-ToggleOnly`, confirm that `InternalMessage`, `ExternalMessage`, `ExternalAudience`, `DeclineMeetingMessage`, and other text or content parameters are not present.

## Step 4: Create the department management scope

The management scope controls which target mailboxes the delegated users can modify. This article uses `Department`, because it is visible and easy to verify with `Get-User`.

Example for the fictitious `Operations` department:

```powershell
New-ManagementScope `
    -Name "OOF-Operations Scope" `
    -RecipientRestrictionFilter "Department -eq 'Operations'"
```

Example for the fictitious `CustomerCare` department:

```powershell
New-ManagementScope `
    -Name "OOF-CustomerCare Scope" `
    -RecipientRestrictionFilter "Department -eq 'CustomerCare'"
```

Verify the attribute value before relying on it for scoping.

```powershell
Get-User -Identity "alex.wilber@example.com" |
    Select-Object Name,Department,RecipientType
```

You can also list all mailboxes that would be included in a department-based scope.

```powershell
Get-User -Filter "Department -eq 'Operations'" |
    Select-Object Name,Department,RecipientType
```

If the department attribute is maintained on the user object, use `Get-User` for verification. If your local operational process works primarily with mailboxes, you can also use mailbox-centric checks, but the important point is that the OPath filter must match the recipient object property used by Exchange RBAC.

## Step 5: Create role groups for the delegated users

The role group is the assignment container. It holds the delegated end users and combines one scenario-specific role with the department write scope.

### Full-control group for Operations

```powershell
New-RoleGroup `
    -Name "OOF_Operations_FullControl" `
    -Roles "OOF-Management-FullControl" `
    -CustomRecipientWriteScope "OOF-Operations Scope" `
    -Members "ava.reed@example.com"
```

### Toggle-only group for Operations

```powershell
New-RoleGroup `
    -Name "OOF_Operations_ToggleOnly" `
    -Roles "OOF-Management-ToggleOnly" `
    -CustomRecipientWriteScope "OOF-Operations Scope" `
    -Members "noah.brooks@example.com"
```

Add more delegated users as needed.

```powershell
Add-RoleGroupMember `
    -Identity "OOF_Operations_FullControl" `
    -Member "mia.clark@example.com"
```

Remove users when the delegation is no longer required.

```powershell
Remove-RoleGroupMember `
    -Identity "OOF_Operations_FullControl" `
    -Member "mia.clark@example.com" `
    -Confirm:$false
```

After membership changes, the delegated user should sign out and sign in again before testing the web experience.

## Step 6: Verify role groups and scopes

List role groups using the custom out-of-office roles.

```powershell
Get-RoleGroup |
    Where-Object {
        $_.Roles -contains "OOF-Management-FullControl" -or
        $_.Roles -contains "OOF-Management-ToggleOnly"
    } |
    Select-Object Name,Roles,ManagedBy
```

Check the members of a specific role group.

```powershell
Get-RoleGroupMember "OOF_Operations_FullControl"
Get-RoleGroupMember "OOF_Operations_ToggleOnly"
```

Check the management scope.

```powershell
Get-ManagementScope "OOF-Operations Scope" |
    Format-List Name,RecipientRestrictionFilter,RecipientRoot,RecipientFilterType
```

Check which recipients match the department value.

```powershell
Get-User -Filter "Department -eq 'Operations'" |
    Select-Object Name,Department,RecipientType
```

Test an in-scope mailbox.

```powershell
Get-MailboxAutoReplyConfiguration -Identity "shared.operations@example.com"

Set-MailboxAutoReplyConfiguration `
    -Identity "shared.operations@example.com" `
    -AutoReplyState Enabled
```

Test an out-of-scope mailbox.

```powershell
Set-MailboxAutoReplyConfiguration `
    -Identity "shared.finance@example.com" `
    -AutoReplyState Enabled
```

The out-of-scope operation should fail because the target mailbox is outside the custom recipient write scope.

## Step 7: Verify through Outlook on the web / ECP

The practical test is whether the delegated user can perform the task through the expected user interface.

### Classic ECP flow

1. Sign in to the Exchange Control Panel with the delegated user account.
2. Open the user menu and choose **Another user**.
3. Select a mailbox whose `Department` value is inside the assigned scope.
4. Open **E-Mail organisieren** / **Organize email**.
5. Select **Automatische Antwortnachricht einrichten** / **Set up an automatic reply message**.
6. Enable or disable automatic replies.
7. Configure the schedule if required.
8. Enter or update the internal and external message if the delegated user has the full-control role.
9. Save the change.
10. Repeat the test with a mailbox from another department and confirm that the delegated user cannot manage it.

### Modern Outlook on the web flow

1. Open Outlook on the web in the mailbox context that should be tested.
2. Open **Settings**.
3. Go to **Mail** > **Automatic replies**.
4. Turn on automatic replies.
5. Optionally select **Send replies only during a time period** and set the start and end time.
6. Enter the internal automatic-reply message if message editing is part of the delegated role.
7. Configure external replies if required and allowed.
8. Save the configuration.

Validate the final result with PowerShell.

```powershell
Get-MailboxAutoReplyConfiguration -Identity "shared.operations@example.com" |
    Format-List AutoReplyState,StartTime,EndTime,ExternalAudience,InternalMessage,ExternalMessage
```

## Final thoughts

Out-of-office replies are part of the same communication surface as email signatures: small, repeated, highly visible, and easy to get wrong when managed manually. A focused RBAC model gives organizations a controlled delegation layer, while Set-OutlookSignatures and the Benefactor Circle add-on provide a centralized, template-driven way to deploy out-of-office replies for internal and external recipients. See [Template tags and INI files](https://set-outlooksignatures.com/details#template-tags-and-ini-files).

A clean out-of-office delegation model does not require broad Exchange admin permissions. The working pattern is:

- create `OOF-Management-FullControl` directly from `MyBaseOptions` for full automatic-reply management;
- create `OOF-Management-ToggleOnly` directly from `MyBaseOptions` for enable, disable, and scheduling only;
- keep `Import-RecipientDataProperty`, `Get-MailboxAutoReplyConfiguration`, `Set-ADServerSettings`, and `Set-MailboxAutoReplyConfiguration` in both roles;
- restrict target mailboxes with a department-based management scope;
- use separate role groups for each department and scenario.

That gives selected end users the exact capability they need: manage automatic replies for departmental mailboxes, without becoming general Exchange administrators.

<!--
Managing automatic replies for department mailboxes should not require broad Exchange administrator rights. Exchange RBAC can delegate this specific mailbox-options task to selected users while limiting their access to mailboxes within a defined department scope.

This is useful when a shared mailbox needs a temporary response, a mailbox owner is unexpectedly absent, or a department coordinator must update an out-of-office message outside normal support hours. The delegated user needs access to the automatic-reply configuration, but not to unrelated Exchange settings or mailboxes belonging to other departments.

This article shows a practical model for delegating out-of-office management to selected common end users. They are not made Exchange administrators. They only receive the specific RBAC role entries required to manage automatic replies for mailboxes in their department scope.

https://set-outlooksignatures.com/blog/2026/07/29/delegate-oof
-->

## Turn every small email moment into a professional advantage

Email signatures and out-of-office replies may seem minor, but think about how often people see them.

We help organizations centrally manage and standardize these touchpoints across all users — **unified Outlook branding everywhere, with zero external data exposure.** No manual effort, no inconsistencies, no data leaving your environment. With Set-OutlookSignatures, every email becomes a consistent, secure, and fully controlled brand experience.

👉 See what’s possible for your email setup  
→ [See how it works (2 min)](https://set-outlooksignatures.com/)

👉 Want to try it yourself?  
→ [Quickstart](https://set-outlooksignatures.com/quickstart)

_Not responsible for email setup in your company?_  
Share this article with your IT department or marketing team, they’ll thank you for it.
