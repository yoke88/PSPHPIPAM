<#
    .DESCRIPTION
    Clean saved PhpIpamSession variables which contains apiId and apiTokens

    .EXAMPLE
    Remove-phpipamSession
#>
function Remove-PhpIpamSession {
    [cmdletbinding()]
    param(

    )
    $script:PhpIpamUsername = $null
    $script:PhpIpamPassword = $null
    $script:PhpIpamApiUrl = $null
    $script:PhpIpamAppID = $null
    $script:PhpIpamAppKey = $null
    $script:PhpIpamToken = $null
    $script:PhpIpamTokenExpires = $null
    $script:PhpIpamTokenAuth = $null
    $script:PhpIpamStaticToken = $null

    return $true
}

Export-ModuleMember -Function Remove-phpipamSession
