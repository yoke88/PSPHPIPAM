function Get-PhpIpamSubnets{
    [cmdletbinding()]
    param(
        
    )
    Get-PhpIpamSections|Get-PhpIpamSubnetsBySectionID
}
new-alias -Name Get-PhpIpamAllSubnets -Value Get-PhpIpamSubnets
Export-ModuleMember -Function Get-PhpIpamSubnets -Alias Get-PhpIpamAllSubnets
