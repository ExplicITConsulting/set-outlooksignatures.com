<#
This sample code shows how to automate the creation of the Entra ID app required for Set-OutlookSignatures.

Both types of apps are supported: The one for end users, and the one for SimulateAndDeploy.

You can adapt it to fit your environment.
The sample code is written in a generic way, which allows for easy adaption.

Would you like support? ExplicIT Consulting (https://explicitconsulting.at) offers professional support for this and other open source code.
#>


#Requires -Version 5.1

[CmdletBinding()]

param (
    # Which type of app should be created?
    #   'Set-OutlookSignatures' for the default Set-OutlookSignatures app being accessed by end users runnding Set-OutlookSignatures
    #     Uses only delegated permissions, as described in '.\config\default graph config.ps1'
    #   'SimulateAndDeploy' for use in the "simulate and deploy" scenario
    #     Uses delegated permissions and application permissions, as described in '.\sample code\SimulateAndDeploy.ps1'
    #   For security reasons, the app type has no default value and needs to be set manually
    [ValidateSet('Set-OutlookSignatures', 'SimulateAndDeploy', 'OutlookAddIn')]
    $AppType = $null,

    [ValidateNotNullOrEmpty()]
    $AppName = $null,

    [ValidateNotNullOrEmpty()]
    [uri]$OutlookAddInUrl = $null,

    [ValidateSet('Public', 'Global', 'AzurePublic', 'AzureGlobal', 'AzureCloud', 'AzureUSGovernmentGCC', 'USGovernmentGCC', 'AzureUSGovernment', 'AzureUSGovernmentGCCHigh', 'AzureUSGovernmentL4', 'USGovernmentGCCHigh', 'USGovernmentL4', 'AzureUSGovernmentDOD', 'AzureUSGovernmentL5', 'USGovernmentDOD', 'USGovernmentL5', 'China', 'AzureChina', 'ChinaCloud', 'AzureChinaCloud')]
    [string]$CloudEnvironment = 'Public'
)


Clear-Host

# Remove unnecessary ETS type data associated with arrays in Windows PowerShell
Remove-TypeData System.Array -ErrorAction SilentlyContinue

if ($psISE) {
    Write-Host 'PowerShell ISE detected. Use PowerShell in console or terminal instead.' -ForegroundColor Red
    Write-Host 'Required features are not available in ISE. Exit.' -ForegroundColor Red
    exit 1
}

if (($ExecutionContext.SessionState.LanguageMode) -ine 'FullLanguage') {
    Write-Host "This PowerShell session runs in $($ExecutionContext.SessionState.LanguageMode) mode, not FullLanguage mode." -ForegroundColor Red
    Write-Host 'Required features are only available in FullLanguage mode. Exit.' -ForegroundColor Red
    exit 1
}

$OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding

if ($AppName) {
    $AppName = $AppName.trim()
}

Write-Host 'Set-OutlookSignatures Create-EntraApp.ps1'

$ParameterCheckSuccess = $true

if ([string]::IsNullOrWhiteSpace($AppType)) {
    $ParameterCheckSuccess = $false

    Write-Host '  App type not defined, exiting.' -ForegroundColor Red
    Write-Host "    Add parameter '-AppType' with one of the following values: $(($PSCmdlet.MyInvocation.MyCommand.Parameters['AppType'].Attributes |
    Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }).ValidValues -join ', ') " -ForegroundColor Red
}

if ([string]::IsNullOrWhiteSpace($AppName)) {
    $ParameterCheckSuccess = $false

    Write-Host '  App name not defined, exiting.' -ForegroundColor Red
    Write-Host "    Add parameter '-AppName' with a name for the Entra ID app to be created." -ForegroundColor Red
}

if ($AppType -ieq 'OutlookAddIn' -and $OutlookAddInUrl -eq $null) {
    $ParameterCheckSuccess = $false

    Write-Host '  Outlook Add-In URI not defined, exiting.' -ForegroundColor Red
    Write-Host "    Add parameter '-OutlookAddInUrl' with a URI for the Outlook add-in to be created." -ForegroundColor Red
}

if (($AppType -iin @('Set-OutlookSignatures', 'SimulateAndDeploy')) -and ($OutlookAddInUrl -ne $null)) {
    Write-Host "  Outlook Add-In URI not allowed for app type $($AppType), exiting." -ForegroundColor Red
    Write-Host "    Remove parameter '-OutlookAddInUrl'." -ForegroundColor Red
    exit 1
}

if (-not $ParameterCheckSuccess) {
    Write-Host '  All apps require the AppType and AppName parameters, app type OutlookAddIn additionally the OutlookAddInUrl parameter.' -ForegroundColor Red

    exit 1
} else {
    $AppName = $AppName.trim()
}

switch ($CloudEnvironment) {
    { $_ -iin @('Public', 'Global', 'AzurePublic', 'AzureGlobal', 'AzureCloud', 'AzureUSGovernmentGCC', 'USGovernmentGCC') } {
        $MgGraphEnvironment = 'Global'
        break
    }

    { $_ -iin @('AzureUSGovernment', 'AzureUSGovernmentGCCHigh', 'AzureUSGovernmentL4', 'USGovernmentGCCHigh', 'USGovernmentL4') } {
        $MgGraphEnvironment = 'USGov'
        break
    }

    { $_ -iin @('AzureUSGovernmentDOD', 'AzureUSGovernmentL5', 'USGovernmentDOD', 'USGovernmentL5') } {
        $MgGraphEnvironment = 'USGovDoD'
        break
    }

    { $_ -iin @('China', 'AzureChina', 'ChinaCloud', 'AzureChinaCloud') } {
        $MgGraphEnvironment = 'China'
        break
    }

    default {
        $MgGraphEnvironment = 'Global'
        break
    }
}


Write-Host
Write-Host 'Entra ID app to create'
Write-Host "  App type: $($AppType)"
Write-Host "  App name: $($AppName)"
if ($AppType -ieq 'OutlookAddIn') {
    Write-Host "  Outlook Add-In URI: $($OutlookAddInUrl)"
}


Write-Host
Write-Host 'Install required PowerShell modules'
[enum]::GetNames([System.Net.SecurityProtocolType]) | ForEach-Object {
    try {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol, $_
    } catch {
    }
}

try {
    if (-not (Get-PSRepository | Where-Object { $_.Name -ieq 'PSGallery' })) {
        Register-PSRepository -Name 'PSGallery' -SourceLocation 'https://www.powershellgallery.com/api/v2' -WarningAction SilentlyContinue -ErrorAction Stop
    }

    @('Microsoft.Graph.Authentication', 'Microsoft.Graph.Applications', 'Microsoft.Graph.Identity.SignIns') | ForEach-Object {
        Write-Host "  $($_)"

        if (Get-Module -ListAvailable -Name $_) {
            Find-Module -Name $_ -Repository PSGallery | Update-Module -Force -WarningAction SilentlyContinue -ErrorAction Stop
        } else {
            Find-Module -Name $_ -Repository PSGallery | Install-Module -Scope CurrentUser -Force -AllowClobber -WarningAction SilentlyContinue -ErrorAction Stop
        }

        Import-Module -Name $_ -Force -WarningAction SilentlyContinue -ErrorAction Stop
    }
} catch {
    Write-Host "Error installing PowerShell modules: $($_)" -ForegroundColor Red
    Write-Host
    Write-Host 'This is a severe error. It is not related to this script, but to the basic PowerShell setup on this system.' -ForegroundColor Red
    Write-Host 'Please fix these issues with PowerShell package management and package providers first.' -ForegroundColor Red

    exit 1
}


Write-Host
Write-Host "Connect to your Entra ID with a user being 'Application Administrator' or 'Global Administrator'"
Write-Host "  Connecting to Graph environment '$($MgGraphEnvironment)'"
Write-Host "    To connect to another environment, cancel authentication and add the '-CloudEnvironment' parameter."
Write-Host '  An authentication window will open, likely in a browser'

# Disconnect first, so that no existing connection is re-used. This forces to choose an account for the following connect.
$null = Disconnect-MgGraph -ErrorAction SilentlyContinue

try {
    $scopes = @('Application.ReadWrite.All', 'AppRoleAssignment.ReadWrite.All', 'DelegatedPermissionGrant.ReadWrite.All')

    Connect-MgGraph -Environment $MgGraphEnvironment -ContextScope Process -Scopes $scopes -NoWelcome -ErrorAction Stop

    if (-not (Get-MgContext)) {
        throw 'No connection established.'
    } else {
        $scopes | ForEach-Object {
            if (-not (Get-MgContext).Scopes -icontains ($_)) {
                throw "Required scope '$_' not granted."
            }
        }
    }
} catch {
    Write-Host "Error connecting to Microsoft Graph: $($_)" -ForegroundColor Red
    Write-Host
    Write-Host 'Please ensure that you can connect to Microsoft Graph and that your user has sufficient permissions.' -ForegroundColor Red

    exit 1
}

Write-Host
Write-Host 'Create a new app registration'
Write-Host "  App name: $($AppName)"

$ExistingApp = @(Get-MgApplication -Filter "DisplayName eq '$($AppName)'" -ErrorAction Stop)

if ($ExistingApp.Count -gt 0) {
    $ExistingApp | ForEach-Object {
        Write-Host "  App with name '$($AppName)' already exists. ID: $($_.Id)" -ForegroundColor Red
    }

    Write-Host '  Exiting.' -ForegroundColor Red
    exit 1
}

$params = @{
    DisplayName    = $AppName
    Description    = "$($AppType) app for Set-OutlookSignatures: Email signatures and out-of-office replies for Exchange and Outlook. Full-featured, cost-effective, unsurpassed data privacy."
    Notes          = "$($AppType) app for Set-OutlookSignatures: Email signatures and out-of-office replies for Exchange and Outlook. Full-featured, cost-effective, unsurpassed data privacy."
    SignInAudience = 'AzureADMyOrg'
}

$app = New-MgApplication @params

Write-Host
Write-Host 'Add required permissions to app registration'
if ($AppType -ieq 'Set-OutlookSignatures') {
    $permissionParams = @{
        RequiredResourceAccess = @(
            @{
                # Microsoft Graph
                'ResourceAppId'  = '00000003-0000-0000-c000-000000000000'
                'ResourceAccess' = @(
                    # Microsoft Graph permissions reference: https://learn.microsoft.com/en-us/graph/permissions-reference

                    # Delegated permission: email
                    #   Allows the app to read your users' primary email address.
                    #   Required to log on the current user.
                    @{
                        'id'   = '64a6cdd6-aab1-4aaf-94b8-3cc8405e90d0'
                        'type' = 'Scope'
                    },

                    # Delegated permission: EWS.AccessAsUser.All
                    #   Allows the app to have the same access to mailboxes as the signed-in user via Exchange Web Services.
                    #   Required to connect to Outlook on the web and to set Outlook on the web signature (classic and roaming).
                    @{
                        'id'   = '9769c687-087d-48ac-9cb3-c37dde652038'
                        'type' = 'Scope'
                    },

                    # Delegated permission: Files.Read.All
                    #   Allows the app to read all files the signed-in user can access.
                    #   Required for access to templates and configuration files hosted on SharePoint Online.
                    #   For added security, use Files.SelectedOperations.Selected as alternative, requiring granting specific permissions in SharePoint Online.
                    @{
                        'id'   = 'df85f4d6-205c-4ac5-a5ea-6bf408dba283'
                        'type' = 'Scope'
                    },

                    # Delegated permission: GroupMember.Read.All
                    #   Allows the app to list groups, read basic group properties and read membership of all groups the signed-in user has access to.
                    #   Required to find groups by name and to get their security identifier (SID) and the number of transitive members.
                    @{
                        'id'   = 'bc024368-1153-4739-b217-4326f2e966d0'
                        'type' = 'Scope'
                    },

                    # Delegated permission: Mail.ReadWrite
                    #   Allows the app to create, read, update, and delete email in user mailboxes. Does not include permission to send mail.
                    #   Required to connect to Outlook on the web and to set Outlook signatures.
                    @{
                        'id'   = '024d486e-b451-40bb-833d-3e66d98c5c73'
                        'type' = 'Scope'
                    },

                    # Delegated permission: MailboxSettings.ReadWrite
                    #   Allows the app to create, read, update, and delete user's mailbox settings. Does not include permission to send mail.
                    #   Required to detect the state of the out-of-office assistant and to set out-of-office replies.
                    @{
                        'id'   = '818c620a-27a9-40bd-a6a5-d96f7d610b4b'
                        'type' = 'Scope'
                    },

                    # Delegated permission: offline_access
                    #   Allows the app to see and update the data you gave it access to, even when users are not currently using the app. This does not give the app any additional permissions.
                    #   Required to get a refresh token from Graph.
                    @{
                        'id'   = '7427e0e9-2fba-42fe-b0c0-848c9e6a8182'
                        'type' = 'Scope'
                    },

                    # Delegated permission: openid
                    #   Allows users to sign in to the app with their work or school accounts and allows the app to see basic user profile information.
                    #   Required to log on the current user.
                    @{
                        'id'   = '37f7f235-527c-4136-accd-4a02d197296e'
                        'type' = 'Scope'
                    },

                    # Delegated permission: profile
                    #   Allows the app to see your users' basic profile (e.g., name, picture, user name, email address).
                    #   Required to log on the current user, to access the '/me' Graph API, to get basic properties of the current user.
                    @{
                        'id'   = '14dad69e-099b-42c9-810b-d002981feec1'
                        'type' = 'Scope'
                    },

                    # Delegated permission: User.Read.All
                    #   Allows the app to read the full set of profile properties, reports, and managers of other users in your organization, on behalf of the signed-in user.
                    #   Required for $CurrentUser[…]$ and $CurrentMailbox[…]$ replacement variables, and for simulation mode.
                    @{
                        'id'   = 'a154be20-db9c-4678-8ab7-66f6cc099a59'
                        'type' = 'Scope'
                    }
                )
            }
        )
    }
} elseif ($AppType -ieq 'SimulateAndDeploy') {
    $permissionParams = @{
        RequiredResourceAccess = @(
            @{
                # Microsoft Graph
                'resourceAppId'  = '00000003-0000-0000-c000-000000000000'
                'resourceAccess' = @(
                    # Microsoft Graph permissions reference: https://learn.microsoft.com/en-us/graph/permissions-reference

                    # Microsoft Graph permissions reference: https://learn.microsoft.com/en-us/graph/permissions-reference

                    # Delegated permission: email
                    #   Allows the app to read your users' primary email address.
                    #   Required to log on the current user.
                    @{
                        'id'   = '64a6cdd6-aab1-4aaf-94b8-3cc8405e90d0'
                        'type' = 'Scope'
                    },

                    # Delegated permission: EWS.AccessAsUser.All
                    #   Allows the app to have the same access to mailboxes as the signed-in user via Exchange Web Services.
                    #   Required to connect to Outlook on the web and to set Outlook on the web signature (classic and roaming).
                    @{
                        'id'   = '9769c687-087d-48ac-9cb3-c37dde652038'
                        'type' = 'Scope'
                    },

                    # Delegated permission: Files.Read.All
                    #   Allows the app to read all files the signed-in user can access.
                    #   Required for access to SharePoint Online on Linux, macOS, and on Windows without WebDAV.
                    #   You can use Files.SelectedOperations.Selected as alternative, requiring granting specific permission in SharePoint Online.
                    @{
                        'id'   = 'df85f4d6-205c-4ac5-a5ea-6bf408dba283'
                        'type' = 'Scope'
                    },

                    # Delegated permission: GroupMember.Read.All
                    #   Allows the app to list groups, read basic group properties and read membership of all groups the signed-in user has access to.
                    #   Required to find groups by name and to get their security identifier (SID) and the number of transitive members.
                    @{
                        'id'   = 'bc024368-1153-4739-b217-4326f2e966d0'
                        'type' = 'Scope'
                    },

                    # Delegated permission: Mail.ReadWrite
                    #   Allows the app to create, read, update, and delete email in user mailboxes. Does not include permission to send mail.
                    #   Required to connect to Outlook on the web and to set Outlook signatures.
                    @{
                        'id'   = '024d486e-b451-40bb-833d-3e66d98c5c73'
                        'type' = 'Scope'
                    },

                    # Delegated permission: MailboxSettings.ReadWrite
                    #   Allows the app to create, read, update, and delete user's mailbox settings. Does not include permission to send mail.
                    #   Required to detect the state of the out-of-office assistant and to set out-of-office replies.
                    @{
                        'id'   = '818c620a-27a9-40bd-a6a5-d96f7d610b4b'
                        'type' = 'Scope'
                    },

                    # Delegated permission: offline_access
                    #   Allows the app to see and update the data you gave it access to, even when users are not currently using the app. This does not give the app any additional permissions.
                    #   Required to get a refresh token from Graph.
                    @{
                        'id'   = '7427e0e9-2fba-42fe-b0c0-848c9e6a8182'
                        'type' = 'Scope'
                    },

                    # Delegated permission: openid
                    #   Allows users to sign in to the app with their work or school accounts and allows the app to see basic user profile information.
                    #   Required to log on the current user.
                    @{
                        'id'   = '37f7f235-527c-4136-accd-4a02d197296e'
                        'type' = 'Scope'
                    },

                    # Delegated permission: profile
                    #   Allows the app to see your users' basic profile (e.g., name, picture, user name, email address).
                    #   Required to log on the current user, to access the '/me' Graph API, to get basic properties of the current user.
                    @{
                        'id'   = '14dad69e-099b-42c9-810b-d002981feec1'
                        'type' = 'Scope'
                    },

                    # Delegated permission: User.Read.All
                    #   Allows the app to read the full set of profile properties, reports, and managers of other users in your organization, on behalf of the signed-in user.
                    #   Required for $CurrentUser[…]$ and $CurrentMailbox[…]$ replacement variables, and for simulation mode.
                    @{
                        'id'   = 'a154be20-db9c-4678-8ab7-66f6cc099a59'
                        'type' = 'Scope'
                    },

                    # Application permission: Files.Read.All
                    #   Allows the app to read all files in all site collections without a signed in user.
                    #   Required for access to templates and configuration files hosted on SharePoint Online.
                    #   For added security, use Files.SelectedOperations.Selected as alternative, requiring granting specific permissions in SharePoint Online.
                    @{
                        'id'   = '01d4889c-1287-42c6-ac1f-5d1e02578ef6'
                        'type' = 'Role'
                    },

                    # Application permission: GroupMember.Read.All
                    #   Allows the app to list groups, read basic group properties and read membership of all groups the signed-in user has access to.
                    #   Required to find groups by name and to get their security identifier (SID) and the number of transitive members.
                    @{
                        'id'   = '98830695-27a2-44f7-8c18-0c3ebc9698f6'
                        'type' = 'Role'
                    },

                    # Application permission: Mail.ReadWrite
                    #   Allows the app to create, read, update, and delete mail in all mailboxes without a signed-in user. Does not include permission to send mail.
                    #   Required to connect to Outlook on the web and to set Outlook signatures.
                    @{
                        'id'   = 'e2a3a72e-5f79-4c64-b1b1-878b674786c9'
                        'type' = 'Role'
                    },

                    # Application permission: MailboxSettings.ReadWrite
                    #   Allows the app to create, read, update, and delete user's mailbox settings. Does not include permission to send mail.
                    #   Required to detect the state of the out-of-office assistant and to set out-of-office replies.
                    @{
                        'id'   = '6931bccd-447a-43d1-b442-00a195474933'
                        'type' = 'Role'
                    },

                    # Application permission: User.Read.All
                    #   Allows the app to read the full set of profile properties, reports, and managers of other users in your organization, on behalf of the signed-in user.
                    #   Required for $CurrentUser[…]$ and $CurrentMailbox[…]$ replacement variables, and for simulation mode.
                    @{
                        'id'   = 'df021288-bdef-4463-88db-98f22de89214'
                        'type' = 'Role'
                    }
                )
            },
            @{
                # Office 365 Exchange Online
                'resourceAppId'  = '00000002-0000-0ff1-ce00-000000000000'
                'resourceAccess' = @(
                    @{
                        # Application permission: full_access_as_app
                        #   Allows the app to have full access via Exchange Web Services to all mailboxes without a signed-in user.
                        #   Required for Exchange Web Services access (read Outlook on the web configuration, set classic signature and roaming signatures)
                        'id'   = 'dc890d15-9560-4a4c-9b7f-a736ec74ec40'
                        'type' = 'Role'
                    }
                )
            }
        )
    }
} elseif ($AppType -ieq 'OutlookAddIn') {
    $permissionParams = @{
        RequiredResourceAccess = @(
            @{
                # Microsoft Graph
                'resourceAppId'  = '00000003-0000-0000-c000-000000000000'
                'resourceAccess' = @(
                    # Microsoft Graph permissions reference: https://learn.microsoft.com/en-us/graph/permissions-reference

                    # Delegated permission: GroupMember.Read.All
                    #   Allows the app to list groups, read basic group properties and read membership of all groups the signed-in user has access to.
                    #   Required to find and check license groups.
                    @{
                        'id'   = 'bc024368-1153-4739-b217-4326f2e966d0'
                        'type' = 'Scope'
                    },

                    # Delegated permission: Mail.Read
                    #   Allows to read emails in mailbox of the currently logged-on user (and in no other mailboxes).
                    #    Required because of Microsoft restrictions accessing roaming signatures.
                    @{
                        'id'   = '570282fd-fa5c-430d-a7fd-fc8dc98a9dca'
                        'type' = 'Scope'
                    },

                    # Delegated permission: User.Read.All
                    #   Allows the app to read the full set of profile properties, reports, and managers of other users in your organization, on behalf of the signed-in user.
                    #   Required to get the UPN for a given SMTP email address.
                    @{
                        'id'   = 'a154be20-db9c-4678-8ab7-66f6cc099a59'
                        'type' = 'Scope'
                    }
                )
            }
        )
    }
}

Update-MgApplication -ApplicationId $app.Id -BodyParameter $permissionParams

if ($AppType -iin @('Set-OutlookSignatures', 'SimulateAndDeploy')) {
    Write-Host '  Consider restricting file access by switching from Files.Read.All to Files.SelectedOperations.Selected.'
    Write-Host '    This enhances security but requires granting specific permissions in SharePoint Online.'
}


Write-Host
Write-Host 'Add redirect URIs to app registration'
if ($AppType -iin @('Set-OutlookSignatures', 'SimulateAndDeploy')) {
    $params =	@{
        RedirectUris = @(
            'http://localhost',
            "ms-appx-web://microsoft.aad.brokerplugin/$($app.AppId)"
        )
    }

    Update-MgApplication -ApplicationId $app.Id -PublicClient $params
} elseif ($AppType -ieq 'OutlookAddIn') {
    $params =	@{
        RedirectUris = @(
            "brk-multihub://$($OutlookAddInUrl.DnsSafeHost)"
        )
    }

    Update-MgApplication -ApplicationId $app.Id -Spa $params
}

$params.RedirectUris | ForEach-Object {
    Write-Host "  $($_)"
}

if ($AppType -iin @('Set-OutlookSignatures', 'SimulateAndDeploy')) {
    Write-Host
    Write-Host 'Enable public client flow'

    Update-MgApplication -ApplicationId $app.Id -IsFallbackPublicClient
}


if ($AppType -ieq 'SimulateAndDeploy') {
    Write-Host
    Write-Host 'Add client secret to app registration'

    $params = @{
        displayName = "Initial client secret, valid $(Get-Date -Format 'yyyy-MM-dd')--$(Get-Date (Get-Date).AddMonths(24) -Format 'yyyy-MM-dd')"
        endDateTime = (Get-Date).AddMonths(24)
    }

    $secret = Add-MgApplicationPassword -ApplicationId $app.Id -PasswordCredential $params
}


Write-Host
Write-Host 'Grant admin consent'
Write-Host '  This may take a moment'
$AppServicePrincipal = New-MgServicePrincipal -AppId $App.AppId
$delegatedPermissions = @{}

foreach ($resource in $permissionParams.RequiredResourceAccess) {
    foreach ($resourcePermission in $resource.resourceAccess) {
        if ($resourcePermission.type -eq 'Role') {
            # Application permission

            $null = New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $AppServicePrincipal.Id -PrincipalId $AppServicePrincipal.Id -ResourceId $((Get-MgServicePrincipal -Filter "AppId eq '$($resource.resourceAppId)'").Id) -AppRoleId $resourcePermission.id
        } elseif ($resourcePermission.type -eq 'Scope') {
            # Delegated permission

            $delegatedPermissions[$((Get-MgServicePrincipal -Filter "AppId eq '$($resource.resourceAppId)'").Id)] += " $(((Get-MgServicePrincipal -Filter "appId eq '$($resource.resourceAppId)'").Oauth2PermissionScopes | Where-Object { $_.Id -eq $resourcePermission.id }).Value)"
        }
    }
}

$delegatedPermissions.GetEnumerator() | ForEach-Object {
    $null = New-MgOauth2PermissionGrant -ClientId $AppServicePrincipal.Id -ConsentType 'AllPrincipals' -ResourceId $_.Key -Scope $_.Value.trim()
}


Write-Host
Write-Host 'Disconnect from Entra ID'
$null = Disconnect-MgGraph -ErrorAction SilentlyContinue


Write-Host
Write-Host '▼▼▼ Relevant information for your configuration below ▼▼▼' -ForegroundColor Green
if ($AppType -ieq 'Set-OutlookSignatures') {
    Write-Host "  GraphClientId for Set-OutlookSignatures: '$($app.AppId)'"
} elseif ($AppType -ieq 'SimulateAndDeploy') {
    Write-Host "  GraphClientId for SimulateAndDeploy: '$($app.AppId)'"
    Write-Host "  GraphClientSecret for SimulateAndDeploy: '$($secret.SecretText)'"
    Write-Host "    Do not forget to renew the client secret before $(Get-Date (Get-Date).AddMonths(24) -Format 'yyyy-MM-dd')!"
} elseif ($AppType -ieq 'OutlookAddIn') {
    Write-Host "  GRAPH_CLIENT_ID for Outlook Add-In: '$($app.AppId)'"
}
Write-Host '▲▲▲ Relevant information for your configuration above ▲▲▲' -ForegroundColor Green

Write-Host
Write-Host 'Done'

# SIG # Begin signature block
# MIIwaAYJKoZIhvcNAQcCoIIwWTCCMFUCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCoPrF0oDK3uaoQ
# XP4juZiOzqHiNNjQ3+ZfAQ+MTpVuxaCCFCkwggWQMIIDeKADAgECAhAFmxtXno4h
# MuI5B72nd3VcMA0GCSqGSIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNV
# BAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDAeFw0xMzA4MDExMjAwMDBaFw0z
# ODAxMTUxMjAwMDBaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0
# IFRydXN0ZWQgUm9vdCBHNDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIB
# AL/mkHNo3rvkXUo8MCIwaTPswqclLskhPfKK2FnC4SmnPVirdprNrnsbhA3EMB/z
# G6Q4FutWxpdtHauyefLKEdLkX9YFPFIPUh/GnhWlfr6fqVcWWVVyr2iTcMKyunWZ
# anMylNEQRBAu34LzB4TmdDttceItDBvuINXJIB1jKS3O7F5OyJP4IWGbNOsFxl7s
# Wxq868nPzaw0QF+xembud8hIqGZXV59UWI4MK7dPpzDZVu7Ke13jrclPXuU15zHL
# 2pNe3I6PgNq2kZhAkHnDeMe2scS1ahg4AxCN2NQ3pC4FfYj1gj4QkXCrVYJBMtfb
# BHMqbpEBfCFM1LyuGwN1XXhm2ToxRJozQL8I11pJpMLmqaBn3aQnvKFPObURWBf3
# JFxGj2T3wWmIdph2PVldQnaHiZdpekjw4KISG2aadMreSx7nDmOu5tTvkpI6nj3c
# AORFJYm2mkQZK37AlLTSYW3rM9nF30sEAMx9HJXDj/chsrIRt7t/8tWMcCxBYKqx
# YxhElRp2Yn72gLD76GSmM9GJB+G9t+ZDpBi4pncB4Q+UDCEdslQpJYls5Q5SUUd0
# viastkF13nqsX40/ybzTQRESW+UQUOsxxcpyFiIJ33xMdT9j7CFfxCBRa2+xq4aL
# T8LWRV+dIPyhHsXAj6KxfgommfXkaS+YHS312amyHeUbAgMBAAGjQjBAMA8GA1Ud
# EwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgGGMB0GA1UdDgQWBBTs1+OC0nFdZEzf
# Lmc/57qYrhwPTzANBgkqhkiG9w0BAQwFAAOCAgEAu2HZfalsvhfEkRvDoaIAjeNk
# aA9Wz3eucPn9mkqZucl4XAwMX+TmFClWCzZJXURj4K2clhhmGyMNPXnpbWvWVPjS
# PMFDQK4dUPVS/JA7u5iZaWvHwaeoaKQn3J35J64whbn2Z006Po9ZOSJTROvIXQPK
# 7VB6fWIhCoDIc2bRoAVgX+iltKevqPdtNZx8WorWojiZ83iL9E3SIAveBO6Mm0eB
# cg3AFDLvMFkuruBx8lbkapdvklBtlo1oepqyNhR6BvIkuQkRUNcIsbiJeoQjYUIp
# 5aPNoiBB19GcZNnqJqGLFNdMGbJQQXE9P01wI4YMStyB0swylIQNCAmXHE/A7msg
# dDDS4Dk0EIUhFQEI6FUy3nFJ2SgXUE3mvk3RdazQyvtBuEOlqtPDBURPLDab4vri
# RbgjU2wGb2dVf0a1TD9uKFp5JtKkqGKX0h7i7UqLvBv9R0oN32dmfrJbQdA75PQ7
# 9ARj6e/CVABRoIoqyc54zNXqhwQYs86vSYiv85KZtrPmYQ/ShQDnUBrkG5WdGaG5
# nLGbsQAe79APT0JsyQq87kP6OnGlyE0mpTX9iV28hWIdMtKgK1TtmlfB2/oQzxm3
# i0objwG2J5VT6LaJbVu8aNQj6ItRolb58KaAoNYes7wPD1N1KarqE3fk3oyBIa0H
# EEcRrYc9B9F1vM/zZn4wggawMIIEmKADAgECAhAIrUCyYNKcTJ9ezam9k67ZMA0G
# CSqGSIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0
# IFRydXN0ZWQgUm9vdCBHNDAeFw0yMTA0MjkwMDAwMDBaFw0zNjA0MjgyMzU5NTla
# MGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UE
# AxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcgUlNBNDA5NiBTSEEz
# ODQgMjAyMSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDVtC9C
# 0CiteLdd1TlZG7GIQvUzjOs9gZdwxbvEhSYwn6SOaNhc9es0JAfhS0/TeEP0F9ce
# 2vnS1WcaUk8OoVf8iJnBkcyBAz5NcCRks43iCH00fUyAVxJrQ5qZ8sU7H/Lvy0da
# E6ZMswEgJfMQ04uy+wjwiuCdCcBlp/qYgEk1hz1RGeiQIXhFLqGfLOEYwhrMxe6T
# SXBCMo/7xuoc82VokaJNTIIRSFJo3hC9FFdd6BgTZcV/sk+FLEikVoQ11vkunKoA
# FdE3/hoGlMJ8yOobMubKwvSnowMOdKWvObarYBLj6Na59zHh3K3kGKDYwSNHR7Oh
# D26jq22YBoMbt2pnLdK9RBqSEIGPsDsJ18ebMlrC/2pgVItJwZPt4bRc4G/rJvmM
# 1bL5OBDm6s6R9b7T+2+TYTRcvJNFKIM2KmYoX7BzzosmJQayg9Rc9hUZTO1i4F4z
# 8ujo7AqnsAMrkbI2eb73rQgedaZlzLvjSFDzd5Ea/ttQokbIYViY9XwCFjyDKK05
# huzUtw1T0PhH5nUwjewwk3YUpltLXXRhTT8SkXbev1jLchApQfDVxW0mdmgRQRNY
# mtwmKwH0iU1Z23jPgUo+QEdfyYFQc4UQIyFZYIpkVMHMIRroOBl8ZhzNeDhFMJlP
# /2NPTLuqDQhTQXxYPUez+rbsjDIJAsxsPAxWEQIDAQABo4IBWTCCAVUwEgYDVR0T
# AQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUaDfg67Y7+F8Rhvv+YXsIiGX0TkIwHwYD
# VR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMG
# A1UdJQQMMAoGCCsGAQUFBwMDMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2Fj
# ZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNydDBDBgNV
# HR8EPDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRU
# cnVzdGVkUm9vdEc0LmNybDAcBgNVHSAEFTATMAcGBWeBDAEDMAgGBmeBDAEEATAN
# BgkqhkiG9w0BAQwFAAOCAgEAOiNEPY0Idu6PvDqZ01bgAhql+Eg08yy25nRm95Ry
# sQDKr2wwJxMSnpBEn0v9nqN8JtU3vDpdSG2V1T9J9Ce7FoFFUP2cvbaF4HZ+N3HL
# IvdaqpDP9ZNq4+sg0dVQeYiaiorBtr2hSBh+3NiAGhEZGM1hmYFW9snjdufE5Btf
# Q/g+lP92OT2e1JnPSt0o618moZVYSNUa/tcnP/2Q0XaG3RywYFzzDaju4ImhvTnh
# OE7abrs2nfvlIVNaw8rpavGiPttDuDPITzgUkpn13c5UbdldAhQfQDN8A+KVssIh
# dXNSy0bYxDQcoqVLjc1vdjcshT8azibpGL6QB7BDf5WIIIJw8MzK7/0pNVwfiThV
# 9zeKiwmhywvpMRr/LhlcOXHhvpynCgbWJme3kuZOX956rEnPLqR0kq3bPKSchh/j
# wVYbKyP/j7XqiHtwa+aguv06P0WmxOgWkVKLQcBIhEuWTatEQOON8BUozu3xGFYH
# Ki8QxAwIZDwzj64ojDzLj4gLDb879M4ee47vtevLt/B3E+bnKD+sEq6lLyJsQfmC
# XBVmzGwOysWGw/YmMwwHS6DTBwJqakAwSEs0qFEgu60bhQjiWQ1tygVQK+pKHJ6l
# /aCnHwZ05/LWUpD9r4VIIflXO7ScA+2GRfS0YW6/aOImYIbqyK+p/pQd52MbOoZW
# eE4wggfdMIIFxaADAgECAhAKaypbp7cyIFa+lR7OVPAvMA0GCSqGSIb3DQEBCwUA
# MGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UE
# AxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcgUlNBNDA5NiBTSEEz
# ODQgMjAyMSBDQTEwHhcNMjMwNzExMDAwMDAwWhcNMjYwNzEwMjM1OTU5WjCB5TET
# MBEGCysGAQQBgjc8AgEDEwJBVDEVMBMGCysGAQQBgjc8AgECEwRXaWVuMRUwEwYL
# KwYBBAGCNzwCAQETBFdpZW4xHTAbBgNVBA8MFFByaXZhdGUgT3JnYW5pemF0aW9u
# MRAwDgYDVQQFEwc2MDcwMTN0MQswCQYDVQQGEwJBVDENMAsGA1UECBMEV2llbjEN
# MAsGA1UEBxMEV2llbjEhMB8GA1UEChMYRXhwbGljSVQgQ29uc3VsdGluZyBHbWJI
# MSEwHwYDVQQDExhFeHBsaWNJVCBDb25zdWx0aW5nIEdtYkgwggIiMA0GCSqGSIb3
# DQEBAQUAA4ICDwAwggIKAoICAQDxdNfDY8ulBB2NIOYzd2mVQRhjMBAzNgvJEjXs
# VACQyjesfJfvXZ3gMnUT8M5HkohWjHvhftCFkL5cCck+4XuEGiLisV3hilLL4p8z
# 6L+tbvPnVSWML7VOV835/de+hM/mKdFhqRG+fYNQ1ceFlggiwqfHjIoXLweZACRD
# 3bLwRLYk7w5IEDCtHa0Hit+SpqbZ4MDcEhfS8krG5ha0FqOLkVLAhPfkZ4sOB32V
# dUfQPknxYnhWZVyGVH/ypTYnEY4oo3CFO0f8k4fNc8fGDwNAoxHJwGKYjxeEasgm
# a2EZMHKkZyJpwJKSdZ9FPp4qldYVt/NiCoXzdrLRta0M/Vg5E+XKVtC0EOhY2w6u
# lgFx0Qog/hfC3w2imATDt7Fv5R+ZQ8v3BXzn2pH2DZ1sGI7JZjH0NCxXdY8kaDuZ
# fCQRcDCej/5otpuDxu7l6bBUTBe2ao+ZwCBuN0PWdbyxunii1W/Q3t1bU2Hmu/97
# 4hQOWJNDBuWrPNOlr2qHVqFNCOpHtuddTHMGt9bGwr9FXXe5gTIrAk2CCX+vnDhw
# zgi8UuLWJy+H1b1Y2hUt2oX2izyAjDrXdA6wgGNr3YtIgUt+4BBRz0Zhw6/KQdpN
# wCTnofcgezhz0OS4WMB+ZARaMNK4DpzVwlGrg9NF/nCuQ0sJzt913ndIRl5FXJ71
# GwgCKwIDAQABo4ICAjCCAf4wHwYDVR0jBBgwFoAUaDfg67Y7+F8Rhvv+YXsIiGX0
# TkIwHQYDVR0OBBYEFDz+YL61H9M50y8W+urzdKxOSpf4MA4GA1UdDwEB/wQEAwIH
# gDATBgNVHSUEDDAKBggrBgEFBQcDAzCBtQYDVR0fBIGtMIGqMFOgUaBPhk1odHRw
# Oi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRDb2RlU2lnbmlu
# Z1JTQTQwOTZTSEEzODQyMDIxQ0ExLmNybDBToFGgT4ZNaHR0cDovL2NybDQuZGln
# aWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0Q29kZVNpZ25pbmdSU0E0MDk2U0hB
# Mzg0MjAyMUNBMS5jcmwwPQYDVR0gBDYwNDAyBgVngQwBAzApMCcGCCsGAQUFBwIB
# FhtodHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwgZQGCCsGAQUFBwEBBIGHMIGE
# MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wXAYIKwYBBQUH
# MAKGUGh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRH
# NENvZGVTaWduaW5nUlNBNDA5NlNIQTM4NDIwMjFDQTEuY3J0MAkGA1UdEwQCMAAw
# DQYJKoZIhvcNAQELBQADggIBAISWy98G7WUbOBA3S0odwfltQ3YZmuNgNZDoIdLQ
# YFnB43wgnClFuPIPaKJGYeRH90iioYKsnGDOYvUgr+b+XbIDRRqkHoYYZB+jDYUJ
# f1LS6eD79GAsLEomY/VzyRY9LEbYsmDmHi/riDWDiKWL0YYQmVuxU6NSLz4JZADA
# VsC7bZovRJnL9XFQo0QQxz9jymHH1UVBOAUUojrs7IznXBtQza/PYg+285kCoR/U
# ToA+Bc7j/mwon0tKlNCKyPn04viwjHRSIr8VlCH+qXU+nw6eSH7PVJWargv2sX/h
# t9zJ4JK843KRtd2mEXMUVcS2AUnmuwBSrxXhFQguR5nfrZBUHb4epiAMreGfidEl
# bmxEpzLaBegF8A+C7mCambjhnQ1p9b6JKuV1aS9qyfRf6AYF+OKLzBBbIAKLOmSx
# aHoJdn65B50/Gq5zUIxkoa8lKjEw4xtIBto4xYnFOLQJmiNeyAJeRLHbPGpHm6M+
# tTorAVDdGPQbhDlQT2RHn9pJDiJxFIbPdsNoEgtzAQee5US4QCng1qySpsvhQEoX
# JHh3jq62djlgx2GmVGOsysBfhcqjJROeo0+B32YQRHST/RBEaesZ6SFfXGaO3bBt
# onaU0JOQ9LOioHOuhGVNPjrcKT/NE99Bs2JF1Z8XJfPcDt5R0c10eRY1fiLJLvU5
# GNmrMYIblTCCG5ECAQEwfTBpMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNl
# cnQsIEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0IFRydXN0ZWQgRzQgQ29kZSBTaWdu
# aW5nIFJTQTQwOTYgU0hBMzg0IDIwMjEgQ0ExAhAKaypbp7cyIFa+lR7OVPAvMA0G
# CWCGSAFlAwQCAQUAoIIBbjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgTvnehSj6
# KrbO5TuoqLNf2zDnT8VXDvOrcwg/2C/WZoAwggEABgorBgEEAYI3AgEMMYHxMIHu
# oIHFgIHCAFAAbwB3AGUAcgBlAGQAIABiAHkAIABFAHgAcABsAGkAYwBJAFQAIABD
# AG8AbgBzAHUAbAB0AGkAbgBnAC4AIABVAG4AbABvAGMAawAgAGEAbABsACAAZgBl
# AGEAdAB1AHIAZQBzACAAdwBpAHQAaAAgAFMAZQB0AC0ATwB1AHQAbABvAG8AawBT
# AGkAZwBuAGEAdAB1AHIAZQBzACAAQgBlAG4AZQBmAGEAYwB0AG8AcgAgAEMAaQBy
# AGMAbABlAC6hJIAiaHR0cHM6Ly9zZXQtb3V0bG9va3NpZ25hdHVyZXMuY29tIDAN
# BgkqhkiG9w0BAQEFAASCAgDfi5Cx8ZfNNA3o8lwSvt5FLOVXQbZj5+tNmnGjryC6
# kHnVX77nLyBNJTSwtFGcgiuSHilvamZQuUevAT1ocH7DbgOKg+W6P9IJzaBlTUkx
# HqOkus9uEXhJOijfqgahUcTr1q39BDVcFnweWi33ddN0Yz1IGscbvuDakKEesscP
# 6ACB/4iLAZDHXjkzukLe5o6GlIGnmupGt8ZPNJp4e59V47n3yUx4haP6qQ+C2ECJ
# 6j5ZMlMNqizmPpENfx017ipqfz+UoAub0t7upHXVorpV+ZzM2gno51WWVvHtxzXj
# QkIKLCyo62QZvmIMG8G6OX5EPpjXFMmjSWEwKHd3OPXEexFZFe8v4Sld3UBozc7F
# eECdaDHE5bOybB6gK0FKZtTM28+ja/BpnkZnR11E5NCKzcNgPUbvB/VqZI1L1Tdg
# a+JHG+seH2VsYlZEJMNpCEkkUBhZEsXGv8lbxkDPxjibRLAeRvdryHC9+jO4eC5v
# CYEr59DbyQksh1Pb/Vu+55HdY/IxvIsKcr3UXmzZrYJwUnlzcy9vjpUG/93qC8y8
# Hv3/vLSeQOHXfVqhSDuRabjU9zqA5fU6NwXYPVm4QudiXZOdb2A4IR+GmRsJBYFw
# 0Pywx6I+3lwyK+1YXknpSKcTUc1ZOiZhkdfcyWM/jdlxUsR5I4rOnJm3hrSlnJFw
# 0aGCF3cwghdzBgorBgEEAYI3AwMBMYIXYzCCF18GCSqGSIb3DQEHAqCCF1AwghdM
# AgEDMQ8wDQYJYIZIAWUDBAIBBQAweAYLKoZIhvcNAQkQAQSgaQRnMGUCAQEGCWCG
# SAGG/WwHATAxMA0GCWCGSAFlAwQCAQUABCCGCHxtsVvyh7gFwVihP09Uw+umQGab
# Frjobc44NPSlygIRAMHI3jZ0v8EPb7HE9TiHlZcYDzIwMjUxMjIzMTE1MDEzWqCC
# EzowggbtMIIE1aADAgECAhAKgO8YS43xBYLRxHanlXRoMA0GCSqGSIb3DQEBCwUA
# MGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UE
# AxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBUaW1lU3RhbXBpbmcgUlNBNDA5NiBTSEEy
# NTYgMjAyNSBDQTEwHhcNMjUwNjA0MDAwMDAwWhcNMzYwOTAzMjM1OTU5WjBjMQsw
# CQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRp
# Z2lDZXJ0IFNIQTI1NiBSU0E0MDk2IFRpbWVzdGFtcCBSZXNwb25kZXIgMjAyNSAx
# MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA0EasLRLGntDqrmBWsytX
# um9R/4ZwCgHfyjfMGUIwYzKomd8U1nH7C8Dr0cVMF3BsfAFI54um8+dnxk36+jx0
# Tb+k+87H9WPxNyFPJIDZHhAqlUPt281mHrBbZHqRK71Em3/hCGC5KyyneqiZ7syv
# FXJ9A72wzHpkBaMUNg7MOLxI6E9RaUueHTQKWXymOtRwJXcrcTTPPT2V1D/+cFll
# ESviH8YjoPFvZSjKs3SKO1QNUdFd2adw44wDcKgH+JRJE5Qg0NP3yiSyi5MxgU6c
# ehGHr7zou1znOM8odbkqoK+lJ25LCHBSai25CFyD23DZgPfDrJJJK77epTwMP6eK
# A0kWa3osAe8fcpK40uhktzUd/Yk0xUvhDU6lvJukx7jphx40DQt82yepyekl4i0r
# 8OEps/FNO4ahfvAk12hE5FVs9HVVWcO5J4dVmVzix4A77p3awLbr89A90/nWGjXM
# Gn7FQhmSlIUDy9Z2hSgctaepZTd0ILIUbWuhKuAeNIeWrzHKYueMJtItnj2Q+aTy
# LLKLM0MheP/9w6CtjuuVHJOVoIJ/DtpJRE7Ce7vMRHoRon4CWIvuiNN1Lk9Y+xZ6
# 6lazs2kKFSTnnkrT3pXWETTJkhd76CIDBbTRofOsNyEhzZtCGmnQigpFHti58CSm
# vEyJcAlDVcKacJ+A9/z7eacCAwEAAaOCAZUwggGRMAwGA1UdEwEB/wQCMAAwHQYD
# VR0OBBYEFOQ7/PIx7f391/ORcWMZUEPPYYzoMB8GA1UdIwQYMBaAFO9vU0rp5AZ8
# esrikFb2L9RJ7MtOMA4GA1UdDwEB/wQEAwIHgDAWBgNVHSUBAf8EDDAKBggrBgEF
# BQcDCDCBlQYIKwYBBQUHAQEEgYgwgYUwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3Nw
# LmRpZ2ljZXJ0LmNvbTBdBggrBgEFBQcwAoZRaHR0cDovL2NhY2VydHMuZGlnaWNl
# cnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0VGltZVN0YW1waW5nUlNBNDA5NlNIQTI1
# NjIwMjVDQTEuY3J0MF8GA1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly9jcmwzLmRpZ2lj
# ZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNFRpbWVTdGFtcGluZ1JTQTQwOTZTSEEy
# NTYyMDI1Q0ExLmNybDAgBgNVHSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEw
# DQYJKoZIhvcNAQELBQADggIBAGUqrfEcJwS5rmBB7NEIRJ5jQHIh+OT2Ik/bNYul
# CrVvhREafBYF0RkP2AGr181o2YWPoSHz9iZEN/FPsLSTwVQWo2H62yGBvg7ouCOD
# wrx6ULj6hYKqdT8wv2UV+Kbz/3ImZlJ7YXwBD9R0oU62PtgxOao872bOySCILdBg
# hQ/ZLcdC8cbUUO75ZSpbh1oipOhcUT8lD8QAGB9lctZTTOJM3pHfKBAEcxQFoHlt
# 2s9sXoxFizTeHihsQyfFg5fxUFEp7W42fNBVN4ueLaceRf9Cq9ec1v5iQMWTFQa0
# xNqItH3CPFTG7aEQJmmrJTV3Qhtfparz+BW60OiMEgV5GWoBy4RVPRwqxv7Mk0Sy
# 4QHs7v9y69NBqycz0BZwhB9WOfOu/CIJnzkQTwtSSpGGhLdjnQ4eBpjtP+XB3pQC
# tv4E5UCSDag6+iX8MmB10nfldPF9SVD7weCC3yXZi/uuhqdwkgVxuiMFzGVFwYbQ
# siGnoa9F5AaAyBjFBtXVLcKtapnMG3VH3EmAp/jsJ3FVF3+d1SVDTmjFjLbNFZUW
# MXuZyvgLfgyPehwJVxwC+UpX2MSey2ueIu9THFVkT+um1vshETaWyQo8gmBto/m3
# acaP9QsuLj3FNwFlTxq25+T4QwX9xa6ILs84ZPvmpovq90K8eWyG2N01c4IhSOxq
# t81nMIIGtDCCBJygAwIBAgIQDcesVwX/IZkuQEMiDDpJhjANBgkqhkiG9w0BAQsF
# ADBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQL
# ExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJv
# b3QgRzQwHhcNMjUwNTA3MDAwMDAwWhcNMzgwMTE0MjM1OTU5WjBpMQswCQYDVQQG
# EwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0
# IFRydXN0ZWQgRzQgVGltZVN0YW1waW5nIFJTQTQwOTYgU0hBMjU2IDIwMjUgQ0Ex
# MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAtHgx0wqYQXK+PEbAHKx1
# 26NGaHS0URedTa2NDZS1mZaDLFTtQ2oRjzUXMmxCqvkbsDpz4aH+qbxeLho8I6jY
# 3xL1IusLopuW2qftJYJaDNs1+JH7Z+QdSKWM06qchUP+AbdJgMQB3h2DZ0Mal5kY
# p77jYMVQXSZH++0trj6Ao+xh/AS7sQRuQL37QXbDhAktVJMQbzIBHYJBYgzWIjk8
# eDrYhXDEpKk7RdoX0M980EpLtlrNyHw0Xm+nt5pnYJU3Gmq6bNMI1I7Gb5IBZK4i
# vbVCiZv7PNBYqHEpNVWC2ZQ8BbfnFRQVESYOszFI2Wv82wnJRfN20VRS3hpLgIR4
# hjzL0hpoYGk81coWJ+KdPvMvaB0WkE/2qHxJ0ucS638ZxqU14lDnki7CcoKCz6eu
# m5A19WZQHkqUJfdkDjHkccpL6uoG8pbF0LJAQQZxst7VvwDDjAmSFTUms+wV/FbW
# Bqi7fTJnjq3hj0XbQcd8hjj/q8d6ylgxCZSKi17yVp2NL+cnT6Toy+rN+nM8M7Ln
# LqCrO2JP3oW//1sfuZDKiDEb1AQ8es9Xr/u6bDTnYCTKIsDq1BtmXUqEG1NqzJKS
# 4kOmxkYp2WyODi7vQTCBZtVFJfVZ3j7OgWmnhFr4yUozZtqgPrHRVHhGNKlYzyjl
# roPxul+bgIspzOwbtmsgY1MCAwEAAaOCAV0wggFZMBIGA1UdEwEB/wQIMAYBAf8C
# AQAwHQYDVR0OBBYEFO9vU0rp5AZ8esrikFb2L9RJ7MtOMB8GA1UdIwQYMBaAFOzX
# 44LScV1kTN8uZz/nupiuHA9PMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggr
# BgEFBQcDCDB3BggrBgEFBQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3Nw
# LmRpZ2ljZXJ0LmNvbTBBBggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMuZGlnaWNl
# cnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcnQwQwYDVR0fBDwwOjA4oDag
# NIYyaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RH
# NC5jcmwwIAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3
# DQEBCwUAA4ICAQAXzvsWgBz+Bz0RdnEwvb4LyLU0pn/N0IfFiBowf0/Dm1wGc/Do
# 7oVMY2mhXZXjDNJQa8j00DNqhCT3t+s8G0iP5kvN2n7Jd2E4/iEIUBO41P5F448r
# SYJ59Ib61eoalhnd6ywFLerycvZTAz40y8S4F3/a+Z1jEMK/DMm/axFSgoR8n6c3
# nuZB9BfBwAQYK9FHaoq2e26MHvVY9gCDA/JYsq7pGdogP8HRtrYfctSLANEBfHU1
# 6r3J05qX3kId+ZOczgj5kjatVB+NdADVZKON/gnZruMvNYY2o1f4MXRJDMdTSlOL
# h0HCn2cQLwQCqjFbqrXuvTPSegOOzr4EWj7PtspIHBldNE2K9i697cvaiIo2p61E
# d2p8xMJb82Yosn0z4y25xUbI7GIN/TpVfHIqQ6Ku/qjTY6hc3hsXMrS+U0yy+GWq
# AXam4ToWd2UQ1KYT70kZjE4YtL8Pbzg0c1ugMZyZZd/BdHLiRu7hAWE6bTEm4XYR
# kA6Tl4KSFLFk43esaUeqGkH/wyW4N7OigizwJWeukcyIPbAvjSabnf7+Pu0VrFgo
# iovRDiyx3zEdmcif/sYQsfch28bZeUz2rtY/9TCA6TD8dC3JE3rYkrhLULy7Dc90
# G6e8BlqmyIjlgp2+VqsS9/wQD7yFylIz0scmbKvFoW2jNrbM1pD2T7m3XDCCBY0w
# ggR1oAMCAQICEA6bGI750C3n79tQ4ghAGFowDQYJKoZIhvcNAQEMBQAwZTELMAkG
# A1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRp
# Z2ljZXJ0LmNvbTEkMCIGA1UEAxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENB
# MB4XDTIyMDgwMTAwMDAwMFoXDTMxMTEwOTIzNTk1OVowYjELMAkGA1UEBhMCVVMx
# FTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNv
# bTEhMB8GA1UEAxMYRGlnaUNlcnQgVHJ1c3RlZCBSb290IEc0MIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAv+aQc2jeu+RdSjwwIjBpM+zCpyUuySE98orY
# WcLhKac9WKt2ms2uexuEDcQwH/MbpDgW61bGl20dq7J58soR0uRf1gU8Ug9SH8ae
# FaV+vp+pVxZZVXKvaJNwwrK6dZlqczKU0RBEEC7fgvMHhOZ0O21x4i0MG+4g1ckg
# HWMpLc7sXk7Ik/ghYZs06wXGXuxbGrzryc/NrDRAX7F6Zu53yEioZldXn1RYjgwr
# t0+nMNlW7sp7XeOtyU9e5TXnMcvak17cjo+A2raRmECQecN4x7axxLVqGDgDEI3Y
# 1DekLgV9iPWCPhCRcKtVgkEy19sEcypukQF8IUzUvK4bA3VdeGbZOjFEmjNAvwjX
# WkmkwuapoGfdpCe8oU85tRFYF/ckXEaPZPfBaYh2mHY9WV1CdoeJl2l6SPDgohIb
# Zpp0yt5LHucOY67m1O+SkjqePdwA5EUlibaaRBkrfsCUtNJhbesz2cXfSwQAzH0c
# lcOP9yGyshG3u3/y1YxwLEFgqrFjGESVGnZifvaAsPvoZKYz0YkH4b235kOkGLim
# dwHhD5QMIR2yVCkliWzlDlJRR3S+Jqy2QXXeeqxfjT/JvNNBERJb5RBQ6zHFynIW
# IgnffEx1P2PsIV/EIFFrb7GrhotPwtZFX50g/KEexcCPorF+CiaZ9eRpL5gdLfXZ
# qbId5RsCAwEAAaOCATowggE2MA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFOzX
# 44LScV1kTN8uZz/nupiuHA9PMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3z
# bcgPMA4GA1UdDwEB/wQEAwIBhjB5BggrBgEFBQcBAQRtMGswJAYIKwYBBQUHMAGG
# GGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBDBggrBgEFBQcwAoY3aHR0cDovL2Nh
# Y2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNydDBF
# BgNVHR8EPjA8MDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRBc3N1cmVkSURSb290Q0EuY3JsMBEGA1UdIAQKMAgwBgYEVR0gADANBgkqhkiG
# 9w0BAQwFAAOCAQEAcKC/Q1xV5zhfoKN0Gz22Ftf3v1cHvZqsoYcs7IVeqRq7IviH
# GmlUIu2kiHdtvRoU9BNKei8ttzjv9P+Aufih9/Jy3iS8UgPITtAq3votVs/59Pes
# MHqai7Je1M/RQ0SbQyHrlnKhSLSZy51PpwYDE3cnRNTnf+hZqPC/Lwum6fI0POz3
# A8eHqNJMQBk1RmppVLC4oVaO7KTVPeix3P0c2PR3WlxUjG/voVA9/HYJaISfb8rb
# II01YBwCA8sgsKxYoA5AY8WYIsGyWfVVa88nq2x2zm8jLfR+cWojayL/ErhULSd+
# 2DrZ8LaHlv1b0VysGMNNn3O3AamfV6peKOK5lDGCA3wwggN4AgEBMH0waTELMAkG
# A1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQDEzhEaWdp
# Q2VydCBUcnVzdGVkIEc0IFRpbWVTdGFtcGluZyBSU0E0MDk2IFNIQTI1NiAyMDI1
# IENBMQIQCoDvGEuN8QWC0cR2p5V0aDANBglghkgBZQMEAgEFAKCB0TAaBgkqhkiG
# 9w0BCQMxDQYLKoZIhvcNAQkQAQQwHAYJKoZIhvcNAQkFMQ8XDTI1MTIyMzExNTAx
# M1owKwYLKoZIhvcNAQkQAgwxHDAaMBgwFgQU3WIwrIYKLTBr2jixaHlSMAf7QX4w
# LwYJKoZIhvcNAQkEMSIEIMlg4vlZ59T6UkwmRJDBFYI5Dhz9erZZXtEFp3X664zr
# MDcGCyqGSIb3DQEJEAIvMSgwJjAkMCIEIEqgP6Is11yExVyTj4KOZ2ucrsqzP+Nt
# JpqjNPFGEQozMA0GCSqGSIb3DQEBAQUABIICAJOAGT/XPamnKYkqLj26+vNJLGPS
# ELwn+2LDTuSn+ZDknx0yS5FcejKiC2hGVQK+gz4JW3UQNb14jzFktn2NVsdpqWJs
# 6HC/KUa16x6w1j1r2PGqm0O6xZU5yObEH/rrpfrW86CHBywXsM+DG5yZbxklj0Ew
# bkSSzBqnuLBLE7Bs9tp1RZpdy6L6zEExHfOSOd7qUGgJP1sedE7X/Qt5NyY+k9wM
# HDR5+VGnsN30zkvxGwsV45NuarkB/6ByrB9hsMOZMqMmky0K3ssb5CGYy+11RsPI
# dV6L+nqtPfgSga1HvrvpXugdfNB9Io+aGljdXcxJPuuBFV3Lqwev2ZYTkgWZGRy/
# 5WhsdCl7S9oEyxHKvlUlNZJlvJIdx6s3iK/XNsyT2UkrDCPR3ph9EC4Bkhxb09Yi
# TRLZwSpo8oc8B2JkaahlYB+XGvRotIMenMtJJEHvZaSDTKailM9BwzJs/2rDsjXD
# V8GMWcfYD/t7KFxSn+pp81pB5Sip9EhRYg8f9bVyCp+goXzge2iwOzW8wi9wn+m/
# 6JfLKYPp/OidwrG58ivG3SxkO/k7zUcWUKYaK2mOtLIn+iKqq2sO07N7yTXIm7S+
# ZvhCdRNP0es3gXAUb62hoh8SwiBxbQxSK/npR503t2OdncRa2IeTZd/3dLciSYJj
# mvcns8K89/OOjezA
# SIG # End signature block
