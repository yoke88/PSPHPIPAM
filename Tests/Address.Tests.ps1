$Target = "Address"
Context "$Target" -tag "API" {
    Import-Module "$PSScriptRoot\..\PSPHPIPAM.psm1"
    try {
        Invoke-WebRequest -Uri 'http://127.0.0.1:8080' -ErrorAction stop | out-null
    } catch {
        $script:PSDefaultParameterValues = @{
            'It:Skip' = $true
        }
    }

    context "$Target Test Using Cred Auth" -Tag API {
        $script:TestTarget = $null
        It "New-PhpIpamSession using cred auth" {
            New-PhpIpamSession -useCredAuth -PhpIpamApiUrl http://127.0.0.1:8080/api -AppID script -userName admin -password password | Should -Be true
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
