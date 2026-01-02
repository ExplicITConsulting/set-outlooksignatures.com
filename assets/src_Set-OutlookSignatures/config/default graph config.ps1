# This file allows defining the default configuration for connecting to Microsoft Graph for Set-OutlookSignatures
#
# This script is executed as a whole once per Set-OutlookSignatures run.
#
# Attention: The configuration file is executed as part of Set-OutlookSignatures.ps1 and is not checked for any harmful content. Please only allow qualified technicians write access to this file, only use it to to define replacement variables and test it thoroughly.
#
# A variable defined in this file overrides the definition of the same variable defined earlier in the software.
#
#
# What is the recommended approach for custom configuration files?
# You should not change the default configuration file '.\config\default graph config.ps1', as it might be changed in a future release of Set-OutlookSignatures. In this case, you would have to sort out the changes yourself.
#
# The following steps are recommended:
# 1. Create a new custom configuration file in a separate folder.
# 2. The first step in the new custom configuration file should be to load the default configuration file:
#    # Loading default replacement variables shipped with Set-OutlookSignatures
#    . ([System.Management.Automation.ScriptBlock]::Create((ConvertEncoding -InFile $(Join-Path -Path $(Get-Location).ProviderPath -ChildPath '\config\default graph config.ps1') -InIsHtml $false)))
# 3. After importing the default configuration file, existing configurations and mappings can be altered with custom definitions and new ones can be added.
# 4. Instead of altering existing replacement variables, it is recommended to create new replacement variables with modified content.
# 5. Start Set-OutlookSignatures with the parameter 'GraphConfigFile' pointing to the new custom configuration file.


# Client ID
# The default client ID is defined in the developers Entra ID tenant as multi-tenant, so it can be used everywhere
#   For security and maintenance reasons, it is recommended to create you own app in your own tenant
# It can be replaced with the ID of an app created in your own tenant
#   Option A: Create the app automatically by using the script '.\sample code\Create-EntraApp.ps1'
#     The sample code creates the app with all required settings
#   Option B: Create the Entra ID app manually
#     Create an app in Entra admin center (https://entra.microsoft.com)
#       Sign in with an account that has Cloud Application Administrator or Global Admin permissions
#       Identity > Applications > App registrations > New registration
#       Enter at least a display name for your application
#       Set "Supported account types" to "Accounts in this organizational directory only (<your tenant> - Single tenant)"
#       Set Redirect URI to "Mobile and desktop applications" and add
#         'http://localhost' (http, not https) for browser authentication
#         'ms-appx-web://microsoft.aad.brokerplugin/<Application ID of your app>' for AuthenticationBroker authentication
#       The "Application (client) ID" is the value you need to set for the GraphClientID parameter of Set-OutlookSignatures
#     Client secret
#       There is no need to define a client secret, as we only work with delegated permissions, and not with application permissions
#     Add the following delegated permissions (not application permissions)
#       Identity > Applications > App registrations > your application > Manage > API permissions > Add a permission
#       Microsoft Graph, delegated permissions
#         email
#           Allows the app to read your users' primary email address.
#           Required to log on the current user.
#         EWS.AccessAsUser.All
#           Allows the app to have the same access to mailboxes as the signed-in user via Exchange Web Services.
#           Required to connect to Outlook on the web and to set Outlook signatures.
#         Files.Read.All
#           Allows the app to read all files the signed-in user can access.
#           Required for access to templates and configuration files hosted on SharePoint Online.
#           For added security, use Files.SelectedOperations.Selected as alternative, requiring granting specific permissions in SharePoint Online.
#         GroupMember.Read.All
#           Allows the app to list groups, read basic group properties and read membership of all groups the signed-in user has access to.
#           Required to find groups by name and to get their security identifier (SID) and the number of transitive members.
#         Mail.ReadWrite
#           Allows the app to create, read, update, and delete email in user mailboxes. Does not include permission to send mail.
#           Required to connect to Outlook on the web and to set Outlook signatures.
#         MailboxSettings.ReadWrite
#           Allows the app to create, read, update, and delete user's mailbox settings. Does not include permission to send mail.
#           Required to detect the state of the out-of-office assistant and to set out-of-office replies.
#         offline_access
#           Allows the app to see and update the data you gave it access to, even when users are not currently using the app. This does not give the app any additional permissions.
#           Required to get a refresh token from Graph.
#         openid
#           Allows users to sign in to the app with their work or school accounts and allows the app to see basic user profile information.
#           Required to log on the current user.
#         profile
#           Allows the app to see your users' basic profile (e.g., name, picture, user name, email address).
#           Required to log on the current user, to access the '/me' Graph API, to get basic properties of the current user.
#         User.Read.All
#           Allows the app to read the full set of profile properties, reports, and managers of other users in your organization, on behalf of the signed-in user.
#           Required for $CurrentUser[…]$ and $CurrentMailbox[…]$ replacement variables, and for simulation mode.
#       Provide admin consent
#         Click the "Grant admin consent for <your tenant>" button
#     Enable 'Allow public client flows'
#       Identity > Applications > App registrations > your application > Manage > Authentication > Advanced settings
#       Enable "Allow public client flows"
#       This enables SSO (single sign-on) for domain-joined Windows clients
#
# It is strongly recommended to use the GraphClientID parameter of Set-OutlookSignatures instead of defining it here.
if (-not $GraphClientID) { $GraphClientID = 'beea8249-8c98-4c76-92f6-ce3c468a61e6' }


# Endpoint version
$GraphEndpointVersion = 'v1.0'


# Message box text to show when Linux keyring or macOS keychain is not yet unlocked, and the system asks the user for the password to unlock it
# Leave blank to not show message box at all
# Defining a text is recommended to inform users why they are asked by the system to unlock their keyring or keychain
#   Set-OutlookSignatures usually runs in the background, so the system request is a negative surprise for users
# On Windows, the message box is shown on the very top of the active desktop and cannot be sent to the background,
#   but does not steal the focus
$GraphUnlockKeyringKeychainMessageboxText = "You started Set-OutlookSignatures, or an administrator configured it to run for you to update your Outlook signatures and out-of-office replies.$([System.Environment]::NewLine)$([System.Environment]::NewLine)To look up a required security token for access to Microsoft 365, $(if ((Test-Path -LiteralPath 'variable:IsLinux') -and $IsLinux) { $($PSVersionTable.OS) } elseif ((Test-Path -LiteralPath 'variable:IsMacOS') -and $IsMacOS) { $("$(sw_vers -productName) $(sw_vers -productVersion)") }) will ask you to unlock your personal $( if ((Test-Path -LiteralPath 'variable:IsLinux') -and $IsLinux) { 'keyring' } else { 'keychain' }) with your password.$([System.Environment]::NewLine)$([System.Environment]::NewLine)Should you choose to not unlock you personal $( if ((Test-Path -LiteralPath 'variable:IsLinux') -and $IsLinux) { 'keyring' } else { 'keychain' }), the security token will be saved in an unencrypted file in your user directory."


# Message box text to show before browser opens for authentication to Microsoft 365
# Leave blank to not show message box at all
# Defining a text is recommended to inform users about the upcoming opening of a new browser tab asking for authentication
#   Set-OutlookSignatures usually runs in the background and the M365 logon screen cannot show a hint to Set-OutlookSignatures,
#   so the new tab is a negative surprise for users
# On Windows, the message box is shown on the very top of the active desktop and cannot be sent to the background,
#   but does not steal the focus
$GraphHtmlMessageboxText = "You started Set-OutlookSignatures, or an administrator configured it to run for you to update your Outlook signatures and out-of-office replies.$([System.Environment]::NewLine)$([System.Environment]::NewLine)A required security token for access to Microsoft 365 is not yet available.$([System.Environment]::NewLine)$([System.Environment]::NewLine)The program may run for the first time on this client, a previous security token may have expired or been deleted.$([System.Environment]::NewLine)$([System.Environment]::NewLine)To create this required security token, please login to Microsoft 365 with your account in the new window or browser tab that will open after you click OK in this message."


# HTML message to show after successful browser authentication to Microsoft Graph
# Try to keep the resulting HTML code small, as long code may lead to display errors ("connection reset")
$GraphHtmlMessageSuccess = "<html><head><title>$(if ($BenefactorCircleLicenseFile) { 'Set-OutlookSignatures Benefactor Circle' } else { 'Set-OutlookSignatures' })</title></head><body style=""font-family:sans-serif;""><h1><a href=""$(if ($BenefactorCircleLicenseFile) { 'https://set-outlooksignatures.com/benefactorcircle' } else { 'https://set-outlooksignatures.com' })"" target=""_blank"">$(if ($BenefactorCircleLicenseFile) { 'Set-OutlookSignatures Benefactor Circle' } else { 'Set-OutlookSignatures' })</a></h1><p>Graph authentication successful at $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK').</p><p>&nbsp;</p><p><strong>Thank you for using <a href=""$(if ($BenefactorCircleLicenseFile) { 'https://set-outlooksignatures.com/benefactorcircle' } else { 'https://set-outlooksignatures.com' })"" target=""_blank"">$(if ($BenefactorCircleLicenseFile) { 'Set-OutlookSignatures Benefactor Circle' } else { 'Set-OutlookSignatures' })</a>!</strong></p><p>&nbsp;</p><p>You can close this tab at any time.</p></body></html>"
# Example with automatically closing tab: $GraphHtmlMessageSuccess = "<html><head><script>window.close();</script><title>$(if ($BenefactorCircleLicenseFile) { 'Set-OutlookSignatures Benefactor Circle' } else { 'Set-OutlookSignatures' })</title></head><body style=""font-family:sans-serif;""><h1><a href=""$(if ($BenefactorCircleLicenseFile) { 'https://set-outlooksignatures.com/benefactorcircle' } else { 'https://set-outlooksignatures.com' })"" target=""_blank"">$(if ($BenefactorCircleLicenseFile) { 'Set-OutlookSignatures Benefactor Circle' } else { 'Set-OutlookSignatures' })</a></h1><p>Graph authentication successful at $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK').</p><p>&nbsp;</p><p><strong>Thank you for using <a href=""$(if ($BenefactorCircleLicenseFile) { 'https://set-outlooksignatures.com/benefactorcircle' } else { 'https://set-outlooksignatures.com' })"" target=""_blank"">$(if ($BenefactorCircleLicenseFile) { 'Set-OutlookSignatures Benefactor Circle' } else { 'Set-OutlookSignatures' })</a>!</strong></p><p>&nbsp;</p><p>You can close this tab at any time.</p></body></html>"


# When the user successfully authenticates in the browser, the browser will be redirected to to the given Uri
# Takes precedence over $GraphHtmlMessageSuccess
[uri] $GraphBrowserRedirectSuccess = ''


# HTML message to show after unsuccessful browser authentication to Microsoft Graph
# Try to keep the resulting HTML code small, as long code may lead to display errors ("connection reset")
$GraphHtmlMessageError = "<html><head><title>$(if ($BenefactorCircleLicenseFile) { 'Set-OutlookSignatures Benefactor Circle' } else { 'Set-OutlookSignatures' })</title></head><body style=""font-family:sans-serif;""><h1><a href=""$(if ($BenefactorCircleLicenseFile) { 'https://set-outlooksignatures.com/benefactorcircle' } else { 'https://set-outlooksignatures.com' })"" target=""_blank"">$(if ($BenefactorCircleLicenseFile) { 'Set-OutlookSignatures Benefactor Circle' } else { 'Set-OutlookSignatures' })</a></h1><p>Graph authentication failed at $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK').</p><p>You may want to inform your helpdesk or administrator about this problem.</p><p>&nbsp;</p><p>Error: {0}</p><p>Details: {1}</p><p>&nbsp;</p><p><strong>Thank you for using <a href=""$(if ($BenefactorCircleLicenseFile) { 'https://set-outlooksignatures.com/benefactorcircle' } else { 'https://set-outlooksignatures.com' })"" target=""_blank"">$(if ($BenefactorCircleLicenseFile) { 'Set-OutlookSignatures Benefactor Circle' } else { 'Set-OutlookSignatures' })</a>!</strong></p></body></html>"


# When the user fails to successfully authenticate in the browser, the browser will be redirected to to the given Uri
# Takes precedence over $GraphHtmlMessageError
[uri] $GraphBrowserRedirectError = ''


# User properties to retrieve from Microsoft Graph/Entra ID
# Custom Entra ID attributes use the following naming scheme: 'extension_<App ID w/o dashes of the app owning the extension attribute>_<attribute name>'
$GraphUserProperties = @(
    'businessPhones',
    'city',
    'companyName',
    'country',
    'department',
    'displayName',
    'faxNumber',
    'givenName',
    'jobTitle',
    'mail',
    'mailNickname',
    'mobilePhone',
    'officeLocation',
    'onPremisesExtensionAttributes',
    'postalCode',
    'proxyAddresses',
    'state',
    'streetAddress',
    'surname'
)


# Mapping Graph/Entra ID user properties to on-prem Active Directory user properties and for use as replacement variables
# This way, we do not need to differentiate between on-prem, hybrid and cloud in '.\config\default replacement variables.ps1'
# Active Directory attribute name on the left, Entra ID attribute name on the right
#   If the attribute only exists in Entra ID, just make up a non-existing Active Directory attribute name
# Custom Entra ID attributes use the following naming scheme: 'extension_<App ID w/o dashes of the app owning the extension attribute>_<attribute name>'
$GraphUserAttributeMapping = @{
    co                         = 'country'
    company                    = 'companyName'
    department                 = 'department'
    displayName                = 'displayName'
    extensionAttribute1        = 'onPremisesExtensionAttributes.extensionAttribute1'
    extensionAttribute2        = 'onPremisesExtensionAttributes.extensionAttribute2'
    extensionAttribute3        = 'onPremisesExtensionAttributes.extensionAttribute3'
    extensionAttribute4        = 'onPremisesExtensionAttributes.extensionAttribute4'
    extensionAttribute5        = 'onPremisesExtensionAttributes.extensionAttribute5'
    extensionAttribute6        = 'onPremisesExtensionAttributes.extensionAttribute6'
    extensionAttribute7        = 'onPremisesExtensionAttributes.extensionAttribute7'
    extensionAttribute8        = 'onPremisesExtensionAttributes.extensionAttribute8'
    extensionAttribute9        = 'onPremisesExtensionAttributes.extensionAttribute9'
    extensionAttribute10       = 'onPremisesExtensionAttributes.extensionAttribute10'
    extensionAttribute11       = 'onPremisesExtensionAttributes.extensionAttribute11'
    extensionAttribute12       = 'onPremisesExtensionAttributes.extensionAttribute12'
    extensionAttribute13       = 'onPremisesExtensionAttributes.extensionAttribute13'
    extensionAttribute14       = 'onPremisesExtensionAttributes.extensionAttribute14'
    extensionAttribute15       = 'onPremisesExtensionAttributes.extensionAttribute15'
    facsimileTelephoneNumber   = 'faxNumber'
    givenName                  = 'givenName'
    l                          = 'city'
    mail                       = 'mail'
    mailNickname               = 'mailNickname'
    mobile                     = 'mobilePhone'
    physicalDeliveryOfficeName = 'officeLocation'
    postalCode                 = 'postalCode'
    proxyAddresses             = 'proxyAddresses'
    sn                         = 'surname'
    st                         = 'state'
    streetAddress              = 'streetAddress'
    telephoneNumber            = 'businessPhones'
    title                      = 'jobTitle'
}


# SIG # Begin signature block
# MIIwaAYJKoZIhvcNAQcCoIIwWTCCMFUCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCADi/ePzNK2nm5J
# HN+AV5fOT7ksuM9ezHccxHGjr4AROqCCFCkwggWQMIIDeKADAgECAhAFmxtXno4h
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
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgl5CP7Nzs
# uRy7DEMy3kB5y/APFjpuCSKaBuQ7hzVe5h8wggEABgorBgEEAYI3AgEMMYHxMIHu
# oIHFgIHCAFAAbwB3AGUAcgBlAGQAIABiAHkAIABFAHgAcABsAGkAYwBJAFQAIABD
# AG8AbgBzAHUAbAB0AGkAbgBnAC4AIABVAG4AbABvAGMAawAgAGEAbABsACAAZgBl
# AGEAdAB1AHIAZQBzACAAdwBpAHQAaAAgAFMAZQB0AC0ATwB1AHQAbABvAG8AawBT
# AGkAZwBuAGEAdAB1AHIAZQBzACAAQgBlAG4AZQBmAGEAYwB0AG8AcgAgAEMAaQBy
# AGMAbABlAC6hJIAiaHR0cHM6Ly9zZXQtb3V0bG9va3NpZ25hdHVyZXMuY29tIDAN
# BgkqhkiG9w0BAQEFAASCAgCpV2yVq0rqx+gV/GBkBhio96ptfyib1/EyaadH3Z/H
# w6KgekNPq3Fw9cJAB/UlJoQSZUJHD6C1+nrEvMWkkIg3TfL9GWkhOJOG8UKYu89G
# DavtNsyhOa7DZmQS5S3lSPj+A5Fz75pa9aY+4xPp+fIy/cFlaPcaXmuAwcgLHVVb
# PY5UQ7KqNTHL/TibiSxj4w7xXKrPF9OoYB36OO4zSArylhb2qNS1mBRiGPjxF29c
# 7srxOASncsPAZYp0vI6VJkagEr24RLK9BPfK+Vz21fqxDA4WYWvYTrbkKE/97RrX
# P4zZA4NsLrVvYJn+X1f8K88LptKIQyF2r3V0vXKZvUMQBk+TWbjEmPuaEhvjwwLA
# JBioZhA+wcBFtInbriVPbHdZNqR+4fibHWRDDb65Zh+7x8Ha96kwT0/oooGQ8rrx
# ZpqJJaB7mu1WV6RMqHPRJPEgPq3GSXoaCVV8GODamptiGdOUt4/Lzk/04HE8a9pl
# x1NqeUGwMFXpCMlfs8XZ42mH3HNnnVbjyeuHB3nG4FKsYjI+UbOg2RUZI6At6sjN
# oHghyTqsAPv1ZjdQwJ1aerxHVePbejZjE2JruArPURaCpcv/ct+UiPaanrIg6wZB
# 1tVWMr/nPhPhNuGOHau+kmBvHPWQRBjAMBDk+ovWdyD5j+zhc39v4aJvaZOTOY2g
# JqGCF3cwghdzBgorBgEEAYI3AwMBMYIXYzCCF18GCSqGSIb3DQEHAqCCF1AwghdM
# AgEDMQ8wDQYJYIZIAWUDBAIBBQAweAYLKoZIhvcNAQkQAQSgaQRnMGUCAQEGCWCG
# SAGG/WwHATAxMA0GCWCGSAFlAwQCAQUABCADtDf9ql0+caDkjm7V/wLjzirDU3Nb
# +d+lY98VijselQIRALr6iM5GLjSKhjifBi+7u1wYDzIwMjUxMjIzMTE1MDE0WqCC
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
# NFowKwYLKoZIhvcNAQkQAgwxHDAaMBgwFgQU3WIwrIYKLTBr2jixaHlSMAf7QX4w
# LwYJKoZIhvcNAQkEMSIEIJm3jNdmi5nGp3zsagwAOe3EZrLzzMtY+8tp5ZAzYIlp
# MDcGCyqGSIb3DQEJEAIvMSgwJjAkMCIEIEqgP6Is11yExVyTj4KOZ2ucrsqzP+Nt
# JpqjNPFGEQozMA0GCSqGSIb3DQEBAQUABIICAEV+IPxeSNg+H63O8wIu+RIvpU/T
# jU7Vc7RFlmgxg8YiRvJLQtzcbQTq4LdxRvRdp8/oQquQa2eqwBgO1zJjxD30b54X
# b+R0XteETTq+f3kzLATF7/qPuC+ZG1Zf+h4nvH5mWspPNcL3kxE46pdwXN5Eukh+
# EFNXMDKkNwbCDVHVZWMRtWYBuOLXo1chxJrGlZ702oK4Z2AnfvTu7CrFWcHlnWmX
# Z3hNUH6Jy+jgbl+S9DrsyVIT/TzOx6wIYXbbxOxVPJrbZ60eo9EHAPYV5rPxCV/m
# PHYHIW/A+ebvelID8VmmBwrDt53/4aNyFhdKdfEPCjJ2g8yNaxFoxKk9e+qA31ce
# 3nVcln9gviLzzAes1qg4qnYIxnMlkqJz44fmewoq1QXBpUj7g/nxWn0CXkAx3e2w
# RuT+n57SSilNUsF/xh/qldy3sMYroV5AjouVk7pOs/e0FFyLgyEITst48INuLCfH
# 7PyemoP8nw5XNVIZCwjm1CJCnJ009jSM+KaxXUgAxdFH5ohe4NsyxAWuXmzXKjdj
# 6I+8Mp3VyXV3jy64LkmiYwVoByAvJYAwR2lM2tXPdWSqxiSUuCov1VvDlmZ/Yn0z
# E2YL1/A0SsCI7+VooMN7BMK6hyEhwnJFnPNfWjDtEmGR5GUrpFk6VZiq4GbTU6Fp
# 6J3anGxAwBDlU9hv
# SIG # End signature block
