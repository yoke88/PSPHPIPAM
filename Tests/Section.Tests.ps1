$Target = "Section"
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
        $script:section=$null
        It "New-PhpIpamSession using cred auth (SSL with user token)" {
            New-PhpIpamSession -useCredAuth -PhpIpamApiUrl "$PHPIPAM_HTTPS_URL/api" -AppID $PHPIPAM_SSL_WITH_USER_TOKERN_APPID -userName $PHPIPAM_USER_NAME -password $PHPIPAM_USER_PASS | Should -Be true
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
    context "$Target Test Using static app code (SSL with App code token)" -Tag API {
        $script:section=$null
        It "New-PhpIpamSession using static app code (SSL with app code token)" {
            New-PhpIpamSession -UseStaticAppKeyAuth -PhpIpamApiUrl "$PHPIPAM_HTTPS_URL/api" -AppID $PHPIPAM_SSL_WITH_APP_CODE_APPID -Appkey $PHPIPAM_SSL_WITH_APP_CODE_APPCODE | Should -Be true
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
    context "$Target Test Using Cred Auth (User token)" -Tag API {
        $script:section=$null
        It "New-PhpIpamSession using Cred Auth (User token)" {
            New-PhpIpamSession -useCredAuth -PhpIpamApiUrl "$PHPIPAM_HTTP_URL/api" -AppID $PHPIPAM_NOSSL_WITH_USER_TOKEN_APPID -userName $PHPIPAM_USER_NAME -password $PHPIPAM_USER_PASS | Should -Be true
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
