function Get-PhpIpamSubnetsBySectionID{
    Param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
        [int]$ID
    )
    begin{
    }

    process{
        $r=Invoke-PhpIpamExecute -method get -controller sections -identifiers @($ID,'subnets')
        Resolve-PhpIpamExecuteResult -result $r
    }

    end{

    }
}

Export-ModuleMember -Function Get-PhpIpamSubnetsBySectionID
