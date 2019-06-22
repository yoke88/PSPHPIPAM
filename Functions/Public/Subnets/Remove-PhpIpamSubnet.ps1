<#
.SYNOPSIS
    Remove PhpIpam Subnet by subnet ID
.DESCRIPTION
    Remove PhpIpam Subnet by subnet ID
.PARAMETER ID
    The subnet id
.EXAMPLE
    # Create a subnet
    PS C:\> New-PhpIpamSubnet -Params @{sectionId=1;subnet='192.168.10.0';mask=24}
    # Get this subnet
    PS C:\> $subnet=Get-PhpIpamAllSubnets|?{$_.subnet -eq '192.168.10.0' -and $_.sectionid -eq 1 }
    # Delete this subnet
    PS C:\> Remove-PhpIpamSubnetByID -ID $subnet
    OR
    PS C:\> $subnet|Remove-PhpIpamSubnet

.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Remove-PhpIpamSubnet {
    [cmdletBinding()]
    Param(
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, position = 0)]
        [int]$ID
    )

    begin {
        Write-Verbose $ID
    }
    process {
        $r = Invoke-PhpIpamExecute -method delete -controller subnets -identifiers @($ID)

        if ($r -and $r.success) {
            return $true
        } else {
            return $false
        }
    }

    end {

    }
}
New-Alias -name Remove-PhpIpamSubnetByID -Value Remove-PhpIpamSubnet
Export-ModuleMember -Function Remove-PhpIpamSubnet -alias Remove-PhpIpamSubnetByID
