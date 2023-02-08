function Get-PhpIpamSubnets{
    [cmdletbinding()]
    param(
        
    )
    $r=Invoke-PhpIpamExecute -method get -controller subnets
    Resolve-PhpIpamExecuteResult -result $r
}
new-alias -Name Get-PhpIpamAllSubnets -Value Get-PhpIpamSubnets
Export-ModuleMember -Function Get-PhpIpamSubnets -Alias Get-PhpIpamAllSubnets
