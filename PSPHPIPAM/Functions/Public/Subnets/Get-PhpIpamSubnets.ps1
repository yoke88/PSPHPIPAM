function Get-PhpIpamSubnets{
    [cmdletbinding()]
    param(
        
    )
    Invoke-PhpIpamExecute -method get -controller subnets
}
new-alias -Name Get-PhpIpamAllSubnets -Value Get-PhpIpamSubnets
Export-ModuleMember -Function Get-PhpIpamSubnets -Alias Get-PhpIpamAllSubnets
