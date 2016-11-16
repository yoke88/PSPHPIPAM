function Get-PhpIpamAllSections{
    return $(Invoke-PhpIpamExecute -method get -controller sections).data
}

function Get-PhpIpamSectionsByID{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
         [int]$ID
    )

    begin{

    }
    process{
        return $(Invoke-PhpIpamExecute -method get -controller sections -identifiers @($ID)).data
    }

    end{

    }
}

function Get-PhpIpamSubnetsBySectionID{
    Param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
        [int]$ID
    )
    begin{
    }

    process{
        return $(Invoke-PhpIpamExecute -method get -controller sections -identifiers @($ID,'subnets')).data
    }

    end{

    }
}

function Get-PhpIpamSectionByName{
    
    Param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    begin{

    }
    process{
        return $(Invoke-PhpIpamExecute -method get -controller sections -identifiers @($name)).data
    }

    end{

    }
}
<#

function Get-PhpIpamSectionCustom_fields{

    return $(Invoke-PhpIpamExecute -method get -controller sections -identifiers @('custom_fields')).data
}

#>

function New-PhpIpamSection{

    [cmdletBinding()]
    Param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [validateScript({$_ -is [system.collections.hashtable]})]
        $Params=@{}
    )
    begin{

    }
    process{
        if($(Invoke-PhpIpamExecute -method post -controller sections -params $Params).success){
            if($Params.ContainsKey('name')){
                return Get-PhpIpamSectionByName -Name $Params['name']
            }      
        }
    }
    end{

    }
}

function Remove-PhpIpamSection{
    Param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [int]$ID=$null
    )
    BEGIN{

    }
    PROCESS{
        return $(Invoke-PhpIpamExecute -method delete -controller sections -params @{'id'=$id}).success
    }
    END{

    }
}


function Update-PhpIpamSection{
    [cmdletBinding()]
    param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [validatescript({$_ -is [hashtable] -or $_ -is [psCustomObject]})]
        $Params=@{}
    )
    BEGIN{

    }
    PROCESS{
        return $(Invoke-PhpIpamExecute -method patch -controller sections -params $Params).success
    }
    END{

    }
}





