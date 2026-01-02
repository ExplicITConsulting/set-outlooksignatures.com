# This file allows defining custom replacement variables for Set-OutlookSignatures
#
# This script is executed as a whole once for each mailbox.
# It allows for complex replacement variable handling (complex string transformations, retrieving information from web services and databases, etc.).
#   Important when the final text value of a variable contains another variable: Variables are not replaced in the order they are defined in this file,
#     but alphabetically using the sort order culture 127 (invariant).
#
# Attention: The configuration file is executed as part of Set-OutlookSignatures.ps1 and is not checked for any harmful content. Please only allow qualified technicians write access to this file, only use it to to define replacement variables and test it thoroughly.
#
# Replacement variable names are not case sensitive.
#
# A variable defined in this file overrides the definition of the same variable defined earlier in the software.
#
#
# See README file for more examples, such as:
#   Allowed tags
#   How to work with INI files
#   Variable replacement
#   Photos from Active Directory
#   Delete images when attribute is empty, variable content based on group membership
#   How to avoid blank lines when replacement variables return an empty string?
#
#
# What is the recommended approach for custom configuration files?
# You should not change the default configuration file '.\config\default replacement variable.ps1', as it might be changed in a future release of Set-OutlookSignatures. In this case, you would have to sort out the changes yourself.
#
# The following steps are recommended:
# 1. Create a new custom configuration file in a separate folder.
# 2. The first step in the new custom configuration file should be to load the default configuration file:
#    # Loading default replacement variables shipped with Set-OutlookSignatures
#    . ([System.Management.Automation.ScriptBlock]::Create((ConvertEncoding -InFile $(Join-Path -Path $(Get-Location).ProviderPath -ChildPath '\config\default replacement variables.ps1') -InIsHtml $false)))
# 3. After importing the default configuration file, existing replacement variables can be altered with custom definitions and new replacement variables can be added.
# 4. Instead of altering existing replacement variables, it is recommended to create new replacement variables with modified content.
# 5. Start Set-OutlookSignatures with the parameter 'ReplacementVariableConfigFile' pointing to the new custom configuration file.
#
#
# To simplify signature design in limited space, shorter versions of replacement variables are made available automatically:
# - CurrentUser -> U
#   Example: '$CurrentUserVariableX$' is also available as '$UVariableX$'
# - CurrentUserManager -> UM
#   Example: '$CurrentUserManagerVariableX$' is also available as '$UMVariableX$'
# - CurrentMailbox -> M
#   Example: '$CurrentMailboxVariableX$' is also available as '$MVariableX$'
# - CurrentMailboxManager -> MM
#   Example: '$CurrentMailboxManagerVariableX$' is also available as '$MMVariableX$'


# Currently logged in user
$ReplaceHash['$CurrentUserGivenName$'] = [string]$ADPropsCurrentUser.givenName
$ReplaceHash['$CurrentUserSurname$'] = [string]$ADPropsCurrentUser.sn
$ReplaceHash['$CurrentUserDepartment$'] = [string]$ADPropsCurrentUser.department
$ReplaceHash['$CurrentUserTitle$'] = [string]$ADPropsCurrentUser.title
$ReplaceHash['$CurrentUserStreetAddress$'] = [string]$ADPropsCurrentUser.streetAddress
$ReplaceHash['$CurrentUserPostalcode$'] = [string]$ADPropsCurrentUser.postalCode
$ReplaceHash['$CurrentUserLocation$'] = [string]$ADPropsCurrentUser.l
$ReplaceHash['$CurrentUserCountry$'] = [string]$ADPropsCurrentUser.co
$ReplaceHash['$CurrentUserState$'] = [string]$ADPropsCurrentUser.st
$ReplaceHash['$CurrentUserTelephone$'] = [string]$ADPropsCurrentUser.telephoneNumber
$ReplaceHash['$CurrentUserFax$'] = [string]$ADPropsCurrentUser.facsimileTelephoneNumber
$ReplaceHash['$CurrentUserMobile$'] = [string]$ADPropsCurrentUser.mobile
$ReplaceHash['$CurrentUserMail$'] = [string]$ADPropsCurrentUser.mail
$ReplaceHash['$CurrentUserPhoto$'] = $ADPropsCurrentUser.thumbnailPhoto
$ReplaceHash['$CurrentUserPhotoDeleteEmpty$'] = $ADPropsCurrentUser.thumbnailPhoto
$ReplaceHash['$CurrentUserExtAttr1$'] = [string]$ADPropsCurrentUser.extensionAttribute1
$ReplaceHash['$CurrentUserExtAttr2$'] = [string]$ADPropsCurrentUser.extensionAttribute2
$ReplaceHash['$CurrentUserExtAttr3$'] = [string]$ADPropsCurrentUser.extensionAttribute3
$ReplaceHash['$CurrentUserExtAttr4$'] = [string]$ADPropsCurrentUser.extensionAttribute4
$ReplaceHash['$CurrentUserExtAttr5$'] = [string]$ADPropsCurrentUser.extensionAttribute5
$ReplaceHash['$CurrentUserExtAttr6$'] = [string]$ADPropsCurrentUser.extensionAttribute6
$ReplaceHash['$CurrentUserExtAttr7$'] = [string]$ADPropsCurrentUser.extensionAttribute7
$ReplaceHash['$CurrentUserExtAttr8$'] = [string]$ADPropsCurrentUser.extensionAttribute8
$ReplaceHash['$CurrentUserExtAttr9$'] = [string]$ADPropsCurrentUser.extensionAttribute9
$ReplaceHash['$CurrentUserExtAttr10$'] = [string]$ADPropsCurrentUser.extensionAttribute10
$ReplaceHash['$CurrentUserExtAttr11$'] = [string]$ADPropsCurrentUser.extensionAttribute11
$ReplaceHash['$CurrentUserExtAttr12$'] = [string]$ADPropsCurrentUser.extensionAttribute12
$ReplaceHash['$CurrentUserExtAttr13$'] = [string]$ADPropsCurrentUser.extensionAttribute13
$ReplaceHash['$CurrentUserExtAttr14$'] = [string]$ADPropsCurrentUser.extensionAttribute14
$ReplaceHash['$CurrentUserExtAttr15$'] = [string]$ADPropsCurrentUser.extensionAttribute15
$ReplaceHash['$CurrentUserOffice$'] = [string]$ADPropsCurrentUser.physicalDeliveryOfficeName
$ReplaceHash['$CurrentUserCompany$'] = [string]$ADPropsCurrentUser.company
$ReplaceHash['$CurrentUserMailNickname$'] = [string]$ADPropsCurrentUser.mailNickname
$ReplaceHash['$CurrentUserDisplayName$'] = [string]$ADPropsCurrentUser.displayName


# Manager of currently logged in user
$ReplaceHash['$CurrentUserManagerGivenName$'] = [string]$ADPropsCurrentUserManager.givenName
$ReplaceHash['$CurrentUserManagerSurname$'] = [string]$ADPropsCurrentUserManager.sn
$ReplaceHash['$CurrentUserManagerDepartment$'] = [string]$ADPropsCurrentUserManager.department
$ReplaceHash['$CurrentUserManagerTitle$'] = [string]$ADPropsCurrentUserManager.title
$ReplaceHash['$CurrentUserManagerStreetAddress$'] = [string]$ADPropsCurrentUserManager.streetAddress
$ReplaceHash['$CurrentUserManagerPostalcode$'] = [string]$ADPropsCurrentUserManager.postalCode
$ReplaceHash['$CurrentUserManagerLocation$'] = [string]$ADPropsCurrentUserManager.l
$ReplaceHash['$CurrentUserManagerCountry$'] = [string]$ADPropsCurrentUserManager.co
$ReplaceHash['$CurrentUserManagerState$'] = [string]$ADPropsCurrentUserManager.st
$ReplaceHash['$CurrentUserManagerTelephone$'] = [string]$ADPropsCurrentUserManager.telephoneNumber
$ReplaceHash['$CurrentUserManagerFax$'] = [string]$ADPropsCurrentUserManager.facsimileTelephoneNumber
$ReplaceHash['$CurrentUserManagerMobile$'] = [string]$ADPropsCurrentUserManager.mobile
$ReplaceHash['$CurrentUserManagerMail$'] = [string]$ADPropsCurrentUserManager.mail
$ReplaceHash['$CurrentUserManagerPhoto$'] = $ADPropsCurrentUserManager.thumbnailPhoto
$ReplaceHash['$CurrentUserManagerExtAttr1$'] = [string]$ADPropsCurrentUserManager.extensionAttribute1
$ReplaceHash['$CurrentUserManagerExtAttr2$'] = [string]$ADPropsCurrentUserManager.extensionAttribute2
$ReplaceHash['$CurrentUserManagerExtAttr3$'] = [string]$ADPropsCurrentUserManager.extensionAttribute3
$ReplaceHash['$CurrentUserManagerExtAttr4$'] = [string]$ADPropsCurrentUserManager.extensionAttribute4
$ReplaceHash['$CurrentUserManagerExtAttr5$'] = [string]$ADPropsCurrentUserManager.extensionAttribute5
$ReplaceHash['$CurrentUserManagerExtAttr6$'] = [string]$ADPropsCurrentUserManager.extensionAttribute6
$ReplaceHash['$CurrentUserManagerExtAttr7$'] = [string]$ADPropsCurrentUserManager.extensionAttribute7
$ReplaceHash['$CurrentUserManagerExtAttr8$'] = [string]$ADPropsCurrentUserManager.extensionAttribute8
$ReplaceHash['$CurrentUserManagerExtAttr9$'] = [string]$ADPropsCurrentUserManager.extensionAttribute9
$ReplaceHash['$CurrentUserManagerExtAttr10$'] = [string]$ADPropsCurrentUserManager.extensionAttribute10
$ReplaceHash['$CurrentUserManagerExtAttr11$'] = [string]$ADPropsCurrentUserManager.extensionAttribute11
$ReplaceHash['$CurrentUserManagerExtAttr12$'] = [string]$ADPropsCurrentUserManager.extensionAttribute12
$ReplaceHash['$CurrentUserManagerExtAttr13$'] = [string]$ADPropsCurrentUserManager.extensionAttribute13
$ReplaceHash['$CurrentUserManagerExtAttr14$'] = [string]$ADPropsCurrentUserManager.extensionAttribute14
$ReplaceHash['$CurrentUserManagerExtAttr15$'] = [string]$ADPropsCurrentUserManager.extensionAttribute15
$ReplaceHash['$CurrentUserManagerOffice$'] = [string]$ADPropsCurrentUserManager.physicalDeliveryOfficeName
$ReplaceHash['$CurrentUserManagerCompany$'] = [string]$ADPropsCurrentUserManager.company
$ReplaceHash['$CurrentUserManagerMailNickname$'] = [string]$ADPropsCurrentUserManager.mailNickname
$ReplaceHash['$CurrentUserManagerDisplayName$'] = [string]$ADPropsCurrentUserManager.displayName


# Current mailbox
$ReplaceHash['$CurrentMailboxGivenName$'] = [string]$ADPropsCurrentMailbox.givenName
$ReplaceHash['$CurrentMailboxSurname$'] = [string]$ADPropsCurrentMailbox.sn
$ReplaceHash['$CurrentMailboxDepartment$'] = [string]$ADPropsCurrentMailbox.department
$ReplaceHash['$CurrentMailboxTitle$'] = [string]$ADPropsCurrentMailbox.title
$ReplaceHash['$CurrentMailboxStreetAddress$'] = [string]$ADPropsCurrentMailbox.streetAddress
$ReplaceHash['$CurrentMailboxPostalcode$'] = [string]$ADPropsCurrentMailbox.postalCode
$ReplaceHash['$CurrentMailboxLocation$'] = [string]$ADPropsCurrentMailbox.l
$ReplaceHash['$CurrentMailboxCountry$'] = [string]$ADPropsCurrentMailbox.co
$ReplaceHash['$CurrentMailboxState$'] = [string]$ADPropsCurrentMailbox.st
$ReplaceHash['$CurrentMailboxTelephone$'] = [string]$ADPropsCurrentMailbox.telephoneNumber
$ReplaceHash['$CurrentMailboxFax$'] = [string]$ADPropsCurrentMailbox.facsimileTelephoneNumber
$ReplaceHash['$CurrentMailboxMobile$'] = [string]$ADPropsCurrentMailbox.mobile
$ReplaceHash['$CurrentMailboxMail$'] = [string]$ADPropsCurrentMailbox.mail
$ReplaceHash['$CurrentMailboxPhoto$'] = $ADPropsCurrentMailbox.thumbnailPhoto
$ReplaceHash['$CurrentMailboxExtAttr1$'] = [string]$ADPropsCurrentMailbox.extensionAttribute1
$ReplaceHash['$CurrentMailboxExtAttr2$'] = [string]$ADPropsCurrentMailbox.extensionAttribute2
$ReplaceHash['$CurrentMailboxExtAttr3$'] = [string]$ADPropsCurrentMailbox.extensionAttribute3
$ReplaceHash['$CurrentMailboxExtAttr4$'] = [string]$ADPropsCurrentMailbox.extensionAttribute4
$ReplaceHash['$CurrentMailboxExtAttr5$'] = [string]$ADPropsCurrentMailbox.extensionAttribute5
$ReplaceHash['$CurrentMailboxExtAttr6$'] = [string]$ADPropsCurrentMailbox.extensionAttribute6
$ReplaceHash['$CurrentMailboxExtAttr7$'] = [string]$ADPropsCurrentMailbox.extensionAttribute7
$ReplaceHash['$CurrentMailboxExtAttr8$'] = [string]$ADPropsCurrentMailbox.extensionAttribute8
$ReplaceHash['$CurrentMailboxExtAttr9$'] = [string]$ADPropsCurrentMailbox.extensionAttribute9
$ReplaceHash['$CurrentMailboxExtAttr10$'] = [string]$ADPropsCurrentMailbox.extensionAttribute10
$ReplaceHash['$CurrentMailboxExtAttr11$'] = [string]$ADPropsCurrentMailbox.extensionAttribute11
$ReplaceHash['$CurrentMailboxExtAttr12$'] = [string]$ADPropsCurrentMailbox.extensionAttribute12
$ReplaceHash['$CurrentMailboxExtAttr13$'] = [string]$ADPropsCurrentMailbox.extensionAttribute13
$ReplaceHash['$CurrentMailboxExtAttr14$'] = [string]$ADPropsCurrentMailbox.extensionAttribute14
$ReplaceHash['$CurrentMailboxExtAttr15$'] = [string]$ADPropsCurrentMailbox.extensionAttribute15
$ReplaceHash['$CurrentMailboxOffice$'] = [string]$ADPropsCurrentMailbox.physicalDeliveryOfficeName
$ReplaceHash['$CurrentMailboxCompany$'] = [string]$ADPropsCurrentMailbox.company
$ReplaceHash['$CurrentMailboxMailNickname$'] = [string]$ADPropsCurrentMailbox.mailNickname
$ReplaceHash['$CurrentMailboxDisplayName$'] = [string]$ADPropsCurrentMailbox.displayName


# Manager of current mailbox
$ReplaceHash['$CurrentMailboxManagerGivenName$'] = [string]$ADPropsCurrentMailboxManager.givenName
$ReplaceHash['$CurrentMailboxManagerSurname$'] = [string]$ADPropsCurrentMailboxManager.sn
$ReplaceHash['$CurrentMailboxManagerDepartment$'] = [string]$ADPropsCurrentMailboxManager.department
$ReplaceHash['$CurrentMailboxManagerTitle$'] = [string]$ADPropsCurrentMailboxManager.title
$ReplaceHash['$CurrentMailboxManagerStreetAddress$'] = [string]$ADPropsCurrentMailboxManager.streetAddress
$ReplaceHash['$CurrentMailboxManagerPostalcode$'] = [string]$ADPropsCurrentMailboxManager.postalCode
$ReplaceHash['$CurrentMailboxManagerLocation$'] = [string]$ADPropsCurrentMailboxManager.l
$ReplaceHash['$CurrentMailboxManagerCountry$'] = [string]$ADPropsCurrentMailboxManager.co
$ReplaceHash['$CurrentMailboxManagerState$'] = [string]$ADPropsCurrentMailboxManager.st
$ReplaceHash['$CurrentMailboxManagerTelephone$'] = [string]$ADPropsCurrentMailboxManager.telephoneNumber
$ReplaceHash['$CurrentMailboxManagerFax$'] = [string]$ADPropsCurrentMailboxManager.facsimileTelephoneNumber
$ReplaceHash['$CurrentMailboxManagerMobile$'] = [string]$ADPropsCurrentMailboxManager.mobile
$ReplaceHash['$CurrentMailboxManagerMail$'] = [string]$ADPropsCurrentMailboxManager.mail
$ReplaceHash['$CurrentMailboxManagerPhoto$'] = $ADPropsCurrentMailboxManager.thumbnailPhoto
$ReplaceHash['$CurrentMailboxManagerExtAttr1$'] = [string]$ADPropsCurrentMailboxManager.extensionAttribute1
$ReplaceHash['$CurrentMailboxManagerExtAttr2$'] = [string]$ADPropsCurrentMailboxManager.extensionAttribute2
$ReplaceHash['$CurrentMailboxManagerExtAttr3$'] = [string]$ADPropsCurrentMailboxManager.extensionAttribute3
$ReplaceHash['$CurrentMailboxManagerExtAttr4$'] = [string]$ADPropsCurrentMailboxManager.extensionAttribute4
$ReplaceHash['$CurrentMailboxManagerExtAttr5$'] = [string]$ADPropsCurrentMailboxManager.extensionAttribute5
$ReplaceHash['$CurrentMailboxManagerExtAttr6$'] = [string]$ADPropsCurrentMailboxManager.extensionAttribute6
$ReplaceHash['$CurrentMailboxManagerExtAttr7$'] = [string]$ADPropsCurrentMailboxManager.extensionAttribute7
$ReplaceHash['$CurrentMailboxManagerExtAttr8$'] = [string]$ADPropsCurrentMailboxManager.extensionAttribute8
$ReplaceHash['$CurrentMailboxManagerExtAttr9$'] = [string]$ADPropsCurrentMailboxManager.extensionAttribute9
$ReplaceHash['$CurrentMailboxManagerExtAttr10$'] = [string]$ADPropsCurrentMailboxManager.extensionAttribute10
$ReplaceHash['$CurrentMailboxManagerExtAttr11$'] = [string]$ADPropsCurrentMailboxManager.extensionAttribute11
$ReplaceHash['$CurrentMailboxManagerExtAttr12$'] = [string]$ADPropsCurrentMailboxManager.extensionAttribute12
$ReplaceHash['$CurrentMailboxManagerExtAttr13$'] = [string]$ADPropsCurrentMailboxManager.extensionAttribute13
$ReplaceHash['$CurrentMailboxManagerExtAttr14$'] = [string]$ADPropsCurrentMailboxManager.extensionAttribute14
$ReplaceHash['$CurrentMailboxManagerExtAttr15$'] = [string]$ADPropsCurrentMailboxManager.extensionAttribute15
$ReplaceHash['$CurrentMailboxManagerOffice$'] = [string]$ADPropsCurrentMailboxManager.physicalDeliveryOfficeName
$ReplaceHash['$CurrentMailboxManagerCompany$'] = [string]$ADPropsCurrentMailboxManager.company
$ReplaceHash['$CurrentMailboxManagerMailNickname$'] = [string]$ADPropsCurrentMailboxManager.mailNickname
$ReplaceHash['$CurrentMailboxManagerDisplayName$'] = [string]$ADPropsCurrentMailboxManager.displayName


# Sample code: Full user name including honorific and academic titles
#   $CurrentUserNameWithHonorifics$, $CurrentUserManagerNameWithHonorifics$, $CurrentMailboxNameWithHonorifics$, $CurrentMailboxManagerNameWithHonorifics$
# According to standards in German speaking countries:
#   "<custom AD attribute 'honorificPrefix'> <standard AD attribute 'givenname'> <standard AD attribute 'surname'>, <custom AD attribute 'honorificSuffix'>"
# If one or more attributes are not set, unnecessary whitespaces and commas are avoided
# Examples:
#   Mag. Dr. John Doe, BA MA PhD
#   Dr. John Doe
#   John Doe, PhD
#   John Doe
# Would you like support? ExplicIT Consulting (https://explicitconsulting.at) offers professional support for this and other open source code.
$ReplaceHash['$CurrentUserNameWithHonorifics$'] = (((((([string]$ADPropsCurrentUser.honorificPrefix, [string]$ADPropsCurrentUser.givenname, [string]$ADPropsCurrentUser.sn) | Where-Object { $_ -ne '' }) -join ' '), [string]$ADPropsCurrentUser.honorificSuffix) | Where-Object { $_ -ne '' }) -join ', ')
$ReplaceHash['$CurrentUserManagerNameWithHonorifics$'] = (((((([string]$ADPropsCurrentUserManager.honorificPrefix, [string]$ADPropsCurrentUserManager.givenname, [string]$ADPropsCurrentUserManager.sn) | Where-Object { $_ -ne '' }) -join ' '), [string]$ADPropsCurrentUserManager.honorificSuffix) | Where-Object { $_ -ne '' }) -join ', ')
$ReplaceHash['$CurrentMailboxNameWithHonorifics$'] = (((((([string]$ADPropsCurrentMailbox.honorificPrefix, [string]$ADPropsCurrentMailbox.givenname, [string]$ADPropsCurrentMailbox.sn) | Where-Object { $_ -ne '' }) -join ' '), [string]$ADPropsCurrentMailbox.honorificSuffix) | Where-Object { $_ -ne '' }) -join ', ')
$ReplaceHash['$CurrentMailboxManagerNameWithHonorifics$'] = (((((([string]$ADPropsCurrentMailboxManager.honorificPrefix, [string]$ADPropsCurrentMailboxManager.givenname, [string]$ADPropsCurrentMailboxManager.sn) | Where-Object { $_ -ne '' }) -join ' '), [string]$ADPropsCurrentMailboxManager.honorificSuffix) | Where-Object { $_ -ne '' }) -join ', ')



# Sample code: Take salutation or gender pronouns string from Extension Attribute 3
#   $CurrentUserSalutation$, $CurrentUserManagerSalutation$, $CurrentMailboxSalutation$, $CurrentMailboxManagerSalutation$
#   $CurrentUserGenderPronouns$, $CurrentUserManagerGenderPronouns$, $CurrentMailboxGenderPronouns$, $CurrentMailboxManagerGenderPronouns$
# Format
#   If ExtensionAttribute3 is not empty or whitespace, put it in brackets and add a leading space
#     Examples: " (Mr.)", " (Ms.)", " (she/her)"
#   Else: '' (emtpy string)
# Would you like support? ExplicIT Consulting (https://explicitconsulting.at) offers professional support for this and other open source code.
$ReplaceHash['$CurrentUserSalutation$'] = $ReplaceHash['$CurrentUserGenderPronouns$'] = $(if ([string]::IsNullOrWhiteSpace([string]$ADPropsCurrentUser.extensionattribute3)) { $null } else { " ($([string]$ADPropsCurrentUser.extensionattribute3))" })
$ReplaceHash['$CurrentUserManagerSalutation$'] = $ReplaceHash['$CurrentUserManagerGenderPronouns$'] = $(if ([string]::IsNullOrWhiteSpace([string]$ADPropsCurrentUserManager.extensionattribute3)) { $null } else { " ($([string]$ADPropsCurrentUserManager.extensionattribute3))" })
$ReplaceHash['$CurrentMailboxSalutation$'] = $ReplaceHash['$CurrentMailboxGenderPronouns$'] = $(if ([string]::IsNullOrWhiteSpace([string]$ADPropsCurrentMailbox.extensionattribute3)) { $null } else { " ($([string]$ADPropsCurrentMailbox.extensionattribute3))" })
$ReplaceHash['$CurrentMailboxManagerSalutation$'] = $ReplaceHash['$CurrentMailboxManagerGenderPronouns$'] = $(if ([string]::IsNullOrWhiteSpace([string]$ADPropsCurrentMailboxManager.extensionattribute3)) { $null } else { " ($([string]$ADPropsCurrentMailboxManager.extensionattribute3))" })


$ReplaceHash['$CurrentUserTelephone-prefix-noempty$'] = $(if (-not $ReplaceHash['$CurrentUserTelephone$']) { '' } else { $(if ($UseHtmTemplates) { '<br>' } else { "`n" }) + 'Telephone: ' } )
$ReplaceHash['$CurrentUserMobile-prefix-noempty$'] = $(if (-not $ReplaceHash['$CurrentUserMobile$']) { '' } else { $(if ($UseHtmTemplates) { '<br>' } else { "`n" }) + 'Mobile: ' } )

$ReplaceHash['$CurrentUserTelephone-noempty$'] = $(if (-not $ReplaceHash['$CurrentUserTelephone$']) { '' } else { $(if ($UseHtmTemplates) { '<br>' } else { "`n" }) + 'Telephone: ' } )
$ReplaceHash['$CurrentUserMobile-noempty$'] = $(if (-not $ReplaceHash['$CurrentUserMobile$']) { '' } else { $(if ($UseHtmTemplates) { '<br>' } else { "`n" }) + 'Mobile: ' } )


# Create $Current[User|Manager|Mailbox|MailboxManager][Telephone|Fax|Mobile]-[E164|INTERNATIONAL|NATIONAL|RFC3966]$ replacement variables
# FormatPhoneNumber: Format phone number in different formats
# Examples
#   FormatPhoneNumber -Number $ReplaceHash['$CurrentUserTelephone$'] -Country $ReplaceHash['$CurrentUserCountry$'] -Format 'INTERNATIONAL'
#   FormatPhoneNumber -Number $ReplaceHash['$CurrentUserTelephone$'] -Country $ReplaceHash['$CurrentUserCountry$'] -Format 'RFC3966'
# Parameters
#   Number
#     The phone number to format or parse, as a string. Can include country code or be in local format.
#       Extensions can only be detected reliably when marked with common indicators such as "ext", "ext.", "x", "x.", ";ext=", ",", or ";".
#         There is comprehensive public information about country codes and national destination codes, but not on how
#           carriers actually handle numbers they assign. Service numbers, short numbers, portable numbers make automatic extension detection practically impossible.
#    Country
#      Either a two-letter ISO country code (e.g., "AT", "US") or full English country name (e.g., "Austria", "United States").
#      Required when the phone number does not include a country code such as +43 or +1.
#        Country codes starting with 00 ('+0043 ...') can only be interpreted correctly if the Country parameter is specified.
#    Format
#      Desired phone number format.
#      Examples are based on two numbers:
#        '+1 305 418 9136,56', which is '305 418 9136 ext 56' with country set to 'US'.
#        '+43 50 123456,7890', which is '050 123456 ext 7890' with country set to 'AT'.
#      Format is one of the following:
#        E164
#          International format used for carrier routing. Not intended to be displayed to end users.
#          Examples (note the missing extension):
#            +13054189136
#            +4350123456
#        INTERNATIONAL
#          Displaying numbers to users in a global context (e.g., contact lists, websites).
#          Examples:
#            +1 305-418-9136 ext. 56
#            +43 50 123 456 ext. 7890
#        NATIONAL
#          Local format as dialed within the country, no country code.
#          Examples:
#            (305) 418-9136 ext. 56
#            050 123 456 ext. 7890
#        RFC3966
#          Embedding phone numbers in hyperlinks (tel:+43-1-23456789) or machine-readable formats.
#          Examples:
#            tel:+1-305-418-9136;ext=56
#            tel:+43-50-123-456;ext=7890
#        CUSTOM
#          Useful when you need to extract parts of the phone number for custom formatting.
#          Returns an object with the following properties:
#            CountryCode (int), NationalDestinationCode (string), SubscriberNumber (string), Extension (string),
#            ParseResult (a PhoneNumber object), OriginalInput (string), ErrorMessage (string)
#          Examples:
#            CountryCode 1, NationDesitionCode 305, SubscriberNumber 4189136, Extension 56
#            CountryCode 43, NationalDestinationCode 50, SubscriberNumber 123456, Extension 7890
foreach ($x in @('CurrentUser', 'CurrentUserManager', 'CurrentMailbox', 'CurrentMailboxManager')) {
    foreach ($y in @('Telephone', 'Fax', 'Mobile')) {
        foreach ($z in @('E164', 'INTERNATIONAL', 'NATIONAL', 'RFC3966')) {
            if ($ReplaceHash["`$$($x)$($y)`$"]) {
                $ReplaceHash["`$$($x)$($y)-$($z)`$"] = FormatPhoneNumber -Number $ReplaceHash["`$$($x)$($y)`$"] -Country $ReplaceHash["`$$($x)Country`$"] -Format $z
            } else {
                $ReplaceHash["`$$($x)$($y)-$($z)`$"] = $ReplaceHash["`$$($x)$($y)`$"]
            }
        }
    }
}

# Example: Custom formatting in a (technically wrong) style often seen in German speaking countries
#   '+1 305 418 9136,56' -> '+1 (0) 305 4189136 DW 56'
#   '+43 50 123456,7890' -> '+43 (0) 50 123456 DW 7890'
<#
foreach ($x in @('CurrentUser', 'CurrentUserManager', 'CurrentMailbox', 'CurrentMailboxManager')) {
    foreach ($y in @('Telephone', 'Fax', 'Mobile')) {
        , (FormatPhoneNumber -Number $ReplaceHash["`$$($x)$($y)`$"] -Country $ReplaceHash["`$$($x)Country`$"] -Format CUSTOM) | ForEach-Object {
            $ReplaceHash["`$$($x)$($y)-CustomGermanFormat`$"] = $(
                if ($_.ErrorMessage) {
                    $_.OriginalInput
                } else {
                    @(
                        @(
                            "+$($_.CountryCode)"
                            '(0)'
                            "$($_.NationalDestinationCode)"
                            "$($_.SubscriberNumber)"
                            "$(if ($_.Extension) { "DW $($_.Extension)" } else { '' } )"
                        ) | Where-Object { $_ }
                    ) -join ' '
                }
            )
        }
    }
}
#>


# Sample code: Create vCard QR codes and save the images in the following replacement variables:
#   $CurrentUserCustomImage1$, $CurrentUserManagerCustomImage1$, $CurrentMailboxCustomImage1$, $CurrentMailboxManagerCustomImage1$
# You are not limited to vCard, you can create any QR code content you like.
# Would you like support? ExplicIT Consulting (https://explicitconsulting.at) offers professional support for this and other open source code.
@('CurrentUser', 'CurrentUserManager', 'CurrentMailbox', 'CurrentMailboxManager') | ForEach-Object {
    $QRCodeContent = @(
        @(
            @(
                'BEGIN:VCARD'
                'VERSION:2.1'
                "N:$($ReplaceHash['$' + $_ + 'Surname$']);$($ReplaceHash['$' + $_ + 'GivenName$']);;$([string](Get-Variable -Name "ADProps$($_)" -ValueOnly).honorificPrefix);$([string](Get-Variable -Name "ADProps$($_)" -ValueOnly).honorificSuffix)"
                "TITLE:$($ReplaceHash['$' + $_ + 'Title$'])"
                "ORG:$($ReplaceHash['$' + $_ + 'Company$'])"
                "EMAIL;WORK;INTERNET:$($ReplaceHash['$' + $_ + 'Mail$'])"
                "TEL;WORK;VOICE:$($ReplaceHash['$' + $_ + 'Telephone-RFC3966$'] -ireplace 'tel:', '' -ireplace ';ext=', ',')"
                "TEL;WORK;CELL:$($ReplaceHash['$' + $_ + 'Mobile-RFC3966$'] -ireplace 'tel:', '' -ireplace ';ext=', ',')"
                "ADR;WORK:;;$($ReplaceHash['$' + $_ + 'StreetAddress$']);$($ReplaceHash['$' + $_ + 'Location$']);$($ReplaceHash['$' + $_ + 'State$']);$($ReplaceHash['$' + $_ + 'Postalcode$']);$($ReplaceHash['$' + $_ + 'Country$'])"
                'END:VCARD'
            ) | ForEach-Object { $_.trim() }
        ) | Where-Object { $_ -and (-not $_.EndsWith(':')) }
    ) -join ("`r`n")

    if ($QRCodeContent -notmatch '\r\nN:.*\r\n') { $QRCodeContent = 'https://set-outlooksignatures.com' }

    $ReplaceHash['$' + $_ + 'CustomImage1$'] = ((New-Object -TypeName QRCoder.PngByteQRCode -ArgumentList ((New-Object -TypeName QRCoder.QRCodeGenerator).CreateQrCode($QRCodeContent, 'L', $true))).GetGraphic(20, [byte[]]@(0, 0, 0), [byte[]]@(255, 255, 255), $false))
}


# Format an address according to country specific rules
#   Create $Current[User|Manager|Mailbox|MailboxManager]PostalAddress$ replacement variables
foreach ($x in @('CurrentUser', 'CurrentUserManager', 'CurrentMailbox', 'CurrentMailboxManager')) {
    $FormatPostAddressOptions = @{
        # Address components as described in https://github.com/OpenCageData/address-formatting/blob/master/conf/components.yaml
        Components      = @{
            attention = @(
                @(
                    @(
                        "$($ReplaceHash["`$$($x)GivenName`$"]) $($ReplaceHash["`$$($x)Surname`$"])"
                        "$($ReplaceHash["`$$($x)Department`$"])"
                        "$($ReplaceHash["`$$($x)Company`$"])"
                    ) | ForEach-Object { $_.trim() }
                ) | Where-Object { $_ }
            ) -join [System.Environment]::NewLine
            road      = $ReplaceHash["`$$($x)StreetAddress`$"]
            city      = $ReplaceHash["`$$($x)Location`$"]
            postcode  = $ReplaceHash["`$$($x)Postalcode`$"]
            state     = $ReplaceHash["`$$($x)State`$"]
            country   = $ReplaceHash["`$$($x)Country`$"]
        }

        # Country as two-letter ISO country code (e.g., "AT", "US") or full English country name (e.g., "Austria", "United States")
        #   Needed to choose correct address format rules
        Country         = $(
            $tempSearchString = "$($ReplaceHash["`$$($x)Country`$"])".Trim()

            if ([string]::IsNullOrWhiteSpace($tempSearchString)) {
                $null
            } else {
                (
                    @(
                        foreach ($tempSpecificCulture in [System.Globalization.CultureInfo]::GetCultures('SpecificCultures')) {
                            $tempRegionInfo = New-Object System.Globalization.RegionInfo($tempSpecificCulture)

                            if (
                                [System.Globalization.CultureInfo]::InvariantCulture.CompareInfo.IndexOf(
                                    ('|' + $(
                                        @(
                                            foreach ($attribute in @('Name', 'EnglishName', 'DisplayName', 'NativeName', 'TwoLetterISORegionName', 'ThreeLetterISORegionName', 'ThreeLetterWindowsRegionName')) {
                                                if (-not [string]::IsNullOrWhiteSpace($tempRegionInfo.$attribute)) {
                                                    (($tempRegionInfo.$attribute).Normalize('FormKD') -replace '[\p{M}\p{P}\p{S}\p{C}\p{Z}\s]').ToLower()
                                                }
                                            }
                                        ) -join '|'
                                    ) + '|'),
                                    ('|' + ($tempSearchString.Normalize('FormKD') -replace '[\p{M}\p{P}\p{S}\p{C}\p{Z}\s]').ToLower() + '|'),
                                    [System.Globalization.CompareOptions]::IgnoreCase -bor [System.Globalization.CompareOptions]::IgnoreNonSpace -bor [System.Globalization.CompareOptions]::IgnoreKanaType -bor [System.Globalization.CompareOptions]::IgnoreWidth
                                ) -ge 0
                            ) {
                                $tempRegionInfo
                            }
                        }
                    ) | Select-Object -First 1
                ).TwoLetterISORegionName
            }
        )
        # Shorten address components ("St." instead of "Street", "Rd." instead of "Road", etc.)
        Abbreviate      = $false

        # Only return known parts of the address, omit unknown parts
        #   When disabled, unknown parts are added the the "attention" component
        OnlyAddress     = $false

        # Use a custom address template instead of the predefined ones
        #   Predefined templates: https://github.com/OpenCageData/address-formatting/blob/master/conf/countries/worldwide.yaml
        AddressTemplate = $null
    }

    if ($UseHtmTemplates) {
        $ReplaceHash["`$$($x)PostalAddress`$"] = 
        (([System.Net.WebUtility]::HtmlEncode((Format-PostalAddress @FormatPostAddressOptions)) -replace "`r`n", '<p>') -replace "`n", '<br>')
    } else {
        $ReplaceHash["`$$($x)PostalAddress`$"] = (Format-PostalAddress @FormatPostAddressOptions)
    }
}


# SIG # Begin signature block
# MIIwZwYJKoZIhvcNAQcCoIIwWDCCMFQCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDXHGVXjgiKMFau
# AauaILqQiuP6OBptPtvJYfX+0qCOEKCCFCkwggWQMIIDeKADAgECAhAFmxtXno4h
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
# GNmrMYIblDCCG5ACAQEwfTBpMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNl
# cnQsIEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0IFRydXN0ZWQgRzQgQ29kZSBTaWdu
# aW5nIFJTQTQwOTYgU0hBMzg0IDIwMjEgQ0ExAhAKaypbp7cyIFa+lR7OVPAvMA0G
# CWCGSAFlAwQCAQUAoIIBbjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgIdhA7z8m
# uLknskBMh8WktDVukBaVwdltyBpA8l3iWK8wggEABgorBgEEAYI3AgEMMYHxMIHu
# oIHFgIHCAFAAbwB3AGUAcgBlAGQAIABiAHkAIABFAHgAcABsAGkAYwBJAFQAIABD
# AG8AbgBzAHUAbAB0AGkAbgBnAC4AIABVAG4AbABvAGMAawAgAGEAbABsACAAZgBl
# AGEAdAB1AHIAZQBzACAAdwBpAHQAaAAgAFMAZQB0AC0ATwB1AHQAbABvAG8AawBT
# AGkAZwBuAGEAdAB1AHIAZQBzACAAQgBlAG4AZQBmAGEAYwB0AG8AcgAgAEMAaQBy
# AGMAbABlAC6hJIAiaHR0cHM6Ly9zZXQtb3V0bG9va3NpZ25hdHVyZXMuY29tIDAN
# BgkqhkiG9w0BAQEFAASCAgB1STMhw4Pf9HmWa/NHjNkR/81xEFUWsU9mWdSwCEtT
# JEKQroAWqMxPcDzoMUdcn6l5kjF4r7dSyfCn9bHwP1vXLYIxWo7tVJqWxSIpdiYQ
# pSBy6lWlqa/yUC/vgNCWJQNQ5+zAdgTfXP2SPv5e5Mh9YJegydDempHb270jFnR9
# KvBcM2uwjvn7CuGzCAtBvSh3uKVdrTurQMR+HdU7Zazu9DzgLZ21faC9VNgCQgs8
# TTAuPcgySDZJCj5/L86Ao1PYKLoMEVmk2ILPVQyUhhyKmmjIoEFK91SmGzrWkqFq
# fYCIVyxEpSeya5Z4pP1p29cy7Y4C9/mP6pfRWMluSj4Ga9omgliXOcEl4LBhwjlq
# icdHUthLKCVQYIPUk+865d9x3KJchRqhoysgW1ZX6VsqW9QScsB3AG7KLVNUAZWv
# yPwYTC/BoaHjo2lRWZkE72pZpskWBiM6cWt3gEcRVkQrtynorfPGTMfYs8QE3aEc
# hddyrknGr9tCAS1NfgnDaAt19UEanVUpEGz4PzZ0SBnODkLFSpfwK3o8XU+iHjIl
# VazOB7E9Vl3/5v4gOzfebRU/OOR9UE5Cd9GoxxZMnT7Qvt51j54Hf1RRUvWD0p/7
# zMsX7MxUw9qebb26YTOMK7uXaWhwgRCVh+F8kzHxROj+etE74FOhzCnpMrjIiJ7q
# BKGCF3YwghdyBgorBgEEAYI3AwMBMYIXYjCCF14GCSqGSIb3DQEHAqCCF08wghdL
# AgEDMQ8wDQYJYIZIAWUDBAIBBQAwdwYLKoZIhvcNAQkQAQSgaARmMGQCAQEGCWCG
# SAGG/WwHATAxMA0GCWCGSAFlAwQCAQUABCA5yDsIJJJko5ut87LRVLNBi7xGsYPC
# tMekcaOaw91aggIQEBRefZMYgYg2l9jNA7WfwxgPMjAyNTEyMjMxMTUwMTRaoIIT
# OjCCBu0wggTVoAMCAQICEAqA7xhLjfEFgtHEdqeVdGgwDQYJKoZIhvcNAQELBQAw
# aTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQD
# EzhEaWdpQ2VydCBUcnVzdGVkIEc0IFRpbWVTdGFtcGluZyBSU0E0MDk2IFNIQTI1
# NiAyMDI1IENBMTAeFw0yNTA2MDQwMDAwMDBaFw0zNjA5MDMyMzU5NTlaMGMxCzAJ
# BgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMyRGln
# aUNlcnQgU0hBMjU2IFJTQTQwOTYgVGltZXN0YW1wIFJlc3BvbmRlciAyMDI1IDEw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDQRqwtEsae0OquYFazK1e6
# b1H/hnAKAd/KN8wZQjBjMqiZ3xTWcfsLwOvRxUwXcGx8AUjni6bz52fGTfr6PHRN
# v6T7zsf1Y/E3IU8kgNkeECqVQ+3bzWYesFtkepErvUSbf+EIYLkrLKd6qJnuzK8V
# cn0DvbDMemQFoxQ2Dsw4vEjoT1FpS54dNApZfKY61HAldytxNM89PZXUP/5wWWUR
# K+IfxiOg8W9lKMqzdIo7VA1R0V3Zp3DjjANwqAf4lEkTlCDQ0/fKJLKLkzGBTpx6
# EYevvOi7XOc4zyh1uSqgr6UnbksIcFJqLbkIXIPbcNmA98Oskkkrvt6lPAw/p4oD
# SRZreiwB7x9ykrjS6GS3NR39iTTFS+ENTqW8m6THuOmHHjQNC3zbJ6nJ6SXiLSvw
# 4Smz8U07hqF+8CTXaETkVWz0dVVZw7knh1WZXOLHgDvundrAtuvz0D3T+dYaNcwa
# fsVCGZKUhQPL1naFKBy1p6llN3QgshRta6Eq4B40h5avMcpi54wm0i2ePZD5pPIs
# soszQyF4//3DoK2O65Uck5Wggn8O2klETsJ7u8xEehGifgJYi+6I03UuT1j7Fnrq
# VrOzaQoVJOeeStPeldYRNMmSF3voIgMFtNGh86w3ISHNm0IaadCKCkUe2LnwJKa8
# TIlwCUNVwppwn4D3/Pt5pwIDAQABo4IBlTCCAZEwDAYDVR0TAQH/BAIwADAdBgNV
# HQ4EFgQU5Dv88jHt/f3X85FxYxlQQ89hjOgwHwYDVR0jBBgwFoAU729TSunkBnx6
# yuKQVvYv1Ensy04wDgYDVR0PAQH/BAQDAgeAMBYGA1UdJQEB/wQMMAoGCCsGAQUF
# BwMIMIGVBggrBgEFBQcBAQSBiDCBhTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Au
# ZGlnaWNlcnQuY29tMF0GCCsGAQUFBzAChlFodHRwOi8vY2FjZXJ0cy5kaWdpY2Vy
# dC5jb20vRGlnaUNlcnRUcnVzdGVkRzRUaW1lU3RhbXBpbmdSU0E0MDk2U0hBMjU2
# MjAyNUNBMS5jcnQwXwYDVR0fBFgwVjBUoFKgUIZOaHR0cDovL2NybDMuZGlnaWNl
# cnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0VGltZVN0YW1waW5nUlNBNDA5NlNIQTI1
# NjIwMjVDQTEuY3JsMCAGA1UdIAQZMBcwCAYGZ4EMAQQCMAsGCWCGSAGG/WwHATAN
# BgkqhkiG9w0BAQsFAAOCAgEAZSqt8RwnBLmuYEHs0QhEnmNAciH45PYiT9s1i6UK
# tW+FERp8FgXRGQ/YAavXzWjZhY+hIfP2JkQ38U+wtJPBVBajYfrbIYG+Dui4I4PC
# vHpQuPqFgqp1PzC/ZRX4pvP/ciZmUnthfAEP1HShTrY+2DE5qjzvZs7JIIgt0GCF
# D9ktx0LxxtRQ7vllKluHWiKk6FxRPyUPxAAYH2Vy1lNM4kzekd8oEARzFAWgeW3a
# z2xejEWLNN4eKGxDJ8WDl/FQUSntbjZ80FU3i54tpx5F/0Kr15zW/mJAxZMVBrTE
# 2oi0fcI8VMbtoRAmaaslNXdCG1+lqvP4FbrQ6IwSBXkZagHLhFU9HCrG/syTRLLh
# Aezu/3Lr00GrJzPQFnCEH1Y58678IgmfORBPC1JKkYaEt2OdDh4GmO0/5cHelAK2
# /gTlQJINqDr6JfwyYHXSd+V08X1JUPvB4ILfJdmL+66Gp3CSBXG6IwXMZUXBhtCy
# Iaehr0XkBoDIGMUG1dUtwq1qmcwbdUfcSYCn+OwncVUXf53VJUNOaMWMts0VlRYx
# e5nK+At+DI96HAlXHAL5SlfYxJ7La54i71McVWRP66bW+yERNpbJCjyCYG2j+bdp
# xo/1Cy4uPcU3AWVPGrbn5PhDBf3Froguzzhk++ami+r3Qrx5bIbY3TVzgiFI7Gq3
# zWcwgga0MIIEnKADAgECAhANx6xXBf8hmS5AQyIMOkmGMA0GCSqGSIb3DQEBCwUA
# MGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsT
# EHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9v
# dCBHNDAeFw0yNTA1MDcwMDAwMDBaFw0zODAxMTQyMzU5NTlaMGkxCzAJBgNVBAYT
# AlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQg
# VHJ1c3RlZCBHNCBUaW1lU3RhbXBpbmcgUlNBNDA5NiBTSEEyNTYgMjAyNSBDQTEw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC0eDHTCphBcr48RsAcrHXb
# o0ZodLRRF51NrY0NlLWZloMsVO1DahGPNRcybEKq+RuwOnPhof6pvF4uGjwjqNjf
# EvUi6wuim5bap+0lgloM2zX4kftn5B1IpYzTqpyFQ/4Bt0mAxAHeHYNnQxqXmRin
# vuNgxVBdJkf77S2uPoCj7GH8BLuxBG5AvftBdsOECS1UkxBvMgEdgkFiDNYiOTx4
# OtiFcMSkqTtF2hfQz3zQSku2Ws3IfDReb6e3mmdglTcaarps0wjUjsZvkgFkriK9
# tUKJm/s80FiocSk1VYLZlDwFt+cVFBURJg6zMUjZa/zbCclF83bRVFLeGkuAhHiG
# PMvSGmhgaTzVyhYn4p0+8y9oHRaQT/aofEnS5xLrfxnGpTXiUOeSLsJygoLPp66b
# kDX1ZlAeSpQl92QOMeRxykvq6gbylsXQskBBBnGy3tW/AMOMCZIVNSaz7BX8VtYG
# qLt9MmeOreGPRdtBx3yGOP+rx3rKWDEJlIqLXvJWnY0v5ydPpOjL6s36czwzsucu
# oKs7Yk/ehb//Wx+5kMqIMRvUBDx6z1ev+7psNOdgJMoiwOrUG2ZdSoQbU2rMkpLi
# Q6bGRinZbI4OLu9BMIFm1UUl9VnePs6BaaeEWvjJSjNm2qA+sdFUeEY0qVjPKOWu
# g/G6X5uAiynM7Bu2ayBjUwIDAQABo4IBXTCCAVkwEgYDVR0TAQH/BAgwBgEB/wIB
# ADAdBgNVHQ4EFgQU729TSunkBnx6yuKQVvYv1Ensy04wHwYDVR0jBBgwFoAU7Nfj
# gtJxXWRM3y5nP+e6mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsG
# AQUFBwMIMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Au
# ZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0cy5kaWdpY2Vy
# dC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNydDBDBgNVHR8EPDA6MDigNqA0
# hjJodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0
# LmNybDAgBgNVHSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEwDQYJKoZIhvcN
# AQELBQADggIBABfO+xaAHP4HPRF2cTC9vgvItTSmf83Qh8WIGjB/T8ObXAZz8Oju
# hUxjaaFdleMM0lBryPTQM2qEJPe36zwbSI/mS83afsl3YTj+IQhQE7jU/kXjjytJ
# gnn0hvrV6hqWGd3rLAUt6vJy9lMDPjTLxLgXf9r5nWMQwr8Myb9rEVKChHyfpzee
# 5kH0F8HABBgr0UdqirZ7bowe9Vj2AIMD8liyrukZ2iA/wdG2th9y1IsA0QF8dTXq
# vcnTmpfeQh35k5zOCPmSNq1UH410ANVko43+Cdmu4y81hjajV/gxdEkMx1NKU4uH
# QcKfZxAvBAKqMVuqte69M9J6A47OvgRaPs+2ykgcGV00TYr2Lr3ty9qIijanrUR3
# anzEwlvzZiiyfTPjLbnFRsjsYg39OlV8cipDoq7+qNNjqFzeGxcytL5TTLL4ZaoB
# dqbhOhZ3ZRDUphPvSRmMThi0vw9vODRzW6AxnJll38F0cuJG7uEBYTptMSbhdhGQ
# DpOXgpIUsWTjd6xpR6oaQf/DJbg3s6KCLPAlZ66RzIg9sC+NJpud/v4+7RWsWCiK
# i9EOLLHfMR2ZyJ/+xhCx9yHbxtl5TPau1j/1MIDpMPx0LckTetiSuEtQvLsNz3Qb
# p7wGWqbIiOWCnb5WqxL3/BAPvIXKUjPSxyZsq8WhbaM2tszWkPZPubdcMIIFjTCC
# BHWgAwIBAgIQDpsYjvnQLefv21DiCEAYWjANBgkqhkiG9w0BAQwFADBlMQswCQYD
# VQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGln
# aWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3QgQ0Ew
# HhcNMjIwODAxMDAwMDAwWhcNMzExMTA5MjM1OTU5WjBiMQswCQYDVQQGEwJVUzEV
# MBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29t
# MSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQwggIiMA0GCSqGSIb3
# DQEBAQUAA4ICDwAwggIKAoICAQC/5pBzaN675F1KPDAiMGkz7MKnJS7JIT3yithZ
# wuEppz1Yq3aaza57G4QNxDAf8xukOBbrVsaXbR2rsnnyyhHS5F/WBTxSD1Ifxp4V
# pX6+n6lXFllVcq9ok3DCsrp1mWpzMpTREEQQLt+C8weE5nQ7bXHiLQwb7iDVySAd
# YyktzuxeTsiT+CFhmzTrBcZe7FsavOvJz82sNEBfsXpm7nfISKhmV1efVFiODCu3
# T6cw2Vbuyntd463JT17lNecxy9qTXtyOj4DatpGYQJB5w3jHtrHEtWoYOAMQjdjU
# N6QuBX2I9YI+EJFwq1WCQTLX2wRzKm6RAXwhTNS8rhsDdV14Ztk6MUSaM0C/CNda
# SaTC5qmgZ92kJ7yhTzm1EVgX9yRcRo9k98FpiHaYdj1ZXUJ2h4mXaXpI8OCiEhtm
# mnTK3kse5w5jrubU75KSOp493ADkRSWJtppEGSt+wJS00mFt6zPZxd9LBADMfRyV
# w4/3IbKyEbe7f/LVjHAsQWCqsWMYRJUadmJ+9oCw++hkpjPRiQfhvbfmQ6QYuKZ3
# AeEPlAwhHbJUKSWJbOUOUlFHdL4mrLZBdd56rF+NP8m800ERElvlEFDrMcXKchYi
# Cd98THU/Y+whX8QgUWtvsauGi0/C1kVfnSD8oR7FwI+isX4KJpn15GkvmB0t9dmp
# sh3lGwIDAQABo4IBOjCCATYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQU7Nfj
# gtJxXWRM3y5nP+e6mK4cD08wHwYDVR0jBBgwFoAUReuir/SSy4IxLVGLp6chnfNt
# yA8wDgYDVR0PAQH/BAQDAgGGMHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2Fj
# ZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MEUG
# A1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2Vy
# dEFzc3VyZWRJRFJvb3RDQS5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3
# DQEBDAUAA4IBAQBwoL9DXFXnOF+go3QbPbYW1/e/Vwe9mqyhhyzshV6pGrsi+Ica
# aVQi7aSId229GhT0E0p6Ly23OO/0/4C5+KH38nLeJLxSA8hO0Cre+i1Wz/n096ww
# epqLsl7Uz9FDRJtDIeuWcqFItJnLnU+nBgMTdydE1Od/6Fmo8L8vC6bp8jQ87PcD
# x4eo0kxAGTVGamlUsLihVo7spNU96LHc/RzY9HdaXFSMb++hUD38dglohJ9vytsg
# jTVgHAIDyyCwrFigDkBjxZgiwbJZ9VVrzyerbHbObyMt9H5xaiNrIv8SuFQtJ37Y
# OtnwtoeW/VvRXKwYw02fc7cBqZ9Xql4o4rmUMYIDfDCCA3gCAQEwfTBpMQswCQYD
# VQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xQTA/BgNVBAMTOERpZ2lD
# ZXJ0IFRydXN0ZWQgRzQgVGltZVN0YW1waW5nIFJTQTQwOTYgU0hBMjU2IDIwMjUg
# Q0ExAhAKgO8YS43xBYLRxHanlXRoMA0GCWCGSAFlAwQCAQUAoIHRMBoGCSqGSIb3
# DQEJAzENBgsqhkiG9w0BCRABBDAcBgkqhkiG9w0BCQUxDxcNMjUxMjIzMTE1MDE0
# WjArBgsqhkiG9w0BCRACDDEcMBowGDAWBBTdYjCshgotMGvaOLFoeVIwB/tBfjAv
# BgkqhkiG9w0BCQQxIgQgJNBTsO5CZSPXPu+0eSIFGNSixU4QT44Nym7AbJJtE2ow
# NwYLKoZIhvcNAQkQAi8xKDAmMCQwIgQgSqA/oizXXITFXJOPgo5na5yuyrM/420m
# mqM08UYRCjMwDQYJKoZIhvcNAQEBBQAEggIAycEVgarevaupSN8lvCEhleouXSuu
# BJHF89/QXFjIwe4hhYk+ljQmtkU1WCy9p1HznuHmT8SlqqiKcWfhUm97xgTqGsQe
# 7QJMBqXCaPwsFpkP0PAzNo3S/MQ+ZDHEww/uP2tCTSZkK+GlxBP2zEZuX98kItoY
# O5qp4GAETRDWrWVkCpBWQJ547DQASPU/bjYkV8Y+T9Tk9XZUubGHf08HxFVb6A3i
# 8wJXrbTHXcGmN1SioyloEh+uxfjwad/qAiLxkHkzQbhQVwgB6+BbMku7eqWNBKHV
# 5uBNvJ//pJdNHbeCO4JMvSOmwwfgCFcdu9YwcKcLkelGQLWtpj+spDPU1OBJK5ED
# SozL/tRnTwb0ulGMeXbHiIiPys2rduj8eP6J2xv+1RacMpq+drjXHJn6+tEwHWzr
# ZH4PR3yq6K13XZKtWemy47qmpT8Ao+zDb/HLIeYNCad4b6WsJu1ulfYyUUF3WpMF
# sdjvc99S8LvRFVulfFHLO7A/0S4DqobR9wh60vQiN6vfZHE8oIT3Bsrk2MrMrUbX
# 37HRH2BmCcmkvgdTvEnfFGx2A8DHhCyEHZp6IbyVW6B5EKd+msnhBJshqR8t08uJ
# ndu5aF/+KR2yWQMJNMrtDMZeb+q+JKJURyp7yysNox/qxt+Sn0edxMjyhsFPutU8
# 9EekJ0nFs606ffQ=
# SIG # End signature block
