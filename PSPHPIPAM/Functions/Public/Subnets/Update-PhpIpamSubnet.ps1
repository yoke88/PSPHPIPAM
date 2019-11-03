<#
.SYNOPSIS
    Update Subnet
.DESCRIPTION
    Update Subnet
.PARAMETER Params
    Subnet info which can be hashtable or pscustomobject

.EXAMPLE
    PS C:\> New-PhpIpamSubnet -Params @{sectionId=1;subnet='192.168.10.0';mask=24}
    PS C:\> $UpdatedSubnet=@{id=$subnet.id;description="this was a test"}
    PS C:\> Update-PhpIpamSubnet -Params $UpdatedSubnet

.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Update-PhpIpamSubnet{
    [cmdletBinding()]
    param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [validatescript({$_ -is [hashtable] -or $_ -is [psCustomObject]})]
        $Params=@{}
    )
    BEGIN{

    }
    PROCESS{
        $r=Invoke-PhpIpamExecute -method patch -controller subnets -params $Params
        if($r -and $r.success){
            Get-PhpIpamSubnet -id $params['id']
        }else{
            Write-Error $r
        }
    }
    END{

    }
}

Export-ModuleMember -Function Update-PhpIpamSubnet
