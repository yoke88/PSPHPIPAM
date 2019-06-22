<#
.SYNOPSIS
    Create PhpIpamSection
.DESCRIPTION
    Create PhpIpamSection
.EXAMPLE
    # Create an section and get section info using pipeline
    PS C:\> New-PhpIpamSection -Param @{"name"="section3"}|get-PhpIpamSection

    id               : 10
    name             : section3
    description      :
    masterSection    : 0
    permissions      :
    strictMode       : 1
    subnetOrdering   :
    order            :
    editDate         :
    showVLAN         : 0
    showVRF          : 0
    showSupernetOnly : 0
    DNS              :
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
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
                Get-PhpIpamSectionByName -Name $Params['name']
            }
        }
    }
    end{

    }
}

Export-ModuleMember -Function New-PhpIpamSection
