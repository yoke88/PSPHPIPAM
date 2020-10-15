function Get-PhpIpamTags{
    [cmdletbinding()]
    param(

    )
    $r=Invoke-PhpIpamExecute -method get -controller addresses -identifiers tags
    Resolve-PhpIpamExecuteResult -result $r
}

New-Alias -Name Get-PhpIpamAllTags -Value Get-PhpIpamTags
Export-ModuleMember -Function Get-PhpIpamTags -Alias Get-PhpIpamAllTags
