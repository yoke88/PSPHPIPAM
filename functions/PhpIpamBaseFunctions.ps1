
function Protect-Rijndael256ECB {
    param(
        [string]$Key,
        [string]$Plaintext
    )

    $RijndaelProvider = New-Object -TypeName System.Security.Cryptography.RijndaelManaged

    # Set block size to 256 to imitate MCRYPT_RIJNDAEL_256
    $RijndaelProvider.BlockSize = 256
    # Make sure we use ECB mode, or the generated IV will fuck up the first block upon decryption
    $RijndaelProvider.Mode      = [System.Security.Cryptography.CipherMode]::ECB
    $RijndaelProvider.Padding = [system.security.cryptography.PaddingMode]::Zeros;
    $RijndaelProvider.IV=[byte[]]@(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 )
    $RijndaelProvider.Key       = [system.Text.Encoding]::Default.GetBytes($key)

    # This object will take care of the actual cryptographic transformation
    $Encryptor = $RijndaelProvider.CreateEncryptor($RijndaelProvider.Key,$RijndaelProvider.IV)

    # Set up a memorystream that we can write encrypted data back to
    $EncMemoryStream = New-Object System.IO.MemoryStream
    $EncCryptoStream = New-Object System.Security.Cryptography.CryptoStream -ArgumentList $EncMemoryStream,$Encryptor,"Write"
    $EncStreamWriter = New-Object System.IO.StreamWriter -ArgumentList $EncCryptoStream

    # When we write data back to the CryptoStream, it'll get encrypted and written back to the MemoryStream
    $EncStreamWriter.Write($Plaintext)

    # Close the writer
    $EncStreamWriter.Close()
    # Close the CryptoStream (pads and flushes any data still left in the buffer)
    $EncCryptoStream.Close()
    $EncMemoryStream.Close()

    # Read the encrypted message from the memory stream
    $Cipher     = $EncMemoryStream.ToArray() -as [byte[]]
    $CipherText = [convert]::ToBase64String($Cipher)

    # return base64 encoded encrypted string
    return $CipherText
}

function UnProtect-Rijndael256ECB {
    param(
        [STRING]$Key,
        [string]$CipherText
    )

    $RijndaelProvider = New-Object -TypeName System.Security.Cryptography.RijndaelManaged

    $RijndaelProvider.BlockSize = 256
    $RijndaelProvider.Mode      = [System.Security.Cryptography.CipherMode]::ECB
    $RijndaelProvider.Key       = [system.Text.Encoding]::default.GetBytes($key)
    $RijndaelProvider.Padding = [system.security.cryptography.PaddingMode]::Zeros;
    $RijndaelProvider.IV=[byte[]]@(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 )
    $Decryptor = $RijndaelProvider.CreateDecryptor($RijndaelProvider.Key,$RijndaelProvider.IV)

    # Reverse process: Base64Decode first, then populate memory stream with ciphertext and lastly read decrypted data through cryptostream
    $Cipher = [convert]::FromBase64String($CipherText) -as [byte[]]

    $DecMemoryStream = New-Object System.IO.MemoryStream -ArgumentList @(,$Cipher)
    $DecCryptoStream = New-Object System.Security.Cryptography.CryptoStream -ArgumentList $DecMemoryStream,$Decryptor,$([System.Security.Cryptography.CryptoStreamMode]::Read)
    $DecStreamWriter = New-Object System.IO.StreamReader -ArgumentList $DecCryptoStream

    $NewPlainText = $DecStreamWriter.ReadToEnd()

    $DecStreamWriter.Close()
    $DecCryptoStream.Close()
    $DecMemoryStream.Close()

    return $NewPlainText
}

function Invoke-PhpIpamExecute{

   <#
     .DESCRIPTION
      invoke-PhpIpamExecute using stored vars to invoke PhpIpamApi, if you can using username and password token based auth ,or you can use
      Appid and AppKey based Encrypt request.

      .PARAMETER $method
      Http Method you want use ("get","put","options","patch","post","delete")

      .PARAMETER $AppKey
      AppKey for phpipam

      .PARAMETER $controller
      Api Endpoint you want use ,which can be one of such set
      ("sections","subnets","folders","addresses","vlans","l2domains","vfr","tools","prefix")

      .PARAMETER $identifiers
      Array to idenfify a resource
      if the api url is  /api/my_app/sections/{id}/subnets/, the identifiers array will be @(4,'subnets'), 4 is the section which id is 4

      .PARAMETR $params
      Hashtable to specify the query string. if the api url you want query is  /api/my_app/sections/ and then you specify @{id=1} as $params
      the result with return just one section which id is 1.

      .PARAMETER $headers
      you can specify you own headers here.

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
  [CmdletBinding()]
   param(
        [parameter(mandatory=$true,HelpMessage="Enter the API method")]
        [validateSet("get","put","options","patch","post","delete")]
        [string]$method,

        [parameter(mandatory=$true,HelpMessage="Enter the controller (API Endpoint)")]
        [validateSet("sections","subnets","folders","addresses","vlans","l2domains","vfr","tools","prefix")]
        [alias('Endpoint')]
        [string]$controller,

        [parameter(mandatory=$false,HelpMessage="Enter the identifiers array")]
        $identifiers=@(),

        [parameter(mandatory=$false,HelpMessage="Enter the params hashtable")]
        [validateScript({$_ -is [system.collections.hashtable]})]
        $params=@{},

        [validateScript({$_ -is [system.collections.hashtable]})]
        $headers=@{},

        [Parameter(Mandatory=$false)]$ContentType=$null

    )
     # Init Uri
        $uri=""
        # lowercase controller
        $controller=$controller.ToLower()
        if($global:phpipamTokenAuth){
            $ipamstatus=test-PhpIpamToken
            if($ipamstatus -eq 'Expired'){
                expand-PhpIpamTokenLife -force
            }

            # get token status again
            $ipamstatus=test-PhpIpamToken

            # build uri which using token auth
            if($ipamstatus -eq 'valid'){
               $uri=$((@($Global:PhpipamAppID,$controller)+$identifiers) -join "/") +"/"
               $uri=$Global:PhpipamApiUrl +"/" +$uri.Replace("//","/")
            }

            if($ipamstatus -eq 'notoken'){
                Write-Error 'No Token can be used,please use new-PhpIpamSession command first to get token'
                return $null
            }

            # build headers
            if(!$headers -or $headers.count -eq 0){
                $headers=@{
                    token=$global:phpipamToken
                }
            }elseif($headers -and $headers.count -gt 1){
                if(!$headers.Contains("token")){
                    $headers.Add("token",$global:phpipamToken)
                }
            }

            try{
                $r=Invoke-RestMethod -Method $method -Headers $headers  -Uri $uri -Body $params -ContentType $ContentType
                if($r -and $r.success){
                    return $r
                }
            }catch{
                Write-Error $_.ErrorDetails.message
                return $null
            }
        }

         if($global:phpipamTokenAuth -eq $false){
            # check whether Global AppID and APPkey exist
            if($Global:PhpipamAppID -and $Global:PhpipamAppKey){
                # start to build uri
                $query_hash=$null
                if($identifiers -and $identifiers.count -gt 0){
                    $query_hash=convert-identifiersArrayToHashTable $identifiers
                    $query_hash=$query_hash+$params
                }else{
                    $query_hash=@{}+$params
                }
                $query_hash.Add("controller",$controller)
                $json_request=$query_hash|ConvertTo-Json -Compress 
                $crypt_request=Protect-Rijndael256ECB -Key $Global:PhpipamAppKey -Plaintext $json_request
                $Encode_Crypt_request=[System.Web.HttpUtility]::UrlEncode($crypt_request)
                $uri="{0}/?app_id={1}&enc_request={2}" -f $Global:PhpipamApiUrl,$Global:PhpipamAppID,$Encode_Crypt_request

                # no need to build header
               try{
                    $r=Invoke-RestMethod -Method $method -Headers $headers  -Uri $uri -ContentType $ContentType
                    if($r -and $r.success){
                        return $r
                    }
               }catch{
                    Write-Error $_.ErrorDetails.message
                    return $false
               }

            }else{
                Write-Error "No AppID and AppKey can be used,please use new-PhpIpamSession command first to check and store AppID and AppKey"
                return $false
            }
         }
         if($global:phpipamTokenAuth -eq $null){
                Write-Error "No Auth Method exist,please use new-PhpIpamSession command first to specify auth method and infos"
                return $false
         }
}

function Remove-PhpIpamSession{

  <#
     .DESCRIPTION
      Clears the globally set credentials. Use at the end of a session or automation script. Takes no args. 

      .EXAMPLE
      Remove-phpipamSession
  #>

  $global:PhpIpamUsername =$null
  $global:PhpIpamPassword =$null
  $global:PhpIpamApiUrl =$null
  $global:PhpIpamAppID=$null
  $global:PhpIpamAppKey=$null
  $global:PhpIpamToken=$null
  $global:PhpIpamTokenExpires=$null
  $global:PhpIpamTokenAuth=$null

  return $true
}

function New-PhpIpamSession{

   <#
     .DESCRIPTION
      Defines global variables (PhpIpam top url,AppID,username, and password) so they do not have to be explicitly defined for subsequent calls.
      If you do not define any switches, New-PhpIpamSession will prompt you for credentials. This is best for an interactive session.


      .PARAMETER $PhpIpamApiUrl
      url which phpipam use for example http://ipam/api/

      .PARAMETER $UseCredAuth
      switch to use username and password (token based auth)

      .PARAMETER UseAppKeyAuth
      switch to use Appid and Appkey (encrypt request)

      .PARAMETER $AppID
      the AppID of using the API.

      .PARAMETER $AppKey
      AppKey for phpipam

      .PARAMETER $Username
      Username for phpipam

      .PARAMETER $Password
      Password for phpipam

      .EXAMPLE
      New-PhpIpamSession -userCredAuth 

      .EXAMPLE
      New-PhpIpamSession -useCredAuth -phpIpamApiUrl http://ipam/api/ -username username -password password -appid script

      .EXAMPLE
      New-PhpIpamSession -useAppKeyAuth -PhpIpamApiUrl http://ipam/api/ -appid script -appkey 'de36328dbe3df0bc7d39ff2306e9aesa'

  #>
        param(

        [parameter(mandatory=$true,ParameterSetName="UseCredAuth",HelpMessage="switch to using name and password auth")]
        [switch]
        $useCredAuth,

        [parameter(mandatory=$true,ParameterSetName="UseAppKeyAuth",HelpMessage="switch to using AppID and AppKey auth")]
        [switch]
        $useAppKeyAuth,

        [parameter(mandatory=$true, HelpMessage="Enter the Api Url of IppIpam")]
        [validatescript({$_.startswith("http")})]
        [string]$PhpIpamApiUrl,

        [parameter(mandatory=$true,ParameterSetName="UseCredAuth", HelpMessage="Enter the AppID of PhpIpam")]
        [parameter(mandatory=$true,ParameterSetName="UseAppKeyAuth", HelpMessage="Enter the AppID of PhpIpam")]
        [string]$AppID,

        [parameter(mandatory=$true,ParameterSetName="UseAppKeyAuth", HelpMessage="Enter the AppKey of PhpIpam")]
        [validatepattern("^[0-9a-fA-f]{32}$")]
        [string]$AppKey,

        [parameter(mandatory=$true,ParameterSetName="UseCredAuth", HelpMessage="Enter the Username of PhpIpam.")]
        [string]$userName,

        [parameter(mandatory=$true,ParameterSetName="UseCredAuth", HelpMessage="Enter The password of PhpIpam.")]
        [string]$password

        )
        if($useCredAuth){
            $token="{0}:{1}" -f $username,$password
            $base64Token=[convert]::ToBase64String([char[]]$token)

            $headers=@{
                        Authorization="Basic {0}" -f $base64Token
            }
            if($PhpIpamApiUrl.EndsWith("/")){
                $PhpIpamApiUrl=$PhpIpamApiUrl.TrimEnd("/")
            }

            $uri="{0}/{1}/user/" -f $PhpIpamApiUrl,$AppID

            try{
                $r=Invoke-RestMethod -Method post -Uri $uri -Headers $headers
                if($r -and $r.success){
                # success

                    $global:PhpIpamUsername =$username
                    $global:PhpIpamPassword =$password
                    $global:PhpIpamApiUrl =$PhpIpamApiUrl
                    $global:PhpIpamAppID=$AppID
                    $global:PhpIpamToken=$r.data.token
                    $global:PhpIpamTokenExpires=$r.data.expires
                    $global:PhpIpamTokenAuth=$true
                    return $true
                }else{
                    Write-Error "Something error there"
                    return $false
                }
            }catch{
                write-error $_.ErrorDetails.message
                return $false
            }
        }

        if($useAppKeyAuth){
            $request_json=@{'controller'='sections'}|ConvertTo-Json -Compress
            $enc_request=Protect-Rijndael256ECB -Key $AppKey -Plaintext $request_json
            $Encode_Crypt_request=[System.Web.HttpUtility]::UrlEncode($enc_request)
            $uri="{0}/?app_id={1}&enc_request={2}" -f $PhpIpamApiUrl,$AppID,$Encode_Crypt_request
            
            try{
                $r=Invoke-RestMethod -Method get -Uri $uri 
                if($r -and $r.success){
                # success
                    $global:PhpIpamApiUrl =$PhpIpamApiUrl
                    $global:PhpIpamAppID=$AppID
                    $global:PhpIpamAppKey=$AppKey
                    $global:PhpIpamTokenAuth=$false
                    return $true
                }else{
                    Write-Error "Somthing error there"
                    return $false
                }
            }catch{
                write-error $_.ErrorDetails.message
                return $false
            }
        }
}  

function Test-PhpIpamToken{
    <#
         .DESCRIPTION
         after you succefully called new-phpipamSession ,the global param was set. then test-phpipam use the saved params to test whether token is expired.

         .Example
         test-PhpIpamToken
    #>

    if($global:PhpIpamTokenExpires){
        if($global:PhpIpamTokenExpires -lt $(get-date)){
            return "Expired"
        }else{
            return "Valid"
        }
    }else{
        return "NoToken"
    }
}

function Expand-PhpIpamTokenLife{
param(
    [switch]$force
)
    if(!$force){
        $TokenStatus=test-PhpIpamToken
        if($Tokenstatus -eq "Valid"){
            $r=invoke-PHPIpamExecute -method patch -controller user -useCredAuth
            if($r){
                $global:PhpIpamTokenExpires=$r.data.expired
                return $r.data.expired
            }
        }
    }
    if($TokenStatus -eq "Expired" -or $force){
        if(New-PhpIpamSession -useCredAuth -PhpIpamApiUrl $global:PhpIpamApiUrl -AppID $Global:PhpIpamAppID -userName $global:PhpIpamUsername -password $global:PhpIpamPassword){
            return $global:PhpIpamTokenExpires
        }
    }
}

function Convert-IdentifiersArrayToHashTable{
    param(
        [parameter(Mandatory=$true)]
        [AllowEmptyCollection()]
        [object[]]
        $Identifiers
      )
    $output=@{}
    For($i=0;$i -lt $Identifiers.Count;$i++){
        if($i -eq 0){
            $output.Add("id",$Identifiers[$i])
        }else{
            $output.add("id$($i)",$Identifiers[$i])
        }
    }
    return $output
   }