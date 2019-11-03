$Target = "Address"
$ModuleName="PSPHPIPAM"
Context "$Target" -tag "API" {
    Remove-Module $ModuleName -ErrorAction SilentlyContinue |Out-Null
    Import-Module "$PSScriptRoot\..\$ModuleName"
    if(test-path "$PSScriptRoot\..\phpipam_env_vars.ps1"){
        . "$PSScriptRoot\..\phpipam_env_vars.ps1"
    }else{
        throw "can not found $("$PSScriptRoot\..\phpipam_env_vars.ps1")"
    }

    try {
        Invoke-WebRequest -Uri $PHPIPAM_HTTP_URL -ErrorAction stop | out-null
    } catch {
        $script:PSDefaultParameterValues = @{
            'It:Skip' = $true
        }
    }

    context "$Target Test Using Cred Auth (SSL with user token)" -Tag API {
        $script:TestTarget = $null
        It "New-PhpIpamSession using cred auth (SSL with user token)" {
            New-PhpIpamSession -useCredAuth -PhpIpamApiUrl "$PHPIPAM_HTTPS_URL/api" -AppID $PHPIPAM_SSL_WITH_USER_TOKERN_APPID -userName $PHPIPAM_USER_NAME -password $PHPIPAM_USER_PASS | Should -Be true
        }
        It "Get $Target should work" {
            Get-PhpIpamAddresses|remove-PhpIpamAddress|Out-Null
            $r = Get-PhpIpamAddresses
            if (!$r) {
                Get-PhpIpamSubnetByCIDR -CIDR "192.168.10.0/24" | Remove-PhpIpamSubnet | Out-Null
                Get-PhpIpamAddressByIP -IP "192.168.10.2" | Remove-PhpIpamAddress | Out-Null
                $script:subnet = New-PhpIpamSubnet -Params @{sectionId = 2; subnet = '192.168.10.0'; mask = 24 }
                $script:TestTarget = New-PhpIpamAddress -params @{subnetId = [int]$script:subnet.id; ip = '192.168.10.2' }
                (Get-PhpIpamAddresses).ip -contains "192.168.10.2" | should -Be $true
            }
        }

        It "get $Target by IP should work" {
            Get-PhpIpamAddress -IP "192.168.10.2" | should -not  -BeNullOrEmpty
        }

        it "Get $Target by ID should work" {
            Get-PhpIpamAddress -ID $script:TestTarget.id | should -not  -BeNullOrEmpty
        }
        it "Create $Target should work" {
            Get-PhpIpamAddressByIP -IP '192.168.10.3' | Remove-PhpIpamAddress | Out-Null
            $script:TestTarget = New-PhpIpamAddress -params @{
                subnetId = $script:subnet.id
                ip = '192.168.10.3'
            }
            Get-PhpIpamAddressByIP -IP '192.168.10.3' | should -not -BeNullOrEmpty
        }

        it "Modify $Target should work" {
            $r = Update-PhpIpamAddress -Params @{id = $($script:TestTarget).id; description = "test" }
            $r | should -be $true
            $r.description | should -be "test"
            $r.ip | should -be "192.168.10.3"
        }

        it "Delete $Target should work" {
            Get-PhpIpamAddress -IP "192.168.10.2" | Remove-PhpIpamAddress | should -be $true
            Get-PhpIpamAddress -ID $script:TestTarget.id | Remove-PhpIpamAddress| Should -BeTrue
            Get-PhpIpamAddresses | should -BeNullOrEmpty
        }

        ########### Custom Test ####################
    }
    context "$Target Test Using static app code (SSL with App code token)" -Tag API {
        $script:TestTarget = $null
        It "New-PhpIpamSession using static app code (SSL with app code token)" {
            New-PhpIpamSession -UseStaticAppKeyAuth -PhpIpamApiUrl "$PHPIPAM_HTTPS_URL/api" -AppID $PHPIPAM_SSL_WITH_APP_CODE_APPID -Appkey $PHPIPAM_SSL_WITH_APP_CODE_APPCODE | Should -Be true
        }
        It "Get $Target should work" {
            Get-PhpIpamAddresses|remove-PhpIpamAddress|Out-Null
            $r = Get-PhpIpamAddresses
            if (!$r) {
                Get-PhpIpamSubnetByCIDR -CIDR "192.168.10.0/24" | Remove-PhpIpamSubnet | Out-Null
                Get-PhpIpamAddressByIP -IP "192.168.10.2" | Remove-PhpIpamAddress | Out-Null
                $script:subnet = New-PhpIpamSubnet -Params @{sectionId = 2; subnet = '192.168.10.0'; mask = 24 }
                $script:TestTarget = New-PhpIpamAddress -params @{subnetId = [int]$script:subnet.id; ip = '192.168.10.2' }
                (Get-PhpIpamAddresses).ip -contains "192.168.10.2" | should -Be $true
            }
        }

        It "get $Target by IP should work" {
            Get-PhpIpamAddress -IP "192.168.10.2" | should -not  -BeNullOrEmpty
        }

        it "Get $Target by ID should work" {
            Get-PhpIpamAddress -ID $script:TestTarget.id | should -not  -BeNullOrEmpty
        }
        it "Create $Target should work" {
            Get-PhpIpamAddressByIP -IP '192.168.10.3' | Remove-PhpIpamAddress | Out-Null
            $script:TestTarget = New-PhpIpamAddress -params @{
                subnetId = $script:subnet.id
                ip = '192.168.10.3'
            }
            Get-PhpIpamAddressByIP -IP '192.168.10.3' | should -not -BeNullOrEmpty
        }

        it "Modify $Target should work" {
            $r = Update-PhpIpamAddress -Params @{id = $($script:TestTarget).id; description = "test" }
            $r | should -be $true
            $r.description | should -be "test"
            $r.ip | should -be "192.168.10.3"
        }

        it "Delete $Target should work" {
            Get-PhpIpamAddress -IP "192.168.10.2" | Remove-PhpIpamAddress | should -be $true
            Get-PhpIpamAddress -ID $script:TestTarget.id | Remove-PhpIpamAddress| Should -BeTrue
            Get-PhpIpamAddresses | should -BeNullOrEmpty
        }

        ########### Custom Test ####################
    }
    context "$Target Test Using Cred Auth (User token)" -Tag API {
        $script:TestTarget = $null
        It "New-PhpIpamSession using Cred Auth (User token)" {
            New-PhpIpamSession -useCredAuth -PhpIpamApiUrl "$PHPIPAM_HTTP_URL/api" -AppID $PHPIPAM_NOSSL_WITH_USER_TOKEN_APPID -userName $PHPIPAM_USER_NAME -password $PHPIPAM_USER_PASS | Should -Be true
        }
        It "Get $Target should work" {
            Get-PhpIpamAddresses|remove-PhpIpamAddress|Out-Null
            $r = Get-PhpIpamAddresses
            if (!$r) {
                Get-PhpIpamSubnetByCIDR -CIDR "192.168.10.0/24" | Remove-PhpIpamSubnet | Out-Null
                Get-PhpIpamAddressByIP -IP "192.168.10.2" | Remove-PhpIpamAddress | Out-Null
                $script:subnet = New-PhpIpamSubnet -Params @{sectionId = 2; subnet = '192.168.10.0'; mask = 24 }
                $script:TestTarget = New-PhpIpamAddress -params @{subnetId = [int]$script:subnet.id; ip = '192.168.10.2' }
                (Get-PhpIpamAddresses).ip -contains "192.168.10.2" | should -Be $true
            }
        }

        It "get $Target by IP should work" {
            Get-PhpIpamAddress -IP "192.168.10.2" | should -not  -BeNullOrEmpty
        }

        it "Get $Target by ID should work" {
            Get-PhpIpamAddress -ID $script:TestTarget.id | should -not  -BeNullOrEmpty
        }
        it "Create $Target should work" {
            Get-PhpIpamAddressByIP -IP '192.168.10.3' | Remove-PhpIpamAddress | Out-Null
            $script:TestTarget = New-PhpIpamAddress -params @{
                subnetId = $script:subnet.id
                ip = '192.168.10.3'
            }
            Get-PhpIpamAddressByIP -IP '192.168.10.3' | should -not -BeNullOrEmpty
        }

        it "Modify $Target should work" {
            $r = Update-PhpIpamAddress -Params @{id = $($script:TestTarget).id; description = "test" }
            $r | should -be $true
            $r.description | should -be "test"
            $r.ip | should -be "192.168.10.3"
        }

        it "Delete $Target should work" {
            Get-PhpIpamAddress -IP "192.168.10.2" | Remove-PhpIpamAddress | should -be $true
            Get-PhpIpamAddress -ID $script:TestTarget.id | Remove-PhpIpamAddress| Should -BeTrue
            Get-PhpIpamAddresses | should -BeNullOrEmpty
        }

        ########### Custom Test ####################
    }

}
