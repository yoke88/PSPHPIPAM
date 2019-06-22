function Get-PhpIpamAddress{
    [cmdletBinding(DefaultParameterSetName="ByID")]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0,ParameterSetName="ByIP")]
         [string]$IP,

         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0,ParameterSetName="ByID")]
         [int]$ID,
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0,ParameterSetName="ByHostName")]
         [string]$HostName

    )

    begin{

    }
    process{
            if ($PsCmdlet.ParameterSetName -eq "ByIP"){
                $r=Invoke-PhpIpamExecute -method get -controller addresses -identifiers @("search",$IP)
            }

            if($PsCmdlet.ParameterSetName -eq 'ByID'){
                $r=Invoke-PhpIpamExecute -method get -controller addresses -identifiers @($ID)
            }

            if($PsCmdlet.ParameterSetName -eq 'ByHostName'){
                $r=Invoke-PhpIpamExecute -method get -controller addresses -identifiers @("search_hostname",$HostName)
            }
            Resolve-PhpIpamExecuteResult -result $r
    }

    end{

    }
}
New-Alias -Name Get-PhpIpamAddressByID -Value Get-PhpIpamAddress
New-Alias -Name Get-PhpIpamAddressByIP -Value Get-PhpIpamAddress
New-Alias -Name Get-PhpIpamAddressByHostname -Value Get-PhpIpamAddress
Export-ModuleMember -Function Get-PhpIpamAddress -Alias "Get-PhpIpamAddressByID","Get-PhpIpamAddressByIP","Get-PhpIpamAddressByHostname"
