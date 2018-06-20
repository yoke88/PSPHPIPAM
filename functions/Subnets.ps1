function get-phpipamAllSubnets{
    Get-PhpIpamAllSections|Get-PhpIpamSubnetsBySectionID
}

function Get-PhpIpamSubnetByID{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
         [int]$ID
    )

    begin{

    }
    process{
            return $(Invoke-PhpIpamExecute -method get -controller subnets -identifiers @($ID)).data

    }

    end{

    }
}

function Get-PhpIpamSubnetUsageByID{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
         [int]$ID
    )

    begin{
        Write-Verbose $ID
    }
    process{
        return $(Invoke-PhpIpamExecute -method get -controller subnets -identifiers @($ID,"usage")).data
    }

    end{

    }
}

function Get-PhpIpamSubnetFirst_freeByID{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
         [int]$ID
    )

    begin{
        Write-Verbose $ID
    }
    process{
        return $(Invoke-PhpIpamExecute -method get -controller subnets -identifiers @($ID,"first_free")).data
    }

    end{

    }
}

function Get-PhpIpamSubnetSlavesByID{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
         [int]$ID
    )

    begin{
        Write-Verbose $ID
    }
    process{
        return $(Invoke-PhpIpamExecute -method get -controller subnets -identifiers @($ID,"slaves")).data
    }

    end{

    }
}

function Get-PhpIpamSubnetSlaves_RecursiveByID{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
         [int]$ID
    )

    begin{
        Write-Verbose $ID
    }
    process{
        return $(Invoke-PhpIpamExecute -method get -controller subnets -identifiers @($ID,"slaves_recursive")).data
    }

    end{

    }
}

function Get-PhpIpamSubnetAddressesByID{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
         [int]$ID
    )

    begin{
        Write-Verbose $ID
    }
    process{
        return $(Invoke-PhpIpamExecute -method get -controller subnets -identifiers @($ID,"addresses")).data
    }

    end{

    }
}


function Remove-PhpIpamSubnetByID{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
         [int]$ID
    )

    begin{
        Write-Verbose $ID
    }
    process{
        return $(Invoke-PhpIpamExecute -method delete -controller subnets -identifiers @($ID)).success
    }

    end{

    }
}


function Remove-PhpIpamSubnetAllAddressBySubnetID{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
         [int]$ID
    )

    begin{
        Write-Verbose $ID
    }
    process{
        return $(Invoke-PhpIpamExecute -method delete -controller subnets -identifiers @($ID,"truncate")).success
    }

    end{

    }
}

function Remove-PhpIpamSubnetAllPermissionsBySubnetID{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
         [int]$ID
    )

    begin{
        Write-Verbose $ID
    }
    process{
        return $(Invoke-PhpIpamExecute -method delete -controller subnets -identifiers @($ID,"permissions")).success
    }

    end{

    }
}

function New-PhpIpamSubnet{

    [cmdletBinding()]
    Param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [validateScript({$_ -is [system.collections.hashtable]})]
        $Params=@{}
    )
    begin{

    }
    process{
        if($(Invoke-PhpIpamExecute -method post -controller subnets -params $Params).success){
            if($Params.ContainsKey('subnet')){
                return $(get-PhpIpamAllSubnets|?{$_.subnet -eq $Params['subnet']})
            }      
        }
    }
    end{

    }
}

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
        return $(Invoke-PhpIpamExecute -method patch -controller subnets -params $Params).success
    }
    END{

    }
}
