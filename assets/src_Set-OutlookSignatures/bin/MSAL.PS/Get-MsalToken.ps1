<#
.SYNOPSIS
    Acquire a token using MSAL.NET library.
.DESCRIPTION
    This command will acquire OAuth tokens for both public and confidential clients. Public clients authentication can be interactive, Integrated Windows Authentication, or silent (aka refresh token authentication).
.EXAMPLE
    PS C:\>Get-MsalToken -ClientId '00000000-0000-0000-0000-000000000000' -Scope 'https://graph.microsoft.com/User.Read','https://graph.microsoft.com/Files.ReadWrite'
    Get AccessToken (with MS Graph permissions User.Read and Files.ReadWrite) and IdToken using client id from application registration (public client).
.EXAMPLE
    PS C:\>Get-MsalToken -ClientId '00000000-0000-0000-0000-000000000000' -TenantId '00000000-0000-0000-0000-000000000000' -Interactive -Scope 'https://graph.microsoft.com/User.Read' -LoginHint user@domain.com
    Force interactive authentication to get AccessToken (with MS Graph permissions User.Read) and IdToken for specific Entra ID tenant and UPN using client id from application registration (public client).
.EXAMPLE
    PS C:\>Get-MsalToken -ClientId '00000000-0000-0000-0000-000000000000' -ClientSecret (ConvertTo-SecureString 'SuperSecretString' -AsPlainText -Force) -TenantId '00000000-0000-0000-0000-000000000000' -Scope 'https://graph.microsoft.com/.default'
    Get AccessToken (with MS Graph permissions .Default) and IdToken for specific Entra ID tenant using client id and secret from application registration (confidential client).
.EXAMPLE
    PS C:\>$ClientCertificate = Get-Item -LiteralPath Cert:\CurrentUser\My\0000000000000000000000000000000000000000
    PS C:\>$MsalClientApplication = Get-MsalClientApplication -ClientId '00000000-0000-0000-0000-000000000000' -ClientCertificate $ClientCertificate -TenantId '00000000-0000-0000-0000-000000000000'
    PS C:\>$MsalClientApplication | Get-MsalToken -Scope 'https://graph.microsoft.com/.default'
    Pipe in confidential client options object to get a confidential client application using a client certificate and target a specific tenant.
#>
function Get-MsalToken {
  [CmdletBinding(DefaultParameterSetName = 'PublicClient')]
  [OutputType([Microsoft.Identity.Client.AuthenticationResult])]
  param
  (
    # Identifier of the client requesting the token.
    [Parameter(Mandatory = $true, ParameterSetName = 'PublicClient', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'PublicClient-Interactive', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'PublicClient-IntegratedWindowsAuth', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'PublicClient-Silent', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'PublicClient-UsernamePassword', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'PublicClient-DeviceCode', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientSecret', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientSecret-AuthorizationCode', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientSecret-OnBehalfOf', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientCertificate', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientCertificate-AuthorizationCode', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientCertificate-OnBehalfOf', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string] $ClientId,

    # Secure secret of the client requesting the token.
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientSecret', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientSecret-AuthorizationCode', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientSecret-OnBehalfOf', ValueFromPipelineByPropertyName = $true)]
    [securestring] $ClientSecret,

    # Client assertion certificate of the client requesting the token.
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientCertificate', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientCertificate-AuthorizationCode', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientCertificate-OnBehalfOf', ValueFromPipelineByPropertyName = $true)]
    [System.Security.Cryptography.X509Certificates.X509Certificate2] $ClientCertificate,

    # Specifies if the x5c claim (public key of the certificate) should be sent to the STS.
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClient-InputObject')]
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClientCertificate')]
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClientCertificate-AuthorizationCode')]
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClientCertificate-OnBehalfOf')]
    [switch] $SendX5C,

    # The authorization code received from service authorization endpoint.
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClient-InputObject')]
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientSecret-AuthorizationCode')]
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientCertificate-AuthorizationCode')]
    [string] $AuthorizationCode,

    # Assertion representing the user.
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClient-InputObject', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientSecret-OnBehalfOf', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClientCertificate-OnBehalfOf', ValueFromPipelineByPropertyName = $true)]
    [string] $UserAssertion,

    # Type of the assertion representing the user.
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClient-InputObject', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClientSecret-OnBehalfOf', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClientCertificate-OnBehalfOf', ValueFromPipelineByPropertyName = $true)]
    [string] $UserAssertionType,

    # Address to return to upon receiving a response from the authority.
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-Interactive', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-IntegratedWindowsAuth', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-Silent', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-UsernamePassword', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-DeviceCode', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClientSecret', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClientSecret-AuthorizationCode', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClientSecret-OnBehalfOf', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClientCertificate', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClientCertificate-AuthorizationCode', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClientCertificate-OnBehalfOf', ValueFromPipelineByPropertyName = $true)]
    [uri] $RedirectUri,

    # Instance of Azure Cloud
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [Microsoft.Identity.Client.AzureCloudInstance] $AzureCloudInstance,

    # Tenant identifier of the authority to issue token. It can also contain the value "consumers" or "organizations".
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [string] $TenantId,

    # Address of the authority to issue token.
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [uri] $Authority,

    # Use Platform Authentication Broker
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-Interactive', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-InputObject', ValueFromPipelineByPropertyName = $true)]
    [switch] $AuthenticationBroker,

    # Public client application
    [Parameter(Mandatory = $true, ParameterSetName = 'PublicClient-InputObject', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Microsoft.Identity.Client.IPublicClientApplication] $PublicClientApplication,

    # Confidential client application
    [Parameter(Mandatory = $true, ParameterSetName = 'ConfidentialClient-InputObject', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Microsoft.Identity.Client.IConfidentialClientApplication] $ConfidentialClientApplication,

    # Interactive request to acquire a token for the specified scopes.
    [Parameter(Mandatory = $true, ParameterSetName = 'PublicClient-Interactive')]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-InputObject')]
    [switch] $Interactive,

    # BrowserRedirectError
    [uri] $BrowserRedirectError,

    # BrowserRedirectSuccess
    [uri] $BrowserRedirectSuccess,

    # HtmlMessageSuccess
    [string] $HtmlMessageSuccess,

    # HtmlMessageError
    [string] $HtmlMessageError,

    # Silent request to acquire a security token for the signed-in user in Windows, via Integrated Windows Authentication.
    [Parameter(Mandatory = $true, ParameterSetName = 'PublicClient-IntegratedWindowsAuth')]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-InputObject')]
    [switch] $IntegratedWindowsAuth,

    # Attempts to acquire an access token from the user token cache.
    [Parameter(Mandatory = $true, ParameterSetName = 'PublicClient-Silent')]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-InputObject')]
    [switch] $Silent,

    # Acquires a security token on a device without a Web browser, by letting the user authenticate on another device.
    [Parameter(Mandatory = $true, ParameterSetName = 'PublicClient-DeviceCode')]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-Interactive')]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-InputObject')]
    [switch] $DeviceCode,

    # Array of scopes requested for resource
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [string[]] $Scopes = 'https://graph.microsoft.com/.default',

    # Array of scopes for which a developer can request consent upfront.
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-Interactive', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-InputObject', ValueFromPipelineByPropertyName = $true)]
    [string[]] $ExtraScopesToConsent,

    # Identifier of the user. Generally a UPN.
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-Interactive', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-IntegratedWindowsAuth', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-Silent', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-InputObject', ValueFromPipelineByPropertyName = $true)]
    [string] $LoginHint,

    # Specifies the what the interactive experience is for the user. To force an interactive authentication, use the -Interactive switch.
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-Interactive', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-InputObject', ValueFromPipelineByPropertyName = $true)]
    [ArgumentCompleter( {
        param ( $commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters )
        [Microsoft.Identity.Client.Prompt].DeclaredFields | Where-Object { $_.IsPublic -eq $true -and $_.IsStatic -eq $true -and $_.Name -like "$wordToComplete*" } | Select-Object -ExpandProperty Name
      })]
    [string] $Prompt,

    # Identifier of the user with associated password.
    [Parameter(Mandatory = $true, ParameterSetName = 'PublicClient-UsernamePassword', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-InputObject', ValueFromPipelineByPropertyName = $true)]
    [pscredential]
    [System.Management.Automation.Credential()]
    $UserCredential,

    # Correlation id to be used in the authentication request.
    [Parameter(Mandatory = $false)]
    [guid] $CorrelationId,

    # This parameter will be appended as is to the query string in the HTTP authentication request to the authority.
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [hashtable] $ExtraQueryParameters,

    # Modifies the token acquisition request so that the acquired token is a Proof of Possession token (PoP), rather than a Bearer token.
    [Parameter(Mandatory = $false)]
    [System.Net.Http.HttpRequestMessage] $ProofOfPossession,

    # Ignore any access token in the user token cache and attempt to acquire new access token using the refresh token for the account if one is available.
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient')]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-Silent')]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-InputObject')]
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClientSecret')]
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClientCertificate')]
    [Parameter(Mandatory = $false, ParameterSetName = 'ConfidentialClient-InputObject')]
    [switch] $ForceRefresh,

    # Specifies if the public client application should used an embedded web browser or the system default browser
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-Interactive', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $false, ParameterSetName = 'PublicClient-InputObject', ValueFromPipelineByPropertyName = $true)]
    [switch] $UseEmbeddedWebView,

    # Specifies the timeout threshold for MSAL.net operations.
    [Parameter(Mandatory = $false)]
    [timespan] $Timeout
  )

  begin {
    function CheckForMissingScopes([Microsoft.Identity.Client.AuthenticationResult]$AuthenticationResult, [string[]]$Scopes) {
      foreach ($Scope in $Scopes) {
        if ($AuthenticationResult.Scopes -notcontains $Scope) { return $true }
      }
      return $false
    }

    function Coalesce([psobject[]]$objects) { foreach ($object in $objects) { if ($object -notin $null, [string]::Empty) { return $object } } return $null }

    $InteractiveAuthTopLevelParentWindow = $null
  }

  process {
    switch -Wildcard ($PSCmdlet.ParameterSetName) {
      'PublicClient-InputObject' {
        [Microsoft.Identity.Client.IPublicClientApplication] $ClientApplication = $PublicClientApplication
        break
      }
      'ConfidentialClient-InputObject' {
        [Microsoft.Identity.Client.IConfidentialClientApplication] $ClientApplication = $ConfidentialClientApplication
        break
      }
      'PublicClient*' {
        $paramSelectMsalClientApplication = Select-PsBoundParameters $PSBoundParameters -CommandName Select-MsalClientApplication -CommandParameterSets 'PublicClient'
        [Microsoft.Identity.Client.IPublicClientApplication] $PublicClientApplication = Select-MsalClientApplication @paramSelectMsalClientApplication
        [Microsoft.Identity.Client.IPublicClientApplication] $ClientApplication = $PublicClientApplication
        break
      }
      'ConfidentialClientSecret*' {
        $paramSelectMsalClientApplication = Select-PsBoundParameters $PSBoundParameters -CommandName Select-MsalClientApplication -CommandParameterSets 'ConfidentialClientSecret'
        [Microsoft.Identity.Client.IConfidentialClientApplication] $ConfidentialClientApplication = Select-MsalClientApplication @paramSelectMsalClientApplication
        [Microsoft.Identity.Client.IConfidentialClientApplication] $ClientApplication = $ConfidentialClientApplication
        break
      }
      'ConfidentialClientCertificate*' {
        $paramSelectMsalClientApplication = Select-PsBoundParameters $PSBoundParameters -CommandName Select-MsalClientApplication -CommandParameterSets 'ConfidentialClientCertificate'
        [Microsoft.Identity.Client.IConfidentialClientApplication] $ConfidentialClientApplication = Select-MsalClientApplication @paramSelectMsalClientApplication
        [Microsoft.Identity.Client.IConfidentialClientApplication] $ClientApplication = $ConfidentialClientApplication
        break
      }
    }

    [Microsoft.Identity.Client.AuthenticationResult] $AuthenticationResult = $null
    switch -Wildcard ($PSCmdlet.ParameterSetName) {
      'PublicClient*' {
        if ($PSBoundParameters.ContainsKey('UserCredential') -and $UserCredential) {
          $AquireTokenParameters = $PublicClientApplication.AcquireTokenByUsernamePassword($Scopes, $UserCredential.UserName, $UserCredential.Password)
        } elseif (($PSBoundParameters.ContainsKey('DeviceCode') -and $DeviceCode) -or ($PSBoundParameters.ContainsKey('Interactive') -and $Interactive -and !$script:ModuleFeatureSupport.WebView1Support -and !$script:ModuleFeatureSupport.WebView2Support -and ([uri]$PublicClientApplication.AppConfig.RedirectUri).AbsoluteUri -ine 'http://localhost/') -or ($PSBoundParameters.ContainsKey('Interactive') -and $Interactive -and !$script:ModuleFeatureSupport.WebView1Support -and $PublicClientApplication.AppConfig.RedirectUri -ieq 'urn:ietf:wg:oauth:2.0:oob')) {
          $AquireTokenParameters = $PublicClientApplication.AcquireTokenWithDeviceCode($Scopes, [DeviceCodeHelper]::GetDeviceCodeResultCallback())
        } elseif ($PSBoundParameters.ContainsKey('Interactive') -and $Interactive) {
          $AquireTokenParameters = $PublicClientApplication.AcquireTokenInteractive($Scopes)

          if ((-not (Test-Path -LiteralPath 'variable:IsWindows')) -or $IsWindows) {
            [IntPtr] $ParentWindow = [System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle

            if ($ParentWindow -eq [System.IntPtr]::Zero) {
              Add-Type -AssemblyName PresentationCore, PresentationFramework, System.Windows.Forms

              $InteractiveAuthTopLevelParentWindow = New-Object System.Windows.Window -Property @{
                Width                 = 1
                Height                = 1
                WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen
                ShowActivated         = $false
                Topmost               = $true
              }

              $InteractiveAuthTopLevelParentWindow.Show()
              $InteractiveAuthTopLevelParentWindow.Hide()

              [IntPtr] $ParentWindow = [System.Windows.Interop.WindowInteropHelper]::new($InteractiveAuthTopLevelParentWindow).Handle
            }

            if ($ParentWindow -ne [System.IntPtr]::Zero) { [void] $AquireTokenParameters.WithParentActivityOrWindow($ParentWindow) }
          } elseif ((Test-Path -LiteralPath 'variable:IsMacOS') -and $IsMacOS) {
            $objcCode = @'
using System;
using System.Runtime.InteropServices;

public class MacInterop {
    [DllImport("/usr/lib/libobjc.A.dylib", EntryPoint = "objc_getClass")]
    public static extern IntPtr objc_getClass(string className);

    [DllImport("/usr/lib/libobjc.A.dylib", EntryPoint = "sel_registerName")]
    public static extern IntPtr sel_registerName(string selectorName);

    [DllImport("/usr/lib/libobjc.A.dylib", EntryPoint = "objc_msgSend")]
    public static extern IntPtr objc_msgSend(IntPtr receiver, IntPtr selector);

    public static IntPtr GetMainWindowHandle() {
        IntPtr nsAppClass = objc_getClass("NSApplication");
        IntPtr sharedAppSel = sel_registerName("sharedApplication");
        IntPtr mainWindowSel = sel_registerName("mainWindow");

        IntPtr nsApp = objc_msgSend(nsAppClass, sharedAppSel);
        IntPtr mainWindow = objc_msgSend(nsApp, mainWindowSel);

        return mainWindow;
    }
}
'@

            Add-Type -TypeDefinition $objcCode -Language CSharp
            [IntPtr] $ParentWindow = [MacInterop]::GetMainWindowHandle()

            if ($ParentWindow -ne [System.IntPtr]::Zero) {
              [void] $AquireTokenParameters.WithParentActivityOrWindow($ParentWindow)
            }
          } elseif ((Test-Path -LiteralPath 'variable:IsLinux') -and $IsLinux) {
            try {
              $x11Code = @'
using System;
using System.Runtime.InteropServices;

public class X11Interop {
    [DllImport("libX11")]
    public static extern IntPtr XOpenDisplay(IntPtr display);

    [DllImport("libX11")]
    public static extern IntPtr XDefaultRootWindow(IntPtr display);

    public static IntPtr GetRootWindow() {
        IntPtr display = XOpenDisplay(IntPtr.Zero);
        if (display == IntPtr.Zero) {
            return IntPtr.Zero;
        }
        return XDefaultRootWindow(display);
    }
}
'@

              Add-Type -TypeDefinition $x11Code -Language CSharp

              [IntPtr] $ParentWindow = [X11Interop]::GetRootWindow()

              if ($ParentWindow -ne [System.IntPtr]::Zero) {
                [void] $AquireTokenParameters.WithParentActivityOrWindow($ParentWindow)
              }
            } catch {
              # Do nothing
            }
          }


          #if ($Account) { [void] $AquireTokenParameters.WithAccount($Account) }
          if ($extraScopesToConsent) { [void] $AquireTokenParameters.WithExtraScopesToConsent($extraScopesToConsent) }
          if ($LoginHint) { [void] $AquireTokenParameters.WithLoginHint($LoginHint) }
          if ($Prompt) { [void] $AquireTokenParameters.WithPrompt([Microsoft.Identity.Client.Prompt]::$Prompt) }
          if ($PSBoundParameters.ContainsKey('UseEmbeddedWebView')) { [void] $AquireTokenParameters.WithUseEmbeddedWebView($UseEmbeddedWebView) }

          if (-not $UseEmbeddedWebView) {
            $SystemWebViewOptions = @{}

            if (-not [string]::IsNullOrWhiteSpace($BrowserRedirectSuccess)) {
              $SystemWebViewOptions.BrowserRedirectSuccess = $BrowserRedirectSuccess
            }

            if (-not [string]::IsNullOrWhiteSpace($BrowserRedirectError)) {
              $SystemWebViewOptions.BrowserRedirectError = $BrowserRedirectError
            }

            if (-not [string]::IsNullOrWhiteSpace($HtmlMessageSuccess)) {
              $SystemWebViewOptions.HtmlMessageSuccess = $HtmlMessageSuccess
            }

            if (-not [string]::IsNullOrWhiteSpace($HtmlMessageError)) {
              $SystemWebViewOptions.HtmlMessageError = $HtmlMessageError
            }

            if (@($SystemWebViewOptions.getEnumerator()).count -gt 0) {
              [void] $AquireTokenParameters.WithSystemWebViewOptions($(New-Object Microsoft.Identity.Client.SystemWebViewOptions -Property $SystemWebViewOptions))
            }
          }

          if (!$Timeout -and (($PSBoundParameters.ContainsKey('UseEmbeddedWebView') -and !$UseEmbeddedWebView) -or $PSVersionTable.PSEdition -eq 'Core')) {
            $Timeout = New-TimeSpan -Minutes 2
          }
        } elseif ($PSBoundParameters.ContainsKey('IntegratedWindowsAuth') -and $IntegratedWindowsAuth) {
          $AquireTokenParameters = $PublicClientApplication.AcquireTokenByIntegratedWindowsAuth($Scopes)
          if ($LoginHint) { [void] $AquireTokenParameters.WithUsername($LoginHint) }
        } elseif ($PSBoundParameters.ContainsKey('Silent') -and $Silent) {
          if ($PSBoundParameters.ContainsKey('LoginHint') -and $LoginHint) {
            $AquireTokenParameters = $PublicClientApplication.AcquireTokenSilent($Scopes, $LoginHint)
          } else {
            if ($PSBoundParameters.ContainsKey('AuthenticationBroker') -and $AuthenticationBroker) {
              [Microsoft.Identity.Client.IAccount] $Account = [Microsoft.Identity.Client.PublicClientApplication]::OperatingSystemAccount
            } else {
              [Microsoft.Identity.Client.IAccount] $Account = $PublicClientApplication.GetAccountsAsync().GetAwaiter().GetResult() | Select-Object -First 1
            }

            $AquireTokenParameters = $PublicClientApplication.AcquireTokenSilent($Scopes, $Account)
          }
          if ($PSBoundParameters.ContainsKey('ForceRefresh')) { [void] $AquireTokenParameters.WithForceRefresh($ForceRefresh) }
        } else {
          $paramGetMsalToken = Select-PsBoundParameters -NamedParameter $PSBoundParameters -CommandName 'Get-MsalToken' -CommandParameterSet 'PublicClient-InputObject' -ExcludeParameters 'PublicClientApplication'
          ## Try Silent Authentication
          Write-Verbose ('Attempting Silent Authentication to Application with ClientId [{0}]' -f $ClientApplication.AppConfig.ClientId)
          try {
            $AuthenticationResult = Get-MsalToken -Silent -PublicClientApplication $PublicClientApplication @paramGetMsalToken
            ## Check for requested scopes
            if (CheckForMissingScopes $AuthenticationResult $Scopes) {
              $AuthenticationResult = Get-MsalToken -Interactive -PublicClientApplication $PublicClientApplication @paramGetMsalToken
            }
          } catch [Microsoft.Identity.Client.MsalUiRequiredException] {
            Write-Debug ('{0}: {1}' -f $_.Exception.GetType().Name, $_.Exception.Message)
            ## Try Integrated Windows Authentication
            Write-Verbose ('Attempting Integrated Windows Authentication to Application with ClientId [{0}]' -f $ClientApplication.AppConfig.ClientId)
            try {
              $AuthenticationResult = Get-MsalToken -IntegratedWindowsAuth -PublicClientApplication $PublicClientApplication @paramGetMsalToken
              ## Check for requested scopes
              if (CheckForMissingScopes $AuthenticationResult $Scopes) {
                $AuthenticationResult = Get-MsalToken -Interactive -PublicClientApplication $PublicClientApplication @paramGetMsalToken
              }
            } catch {
              Write-Debug ('{0}: {1}' -f $_.Exception.GetType().Name, $_.Exception.Message)
              ## Revert to Interactive Authentication
              Write-Verbose ('Attempting Interactive Authentication to Application with ClientId [{0}]' -f $ClientApplication.AppConfig.ClientId)
              $AuthenticationResult = Get-MsalToken -Interactive -PublicClientApplication $PublicClientApplication @paramGetMsalToken
            }
          }
          break
        }
      }
      'ConfidentialClient*' {
        if ($PSBoundParameters.ContainsKey('AuthorizationCode')) {
          $AquireTokenParameters = $ConfidentialClientApplication.AcquireTokenByAuthorizationCode($Scopes, $AuthorizationCode)
        } elseif ($PSBoundParameters.ContainsKey('UserAssertion')) {
          if ($UserAssertionType) { [Microsoft.Identity.Client.UserAssertion] $UserAssertionObj = New-Object Microsoft.Identity.Client.UserAssertion -ArgumentList $UserAssertion, $UserAssertionType }
          else { [Microsoft.Identity.Client.UserAssertion] $UserAssertionObj = New-Object Microsoft.Identity.Client.UserAssertion -ArgumentList $UserAssertion }
          $AquireTokenParameters = $ConfidentialClientApplication.AcquireTokenOnBehalfOf($Scopes, $UserAssertionObj)
        } else {
          $AquireTokenParameters = $ConfidentialClientApplication.AcquireTokenForClient($Scopes)
          if ($PSBoundParameters.ContainsKey('ForceRefresh')) { [void] $AquireTokenParameters.WithForceRefresh($ForceRefresh) }
        }
        if ($SendX5C) { [void] $AquireTokenParameters.WithSendX5C($SendX5C) }
      }
      '*' {
        if ($AzureCloudInstance -and $TenantId) { [void] $AquireTokenParameters.WithAuthority($AzureCloudInstance, $TenantId) }
        elseif ($AzureCloudInstance) { [void] $AquireTokenParameters.WithAuthority($AzureCloudInstance, 'common') }
        elseif ($TenantId) { [void] $AquireTokenParameters.WithAuthority($ClientApplication.AppConfig.Authority.AuthorityInfo.CanonicalAuthority.AbsoluteUri, $TenantId) }
        if ($Authority) { [void] $AquireTokenParameters.WithAuthority($Authority.AbsoluteUri) }
        if ($CorrelationId) { [void] $AquireTokenParameters.WithCorrelationId($CorrelationId) }
        if ($ExtraQueryParameters) { [void] $AquireTokenParameters.WithExtraQueryParameters((ConvertTo-Dictionary $ExtraQueryParameters -KeyType ([string]) -ValueType ([string]))) }
        if ($ProofOfPossession) { [void] $AquireTokenParameters.WithProofOfPosession($ProofOfPossession) }
        Write-Debug ('Aquiring Token for Application with ClientId [{0}]' -f $ClientApplication.AppConfig.ClientId)
        if (!$Timeout) { $Timeout = [timespan]::Zero }

        ## Wait for async task to complete
        $tokenSource = New-Object System.Threading.CancellationTokenSource
        try {
          #$AuthenticationResult = $AquireTokenParameters.ExecuteAsync().GetAwaiter().GetResult()
          $taskAuthenticationResult = $AquireTokenParameters.ExecuteAsync($tokenSource.Token)
          try {
            $endTime = [datetime]::Now.Add($Timeout)
            while (!$taskAuthenticationResult.IsCompleted) {
              if ($Timeout -eq [timespan]::Zero -or [datetime]::Now -lt $endTime) {
                try { WatchCatchableExitSignal } catch { }

                Start-Sleep -Seconds 1
              } else {
                $tokenSource.Cancel()
                try { $taskAuthenticationResult.Wait() }
                catch { }
                Write-Error -Exception (New-Object System.TimeoutException) -Category ([System.Management.Automation.ErrorCategory]::OperationTimeout) -CategoryActivity $MyInvocation.MyCommand -ErrorId 'GetMsalTokenFailureOperationTimeout' -TargetObject $AquireTokenParameters -ErrorAction Stop
              }
            }
          } finally {
            if (!$taskAuthenticationResult.IsCompleted) {
              Write-Debug ('Canceling Token Acquisition for Application with ClientId [{0}]' -f $ClientApplication.AppConfig.ClientId)
              $tokenSource.Cancel()
            }

            $tokenSource.Dispose()

            if ($InteractiveAuthTopLevelParentWindow) {
              try {
                $InteractiveAuthTopLevelParentWindow.Close()
              } catch {
                # Do nothing
              }
            }
          }

          ## Parse task results
          if ($taskAuthenticationResult.IsFaulted) {
            Write-Error -Exception $taskAuthenticationResult.Exception -Category ([System.Management.Automation.ErrorCategory]::AuthenticationError) -CategoryActivity $MyInvocation.MyCommand -ErrorId 'GetMsalTokenFailureAuthenticationError' -TargetObject $AquireTokenParameters -ErrorAction Stop
          }
          if ($taskAuthenticationResult.IsCanceled) {
            Write-Error -Exception (New-Object System.Threading.Tasks.TaskCanceledException $taskAuthenticationResult) -Category ([System.Management.Automation.ErrorCategory]::OperationStopped) -CategoryActivity $MyInvocation.MyCommand -ErrorId 'GetMsalTokenFailureOperationStopped' -TargetObject $AquireTokenParameters -ErrorAction Stop
          } else {
            $AuthenticationResult = $taskAuthenticationResult.Result
          }
        } catch {
          Write-Error -Exception (Coalesce $_.Exception.InnerException, $_.Exception) -Category ([System.Management.Automation.ErrorCategory]::AuthenticationError) -CategoryActivity $MyInvocation.MyCommand -ErrorId 'GetMsalTokenFailureAuthenticationError' -TargetObject $AquireTokenParameters -ErrorAction Stop
        }
        break
      }
    }

    return $AuthenticationResult
  }
}


# SIG # Begin signature block
# MIIwaAYJKoZIhvcNAQcCoIIwWTCCMFUCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDtuwsRb2KOl4H2
# +uq96pnYqMbxNFNA2U4i/uQwIRm//qCCFCkwggWQMIIDeKADAgECAhAFmxtXno4h
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
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgs+bApBQl
# LV+kezXDBH1DgSvpx0JcDxWgbSUhL8Yb7UQwggEABgorBgEEAYI3AgEMMYHxMIHu
# oIHFgIHCAFAAbwB3AGUAcgBlAGQAIABiAHkAIABFAHgAcABsAGkAYwBJAFQAIABD
# AG8AbgBzAHUAbAB0AGkAbgBnAC4AIABVAG4AbABvAGMAawAgAGEAbABsACAAZgBl
# AGEAdAB1AHIAZQBzACAAdwBpAHQAaAAgAFMAZQB0AC0ATwB1AHQAbABvAG8AawBT
# AGkAZwBuAGEAdAB1AHIAZQBzACAAQgBlAG4AZQBmAGEAYwB0AG8AcgAgAEMAaQBy
# AGMAbABlAC6hJIAiaHR0cHM6Ly9zZXQtb3V0bG9va3NpZ25hdHVyZXMuY29tIDAN
# BgkqhkiG9w0BAQEFAASCAgC43DFD5tja75QcFes3LiZV+eGHwa5ytQXLMxQj/n0o
# M0Mr/b82Ck48ynm9AMWtwkBMtc5pp9mT7BiktHTbMJzBSWK35oSXQHYIDpfK24ZY
# lpBCJEBjJpxFFuMYK/rKHixxVRAOc7BmZg2H2/7Q+2hVYme2IB2+kfPHirnBx4Ab
# /NA2GluahJfokqs04e+Pw26k+gjfDFPuosfaPrBJWgHpVqVICufMJodVtstMnkDo
# mPgv2Xe7DWoIf3h5q59g85NM1SFgjERnhTZCOvRegHgOZMbtlpLLyvfPEM9W6ldO
# muQIANMeUhYPmwnndZqNYd2ZRqDvRN7X1rPE9lJ+Y9FCerS+5JP3nUtq5Evz/4gA
# FXyMvgALSwdUpC2U/k5rQc74wLMSEqhGq8hnsPQbMdqHfdwf/pQoPrD3w2gjk1wb
# 9mwbMv3CJ0tLIEV361P75i0TGeztXjKK9E/yd2mWScVbCB3ucSq+rMGGd2e+fjjl
# MZAt+2I+HL8e6iMYYoxrgPVCg+tpwNWOaenQEyMzwPOvA7kJ91RYg2oXcqtUHFj6
# uNxZqvpXt92ZKsgCnJrD7q1U99U1H0ph4GLhNTLwei5FZH4wlxSQTOE+PgohVuTw
# WXgMf99MVUZ0Ovn8eS9gZkBGg6Xk4e+Eh37k918XjEC7TmojXB4Yblu+Gd/mldNU
# X6GCF3cwghdzBgorBgEEAYI3AwMBMYIXYzCCF18GCSqGSIb3DQEHAqCCF1AwghdM
# AgEDMQ8wDQYJYIZIAWUDBAIBBQAweAYLKoZIhvcNAQkQAQSgaQRnMGUCAQEGCWCG
# SAGG/WwHATAxMA0GCWCGSAFlAwQCAQUABCDGsGpral8GJVHp5wpxTtv0tLJkQOiQ
# jdMu983yV53xGgIRAIf1+YAqTmjCoBSNxsEMzscYDzIwMjUxMjIzMTE1MDExWqCC
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
# MVowKwYLKoZIhvcNAQkQAgwxHDAaMBgwFgQU3WIwrIYKLTBr2jixaHlSMAf7QX4w
# LwYJKoZIhvcNAQkEMSIEIDit66hsSZ95h94Xk+C8B1K9OeZey0QtyugV9TaQ4wVt
# MDcGCyqGSIb3DQEJEAIvMSgwJjAkMCIEIEqgP6Is11yExVyTj4KOZ2ucrsqzP+Nt
# JpqjNPFGEQozMA0GCSqGSIb3DQEBAQUABIICAKd8zYNYsbwoplV0GkHZPPCyz+Pm
# 5QoYUpt6/FXhg/DdZf99oiwykE+VQpw99zWyvuxymB9NT5ef3aH+mjvaf3TlSC33
# Mx7ilbqb/dsQVGEwjTIEgM/rtyO5k4WdxhKWWM9jM0oTy84l4iv9+x1r6NrGSKos
# NLwIYX61e8/LZwMxqPtJ71Fj2kzZISfRdvovzCDMxDC7mUMMdlXUS2qu74vIN2R+
# tD5B9nSSLFUz7ZNHiD7vrvW/qiqs8uEXHhVFqrinvrm9hyPyncG72tNumNiUTZB1
# gUNNATc6NlTuce24GL3z7Pjw5o+YP55vw8Q8msvH5m2JNWU/GrgBtiRTWtrSuVM9
# sx8ENKCii0N6oHgkRc2cGpYCWlc7sohik7fjBu/bxQHdLrWqQ8kIoUawzoHqaJXo
# tAOM8/Rg0jyJjuH37BgP8XtmnjZxleSBDAqB11uwaCkI+Pp/HbrfJ6kD6CpRk2nM
# C4ubc6/alwPNmRLiEItOobeby1uykzWtTAAMQUwXJMGrzwpwPq0cn/eP7tQud3hO
# RRzVWCqYK1LaGoPXrPyUJKKaveAxZbekq1jA0BqclEYa/CPFL85LLk7HaCPKh5Ra
# qPD6jiHJ56fO3eVxauVhvC7e6IiXG2ftqUcOrpOM+cITQAm7Rea8SfzyDm5RfrvE
# SIn7WH2LVSumE+69
# SIG # End signature block
