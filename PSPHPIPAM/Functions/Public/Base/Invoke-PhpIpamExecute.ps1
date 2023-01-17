function Invoke-PhpIpamExecute {
    <#
     .DESCRIPTION
        invoke-PhpIpamExecute using stored vars to invoke PhpIpamApi, if you can using username and password token based auth ,or you can use
        Appid and AppKey based Encrypt request.

      .PARAMETER Method
      Http Method you want use ("get","put","options","patch","post","delete")

      .PARAMETER AppKey
      AppKey for phpipam

      .PARAMETER Controller
      Api Endpoint you want use ,which can be one of such set
      ("sections","subnets","folders","addresses","vlans","l2domains","vfr","tools","prefix","Circuits")

      .PARAMETER Identifiers
      Array to idenfify a resource
      if the api url is  /api/my_app/sections/{id}/subnets/, the identifiers array will be @(4,'subnets'), 4 is the section which id is 4

      .PARAMETER Params
      Hashtable to specify the query string. if the api url you want query is  /api/my_app/sections/ and then you specify @{id=1} as $params
      the result with return just one section which id is 1.

      .PARAMETER Headers
      you can specify you own headers here.

      .PARAMETER ContentType
      specify your contenType

      .EXAMPLE
      invoke-PHPIpamExecute -method get  -controller sections

      .EXAMPLE
      /api/my_app/sections/
      invoke-PHPIpamExecute -method get   -controller sections

      .EXAMPLE
      /api/my_app/sections/?id=4
      invoke-PHPIpamExecute -method get  -controller sections -params @{id=10}

      .EXAMPLE
      /api/my_app/sections/4
      invoke-PHPIpamExecute -method get  -controller sections -identifiers @(4)

  #>
    [cmdletbinding()]
    param(
        [parameter(mandatory = $true, HelpMessage = "Enter the API method")]
        [validateSet("get", "put", "options", "patch", "post", "delete")]
        [string]$method = "get",

        [parameter(mandatory = $true, HelpMessage = "Enter the controller (API Endpoint)")]
        [validateSet("sections", "subnets", "folders", "addresses", "vlans", "vlan", "l2domains", "vrf", "tools", "prefix", "user","devices")]
        [alias('Endpoint')]
        [string]$controller = "sections",

        [parameter(mandatory = $false, HelpMessage = "Enter the identifiers array")]
        [array]$identifiers = @(),

        [parameter(mandatory = $false, HelpMessage = "Enter the params hashtable")]
        [validateScript( { $_ -is [hashtable] -or $_ -is [psCustomObject] })]
        $params = @{ },

        [validateScript( { $_ -is [hashtable] })]
        $headers = @{ },

        [parameter(mandatory = $false)]
        $ContentType = $null

    )

    if (!$script:PhpIpamToken -and !$script:PhpipamAppID -and !$script:PhpipamAppKey) {
        throw "No Auth Method exist,please use new-PhpIpamSession command first to specify auth method and infos"
    }
    # Init Uri
    $uri = ""

    # lowercase controller
    $controller = $controller.ToLower()
    if ($params -is [psCustomObject]) {
        $params = $params | ConvertTo-HashtableFromPsCustomObject
    }

    if ($script:phpipamTokenAuth) {
        Write-Debug "Using TokenAuth,Test Token Status"
        write-debug "IsStaticToken=$(if($script:PhpIpamStaticToken){$script:PhpIpamStaticToken}else{"False"})"
        $ipamstatus = test-PhpIpamToken
        if ($ipamstatus -eq 'Expired') {
            Write-Debug "Token status is Expired"
            expand-PhpIpamTokenLife -force
        }

        # get token status again
        $ipamstatus = test-PhpIpamToken

        # build uri which using token auth
        if ($ipamstatus -eq 'valid') {
            $uri = $((@($script:PhpipamAppID, $controller) + $identifiers) -join "/") + "/"
            $uri = $script:PhpipamApiUrl + "/" + $uri.Replace("//", "/")
        }

        if ($ipamstatus -eq 'notoken') {
            throw 'No Token can be used,please use new-PhpIpamSession command first to get token'
        }

        # build headers
        if (!$headers -or $headers.count -eq 0) {
            $headers = @{
                token = $script:phpipamToken
            }
        } elseif ($headers -and $headers.count -gt 1) {
            if (!$headers.Contains("token")) {
                $headers.Add("token", $script:phpipamToken)
            }
        }
    }

    if (!$script:phpipamTokenAuth) {
        # Crypted Request
        if ($script:PhpipamAppID -and $script:PhpipamAppKey) {
            # start to build uri
            $query_hash = $null
            if ($identifiers -and $identifiers.count -gt 0) {
                $query_hash = convert-identifiersArrayToHashTable $identifiers
                $query_hash = $query_hash + $params
            } else {
                $query_hash = @{ } + $params
            }
            $query_hash.Add("controller", $controller)
            $json_request = $query_hash | ConvertTo-Json -Compress -Depth 100
            Write-Verbose "json_request: $(convertto-json $json_request -depth 100)"
            $crypt_request = Protect-Rijndael256ECB -Key $script:PhpipamAppKey -Plaintext $json_request
            $Encode_Crypt_request = [System.Web.HttpUtility]::UrlEncode($crypt_request)

            $uri = "{0}/?app_id={1}&enc_request={2}" -f $script:PhpipamApiUrl, $script:PhpipamAppID, $Encode_Crypt_request

            # no need to build header

        } else {
            throw "No AppID and AppKey can be used,please use new-PhpIpamSession command first to check and store AppID and AppKey"
        }
    }


    try {
        write-debug "$method uri=$uri"
        write-debug "headers=$($headers|convertto-json -Depth 100)"
        write-debug "contentType=$($contenttype|ConvertTo-Json -Depth 100)"
        write-debug "body=$($params|convertto-json -Depth 100)"

        $r = Invoke-RestMethod -Method $method -Headers $headers  -Uri $uri -body $params -ContentType $ContentType
        if ($r -and $r -is [System.Management.Automation.PSCustomObject]) {
            write-debug "Func Return:`r`n$($r|convertto-json -Depth 100)"
            return $r
        } else {
            # to process unvliad json output like this
            # <div class='alert alert-danger'>Error: SQLSTATE[23000]: Integrity constraint violation: 1048 Column 'cuser' cannot be null</div>{"code":201,"success":true,"data":"Section created"}
            if ($r -and $r -is [System.String]) {
                $objmatch = ([regex]'(\{\s*"code"\s*:\s*(.+?)\s*.+?\})').Match($r)
                if ($objmatch.Success) {
                    try {
                        $r = ConvertFrom-Json -InputObject $objmatch.Groups[1].Value -ErrorAction Stop
                        write-debug "Func Return:`r`n$($r|convertto-json -Depth 100)"
                        return $r
                    } catch {
                        throw $("Can not parse the output [" + $r + ']')
                    }
                } else {
                    throw $("Can not parse the output [" + $r + ']')
                }
            }
        }
    } catch {
        try{
            # for exception caused by returns like this
            # {"code":404,"success":0,"message":"Section does not exist","time":0.0050000000000000001}
            $message=$_.ErrorDetails.message|ConvertFrom-Json -ErrorAction SilentlyContinue
            if($message){
                Write-Debug "Func Return:`r`n$($message|convertto-json -Depth 100)"
                return $message
            }

        }catch{
            throw $_.ErrorDetails.Message
        }
    }
}

Export-ModuleMember -Function Invoke-PhpIpamExecute
