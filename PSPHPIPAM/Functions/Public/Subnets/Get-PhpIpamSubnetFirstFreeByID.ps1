function Get-PhpIpamSubnetFirstFreeByID{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
         [int]$ID
    )

    begin{
        Write-Verbose $ID
    }
    process{
        $r=Invoke-PhpIpamExecute -method get -controller subnets -identifiers @($ID,"first_free")
        Resolve-PhpIpamExecuteResult -result $r
    }

    end{

    }
}

# For Compatible with old version
# add new alias
New-Alias -Name Get-PhpIpamSubnetFirst_FreeByID -Value Get-PhpIpamSubnetFirstFreeByID
Export-ModuleMember -Function Get-PhpIpamSubnetFirstFreeByID -Alias Get-PhpIpamSubnetFirst_FreeByID
