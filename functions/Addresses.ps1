function Get-PhpIpamAddressesByID{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
         [int]$ID
    )

    begin{

    }
    process{
            return $(Invoke-PhpIpamExecute -method get -controller addresses -identifiers @($ID)).data

    }

    end{

    }
}

function Get-PhpIpamAddressesByIP{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
         [string]$IP
    )

    begin{

    }
    process{
            return $(Invoke-PhpIpamExecute -method get -controller addresses -identifiers @("search",$IP)).data

    }

    end{

    }
}


function Get-PhpIpamAddresses{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0,ParameterSetName="IP")]
         [string]$IP,

         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0,ParameterSetName="ID")]
         [int]$ID
    )

    begin{

    }
    process{
            if ($PsCmdlet.ParameterSetName -eq "IP"){
                return $(Invoke-PhpIpamExecute -method get -controller addresses -identifiers @("search",$IP)).data
            }

            if($PsCmdlet.ParameterSetName -eq 'ID'){

                return $(Invoke-PhpIpamExecute -method get -controller addresses -identifiers @($ID)).data
            }

    }

    end{

    }
}

function Update-PhpIpamAddressByID{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
         [string]$ID,

         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
         $params
    )
    
    begin{

    }
    process{
            return $(Invoke-PhpIpamExecute -method patch -controller addresses -identifiers @($ID) -params $params).data

    }

    end{

    }
}

function new-phpipamAddress{
    [cmdletBinding()]
    Param(
     [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
      $params
    )

    begin{

    }
    process{
            return $(Invoke-PhpIpamExecute -method post -controller addresses  -params $params).success

    }

    end{

    }
}


function Search-PhpIpamAddressByHostname{
 #/api/my_app/addresses/search_hostname/{hostname}/
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,position=0)]
         [string]$hostname
    )
    
    begin{

    }
    process{
            return $(Invoke-PhpIpamExecute -method get -controller addresses -identifiers @("search_hostname",$hostname)).data

    }

    end{

    }
}

