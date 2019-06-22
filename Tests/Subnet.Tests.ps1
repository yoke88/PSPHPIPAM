Context "Subnets" -tag "API" {
    Import-Module "$PSScriptRoot\..\PSPHPIPAM.psm1"
    try {
        Invoke-WebRequest -Uri 'http://127.0.0.1:8080' -ErrorAction stop | out-null
    } catch {
        $script:PSDefaultParameterValues = @{
            'It:Skip' = $true
        }
    }

    context "Subnet Test Using Cred Auth" -Tag API {
        $script:subnet = $null
        It "New-PhpIpamSession using cred auth" {
            New-PhpIpamSession -useCredAuth -PhpIpamApiUrl http://127.0.0.1:8080/api -AppID script -userName admin -password password | Should -Be true
        }
        It "Get Subnets should work" {
            Get-PhpIpamSubnets | should -not -BeNullOrEmpty
        }

        It "get subnet by id should work" {
            Get-PhpIpamSubnet -id 1 | should -not  -BeNullOrEmpty
            Get-PhpIpamSubnetByID 1 | should -not -BeNullOrEmpty
            Get-PhpIpamSubnet 1 | should -not -BeNullOrEmpty
            1 | Get-PhpIpamSubnet | should -not -BeNullOrEmpty

        }

        it "Get subnet by CIDR should work" {
            Get-PhpIpamSubnet -CIDR "fd13:6d20:29dc:cf27::/64" | Should -not -BeNullOrEmpty
            Get-PhpIpamSubnet "fd13:6d20:29dc:cf27::/64" | Should -not -BeNullOrEmpty
            get-PhpIpamSubnetByCIDR "fd13:6d20:29dc:cf27::/64" | Should -not -BeNullOrEmpty
            "fd13:6d20:29dc:cf27::/64" | Get-PhpIpamSubnet | Should -not -BeNullOrEmpty
        }
        it "Create subnet should work" {
            # create subnet in ipv6 section which id=2
            Get-PhpIpamSubnet -CIDR '192.168.11.0/24'|Remove-PhpIpamSubnet|Out-Null
            $script:subnet = New-PhpIpamSubnet -Params @{sectionId=2;subnet='192.168.11.0';mask=24}
            $script:subnet | should -not  -BeNullOrEmpty
            $script:subnet.subnet | should -be "192.168.11.0"
            $script:subnet.mask|should -be 24
            $script:subnet.sectionId|should -be 2

        }

        it "Modify subnet should work" {
            $r = Update-PhpIpamSubnet -Params @{id = $script:subnet.id; description = "test" }
            $r | should -not -BeNullOrEmpty
            $r.description | should -be "test"
        }

        it "Delete subnet should work"  {
            Get-PhpIpamSubnet -CIDR "192.168.11.0/24" | Remove-PhpIpamSubnet| should -be $true
            Get-PhpIpamSubnet -ID $script:subnet.id | Should -BeNullOrEmpty
        }

        it 'Get-PhpIpamSubnetAddressesByID should work'{
            # $subnet do not equal $script:subnet
            # $subnet exists only in the scriptblock ENV
            $subnet=get-PhpIpamSubnetByCIDR "192.168.111.0/24"
            if(!$subnet){
                # create new subnet in ipv6 section(default exists)
                $subnet=New-PhpIpamSubnet -Params @{sectionId=2;subnet='192.168.111.0';mask=24}
            }
            if($subnet){
                try{
                    $ipaddress=New-PhpIpamAddress -params @{subnetId=$subnet.id;ip='192.168.111.2'} -ErrorAction SilentlyContinue
                    $ipaddress2=New-PhpIpamAddress -params @{subnetId=$subnet.id;ip='192.168.111.3'} -ErrorAction SilentlyContinue
                }catch{

                }
                $ipaddresses=Get-PhpIpamSubnetAddressesByID -ID $subnet.id
                $ipaddresses.count |Should -be 2
                ($ipaddresses.ip|Sort-Object) -join ","|Should -be '192.168.111.2,192.168.111.3'
            }
        }

        it "Get-PhpIpamSubnetFirstFreeByID should work"{
            $subnet=get-PhpIpamSubnetByCIDR "192.168.111.0/24"
            Get-PhpIpamSubnetFirstFreeByID -id $subnet.id |Should -Be '192.168.111.1'
        }

        it "Get-PhpIpamSubnetsBySectionID should work"{
            # list subnets in ipv6(id=2) section
            $sections=Get-PhpIpamSubnetsBySectionID -id 2
            $sections.Count |Should -BeGreaterOrEqual 1
            $sections.subnet -contains "192.168.111.0"|Should -be $true
        }
    }
}
