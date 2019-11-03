function Test-PhpIpamToken {
    <#
         .DESCRIPTION
         after you succefully called new-phpipamSession ,the global param was set. then test-phpipam use the saved params to test whether token is expired.

         .Example
         test-PhpIpamToken
    #>
    [cmdletbinding()]
    param(

    )
    if (!$script:PhpIpamTokenAuth) {
        Write-Warning "Because you use encrypted request(You never get a token,Do not use this func if you using encryped request)"
        return "Valid"
    }
    else {
        if ($script:PhpIpamTokenExpires) {
            if ($script:PhpIpamTokenExpires -lt $(get-date)) {
                return "Expired"
            }
            else {
                return "Valid"
            }
        }
        else {
            return "NoToken"
        }
    }

}

Export-ModuleMember -Function Test-PhpIpamToken
