<#
.SYNOPSIS
    Get All custom_fields of controller
.DESCRIPTION
    Get All custom_fields of controller
.EXAMPLE
    PS C:\>Get-PhpIpamCustomFields

.INPUTS
    No Inputs Need
.OUTPUTS
    Output (if any)
.NOTES

#>
function Get-PhpIpamCustomFields{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("subnets","addresses","vlans","l2domains")]
        [string[]]
        $Controllers
    )
    $Controller|ForEach-Object{
        $r=Invoke-PhpIpamExecute -method get -controller $_ -identifiers @('custom_fields')
        Resolve-PhpIpamExecuteResult -result $r
    }

}

New-Alias  -name 'Get-PhpIpamCustom_Fields' -Value Get-PhpIpamCustomFields
Export-ModuleMember -Function Get-PhpIpamCustomFields -Alias Get-PhpIpamCustom_Fields
