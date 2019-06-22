<#
.SYNOPSIS
    get phpipamsubnet by subnet id or CIDR
.DESCRIPTION
    get phpipamsubnet by subnet id or CIDR
.EXAMPLE
    # By subnetID
    PS C:\> Get-PhpIpamSubnet 1
    # By CIDR
    PS C:\> Get-PhpIpamSubnet -CIDR 'fd13:6d20:29dc:cf27::/64'
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Get-PhpIpamSubnet{
    [cmdletBinding()]
    Param(
         [parameter(
             Mandatory=$true,
             ValueFromPipeline=$true,
             ValueFromPipelineByPropertyName=$true,
             position=0,
             ParameterSetName="ByID"
             )]
         [int]$ID,
        [parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            position=0,
            ParameterSetName="ByCIDR",
            HelpMessage="CIDR Can be like: 192.168.9.0/23 "
            )]
        [string]$CIDR
    )

    begin{

    }
    process{
        if($PSCmdlet.ParameterSetName -eq 'ByID'){
            $r=Invoke-PhpIpamExecute -method get -controller subnets -identifiers @($ID)
        }

        if($PSCmdlet.ParameterSetName -eq 'ByCIDR'){
            $r=Invoke-PhpIpamExecute -method get -controller subnets -identifiers @('cidr',$CIDR)
        }

        Resolve-PhpIpamExecuteResult -result $r
    }

    end{

    }
}
New-Alias -Name Get-PhpIpamSubnetByID -Value get-PhpIpamSubnet
new-alias -Name get-PhpIpamSubnetByCIDR -Value Get-PhpIpamSubnet
Export-ModuleMember -Function Get-PhpIpamSubnet -Alias 'Get-PhpIpamSubnetByID','get-PhpIpamSubnetByCIDR'

