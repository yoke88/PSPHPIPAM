<#
.SYNOPSIS
  Create New Address in a subnet
.DESCRIPTION
  Create New Address in a subnet
.EXAMPLE

  PS C:\> New-PhpIpamAddress -params @{subnetId=10;ip='192.168.10.2'}
  PS C:\> Get-PhpIpamAddresses -id 11
  PS C:\> Get-PhpIpamAddressesByIP 192.168.10.2

.INPUTS
  Inputs (if any)
.OUTPUTS
  the Address Id
.NOTES
  General notes
#>
function New-PhpIpamAddress{
    [cmdletBinding()]
    Param(
     [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
      $params
    )

    begin{

    }
    process{
          $r=Invoke-PhpIpamExecute -method post -controller addresses  -params $params
          if($r -and $r.success){
            Get-PhpIpamAddress -ID $r.id
          }else{
            Write-Error $r
          }
    }

    end{

    }
}

Export-ModuleMember -Function New-PhpIpamAddress
