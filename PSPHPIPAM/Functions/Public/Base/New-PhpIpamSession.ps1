function New-PhpIpamSession {
    <#
      .DESCRIPTION
       Defines global variables (PhpIpam top url,AppID,username, and password) so they do not have to be explicitly defined for subsequent calls.
       If you do not define any switches, New-PhpIpamSession will prompt you for credentials. This is best for an interactive session.

      .PARAMETER PhpIpamApiUrl
      url which phpipam use for example http://ipam/api/

      .PARAMETER UseCredAuth
      switch to use username and password (token based auth)

      .PARAMETER UseAppKeyAuth
      switch to use Appid and Appkey (encrypt request)

      .PARAMETER AppID
      the AppID of using the API.

      .PARAMETER AppKey
      AppKey for phpipam

      .PARAMETER Username
      Username for phpipam

      .PARAMETER Password
      Password for phpipam

      .EXAMPLE
        New-PhpIpamSession -userCredAuth

      .EXAMPLE
      New-PhpIpamSession -useCredAuth -phpIpamApiUrl http://ipam/api/ -username username -password password -appid script

      .EXAMPLE
      New-PhpIpamSession -useAppKeyAuth -PhpIpamApiUrl http://ipam/api/ -appid script -appkey 'de36328dbe3df0bc7d39ff2306e9aesa'

  #>
    [cmdletbinding()]
    param(

        [parameter(
            mandatory = $true,
            ParameterSetName = "UseCredAuth",
            HelpMessage = "Using name and password auth when app security is None or SSL"
        )]
        [switch]
        [Alias("CredAuth")]
        $UseCredAuth,

        [parameter(
            mandatory = $true,
            ParameterSetName = "UseCryptAuth",
            HelpMessage = "Using Appid and AppCode to crypt request when app security is Crypt"
        )]
        [switch]
        [Alias("UseCryptAuth", "CryptAuth", "UseEncryptAuth")]
        [ValidateScript( { if ($PSVersionTable.PSEdition -eq 'Core') { throw("CryptoAuth need Rijndael256, it's not implemented in powershell core") } else {$true} })]
        # for compatible , leave this parameter name not changed, it may be confusing
        $UseAppKeyAuth,

        [parameter(mandatory = $true, ParameterSetName = "UseStaticAppKeyAuth", HelpMessage = "Using Static Appid and AppCode(token) when app security is SSL with AppCode")]
        [switch]
        [Alias("SSLCodeAuth", "StaticTokenAuth")]
        $UseStaticAppKeyAuth,

        [parameter(mandatory = $true, HelpMessage = "Enter the url of PHPIpam API")]
        [validatescript( { $_.startswith("http") })]
        [string]$PhpIpamApiUrl,
        [parameter(mandatory = $true, ParameterSetName = "UseCredAuth", HelpMessage = "Enter the AppID of PhpIpam")]
        [parameter(mandatory = $true, ParameterSetName = "UseCryptAuth", HelpMessage = "Enter the AppID of PhpIpam")]
        [parameter(mandatory = $true, ParameterSetName = "UseStaticAppKeyAuth", HelpMessage = "Enter the AppID of PhpIpam")]
        [Alias("AppCode")]
        [string]$AppID,

        [parameter(mandatory = $true, ParameterSetName = "UseCryptAuth", HelpMessage = "Enter the AppKey of PhpIpam")]
        [parameter(mandatory = $true, ParameterSetName = "UseStaticAppKeyAuth", HelpMessage = "Enter the AppID of PhpIpam")]
        [validatepattern("^[\w\-_]{32}$")]
        [string]$AppKey,

        [parameter(mandatory = $true, ParameterSetName = "UseCredAuth", HelpMessage = "Enter the Username of PhpIpam.")]
        [string]$userName,

        [parameter(mandatory = $true, ParameterSetName = "UseCredAuth", HelpMessage = "Enter The password of PhpIpam.")]
        [string]$password,
        [switch]$SkipCertificateCheck

    )

    if ($PhpIpamApiUrl.EndsWith("/")) {
        $PhpIpamApiUrl = $PhpIpamApiUrl.TrimEnd("/")
    }

    if ($useCredAuth) {
        $token = "{0}:{1}" -f $username, $password
        $base64Token = [convert]::ToBase64String([char[]]$token)

        $headers = @{
            Authorization = "Basic {0}" -f $base64Token
        }
        $uri = "{0}/{1}/user/" -f $PhpIpamApiUrl, $AppID

        try {
            $r = Invoke-RestMethod -Method post -Uri $uri -Headers $headers
            if ($r -and $r.success) {
                # success
                Remove-PhpIpamSession | Out-Null
                $script:PhpIpamUsername = $username
                $script:PhpIpamPassword = $password
                $script:PhpIpamApiUrl = $PhpIpamApiUrl
                $script:PhpIpamAppID = $AppID
                $script:PhpIpamAppKey = $AppKey
                $script:PhpIpamToken = $r.data.token
                $script:PhpIpamTokenExpires = $r.data.expires
                $script:PhpIpamTokenAuth = $true
                return $true
            } else {
                Write-Error "Something error there"
                return $false
            }
        } catch {
            write-error $_.ErrorDetails.message
            return $false
        }
    }
    if ($UseStaticAppKeyAuth) {
        $headers = @{
            token = $AppKey
        }
        $uri = "{0}/{1}/sections/" -f $PhpIpamApiUrl, $AppID

        try {
            $r = Invoke-RestMethod -Method get -Uri $uri -Headers $headers
            if ($r -and $r.success) {
                # success
                Remove-PhpIpamSession | out-null
                $script:PhpIpamApiUrl = $PhpIpamApiUrl
                $script:PhpIpamAppID = $AppID
                $script:PhpIpamAppKey = $AppKey
                $script:PhpIpamToken = $AppKey
                $script:PhpIpamTokenExpires = (get-date).AddYears(100)
                $script:PhpIpamTokenAuth = $true
                $script:PhpIpamStaticToken = $true
                return $true
            } else {
                Write-Error "Something error there"
                return $false
            }
        } catch {
            write-error $_.ErrorDetails.message
            return $false
        }
    }

    if ($useAppKeyAuth) {
        # useAppKeyAuth=encrypted request
        $request_json = @{'controller' = 'sections' } | ConvertTo-Json -Compress
        $enc_request = Protect-Rijndael256ECB -Key $AppKey -Plaintext $request_json
        $Encode_Crypt_request = [System.Web.HttpUtility]::UrlEncode($enc_request)
        $uri = "{0}/?app_id={1}&enc_request={2}" -f $PhpIpamApiUrl, $AppID, $Encode_Crypt_request

        try {
            $r = Invoke-RestMethod -Method get -Uri $uri
            write-debug $r
            if ($r -and $r.success) {
                # success
                Remove-PhpIpamSession | out-null
                $script:PhpIpamApiUrl = $PhpIpamApiUrl
                $script:PhpIpamAppID = $AppID
                $script:PhpIpamAppKey = $AppKey
                return $true
            } else {
                return $false
            }

        } catch {
            write-error $_.ErrorDetails.message
            return $null
        }
    }
}


Export-ModuleMember -Function New-PhpIpamSession
