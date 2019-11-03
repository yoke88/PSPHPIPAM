<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> remove-phpipamaddress -id 1
    PS C:\> get-PhpIpamAddress
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Remove-PhpIpamAddress{
    [cmdletBinding()]
    Param(
         [parameter(
             Mandatory=$true,
             ValueFromPipeline=$true,
             ValueFromPipelineByPropertyName=$true,
             position=0
         )]
         [int]$id
    )

    begin{

    }
    process{
        Write-Debug "AddressId=$id"
        $r=Invoke-PhpIpamExecute -method delete -controller addresses -identifiers @($ID)
        if($r -and $r.success){
            return $true
        }else{
            Write-Error $r
        }
    }

    end{

    }
}
New-Alias -Name Remove-PhpIpamAddress -Value Remove-PhpIpamAddress
Export-ModuleMember -Function  Remove-PhpIpamAddress -Alias Remove-PhpIpamAddressByID
