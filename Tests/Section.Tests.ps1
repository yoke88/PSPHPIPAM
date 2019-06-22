Context "Sections" -tag "API" {
    Import-Module "$PSScriptRoot\..\PSPHPIPAM.psm1"
    try {
        Invoke-WebRequest -Uri 'http://127.0.0.1:8080' -ErrorAction stop | out-null
    } catch {
        $script:PSDefaultParameterValues = @{
            'It:Skip' = $true
        }
    }

    context "Section Test Using Cred Auth" -Tag API {
        $script:section=$null
        It "New-PhpIpamSession using cred auth" {
            New-PhpIpamSession -useCredAuth -PhpIpamApiUrl http://127.0.0.1:8080/api -AppID script -userName admin -password password | Should -Be true
        }
        It "Get Sections should work"{
            Get-PhpIpamSections|should -not -BeNullOrEmpty
        }

        It "get section by id should work"{
            Get-PhpIpamSectionByID -id 2 |should -not  -BeNullOrEmpty
        }

        it "Get section by name should work"{
            Get-PhpIpamSectionByName -Name "Ipv6" |should -not  -BeNullOrEmpty
        }
        it "Create section should work"{
            Remove-PhpIpamSection -Name "sectionaa"|Out-Null
            $script:section=New-PhpIpamSection -Params @{name="sectionaa"}
            $script:section|should -not  -BeNullOrEmpty
            $script:section.name |should -be "sectionaa"
        }

        it "Modify section should work"{
            $r=Update-PhpIpamSection -Params @{id=$script:section.id;description="test"}
            $r|should -be $true
            $r.description |should -be "test"
        }

        it "Delete section should work"{
            Get-PhpIpamSection -name "sectionaa"|Remove-PhpIpamSection| should -be $true
            Get-PhpIpamSection -name "sectionaa"|Should -BeNullOrEmpty
        }
    }
}
