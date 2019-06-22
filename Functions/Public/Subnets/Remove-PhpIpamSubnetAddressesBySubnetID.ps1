
<#
.SYNOPSIS
    remove all ip addresses in a subnet
.DESCRIPTION
    remove all ip addresses in a subnet
.EXAMPLE
    PS C:\> Remove-PhpIpamSubnetAddressesBySubnetID -id  31
    PS C:\> Get-PhpIpamSubnetAddressesByID -id 31
    PS C:\> Get-PhpIpamSubnet -ID 31

.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Remove-PhpIpamSubnetAddressesBySubnetID {
    [cmdletBinding()]
    Param(
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, position = 0)]
        [int]$ID
    )

    begin {
        Write-Verbose $ID
    }
    process {
        $r=Invoke-PhpIpamExecute -method delete -controller subnets -identifiers @($ID, "truncate")
        if($r -and $r.success){
            return $true
        }else{
            return $false
        }
    }

    end {

    }
}
New-Alias -name "Remove-PhpIpamSubnetAllAddressBySubnetID" -value Remove-PhpIpamSubnetAddressesBySubnetID
Export-ModuleMember -Function Remove-PhpIpamSubnetAddressesBySubnetID -Alias Remove-PhpIpamSubnetAllAddressBySubnetID
