function Get-PhpIpamAllSections{
    
    return $(Invoke-PhpIpamExecute -method get -controller sections).data
}

function Get-PhpIpamSectionsByID{

    Param(
         [parameter(Mandatory=$true)]
         [int]$ID
    )
    
    return $(Invoke-PhpIpamExecute -method get -controller sections -identifiers @($ID)).data
}

function Get-PhpIpamSubnetsBySectionID{
    Param(
        [parameter(Mandatory=$true)]
        [int]$ID
    )

    return $(Invoke-PhpIpamExecute -method get -controller sections -identifiers @($ID,'subnets')).data
}

function Get-PhpIpamSectionByName{
    
    Param(
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    return $(Invoke-PhpIpamExecute -method get -controller sections -identifiers @($name)).data
}
<#

function Get-PhpIpamSectionCustom_fields{

    return $(Invoke-PhpIpamExecute -method get -controller sections -identifiers @('custom_fields')).data
}

#>

function New-PhpIpamSection{
    Param(
        [parameter(Mandatory=$true)]
        [validateScript({$_ -is [system.collections.hashtable]})]
        $Params=@{}
    )
    Invoke-PhpIpamExecute -method post -controller sections -params $Params
}

function Remove-PhpIpamSection{


}

function Update-PhpIpamSection{


}


