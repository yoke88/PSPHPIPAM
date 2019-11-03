<#
.SYNOPSIS
    Get PhpIpam Section by section name or section id
.DESCRIPTION
    Get PhpIpam Section by section name or section id
.EXAMPLE
    PS C:\> New-PhpIpamSection -Param @{"name"="section2"}

    id               : 8
    name             : section2
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

    # get section by section name
    PS C:\> get-PhpIpamSection section2

    # get section by section id
    PS C:\> get-PhpIpamSection 8

    # specify -id to using explicitly ById ParameterSet
    PS C:\> get-PhpIpamSection -id 8

    # specify -name to using explicitly ByName ParameterSet
    PS C:\> get-PhpIpamSection -name section2

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
function Get-PhpIpamSection {
    [cmdletbinding()]
    Param(
        [parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            position = 0,
            ParameterSetName = "ByName"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            position = 0,
            ParameterSetName = "ByID"
        )]
        [ValidateNotNullOrEmpty()]
        [int]$ID
    )

    begin {

    }
    process {
        if ($PSCmdlet.ParameterSetName -eq 'ByName') {
            $r=Invoke-PhpIpamExecute -method get -controller sections -identifiers @($name)
        }
        if ($PSCmdlet.ParameterSetName -eq 'ByID') {
            $r=Invoke-PhpIpamExecute -method get -controller sections -identifiers @($ID)
        }
        Resolve-PhpIpamExecuteResult -result $r
    }

    end {

    }
}

New-Alias -Name Get-PhpIpamSectionByName -Value Get-PhpIpamSection
new-alias -Name Get-PhpIpamSectionByID -Value Get-PhpIpamSection
Export-ModuleMember  -function  Get-PhpIpamSection -alias "Get-PhpIpamSectionByName", "Get-PhpIpamSectionByID"
