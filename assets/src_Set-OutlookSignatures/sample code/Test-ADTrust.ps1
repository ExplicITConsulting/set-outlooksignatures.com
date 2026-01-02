<#
This sample code is used to check AD trusts and AD connectivity from a client computer.

Connection ist tested for every combination of
- DNS name of domain and domain controllers
- IP address of domain and domain controllers
- Protocols LDAP and GC, with and without encryption

This script assumes that the trust to check is either a cross-forest trust, or that the trusted domain is the only domain in it's forest

You have to adapt it to fit your environment.
The sample code is written in a generic way, which allows for easy adaption.

Would you like support? ExplicIT Consulting (https://explicitconsulting.at) offers professional support for this and other open source code.
#>


#Requires -Version 5.1

[CmdletBinding()]

param (
    [string[]]$CrossForestTrustRootDomains = @('example.com'),
    [string[]]$DcPorts = @(88, 389, 636, 9389),
    [string[]]$GcPorts = @(3268, 3269),
    [string[]]$DcProtocols = @('LDAP'),
    [string[]]$GcProtocols = @('GC'),
    [int]$JobsParallel = 10,
    [int]$JobTimeoutSeconds = 1200
)


Clear-Host


try {
    Write-Host "Start script @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
    Write-Host '  Ports ususally required for LDAP and Global Catalog communication:'
    Write-Host '    88 TCP/UDP (Kerberos authentication)'
    Write-Host '    389 TCP/UPD (LDAP)'
    Write-Host '    636 TCP (LDAPS)'
    Write-Host '    3268 TCP (Global Catalog)'
    Write-Host '    3269 TCP (Global Catalog TLS)'
    Write-Host '    9389 TCP (Active Directory Web Services)'
    Write-Host '    49152-65535 TCP (high ports)'
    Write-Host '  DNS name resolution must work flawlessly, too.'


    Write-Host
    Write-Host "Check parameters and script environment @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"

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

    $OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding

    Write-Host "  PowerShell: '$((($($PSVersionTable.PSVersion), $($PSVersionTable.PSEdition), $($PSVersionTable.Platform), $($PSVersionTable.OS)) | Where-Object {$_}) -join "', '")'"

    Write-Host "  PowerShell bitness: $(if ([Environment]::Is64BitProcess -eq $false) {'Non-'})64-bit process on a $(if ([Environment]::Is64OperatingSystem -eq $false) {'Non-'})64-bit operating system"

    Write-Host '  Parameters'
    foreach ($parameter in (Get-Command -Name $PSCommandPath).Parameters.keys) {
        if ((Get-Variable -Name $parameter -EA SilentlyContinue -ValueOnly) -is [hashtable]) {
            Write-Host "    $($parameter): '$(@((Get-Variable -Name $parameter -ValueOnly).GetEnumerator() | ForEach-Object { "$($_.Name)=$($_.Value)" }) -join ', ')'"
        } else {
            Write-Host "    $($parameter): '$((Get-Variable -Name $parameter -EA SilentlyContinue -ValueOnly) -join ', ')'"
        }
    }

    if ((-not (Test-Path -LiteralPath 'variable:IsWindows')) -or $IsWindows) {
    } else {
        Write-Host "  Your OS: $($PSVersionTable.OS)" -ForegroundColor Red
        Write-Host '  This script is supported on Windows only. Exit.' -ForegroundColor Red
    }

    if (($ExecutionContext.SessionState.LanguageMode) -ine 'FullLanguage') {
        Write-Host "  This PowerShell session runs in $($ExecutionContext.SessionState.LanguageMode) mode, not FullLanguage mode." -ForegroundColor Red
        Write-Host '  Required features are only available in FullLanguage mode. Exit.' -ForegroundColor Red
        exit 1
    }

    foreach ($CrossForestTrustRootDomain in $CrossForestTrustRootDomains) {
        Write-Host
        Write-Host "$CrossForestTrustRootDomain"

        Write-Host "  Check forest root domain via LDAP @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
        $ADForestRootDomain = ([ADSI]"LDAP://$($CrossForestTrustRootDomain)/RootDSE").rootDomainNamingContext -replace ('DC=', '') -replace (',', '.')

        if (-not $ADForestRootDomain) {
            Write-Host "    Could not connect to '$($CrossForestTrustRootDomain)' via LDAP to query RootDSE. Skipping."
            continue
        }

        if ($ADForestRootDomain -ine $CrossForestTrustRootDomain) {
            Write-Host "    '$($CrossForestTrustRootDomain)' is not the forest root domain, using '$($ADForestRootDomain)' from now on."
            $CrossForestTrustRootDomain = $ADForestRootDomain
        } else {
            Write-Host "    '$($CrossForestTrustRootDomain)' is the forest root domain, continue using this name."
        }


        Write-Host "  Get FQDN of all Global Catalog servers via DNS query @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"

        $AllGCs = @((Resolve-DnsName -Name "_gc._tcp.$($CrossForestTrustRootDomain)" -Type srv).nametarget)

        Write-Host "    $($AllGCs.count) found"

        if ($AllGCs.count -lt 1) {
            Write-Host '    No Global Catalog servers found. Check input and DNS resolution. Skipping.'
            continue
        }


        Write-Host "  Get FQDN of all Domain Controller servers via DNS query @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
        $AllDCs = @()

        foreach ($DomainName in @(@(foreach ($GC in $AllGCs) { ($GC -split '\.', 2)[1] }) | Select-Object -Unique)) {
            $AllDCs += (Resolve-DnsName -Name "_ldap._tcp.$($DomainName)" -Type srv).nametarget
        }

        Write-Host "    $($AllDCs.count) found"

        $JobsParallel = [math]::min($JobsParallel, $AllDCs.count)


        Write-Host "  Testing server connectivity ($($JobsParallel) in parallel) @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
        Write-Host '    This can take very long due to long, non-configurable timeouts.'

        $script:jobs = New-Object System.Collections.ArrayList

        [void][runspacefactory]::CreateRunspacePool()
        $RunspacePool = [runspacefactory]::CreateRunspacePool(1, $JobsParallel)
        $RunspacePool.Open()

        Write-Output '"Time";"Client";"Target forest/domain";"Target server";"Check";"DNS name or IP address";"Port";"Result";"Time in ms";"Error"'

        foreach ($DC in (@($AllDCs + $AllGCs) | Sort-Object -Culture 127 -Unique)) {
            $PowerShell = [powershell]::Create()
            $PowerShell.RunspacePool = $RunspacePool

            [void]$PowerShell.AddScript( {
                    param (
                        $CrossForestTrustRootDomain,
                        $DC,
                        $IsGC,
                        $DcPorts,
                        $DcProtocols,
                        $GcPorts,
                        $GcProtocols
                    )

                    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

                    $DebugPreference = 'Continue'

                    Write-Debug "  Start(Ticks) = $((Get-Date).Ticks)"

                    $Client = [System.Net.Dns]::GetHostByName($env:computerName).HostName

                    #Write-Output "    $($DC)"



                    if ($IsGC) {
                        #Write-Output '      Role: Domain Controller and Global Catalog'
                        $Ports = @($DcPorts) + @($GcPorts)
                        $Protocols = @($DcProtocols) + @($GcProtocols)
                    } else {
                        #Write-Output '      Role: Domain Controller only, no Global Catalog'
                        $Ports = @($DcPorts)
                        $Protocols = @($DcProtocols)
                    }


                    $IPs = @(([System.Net.Dns]::GetHostAddresses($DC)).IPAddressToString)
                    #Write-Output "      IP(s): $($IPs -join ', ')"

                    foreach ($Port in $Ports) {
                        Write-Output $('"' +
                            (
                                @(
                                    @(
                                        $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK'),
                                        $($Client),
                                        $($CrossForestTrustRootDomain),
                                        $($DC),
                                        'Port via DNS',
                                        $($DC),
                                        $($Port),
                                        $($stopwatch.Restart(); (Test-NetConnection -ComputerName $DC -Port $Port -WarningAction silentlycontinue).TcpTestSucceeded),
                                        $($stopwatch.ElapsedMilliseconds),
                                        ''
                                    ) | ForEach-Object { $_ -ireplace '"', '""' }
                                ) -join '";"'
                            ) + '"'
                        )

                        foreach ($IP in $IPs) {
                            Write-Output $('"' +
                                (
                                    @(
                                        @(
                                            $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK'),
                                            $($Client),
                                            $($CrossForestTrustRootDomain),
                                            $($DC),
                                            'Port via IP',
                                            $($IP),
                                            $($Port),
                                            $($stopwatch.Restart(); (Test-NetConnection -ComputerName $IP -Port $Port -WarningAction silentlycontinue).TcpTestSucceeded),
                                            $($stopwatch.ElapsedMilliseconds),
                                            ''
                                        ) | ForEach-Object { $_ -ireplace '"', '""' }
                                    ) -join '";"'
                                ) + '"'
                            )
                        }
                    }


                    foreach ($Protocol in $Protocols) {
                        $Search = New-Object DirectoryServices.DirectorySearcher
                        $Search.PageSize = 1000
                        $Search.filter = '(objectclass=user)'

                        try {
                            $Search.searchroot = New-Object System.DirectoryServices.DirectoryEntry("$($Protocol)://$DC")
                            $stopwatch.Restart()
                            $UserAccount = [ADSI]"$(($Search.FindOne()).path)"
                            Write-Output $('"' +
                                (
                                    @(
                                        @(
                                            $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK'),
                                            $($Client),
                                            $($CrossForestTrustRootDomain),
                                            $($DC),
                                            'LDAP/GC Query via DNS',
                                            $($DC),
                                            $($Protocol),
                                            $true,
                                            $($stopwatch.ElapsedMilliseconds),
                                            ''
                                        ) | ForEach-Object { $_ -ireplace '"', '""' }
                                    ) -join '";"'
                                ) + '"'
                            )
                        } catch {
                            Write-Output $('"' +
                                (
                                    @(
                                        @(
                                            $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK'),
                                            $($Client),
                                            $($CrossForestTrustRootDomain),
                                            $($DC),
                                            'LDAP/GC Query via DNS',
                                            $($DC),
                                            $($Protocol),
                                            $false,
                                            $($stopwatch.ElapsedMilliseconds),
                                            $($Error[0])
                                        ) | ForEach-Object { $_ -ireplace '"', '""' }
                                    ) -join '";"'
                                ) + '"'
                            )
                        }

                        foreach ($IP in $IPs) {
                            try {
                                $Search.searchroot = New-Object System.DirectoryServices.DirectoryEntry("$($Protocol)://$IP")
                                $stopwatch.Restart();
                                $UserAccount = [ADSI]"$(($Search.FindOne()).path)"
                                Write-Output $('"' +
                                    (
                                        @(
                                            @(
                                                $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK'),
                                                $($Client),
                                                $($CrossForestTrustRootDomain),
                                                $($DC),
                                                'LDAP/GC Query via IP',
                                                $($IP),
                                                $($Protocol),
                                                $true,
                                                $($stopwatch.ElapsedMilliseconds),
                                                ''
                                            ) | ForEach-Object { $_ -ireplace '"', '""' }
                                        ) -join '";"'
                                    ) + '"'
                                )
                            } catch {
                                Write-Output $('"' +
                                    (
                                        @(
                                            @(
                                                $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK'),
                                                $($Client),
                                                $($CrossForestTrustRootDomain),
                                                $($DC),
                                                'LDAP/GC Query via IP',
                                                $($IP),
                                                $($Protocol),
                                                $false,
                                                $($stopwatch.ElapsedMilliseconds),
                                                $($Error[0])
                                            ) | ForEach-Object { $_ -ireplace '"', '""' }
                                        ) -join '";"'
                                    ) + '"'
                                )
                            }
                        }
                    }


                    $stopwatch.Stop()
                }).AddParameters(
                @{
                    CrossForestTrustRootDomain = $CrossForestTrustRootDomain
                    DC                         = $DC
                    IsGC                       = ($DC -iin $AllGCs)
                    DcPorts                    = $DcPorts
                    DcProtocols                = $DcProtocols
                    GcPorts                    = $GcPorts
                    GcProtocols                = $GcProtocols
                }
            )

            $Object = New-Object 'System.Management.Automation.PSDataCollection[psobject]'
            $Handle = $PowerShell.BeginInvoke($Object, $Object)
            $temp = '' | Select-Object PowerShell, Handle, Object, StartTime, Done
            $temp.PowerShell = $PowerShell
            $temp.Handle = $Handle
            $temp.Object = $Object
            $temp.StartTime = $null
            $temp.Done = $false
            [void]$script:jobs.Add($Temp)
        }


        while (($script:jobs.Done | Where-Object { $_ -eq $false }).count -ne 0) {
            foreach ($job in $script:jobs) {
                if (($null -eq $job.StartTime) -and ($job.Powershell.Streams.Debug[0].Message -match 'Start')) {
                    $StartTicks = $job.powershell.Streams.Debug[0].Message -replace '[^0-9]'
                    $job.StartTime = [Datetime]::MinValue + [TimeSpan]::FromTicks($StartTicks)
                }

                if ($null -ne $job.StartTime) {
                    if ((($job.handle.IsCompleted -eq $true) -and ($job.Done -eq $false)) -or (($job.Done -eq $false) -and ((New-TimeSpan -Start $job.StartTime -End (Get-Date)).TotalSeconds -gt $JobTimeoutSeconds))) {
                        $job.object
                        $job.Done = $true
                    }
                }
            }
        }
    }
} catch {
    Write-Host ($error[0] | Format-List * | Out-String)
    Write-Host
    Write-Host "Unknown error, exiting. @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
    exit 1

} finally {
    Write-Host
    Write-Host "End script @$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')@"
}


# SIG # Begin signature block
# MIIwZwYJKoZIhvcNAQcCoIIwWDCCMFQCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAOO5oU4sKDz3mF
# zStIQ4NnUjTF65JO8ul/v9UQP+F0WKCCFCkwggWQMIIDeKADAgECAhAFmxtXno4h
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
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgm3ZTp+AT
# GvfelD7Dg7zFlXYdjlB7pVyvZbTMelxTUxYwggEABgorBgEEAYI3AgEMMYHxMIHu
# oIHFgIHCAFAAbwB3AGUAcgBlAGQAIABiAHkAIABFAHgAcABsAGkAYwBJAFQAIABD
# AG8AbgBzAHUAbAB0AGkAbgBnAC4AIABVAG4AbABvAGMAawAgAGEAbABsACAAZgBl
# AGEAdAB1AHIAZQBzACAAdwBpAHQAaAAgAFMAZQB0AC0ATwB1AHQAbABvAG8AawBT
# AGkAZwBuAGEAdAB1AHIAZQBzACAAQgBlAG4AZQBmAGEAYwB0AG8AcgAgAEMAaQBy
# AGMAbABlAC6hJIAiaHR0cHM6Ly9zZXQtb3V0bG9va3NpZ25hdHVyZXMuY29tIDAN
# BgkqhkiG9w0BAQEFAASCAgBjfZMLB7+cw5hcZQZAB2qYI/qT73uH7MYuNWRrlpds
# p1gGqifCw1VZFO7IiLQjaoXovCMarpI09BBqoyICJiRH4IvxAMAsawFlYl7EWIGw
# WAekYFlv2Pna9FZ0dyrEub4IPp8gmUp0cPHjwOKeHZbjUrbS7mcTMY9X6bTDXSNT
# mv+j3WywxFudeRUq5PVP0HjLeGsC+GJhiCzuGCjE3PXRkfyIayKTyWQIrFA4jZeO
# cCERKBajS7FzEaFgR4lFw+DYomMTy5NTjUWgpsSHqCpCdDMbKKpuskca0Aoy3oqC
# Q3Put/YGYiiZ/YUcdEdHpGta/SG89wBoDD0ptuR/BlkiNVOKtQ7jBELdxsAJtiq3
# jqDeytdk2/hUEQSH3WmwSBVL92+taBw3XI30Hj+rLvPCxvUnS8NjBkZmmLmn/zTN
# aljZE6tsWgADy7LwnYLED9VWQ/rgeo/RY3DiA6EyfEC+SRB2odIT9ZseFUt0SIiB
# SxT3PiLPYQAXDUoLhUdh5ixywtnAMLp1Ajpn0Nlg0VbfBJE2zCF2PWMDsQTopVhO
# E+T1hYj2rL8xa3vsy6MlPrRQlzpXU4OqsG1Z5icn9s6HqJaUl3C2hRdNWkdejlkl
# XT23gXvEoVcDJ6lfUfGHogCVbGtQkhtbvPjYs6q6iB35/DJ6s2VEcmf1Dr7H5Ap7
# KKGCF3YwghdyBgorBgEEAYI3AwMBMYIXYjCCF14GCSqGSIb3DQEHAqCCF08wghdL
# AgEDMQ8wDQYJYIZIAWUDBAIBBQAwdwYLKoZIhvcNAQkQAQSgaARmMGQCAQEGCWCG
# SAGG/WwHATAxMA0GCWCGSAFlAwQCAQUABCAJGh9s3FL4OsGzwR2WXObrfaZCOq15
# YWoYIa2khr4BkAIQeRQZbZdMoHxCV0Hze48D7xgPMjAyNTEyMjMxMTUwMTVaoIIT
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
# DQEJAzENBgsqhkiG9w0BCRABBDAcBgkqhkiG9w0BCQUxDxcNMjUxMjIzMTE1MDE1
# WjArBgsqhkiG9w0BCRACDDEcMBowGDAWBBTdYjCshgotMGvaOLFoeVIwB/tBfjAv
# BgkqhkiG9w0BCQQxIgQgER/93/ezi6KjI6lqd9dHTNqoQZPHtYflPHjuzAFw6fIw
# NwYLKoZIhvcNAQkQAi8xKDAmMCQwIgQgSqA/oizXXITFXJOPgo5na5yuyrM/420m
# mqM08UYRCjMwDQYJKoZIhvcNAQEBBQAEggIAZ64A5P3t++vz7tFEMcPvyba/70Dd
# qUbL+J9YyVejXuxig5Ecp5eqSeGQsWQmEDdlIDc7c6wjKU+f8a+nyCCesXT8j0JZ
# qyugOC+ud8yp0tNjb9saMDo5q6lSERThBy7FFujIi7DU0qW3BXmko+bqV/SKJ731
# I6ex2fRud7FouQ8m3Q2Ai6mDRcLrEbzuLDHxN994RPiMVIt7bR8s+YGn5DvWKsKA
# S8LGpvQWs8wlhIcHe8wthz1H4w1k60L08Wrt/+M6LgbgLkXitkM8lPI4buhLjB6/
# plL3qHEcrbsOO//hGcsPw4LLTZGhgIArOU+UDdhNXHPXeS5LdoOtYxC/Dn9/AzG9
# SLvX61LIsAeIKhrLREdkcrTRM9E3UPZ2A2p0pO6vCxQtAXXhd4upeO1orLZZJDz8
# B1dyFRhIvdQL8P/PKxMq0jh5l9b/S2tQED7UGTlUIAgTcEr1O2F/hLNEbkNlM09w
# MY3yQKC1qdPbGTfHTHRdfNPmIIKReEDMJW+G7sCk0LzwQxkdOvlB8EcqWEyP+uO3
# 9aNENt6OibpbSaJnIu5OS6r1vxUgMhRVlSONB0EVMyVcIaFwuKWjF+Ui6jedg7cB
# nfuUhT52+5MqnGyBTCMB+z2wini2H5N9bNBkOGWWUlnI/7ynKimkpmjppSXVKx0W
# 2x2qTluhMRJomy4=
# SIG # End signature block
