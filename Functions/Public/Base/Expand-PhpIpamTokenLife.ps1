<#
.SYNOPSIS
    Expand PhpIpam Token Life if needed
.DESCRIPTION
    Expand PhpIpam Token Life if needed
.EXAMPLE
    PS C:\> Expand-PhpIpamTokenLife
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Expand-PhpIpamTokenLife {
    [cmdletbinding()]
    param(
        [switch]$force
    )
    if ($script:PhpIpamTokenAuth) {
        if (!$force) {
            $TokenStatus = test-PhpIpamToken
            if ($Tokenstatus -eq "Valid") {
                $r = invoke-PHPIpamExecute -method patch -controller user
                if ($r) {
                    $script:PhpIpamTokenExpires = $r.data.expires
                    return $r.data.expires
                }
            }
        }
        if ($TokenStatus -eq "Expired" -or $force) {
            if (New-PhpIpamSession -useCredAuth -PhpIpamApiUrl $script:PhpIpamApiUrl -AppID $script:PhpIpamAppID -userName $script:PhpIpamUsername -password $script:PhpIpamPassword) {
                return $script:PhpIpamTokenExpires
            }
        }
    }
    else {
        Write-Warning "Because you use encrypted request(You never get a token,Do not use this func if you using encryped request)"
    }
}
Export-ModuleMember -Function Expand-PhpIpamTokenLife
