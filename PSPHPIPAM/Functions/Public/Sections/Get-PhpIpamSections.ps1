function Get-PhpIpamSections{
    [cmdletbinding()]
    param(

    )
    $r=Invoke-PhpIpamExecute -method get -controller sections
    Resolve-PhpIpamExecuteResult -result $r
}

New-Alias -Name Get-PhpIpamAllSections -Value Get-PhpIpamSections
Export-ModuleMember -Function Get-PhpIpamSections -Alias Get-PhpIpamAllSections
