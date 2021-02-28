<#
.SYNOPSIS
    Update address
.DESCRIPTION
    Update address 
.EXAMPLE
    PS /> $IP=Get-PhpIpamAddress -IP 192.168.10.2
    PS /> Update-PhpIpamAddress -params @{id=$IP.id;hostname="testhost"}
    PS /> Get-PhpIpamAddresses -IP 192.168.10.2

.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Update-PhpIpamAddress{
    [cmdletBinding()]
    Param(
         [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
         [ValidateScript({ 
            if($_ -is [hashtable]){ 
                if($_.ContainsKey("id")){
                $True}
            }elseif($_ -is [psCustomObject]){
                 if($_.id){
                 $True}}
             else{Throw "$_ contains no valid ID"}
            })]
         $params
    )

    begin{

    }
    process{
        $r=Invoke-PhpIpamExecute -method patch -controller addresses -identifiers @($params.id) -params $params
        if($r -and $r.success){
         return Get-PhpIpamAddress -ID $params.id
        }
    }

    end{

    }
}

New-Alias -Name Update-PhpIpamAddressByID -Value Update-PhpIpamAddress
Export-ModuleMember -Function Update-PhpIpamAddress -Alias Update-PhpIpamAddressByID

