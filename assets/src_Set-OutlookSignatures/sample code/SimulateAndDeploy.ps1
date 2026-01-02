<#
This sample code shows how to achieve two things:
  - Running simulation mode for multiple users
   How to use simulation mode together with the Benefactor Circle add-on to push signatures and out-of-office replies into mailboxes, without involving end users or their devices

You have to adapt it to fit your environment.
The sample code is written in a generic way, which allows for easy adaption.

Would you like support? ExplicIT Consulting (https://explicitconsulting.at) offers professional support for this and other open source code.


Features
  - Automate simulation mode for all given mailboxes
    - SimulateAndDeploy considers additional mailboxes when the user added them in Outlook on the web, when they are passed via the 'SimulateMailboxes' parameter, or when being added dynamically via the 'VirtualMailboxConfigFile' parameter
  - A configurable number of Set-OutlookSignatures instances run in parallel for better performance
  - Set default signature in Outlook on the web, no matter if classic signature or roaming signatures (requires the Benefactor Circle add-on)
  - Set internal and external out-of-office (OOF) message (requires the Benefactor Circle add-on)
  - Supports on-prem, hybrid and cloud-only environments


Requirements
  Follow the requirements exactly and in full. SimulateAndDeploy will not work correctly when even one requirement is not met.
  Would you like support? ExplicIT Consulting (https://explicitconsulting.at) offers professional support for this and other open source code.

  - For mailboxes on-prem
      - The software needs to be run with an account that
          - has a mailbox
          - and is granted "full access" to all simulated mailboxes
      - If you do not want to simulate cloud mailboxes, set $ConnectOnpremInsteadOfCloud to $true
  - For mailboxes in Exchange Online
      - The software needs to be run with an account that
          - has a mailbox
          - and is granted "full access" to all simulated mailboxes
      - MFA is not supported
          - MFA would require interactivity, breaking the possibility for complete automation
          - Better configure a Conditional Access Policy that only allows logon from a controlled network and does not require MFA
      - Service Principals are not supported by the API
      - Create a new app registration in Entra ID
          - Option A: Create the app automatically by using the script '.\sample code\Create-EntraApp.ps1'
		      - The sample code creates the app with all required settings automatically, only providing admin consent is a manual task
		  - Option B: Create the Entra ID app manually, with the following properties:
		      - Application (!) permissions with admin consent
                  - Microsoft Graph
				      - Files.Read.All
					    Allows the app to read all files in all site collections without a signed in user.
					    Required for access to templates and configuration files hosted on SharePoint Online.
					    For added security, use Files.SelectedOperations.Selected as alternative, requiring granting specific permissions in SharePoint Online.
					  - GroupMember.Read.All
						Allows the app to list groups, read basic group properties and read membership of all groups the signed-in user has access to.
						Required to find groups by name and to get their security identifier (SID) and the number of transitive members.
					  - Mail.ReadWrite
					    Allows the app to create, read, update, and delete mail in all mailboxes without a signed-in user. Does not include permission to send mail.
						Required to connect to Outlook on the web and to set Outlook signatures.
					  - MailboxSettings.ReadWrite
						Allows the app to create, read, update, and delete user's mailbox settings. Does not include permission to send mail.
						Required to set out-of-office replies for the simulated mailboxes
					  - User.Read.All
						Allows the app to read the full set of profile properties, reports, and managers of other users in your organization, on behalf of the signed-in user.
						Required for $CurrentUser[…]$ and $CurrentMailbox[…]$ replacement variables, and for simulation mode.
				  - Office 365 Exchange Online
				      - full_access_as_app
						Allows the app to have full access via Exchange Web Services to all mailboxes without a signed-in user.
						Required for Exchange Web Services access (read Outlook on the web configuration, set classic signature and roaming signatures)
			  - Delegated (!) permissions with admin consent
				These permissions equal those mentioned in '.\config\default graph config.ps1'
			      - Microsoft Graph
					  - email
				        Allows the app to read your users' primary email address.
					    Required to log on the current user.
					  - EWS.AccessAsUser.All
						Allows the app to have the same access to mailboxes as the signed-in user via Exchange Web Services.
						Required to connect to Outlook on the web and to set Outlook on the web signature (classic and roaming).
					  - Files.Read.All
					    Allows the app to read all files the signed-in user can access.
					    Required for access to templates and configuration files hosted on SharePoint Online.
					    For added security, use Files.SelectedOperations.Selected as alternative, requiring granting specific permissions in SharePoint Online.
					  - GroupMember.Read.All
						Allows the app to list groups, read basic group properties and read membership of all groups the signed-in user has access to.
						Required to find groups by name and to get their security identifier (SID) and the number of transitive members.
					  - Mail.ReadWrite
						Allows the app to create, read, update, and delete email in user mailboxes. Does not include permission to send mail.
						Required to connect to Outlook on the web and to set Outlook signatures.
					  - MailboxSettings.ReadWrite
						Allows the app to create, read, update, and delete user's mailbox settings. Does not include permission to send mail.
						Required to detect the state of the out-of-office assistant and to set out-of-office replies.
					  - offline_access
						Allows the app to see and update the data you gave it access to, even when users are not currently using the app. This does not give the app any additional permissions.
						Required to get a refresh token from Graph.
					  - openid
						Allows users to sign in to the app with their work or school accounts and allows the app to see basic user profile information.
						Required to log on the current user.
					  - profile
						Allows the app to see your users' basic profile (e.g., name, picture, user name, email address).
						Required to log on the current user, to access the '/me' Graph API, to get basic properties of the current user.
					  - User.Read.All
						Allows the app to read the full set of profile properties, reports, and managers of other users in your organization, on behalf of the signed-in user.
						Required for $CurrentUser[…]$ and $CurrentMailbox[…]$ replacement variables, and for simulation mode.
			  - Define a client secret (and set a reminder to update it, because it will expire)
				The code can easily be adapted for certificate authentication at application level (which is not possible for user authentication)
			  - Set supported account types to "Accounts in this organizational directory only" (for security reasons)
		  - You can limit the access of the app to specific mailboxes. This is recommended because of the "MailboxSettings.ReadWrite" and "full_access_as-app" permission required at application level.
		      - Use the New-ApplicationAccessPolicy cmdlet to limit access or to deny access to specific mailboxes or to mailboxes organized in groups.
			  - See https://learn.microsoft.com/en-us/powershell/module/exchange/new-applicationaccesspolicy for details
  - Microsoft Word when using DOCX tempates
  - File paths can get very long and be longer than the default OS limit. Make sure you allow long file paths.
      - https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation
  - Do not forget to adapt the "Variables" section of this script according to your needs and your configuration


Limitations and remarks
  - Despitze parallelization, the execution time can be too long for a higher number of users. The reason usually is the Word background process.
      - If you use DOCX templates and/or require signatures in RTF format, Word is needed for document conversion and you can only shorten runtime by adding hardware (scale up or scale out)
	  - If you do need HTML signatures only, you can use the following workaround to avoid starting Word:
	      - Use HTM templates instead of DOCX templates (parameter '-UseHtmTemplates true')
			There are features in DOCX templates that cannot be replicated HTM templates, such as applying Word specific image and text filters
		  - Do not create signatures in RTF format (parameter '-CreateRtfSignatures false')
  - Roaming signatures can currently not be deployed for shared mailboxes, as the API does not support this scenario.
      - Roaming signatures for shared mailboxes pose a general problem, as only signatures with replacement variables from the $CurrentMailbox[…]$ namespace would make sense anyhow
  - SimulateAndDeploy cannot solve problems around the Classic Outlook on Windows roaming signature sync engine, only Microsoft can do this (but unfortunately does not since years).
      - Until Microsoft solves this in Classic Outlook on Windows, expect problems with character encoding (umlauts, diacritics, emojis, etc.) and more.
	  - These Outlook-internal problems will come and go depending on the patch level of Outlook.
	  - These Outlook-internal problems can also be observed when Set-OutlookSignatures is not involved at all.
	  - The only workaround currently known is to disable the Classic Outlook on Windows sync engine and let Set-OutlookSignatures do it by running it on the client regularly.
  - Signatures are directly usable in Outlook on the web and New Outlook (when based on Outlook on the web). Other Outlook editions may work but are not supported.
      - Consider using the Outlook add-in to access signatures created by SimulateAndDeploy on other editions of Outlook in a supported way.
	    See https://set-outlooksignatures.com/outlookaddin for details.
	  - Also see FAQ 'Roaming signatures in Classic Outlook on Windows look different' at https://set-outlooksignatures.com/faq.
  - Consider using the 'VirtualMailboxConfigFile' parameter of Set-OutlookSignatures, ideally together with the output of the Export-RecipientPermissions script.
      - This allows you to automatically create up-to-date lists of mailboxes based on the permissions granted in Exchange, as well as the according INI file lines.
	  - Visit https://github.com/Export-RecipientPermissions for details about Export-RecipientPermissions.
  - Some Word builds throw an error message when run in a non-interactive mode (such as using a scheduled task configured with "Run whether user is logged on or not").
      - The only known workarounds are to run SimulateAndDeploy in interactive mode, or to use HTM templates instead of DOCX templates.
	    ExplicIT Consulting can help you create code converting DOCX templates to HTM templates automatically.


It is recommended to not modify or copy this sample script, but to call it with parameters.
  - The "param" section at the beginning of the script defines all parameters that can be used to call this script.
#>


#Requires -Version 5.1

[CmdletBinding()]

# Variables
param (
	$ConnectOnpremInsteadOfCloud = $false,

	# $GraphUserCredential, $GraphClientID and $GraphClientSecret are only there for backward compatibility.
	# It is recommended to use $GraphData instead. In cross-tenant and multitenant scenarios this is a must.
	[pscredential]$GraphUserCredential = (
		@(, @('SimulateAndDeployUser@example.com', 'P@ssw0rd!')) | ForEach-Object { New-Object System.Management.Automation.PSCredential ($_[0], $(ConvertTo-SecureString $_[1] -AsPlainText -Force)) }
	), # Use Get-Credential for interactive mode or (Get-Content -LiteralPath '.\Config\password.secret') to retrieve info from a separate file (MFA is not supported in any case)
	$GraphClientID = 'The Client ID of the Entra ID app for SimulateAndDeploy', # not the same ID as defined in 'default graph config.ps1' or a custom Graph config file
	$GraphClientSecret = 'The Client Secret of the Entra ID app for SimulateAndDeploy', # to load the secret from a file, use (Get-Content -LiteralPath '.\Config\app.secret')
	[string]$CloudEnvironment = 'Public',

	# As soon as $GraphData is not just an empty array, it takes priority over $GraphUserCredential, $GraphClientID, and $GraphClientSecret
	# Format:
	# $GraphData = @(
	#     , @('Tenant A ID', 'Tenant A SimulateAndDeployUser', 'Tenant A SimulateAndDeployUserPassword', 'Tenant A GraphClientID', 'Tenant A GraphClientSecret')
	#     , @('Tenant B ID', 'Tenant B SimulateAndDeployUser', 'Tenant B SimulateAndDeployUserPassword', 'Tenant B GraphClientID', 'Tenant B GraphClientSecret')
	# )
	$GraphData = @(),

	$SetOutlookSignaturesScriptPath = '..\Set-OutlookSignatures.ps1',
	$SetOutlookSignaturesScriptParameters = @{
		# Do not use: SimulateUser, SimulateMailboxes, AdditionalSignaturePath, SimulateAndDeployGraphCredentialFile
		#
		# ▼▼▼ The "Deploy" part of "SimulateAndDeploy" requires a Benefactor Circle license ▼▼▼
		# ▼▼▼ Without the license, signatures cannot be read from and written to mailboxes ▼▼▼
		BenefactorCircleLicenseFile   = '\\server\share\folder\license.dll'
		BenefactorCircleID            = '<BenefactorCircleID>'
		# ▲▲▲ The "Deploy" part of "SimulateAndDeploy" requires a Benefactor Circle license ▲▲▲
		# ▲▲▲ Without the license, signatures cannot be read from and written to mailboxes ▲▲▲
		#
		SimulateAndDeploy             = $false # $false simulates but does not deploy, $true simulates and deploys
		UseHtmTemplates               = $false
		SignatureTemplatePath         = '.\sample templates\Signatures DOCX'
		SignatureIniFile              = '.\sample templates\Signatures DOCX\_Signatures.ini'
		OOFTemplatePath               = '.\sample templates\Out-of-Office DOCX'
		OOFIniFile                    = '.\sample templates\Out-of-Office DOCX\_OOF.ini'
		ReplacementVariableConfigFile = '.\config\default replacement variables.ps1'
		GraphConfigFile               = '.\config\default graph config.ps1'
		GraphOnly                     = $false
		# Use current verbose mode for later execution of Set-OutlookSignatures
		Verbose                       = $($VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue)
	},

	$SimulateResultPath = 'c:\test\SimulateAndDeploy',
	$JobsConcurrent = 2,
	$JobTimeout = [timespan]::FromMinutes(10),

	$UpdateInterval = [timespan]::FromMinutes(1),

	# List of users and mailboxes to simulate
	#   SimulateUser: Logon name in UPN or pre-Windows 2000 format
	#   SimulateMailboxes: Separate multiple mailboxes by spaces or commas. Leave empty to get mailboxes from Outlook on the web (recommended).
	#   Examples:
	#     ExampleDomain\ExampleUser;
	#     a@example.com;
	#     b@example.com;b@example.com
	#     c@example.com;c@example.com,b@example.com
	#   Consider using the 'VirtualMailboxConfigFile' parameter of Set-OutlookSignatures, ideally together with the output of the Export-RecipientPermissions script.
	#     This allows you to automatically create up-to-date lists of mailboxes based on the permissions granted in Exchange, as well as the according INI file lines.
	#     Visit https://github.com/Export-RecipientPermissions for details about Export-RecipientPermissions.
	$SimulateList = (@'
SimulateUser;SimulateMailboxes
alex.alien@example.com;
bobby.busy@example.com;bobby.busy@example.com
fenix.fish@example.com;fenix.fish@example.com,nat.nuts@example.com
'@ | ConvertFrom-Csv -Delimiter ';')
)


#
# Do not change anything from here on
#


# Functions
function ParseJwtToken {
	# Idea for this code: https://www.michev.info/blog/post/2140/decode-jwt-access-and-id-tokens-via-powershell

	[cmdletbinding()]
	param([Parameter(Mandatory = $true)][string]$token)

	try { WatchCatchableExitSignal } catch { }

	# Validate as per https://tools.ietf.org/html/rfc7519
	# Access and ID tokens are fine, Refresh tokens will not work
	if (!$token.Contains('.') -or !$token.StartsWith('eyJ')) {
		return @{
			error   = 'Invalid token'
			header  = $null
			payload = $null
		}
	} else {
		# Header
		$tokenheader = $token.Split('.')[0].Replace('-', '+').Replace('_', '/')

		# Fix padding as needed, keep adding "=" until string length modulus 4 reaches 0
		while ($tokenheader.Length % 4) { $tokenheader += '=' }

		# Convert from Base64 encoded string to PSObject all at once
		$tokenHeader = [System.Text.Encoding]::UTF8.GetString([system.convert]::FromBase64String($tokenheader)) | ConvertFrom-Json

		# Payload
		$tokenPayload = $token.Split('.')[1].Replace('-', '+').Replace('_', '/')

		# Fix padding as needed, keep adding "=" until string length modulus 4 reaches 0
		while ($tokenPayload.Length % 4) { $tokenPayload += '=' }

		# Convert to Byte array
		$tokenByteArray = [System.Convert]::FromBase64String($tokenPayload)

		# Convert to string array
		$tokenArray = [System.Text.Encoding]::UTF8.GetString($tokenByteArray)

		# Convert from JSON to PSObject
		$tokenPayload = $tokenArray | ConvertFrom-Json

		return @{
			error   = $false
			header  = $tokenHeader
			payload = $tokenPayload
		}
	}
}


function CreateUpdateSimulateAndDeployGraphCredentialFile {
	$local:GraphTokenDictionary = @{}
	$returnValuesCollection = @()

	foreach ($GraphDataObject in $GraphData) {
		$local:GraphTenantId = GraphDomainToTenantID $GraphDataObject[0]
		$local:GraphUserCredentialUser = $GraphDataObject[1]
		$local:GraphUserCredentialPassword = $GraphDataObject[2]
		$local:GraphClientId = $GraphDataObject[3]
		$local:GraphClientSecret = $GraphDataObject[4]

		$local:GraphUserCredential = (New-Object System.Management.Automation.PSCredential ($local:GraphUserCredentialUser, $(ConvertTo-SecureString $local:GraphUserCredentialPassword -AsPlainText -Force)))
		$local:GraphCloudEnvironment = $script:GraphDomainToCloudInstanceCache[$local:GraphTenantId]

		try {
			# User authentication
			$auth = get-msaltoken -AzureCloudInstance $local:GraphCloudEnvironment -UserCredential $local:GraphUserCredential -ClientId $local:GraphClientId -TenantId $local:GraphTenantId -RedirectUri 'http://localhost' -Scopes "$($script:CloudEnvironmentGraphApiEndpoint)/.default"
			$authExo = get-msaltoken -AzureCloudInstance $local:GraphCloudEnvironment -UserCredential $local:GraphUserCredential -ClientId $local:GraphClientId -TenantId $local:GraphTenantId -RedirectUri 'http://localhost' -Scopes "$($script:CloudEnvironmentExchangeOnlineEndpoint)/.default"

			# App authentication
			$Appauth = get-msaltoken -AzureCloudInstance $local:GraphCloudEnvironment -ClientId $local:GraphClientId -ClientSecret ($local:GraphClientSecret | ConvertTo-SecureString -AsPlainText -Force) -TenantId $local:GraphTenantId -RedirectUri 'http://localhost' -Scopes "$($script:CloudEnvironmentGraphApiEndpoint)/.default"
			$AppauthExo = get-msaltoken -AzureCloudInstance $local:GraphCloudEnvironment -ClientId $local:GraphClientId -ClientSecret ($local:GraphClientSecret | ConvertTo-SecureString -AsPlainText -Force) -TenantId $local:GraphTenantId -RedirectUri 'http://localhost' -Scopes "$($script:CloudEnvironmentExchangeOnlineEndpoint)/.default"

			$returnValues = @{
				'error'             = $false
				'AccessToken'       = $auth.AccessToken
				'AuthHeader'        = $auth.createauthorizationheader()
				'AccessTokenExo'    = $authExo.AccessToken
				'AuthHeaderExo'     = $authExo.createauthorizationheader()
				'AppAccessToken'    = $Appauth.AccessToken
				'AppAuthHeader'     = $Appauth.createauthorizationheader()
				'AppAccessTokenExo' = $AppauthExo.AccessToken
				'AppAuthHeaderExo'  = $AppauthExo.createauthorizationheader()
			}
		} catch {
			$returnValues = @{
				'error'             = $error[0] | Out-String
				'AccessToken'       = $null
				'AuthHeader'        = $null
				'AccessTokenExo'    = $null
				'AuthHeaderExo'     = $null
				'AppAccessToken'    = $null
				'AppAuthHeader'     = $null
				'AppAccessTokenExo' = $null
				'AppAuthHeaderExo'  = $null
			}
		}

		$local:GraphTokenDictionary[$local:GraphTenantId] = $returnValues

		$returnValuesCollection += , $returnValues
	}

	if ($returnValuesCollection.count -eq 1) {
		$null = $returnValues | Export-Clixml -Path $SimulateAndDeployGraphCredentialFile
	} else {
		$null = $(
			@{
				GraphDomainToTenantIDCache      = $script:GraphDomainToTenantIDCache
				GraphDomainToCloudInstanceCache = $script:GraphDomainToCloudInstanceCache
				GraphTokenDictionary            = $local:GraphTokenDictionary
			} | Export-Clixml -Path $SimulateAndDeployGraphCredentialFile
		)
	}

	return $returnValuesCollection
}


function GraphDomainToTenantID {
	param (
		[string]$domain = 'explicitconsulting.at',
		[uri]$SpecificGraphApiEndpointOnly = $null
	)

	if (-not $script:GraphDomainToTenantIDCache) {
		$script:GraphDomainToTenantIDCache = @{}
	}

	if (-not $script:GraphDomainToCloudInstanceCache) {
		$script:GraphDomainToCloudInstanceCache = @{}
	}

	$domain = $domain.Trim().ToLower()


	# If $domain is a mail address, extract the domain part
	try {
		try { WatchCatchableExitSignal } catch { }

		$tempDomain = [mailaddress]$domain

		if ($tempDomain.Host) {
			$domain = $tempDomain.Host
		}
	} catch {}

	# If $domain is a URL, extract the DNS safe host
	try {
		try { WatchCatchableExitSignal } catch { }

		$tempDomain = [uri]$domain
		if ($tempDomain.DnsSafeHost) {
			$domain = $tempDomain.DnsSafeHost
		}
	} catch {
		# Not a URI, do nothing
	}

	try { WatchCatchableExitSignal } catch { }

	foreach ($SharePointDomain in @('sharepoint.com', 'sharepoint.us', 'dps.mil', 'sharepoint-mil.us', 'sharepoint.cn')) {
		if ($domain.EndsWith("-my.$($SharePointDomain)")) {
			$domain = $domain -ireplace "-my.$($SharePointDomain)", '.onmicrosoft.com'

			break
		}
	}

	try { WatchCatchableExitSignal } catch { }

	if ([string]::IsNullOrWhitespace($domain)) {
		return
	}

	if ($script:GraphDomainToTenantIDCache.ContainsKey($domain)) {
		return $script:GraphDomainToTenantIDCache[$domain]
	}

	try {
		try { WatchCatchableExitSignal } catch { }

		try {
			$local:result = Invoke-RestMethod -UseBasicParsing -Uri "https://odc.officeapps.live.com/odc/v2.1/federationprovider?domain=$($domain)"
		} catch {
			if (($null -ne $_.Exception.Response) -and ([int]$_.Exception.Response.StatusCode -in (@(304) + (400..599)))) {
				Write-Verbose "Retryable error ($($_.Exception.Response.StatusCode.value__)). Waiting 5s."
				Start-Sleep -Seconds 5
				$local:result = Invoke-RestMethod -UseBasicParsing -Uri "https://odc.officeapps.live.com/odc/v2.1/federationprovider?domain=$($domain)"
			} else {
				throw $_
			}
		}

		try { WatchCatchableExitSignal } catch { }

		$script:GraphDomainToTenantIDCache[$domain] = $local:result.tenantId

		if ($null -eq $local:result.tenantId) {
			return
		}

		if (
			$(
				if ([string]::IsNullOrWhitespace($SpecificGraphApiEndpointOnly)) {
					$true
				} else {
					if ([uri]$local:result.graph -ieq [uri]$SpecificGraphApiEndpointOnly) {
						$true
					} else {
						$false
					}
				}
			)
		) {
			$script:GraphDomainToCloudInstanceCache[$domain] = $script:GraphDomainToCloudInstanceCache[$local:result.tenantId] = switch ($local:result.authority_host) {
				'login.microsoftonline.com' { 'AzurePublic'; break }
				'login.chinacloudapi.cn' { 'AzureChina'; break }
				'login.microsoftonline.us' { 'AzureUsGovernment'; break }
				default { 'AzurePublic' }
			}

			return $local:result.tenantId
		} else {
			return
		}
	} catch {
		$script:GraphDomainToTenantIDCache[$domain] = $null

		return
	}
}


function RemoveItemAlternativeRecurse {
	# Function to avoid problems with OneDrive throwing "Access to the cloud file is denied"

	param(
		[alias('LiteralPath')][string] $Path,
		[switch] $SkipFolder # when $Path is a folder, do not delete $path, only it's content
	)

	try { WatchCatchableExitSignal } catch { }

	$local:ToDelete = @()

	if (Test-Path -LiteralPath $path) {
		foreach ($SinglePath in @(Get-Item -LiteralPath $Path)) {
			try { WatchCatchableExitSignal } catch { }

			if (Test-Path -LiteralPath $SinglePath -PathType Container) {
				if (-not $SkipFolder) {
					$local:ToDelete += @(Get-ChildItem -LiteralPath $SinglePath -Recurse -Force | Sort-Object -Culture 127 -Property PSIsContainer, @{expression = { $_.FullName.split([IO.Path]::DirectorySeparatorChar).count }; descending = $true }, fullname)
					$local:ToDelete += @(Get-Item -LiteralPath $SinglePath -Force)
				} else {
					$local:ToDelete += @(Get-ChildItem -LiteralPath $SinglePath -Recurse -Force | Sort-Object -Culture 127 -Property PSIsContainer, @{expression = { $_.FullName.split([IO.Path]::DirectorySeparatorChar).count }; descending = $true }, fullname)
				}
			} elseif (Test-Path -LiteralPath $SinglePath -PathType Leaf) {
				$local:ToDelete += (Get-Item -LiteralPath $SinglePath -Force)
			}
		}
	} else {
		# Item to delete does not exist, nothing to do
	}

	foreach ($SingleItemToDelete in $local:ToDelete) {
		try { WatchCatchableExitSignal } catch { }

		try {
			if ((Test-Path -LiteralPath $SingleItemToDelete.FullName) -eq $true) {
				Remove-Item -LiteralPath $SingleItemToDelete.FullName -Force -Recurse
			}
		} catch {
			Write-Verbose "Could not delete $($SingleItemToDelete.FullName), error: $($_.Exception.Message)"
			Write-Verbose $_
		}
	}

	try { WatchCatchableExitSignal } catch { }
}

try {
	# Start script
	Write-Host "Start script @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"

	# Remove unnecessary ETS type data associated with arrays in Windows PowerShell
	Remove-TypeData System.Array -ErrorAction SilentlyContinue

	if ($psISE) {
		Write-Host '  PowerShell ISE detected. Use PowerShell in console or terminal instead.' -ForegroundColor Red
		Write-Host '  Required features are not available in ISE. Exit.' -ForegroundColor Red
		exit 1
	}

	if (($ExecutionContext.SessionState.LanguageMode) -ine 'FullLanguage') {
		Write-Host "This PowerShell session runs in $($ExecutionContext.SessionState.LanguageMode) mode, not FullLanguage mode." -ForegroundColor Red
		Write-Host 'Required features are only available in FullLanguage mode. Exit.' -ForegroundColor Red
		exit 1
	}

	Write-Host '  Prepare objects'

	$OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding

	if ($PSScriptRoot) {
		Set-Location -LiteralPath $PSScriptRoot
	} else {
		Write-Host '  Could not determine the script path, which is essential for this script to work.' -ForegroundColor Red
		Write-Host '  Make sure to run this script as a file from a PowerShell console, and not just as a text selection in a code editor.' -ForegroundColor Red
		Write-Host '  Exit.' -ForegroundColor Red
		exit 1
	}

	if (-not $GraphData) {
		$GraphData = @(
			, @($(@($GraphUserCredential.username -split '@')[1]), $GraphUserCredential.username, (New-Object PSCredential 0, $GraphUserCredential.Password).GetNetworkCredential().Password; $GraphClientID, $GraphClientSecret)
		)
	}

	$SetOutlookSignaturesScriptParameters.GraphClientID = $GraphData

	# Cloud environment
	## Endpoints from https://github.com/microsoft/CSS-Exchange/blob/main/Shared/AzureFunctions/Get-CloudServiceEndpoint.ps1
	## Environment names must match https://learn.microsoft.com/en-us/dotnet/api/microsoft.identity.client.azurecloudinstance?view=msal-dotnet-latest
	switch ($CloudEnvironment) {
		{ $_ -iin @('Public', 'Global', 'AzurePublic', 'AzureGlobal', 'AzureCloud', 'AzureUSGovernmentGCC', 'USGovernmentGCC') } {
			$script:CloudEnvironmentEnvironmentName = 'AzurePublic'
			$script:CloudEnvironmentGraphApiEndpoint = 'https://graph.microsoft.com'
			$script:CloudEnvironmentExchangeOnlineEndpoint = 'https://outlook.office.com'
			$script:CloudEnvironmentAutodiscoverSecureName = 'https://autodiscover-s.outlook.com'
			$script:CloudEnvironmentAzureADEndpoint = 'https://login.microsoftonline.com'
			break
		}

		{ $_ -iin @('AzureUSGovernment', 'AzureUSGovernmentGCCHigh', 'AzureUSGovernmentL4', 'USGovernmentGCCHigh', 'USGovernmentL4') } {
			$script:CloudEnvironmentEnvironmentName = 'AzureUSGovernment'
			$script:CloudEnvironmentGraphApiEndpoint = 'https://graph.microsoft.us'
			$script:CloudEnvironmentExchangeOnlineEndpoint = 'https://outlook.office365.us'
			$script:CloudEnvironmentAutodiscoverSecureName = 'https://autodiscover-s.office365.us'
			$script:CloudEnvironmentAzureADEndpoint = 'https://login.microsoftonline.us'
			break
		}

		{ $_ -iin @('AzureUSGovernmentDOD', 'AzureUSGovernmentL5', 'USGovernmentDOD', 'USGovernmentL5') } {
			$script:CloudEnvironmentEnvironmentName = 'AzureUSGovernment'
			$script:CloudEnvironmentGraphApiEndpoint = 'https://dod-graph.microsoft.us'
			$script:CloudEnvironmentExchangeOnlineEndpoint = 'https://outlook-dod.office365.us'
			$script:CloudEnvironmentAutodiscoverSecureName = 'https://autodiscover-s-dod.office365.us'
			$script:CloudEnvironmentAzureADEndpoint = 'https://login.microsoftonline.us'
			break
		}

		{ $_ -iin @('China', 'AzureChina', 'ChinaCloud', 'AzureChinaCloud') } {
			$script:CloudEnvironmentEnvironmentName = 'AzureChina'
			$script:CloudEnvironmentGraphApiEndpoint = 'https://microsoftgraph.chinacloudapi.cn'
			$script:CloudEnvironmentExchangeOnlineEndpoint = 'https://partner.outlook.cn'
			$script:CloudEnvironmentAutodiscoverSecureName = 'https://autodiscover-s.partner.outlook.cn'
			$script:CloudEnvironmentAzureADEndpoint = 'https://login.partner.microsoftonline.cn'
			break
		}
	}

	$SetOutlookSignaturesScriptParameters.CloudEnvironment = $script:CloudEnvironmentEnvironmentName

	Write-Host '  Prepare folders'

	$script:tempDir = (New-Item -Path ([System.IO.Path]::GetTempPath()) -Name (New-Guid).Guid -ItemType Directory).FullName

	foreach ($VariableName in ('SimulateResultPath', 'SetOutlookSignaturesScriptPath')) {
		Set-Variable -Name $VariableName -Value $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath((Get-Variable -Name $VariableName).Value).trimend('\')
	}

	if (-not (Test-Path -LiteralPath $SimulateResultPath)) {
		New-Item -ItemType Directory $SimulateResultPath | Out-Null
	} else {
		RemoveItemAlternativeRecurse -Path $SimulateResultPath -SkipFolder
	}

	@(
		(Join-Path -Path $SimulateResultPath -ChildPath '_log_started.txt'),
		(Join-Path -Path $SimulateResultPath -ChildPath '_log_success.txt'),
		(Join-Path -Path $SimulateResultPath -ChildPath '_log_error.txt')
	) | ForEach-Object {
		New-Item -ItemType File $_ | Out-Null
	}

	try {
		$TranscriptFullName = (Join-Path -Path $SimulateResultPath -ChildPath '_log.txt')
		$TranscriptFullName = (Start-Transcript -LiteralPath $TranscriptFullName -Force).Path

		Write-Host "  Log file: '$TranscriptFullName'"
		Write-Host "    Ignore log lines starting with 'PS>TerminatingError' or '>> TerminatingError' unless instructed otherwise."
	} catch {
		$TranscriptFullName = $null
	}


	# Connect to Graph
	if (-not $ConnectOnpremInsteadOfCloud) {
		Write-Host
		Write-Host "Connect to Graph @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"

		Write-Host '  Microsoft Graph'
		$SimulateAndDeployGraphCredentialFile = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "$((New-Guid).Guid).xml"

		$SetOutlookSignaturesScriptParameters['SimulateAndDeployGraphCredentialFile'] = $SimulateAndDeployGraphCredentialFile

		$script:MsalModulePath = (Join-Path -Path $script:tempDir -ChildPath 'MSAL.PS')

		Copy-Item -LiteralPath $([System.Io.Path]::GetFullPath($((Join-Path -Path (Split-Path $SetOutlookSignaturesScriptPath) -ChildPath 'bin\MSAL.PS')))) -Destination $script:MsalModulePath -Recurse
		if (-not ((Test-Path -LiteralPath 'variable:IsLinux') -and $IsLinux)) { Get-ChildItem -LiteralPath $script:MsalModulePath -Recurse | Unblock-File }
		Import-Module $script:MsalModulePath -Force

		$GraphConnectResult = CreateUpdateSimulateAndDeployGraphCredentialFile

		if (($GraphConnectResult | Where-Object { $_.error -ne $false }).Count -gt 0) {
			Start-Sleep -Seconds 10

			$GraphConnectResult = CreateUpdateSimulateAndDeployGraphCredentialFile

			if (($GraphConnectResult | Where-Object { $_.error -ne $false }).Count -gt 0) {
				Write-Host '    Exiting because of repeated Graph connection error' -ForegroundColor Red
				Write-Host "    $($GraphConnectResult.error)" -ForegroundColor Red
				exit 1
			}
		}
	}


	# Load and check SimulateList
	Write-Host
	Write-Host "Load and check list of mailboxes to simulate @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
	Write-Host "  $(($SimulateList | Measure-Object).count) entries found"

	$SimulateListCheckPositive = $true

	$SimulateListUserDuplicate = @(@(($SimulateList | Group-Object -Property 'SimulateUser' | Where-Object { $_.count -ge 2 }).Group.SimulateUser) | Select-Object -Unique)

	if ($SimulateListUserDuplicate) {
		$SimulateListCheckPositive = $false

		Write-Host '  Duplicate SimulateUser entries:' -ForegroundColor Red

		$SimulateListUserDuplicate | ForEach-Object {
			Write-Host "   $($_)" -ForegroundColor Red
		}
	}

	foreach ($SimulateEntry in $SimulateList) {
		if ($SimulateEntry.SimulateUser -inotmatch '^\S+@\S+$|^\S+\\\S+$') {
			$SimulateListCheckPositive = $false
			Write-Host "  Wrong format for SimulateUser: $($SimulateEntry.SimulateUser)" -ForegroundColor Red
		}

		if ($SimulateEntry.SimulateMailboxes) {
			try {
				[mailaddress[]] $tempSimulateMailboxes = @(@(($SimulateEntry.SimulateMailboxes -replace '\s+', ',' -replace ';+', ',' -replace ',+', ',') -split ',') | Where-Object { $_ })
				$SimulateEntry.SimulateMailboxes = "$($tempSimulateMailboxes -join ', ')"
			} catch {
				$SimulateListCheckPositive = $false
				Write-Host "  Wrong format for SimulateMailboxes: $($SimulateEntry.SimulateMailboxes)"
			}
		} else {
			$SimulateEntry.SimulateMailboxes = $null
		}
	}

	if (-not $SimulateListCheckPositive) {
		Write-Host
		Write-Host 'Errors found, see details above. Exiting.' -ForegroundColor Red
		exit 1
	}


	# Overcome Word security warning when export contains embedded pictures
	# Set-OutlookSignatures handles this itself very well, but multiple instances running in the same user account may lead to problems
	# As a workaround, we define the setting before running the jobs
	if (((-not (Test-Path -LiteralPath 'variable:IsWindows')) -or $IsWindows) -and ($SetOutlookSignaturesScriptParameters.UseHtmTemplates -inotin (1, '1', 'true', '$true', 'yes'))) {
		Write-Host
		Write-Host "Memorize Word security setting and disable it @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
		$script:WordRegistryVersion = [System.Version]::Parse(((((((Get-ItemProperty -LiteralPath 'Registry::HKEY_CLASSES_ROOT\Word.Application\CurVer' -ErrorAction SilentlyContinue).'(default)' -ireplace [Regex]::Escape('Word.Application.'), '') + '.0.0.0.0')) -ireplace '^\.', '' -split '\.')[0..3] -join '.'))
		if ($script:WordRegistryVersion.major -gt 16) {
			Write-Host "  Word version $($script:WordRegistryVersion) is newer than 16 and not yet known. Please inform your administrator. Exit." -ForegroundColor Red
			exit 1
		} elseif ($script:WordRegistryVersion.major -eq 16) {
			$script:WordRegistryVersion = '16.0'
		} elseif ($script:WordRegistryVersion.major -eq 15) {
			$script:WordRegistryVersion = '15.0'
		} elseif ($script:WordRegistryVersion.major -eq 14) {
			$script:WordRegistryVersion = '14.0'
		} elseif ($script:WordRegistryVersion.major -lt 14) {
			Write-Host "    Word version $($script:WordRegistryVersion) is older than Word 2010 and not supported. Please inform your administrator. Exit." -ForegroundColor Red
			exit 1
		}

		if ($null -eq (Get-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Office\$($script:WordRegistryVersion)\Word\Security" -Name 'DisableWarningOnIncludeFieldsUpdate' -ErrorAction SilentlyContinue).DisableWarningOnIncludeFieldsUpdate) {
			$null = "HKCU:\Software\Microsoft\Office\$($script:WordRegistryVersion)\Word\Security" | ForEach-Object { if (Test-Path -LiteralPath $_) { Get-Item -LiteralPath $_ } else { New-Item $_ -Force } } | New-ItemProperty -Name 'DisableWarningOnIncludeFieldsUpdate' -Type DWORD -Value 0 -Force
		}

		if ($null -eq $script:WordDisableWarningOnIncludeFieldsUpdate) {
			if (Test-Path -LiteralPath "HKCU:\Software\Microsoft\Office\$($script:WordRegistryVersion)\Word\Security") {
				$script:WordDisableWarningOnIncludeFieldsUpdate = (Get-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Office\$($script:WordRegistryVersion)\Word\Security").'DisableWarningOnIncludeFieldsUpdate'
			}
		}

		if (($null -eq $script:WordDisableWarningOnIncludeFieldsUpdate) -or ($script:WordDisableWarningOnIncludeFieldsUpdate -ne 1)) {
			$null = "HKCU:\Software\Microsoft\Office\$($script:WordRegistryVersion)\Word\Security" | ForEach-Object { if (Test-Path -LiteralPath $_) { Get-Item -LiteralPath $_ } else { New-Item $_ -Force } } | New-ItemProperty -Name 'DisableWarningOnIncludeFieldsUpdate' -Type DWORD -Value 1 -Force
		}
	}

	# Run simulation mode for each user
	Write-Host
	Write-Host "Run simulation mode for each user and its mailbox(es) @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"

	Write-Host '  Remove old jobs'

	Get-Job | Remove-Job -Force

	$JobsToStartTotal = ($SimulateList | Measure-Object).count
	$JobsToStartOpen = ($SimulateList | Measure-Object).count
	$JobsStarted = 0
	$JobsCompleted = 0

	Write-Host "  $JobstoStartTotal jobs total: $JobsCompleted completed, $($JobsStarted - $JobsCompleted) in progress, $JobsToStartOpen in queue @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"


	$UpdateTime = (Get-Date).Add($UpdateInterval)

	do {
		while ((($JobsToStartOpen -gt 0) -and ((Get-Job).count -lt $JobsConcurrent))) {
			$LogFilePath = Join-Path -Path (Join-Path -Path $SimulateResultPath -ChildPath $($SimulateList[$Jobsstarted].SimulateUser)) -ChildPath '_log.txt'

			if ((Test-Path -LiteralPath (Split-Path -LiteralPath $LogFilePath)) -eq $false) {
				New-Item -ItemType Directory -Path (Split-Path -LiteralPath $LogFilePath) | Out-Null
			}

			# Update Graph credential file before starting a job
			#   this makes sure that the token is still valid when the software runs longer than token lifetime
			if (
				$($ConnectOnpremInsteadOfCloud -ne $true) -and
				$(
					$(-not $GraphConnectResult) -or
					$($GraphConnectResult -and (($GraphConnectResult | Where-Object { $_.error -ne $false }).Count -gt 0)) -or
					$($GraphConnectResult -and
						$(
							@(
								$(
									foreach ($SingleGraphConnectResult in $GraphConnectResult) {
										foreach ($tempTokenType in @('AccessToken', 'AccessTokenExo', 'AppAccessToken', 'AppAccessTokenExo')) {
											$tempParsedToken = ParseJwtToken -token $($SingleGraphConnectResult.$tempTokenType)
											$tempCurrentTimeUtcUnixTimestamp = Get-Date -UFormat %s -Millisecond 0 -Date (Get-Date).ToUniversalTime()

											# True if
											#   Token is expired
											#   The remaining token lifetime is less than or equals the job timeout
											#   At least half of the token lifetime has already passed
											$(
												$($tempCurrentTimeUtcUnixTimestamp -ge $tempParsedToken.payload.exp) -or
												$(($tempParsedToken.payload.exp - $tempCurrentTimeUtcUnixTimestamp) -le $JobTimeout.TotalSeconds) -or
												$($tempCurrentTimeUtcUnixTimestamp -ge ($tempParsedToken.payload.nbf + (($tempParsedToken.payload.exp - $tempParsedToken.payload.nbf) / 2)))
											)
										}
									}
								)
							) -icontains $true
						)
					)
				)
			) {
				Write-Host '    Renewing Graph token'

				$GraphConnectResult = CreateUpdateSimulateAndDeployGraphCredentialFile

				if (($GraphConnectResult | Where-Object { $_.error -ne $false }).Count -gt 0) {
					Start-Sleep -Seconds 70

					$GraphConnectResult = CreateUpdateSimulateAndDeployGraphCredentialFile

					if (($GraphConnectResult | Where-Object { $_.error -ne $false }).Count -gt 0) {
						Start-Sleep -Seconds 70

						$GraphConnectResult = CreateUpdateSimulateAndDeployGraphCredentialFile

						if (($GraphConnectResult | Where-Object { $_.error -ne $false }).Count -gt 0) {
							Start-Sleep -Seconds 70

							$GraphConnectResult = CreateUpdateSimulateAndDeployGraphCredentialFile

							if (($GraphConnectResult | Where-Object { $_.error -ne $false }).Count -gt 0) {
								Write-Host '    Exiting because of repeated Graph connection error' -ForegroundColor Red
								Write-Host "    $($GraphConnectResult.error)" -ForegroundColor Red
								exit 1
							}
						}
					}
				}
			}

			Start-Job {
				param (
					$SetOutlookSignaturesScriptPath,
					$SimulateUser,
					$SimulateMailboxes,
					$SimulateResultPath,
					$LogFilePath,
					$SetOutlookSignaturesScriptParameters
				)

				Start-Transcript -LiteralPath $LogFilePath -Force

				try {
					Write-Host 'CREATE SIGNATURE FILES BY USING SIMULATON MODE OF SET-OUTLOOKSIGNATURES'

					$SetOutlookSignaturesScriptParameters['SimulateUser'] = $SimulateUser
					$SetOutlookSignaturesScriptParameters['SimulateMailboxes'] = $SimulateMailboxes
					$SetOutlookSignaturesScriptParameters['AdditionalSignaturePath'] = $(Join-Path -Path $SimulateResultPath -ChildPath $SimulateUser)

					& $SetOutlookSignaturesScriptPath @SetOutlookSignaturesScriptParameters

					if ($?) {
						Write-Host 'xxxSimulateAndDeployExitCode0xxx'
					} else {
						Write-Host 'xxxSimulateAndDeployExitCode999xxx'
					}
				} catch {
					Write-Host ($error[0] | Format-List * | Out-String)
					Write-Host 'xxxSimulateAndDeployExitCode999xxx'
				}

				Stop-Transcript
			} -Name ("$($Jobsstarted)_Job") -ArgumentList $SetOutlookSignaturesScriptPath,
			$($SimulateList[$Jobsstarted].SimulateUser),
			$($SimulateList[$Jobsstarted].SimulateMailboxes),
			$SimulateResultPath,
			$LogFilePath,
			$SetOutlookSignaturesScriptParameters | Out-Null

			"    User $($SimulateList[$Jobsstarted].SimulateUser) started @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@" | ForEach-Object {
				Write-Host $($_)
				Add-Content -Value $($_.TrimStart()) -LiteralPath (Join-Path -Path $SimulateResultPath -ChildPath '_log_started.txt') -Force -Encoding UTF8
			}

			$JobsToStartOpen--
			$JobsStarted++

			Write-Host "  $JobstoStartTotal jobs total: $JobsCompleted completed, $($JobsStarted - $JobsCompleted) in progress, $JobsToStartOpen in queue @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
		}

		foreach ($x in (Get-Job | Where-Object { (-not $_.PSEndTime) -and (((Get-Date) - $_.PSBeginTime) -gt $JobTimeout) })) {
			"    User $($SimulateList[$($x.name.trimend('_Job'))].SimulateUser) canceled due to timeout @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@" | ForEach-Object {
				Write-Host $($_) -ForegroundColor Red
				Add-Content -Value $($_.TrimStart()) -LiteralPath (Join-Path -Path $SimulateResultPath -ChildPath '_log_error.txt') -Force -Encoding UTF8
			}

			$x | Remove-Job -Force

			$JobsCompleted++

			Write-Host "  $JobstoStartTotal jobs total: $JobsCompleted completed, $($JobsStarted - $JobsCompleted) in progress, $JobsToStartOpen in queue @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
		}

		foreach ($x in (Get-Job | Where-Object { $_.PSEndTime })) {
			$LogFilePath = Join-Path -Path (Join-Path -Path $SimulateResultPath -ChildPath $($SimulateList[$($x.name.trimend('_Job'))].SimulateUser)) -ChildPath '_log.txt'

			if ((Get-Content -LiteralPath $LogFilePath -Encoding UTF8 -Raw).trim().Contains('xxxSimulateAndDeployExitCode0xxx')) {
				"    User $($SimulateList[$($x.name.trimend('_Job'))].SimulateUser) ended with no errors @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@" | ForEach-Object {
					Write-Host $($_) -ForegroundColor Green
					Add-Content -Value $($_.TrimStart()) -LiteralPath (Join-Path -Path $SimulateResultPath -ChildPath '_log_success.txt') -Force -Encoding UTF8
				}
			} else {
				"    User $($SimulateList[$($x.name.trimend('_Job'))].SimulateUser) ended with errors @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@" | ForEach-Object {
					Write-Host $($_) -ForegroundColor Red
					Add-Content -Value $($_.TrimStart()) -LiteralPath (Join-Path -Path $SimulateResultPath -ChildPath '_log_error.txt') -Force -Encoding UTF8
				}
			}

			$x | Remove-Job -Force

			$JobsCompleted++

			Write-Host "  $JobstoStartTotal jobs total: $JobsCompleted completed, $($JobsStarted - $JobsCompleted) in progress, $JobsToStartOpen in queue @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
		}

		if ((Get-Date) -ge $UpdateTime) {
			Write-Host "  $JobstoStartTotal jobs total: $JobsCompleted completed, $($JobsStarted - $JobsCompleted) in progress, $JobsToStartOpen in queue @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
			$UpdateTime = (Get-Date).Add($UpdateInterval)
		}

		Start-Sleep -Seconds 1
	} until (($JobsToStartTotal -eq $JobsStarted) -and ($JobsCompleted -eq $JobsToStartTotal))
} catch {
	Write-Host
	Write-Host ($error[0] | Format-List * | Out-String) -ForegroundColor Red
	Write-Host
	Write-Host 'Unexpected error. Exit.' -ForegroundColor red
} finally {
	Write-Host
	Write-Host "Clean-up @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"

	Get-Job | Remove-Job -Force

	# Restore Word security setting for embedded images
	if (((-not (Test-Path -LiteralPath 'variable:IsWindows')) -or $IsWindows) -and ($SetOutlookSignaturesScriptParameters.UseHtmTemplates -inotin (1, '1', 'true', '$true', 'yes'))) {
		Set-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Office\$($script:WordRegistryVersion)\Word\Security" -Name DisableWarningOnIncludeFieldsUpdate -Value $script:WordDisableWarningOnIncludeFieldsUpdate -ErrorAction Ignore | Out-Null
	}

	if ($script:MsalModulePath) {
		Remove-Module -Name MSAL.PS -Force -ErrorAction SilentlyContinue
		Remove-Item -LiteralPath $script:MsalModulePath -Recurse -Force -ErrorAction SilentlyContinue
	}

	if ($SimulateAndDeployGraphCredentialFile) {
		Remove-Item -LiteralPath $SimulateAndDeployGraphCredentialFile -Force -ErrorAction SilentlyContinue
	}

	if ($script:tempDir) {
		Remove-Item -LiteralPath $script:tempDir -Recurse -Force -ErrorAction SilentlyContinue
	}

	if ($TranscriptFullName) {
		Write-Host
		Write-Host 'Log file'
		Write-Host "  '$TranscriptFullName'"
	}

	Write-Host
	Write-Host "End script @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"

	if ($TranscriptFullName) {
		try { Stop-Transcript | Out-Null } catch { }
	}
}

# SIG # Begin signature block
# MIIwZwYJKoZIhvcNAQcCoIIwWDCCMFQCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCxH0VHPSRSXVsi
# 7xqSmPlvMp8Pho9ceuUU6quJc6v3eaCCFCkwggWQMIIDeKADAgECAhAFmxtXno4h
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
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgHCev1sue
# clVLpNN+ilsRfwaDTHGOqKsyWeZysxgHsy4wggEABgorBgEEAYI3AgEMMYHxMIHu
# oIHFgIHCAFAAbwB3AGUAcgBlAGQAIABiAHkAIABFAHgAcABsAGkAYwBJAFQAIABD
# AG8AbgBzAHUAbAB0AGkAbgBnAC4AIABVAG4AbABvAGMAawAgAGEAbABsACAAZgBl
# AGEAdAB1AHIAZQBzACAAdwBpAHQAaAAgAFMAZQB0AC0ATwB1AHQAbABvAG8AawBT
# AGkAZwBuAGEAdAB1AHIAZQBzACAAQgBlAG4AZQBmAGEAYwB0AG8AcgAgAEMAaQBy
# AGMAbABlAC6hJIAiaHR0cHM6Ly9zZXQtb3V0bG9va3NpZ25hdHVyZXMuY29tIDAN
# BgkqhkiG9w0BAQEFAASCAgDBejZhQ1o1czeM77ShwpU6KrCNwTzGGrgLLGp01Hht
# s1N7CD0xZ9wRJM3Ms71LkDjeeX92yn83jhxhHhWPid+MbaPLsrpfg4FxyO9bQx7u
# V95YnySwi/dZpneOPmgWyk3ECQLsObj7aYEAGaTJ3Z1xM7AlTX1XbEB0Q6A6Orz7
# 9OrNV2/ze2OmyDCv8A6RE6vTwSFhynwghi+DqSoCiU1EcV0fhbPWiGeNSiRYwRWw
# ss7SrbeuRYRfNHFfi/l7jFJXcxIXfvqstr5CraiZqGpLeu/XjkqSjSBnYh1pLe2U
# KLx6d9RNfWpX3FbZSO6vX+9r6Jv7oaDxxJXUQyMYJRHvuJs0rioPqwb4jzZ+FUZP
# c0+NixY9BM91K5hOrpbHRCgOQnP2mYjgjpiChVaAQRlcDiqE0EZE2no+/pOdspuI
# sipjyH6XcP88bgW+QtWtEnvC1MWmbnZhkAXFOOIdpvCNQT3cof1Cj42V4NHTon8C
# 3pOoYZlZafzTdJ4PVw/GhAAn6qUcfPqKbMn6ZCxBi+vzVJ83SIcd5GBEijXtwF9M
# wBwK9NNjOJvfdmsYaSBrzxSWPuUNfQISYNQAbg7axVF7BaTgANetu0wscKyvIYlf
# RUDzaUAM3OY8vUjETuDr6vtyJqINEteyFSvw/Ajfim+F6qnuoYwQ2MEu18SId7vr
# G6GCF3YwghdyBgorBgEEAYI3AwMBMYIXYjCCF14GCSqGSIb3DQEHAqCCF08wghdL
# AgEDMQ8wDQYJYIZIAWUDBAIBBQAwdwYLKoZIhvcNAQkQAQSgaARmMGQCAQEGCWCG
# SAGG/WwHATAxMA0GCWCGSAFlAwQCAQUABCAHmarewvVUSBK60f2dVzkI2Jl++Exb
# v0+UjFIUgtHpAAIQZ6M/t5VbGP2idxDsMlVAsRgPMjAyNTEyMjMxMTUwMTRaoIIT
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
# BgkqhkiG9w0BCQQxIgQg6UO/pq9mFWUQhTR0WDeyPmPVqHvfUXfW+RX6KrleaMEw
# NwYLKoZIhvcNAQkQAi8xKDAmMCQwIgQgSqA/oizXXITFXJOPgo5na5yuyrM/420m
# mqM08UYRCjMwDQYJKoZIhvcNAQEBBQAEggIADUyeL/QkBLpeVhQlSuMNId/f3u3m
# Ok8x/OE6og4r3JEazDbCQ7vT9bELPfiwjrpeZoUPlZ8qhIfvhkk7NMVsQo2yej9O
# o9kSRpXxh2yk6drX3wLB3cyGv7KSjfrjSKK/x0NfhB47KK554k3I/olvW5KKZLbD
# gyoUTy9uTqhzDYfbrjP4HeWZT9TRbyekvnw5yVHh2j9/I6yA8CWbZOUhbxwFIS65
# +BYFaS6U37fafqoIXDX/PMMb4fryEmKPDkxkePpfh+CHKZH4Swv54dZoW5mLHqNG
# kVSC6u/lZ/jK1Ck/aT0bTdamjPRskuwHDWAbNwiUHRkauEdFX2S8BzskMrQFLPRC
# 5b1L4/kJPET8NMANua2tTyhciC+fvpa5/tR84UczuJnRnmC3ldseL5VTFNNQ9/jT
# QjS5IJmFRcNKIlgwurJ0nniQXIfyNRpyHHe9CAxD+/9SjHaD8HcWoU3by/OpUyz6
# +ibgnaE9KSNnXRI6MRNHAz9tB8NmZfMIQhIcwtAy8gvyVcNu7qCXUYUxMJnQB1af
# DwDD3vWYFsEbON2F7vtBMq4frG/iqTCYTQSl6rzQ6K8QMA8r2eBQXZ7HYOZIxzeh
# 0uw70Nabe5T42UmrJs7EMZBnA1yXg1JzyJzQrNcmZecVC4cwp7xYIRW+o5YjYSmK
# pUJsjVccbnOjklg=
# SIG # End signature block
