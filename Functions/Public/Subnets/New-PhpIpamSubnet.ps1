<#
.SYNOPSIS
    Creates new subnet
.DESCRIPTION
    Creates new subnet
.EXAMPLE
    PS C:\> New-PhpIpamSubnet -Params @{sectionId=1;subnet='192.168.10.0';mask=24}
    Create an subnet 192.168.10.0/24 in section 1
.INPUTS
    Hashtable contains subnet infos
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function New-PhpIpamSubnet {

    [cmdletBinding()]
    Param(
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [validateScript( { $_ -is [system.collections.hashtable] })]
        $Params = @{ }
    )
    begin {

    }
    process {
        $r = Invoke-PhpIpamExecute -method post -controller subnets -params $Params

        if ($r -and $r.success) {
            if ($r.id) {
                Get-PhpIpamSubnetByID -id $r.id
            }
        } else {
            Write-Error $r
        }
    }
    end {

    }
}

Export-ModuleMember -Function New-PhpIpamSubnet
