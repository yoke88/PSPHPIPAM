$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here\..\functions\$sut"

Describe "Rijndael256" {

    It "Protect-Rijndael256ECB works" {
        Protect-Rijndael256ECB -Key 5f40c5ba5730bdb93ca561efe5bae433 -Plaintext 123| Should Be 'jpWPzjok9ZYCeUwXGWP4rSsKr23wQ4yS3MVt6lsa0ko='
    }

    It "unProtect-Rijndael256ECB works" {
        unProtect-Rijndael256ECB -Key 5f40c5ba5730bdb93ca561efe5bae433 -CipherText 'jpWPzjok9ZYCeUwXGWP4rSsKr23wQ4yS3MVt6lsa0ko='| Should Be 123
    }
}


Describe "PhpIpamSession" {
    context "Cred auth"{
        It "new-phpipamsession using cred auth" {
            New-PhpIpamSession -useCredAuth -PhpIpamApiUrl http://127.0.0.1/api -AppID script2 -userName admin -password password| Should Be true
        }
    
        it "Test-PhpIpamToken works"{
            Test-PhpIpamToken |should be 'Valid' 
        }
    
        it "Expand-PhpIpamTokenLife works after cred auth"{
            Expand-PhpIpamTokenLife |should Not BeNullOrEmpty
        }
        it "query all user"{
            {$script:tempresult=Invoke-PhpIpamExecute -method get -controller user -identifiers @('all')}|should Not throw
            $script:tempresult.code |should not BeNullOrEmpty
        }

        it "invoke-phpIpamExecute using method: <method> controller: <controller> identifier: <identifier>"{
            param(
                $method,
                $controller,
                $identifier

            )
            {$script:tempresult=invoke-phpIpamExecute -method $method -controller $controller -identifiers $identifier}|should Not throw
            $script:tempresult.code |should not BeNullOrEmpty
        }  -testcases @(
            @{method='Get';controller='sections';identifier=@()},
            @{method='get';controller='sections';identifier=@(1)},
            @{method='get';controller='sections';identifier=@(1,'subnets')},
            @{method='get';controller='sections';identifier=@('ipv6')},
            @{method='get';controller='sections';identifier=@('custom_fields')}, # sections has no custom_fields
            @{method='get';controller='subnets';identifier=@(1)},
            @{method='get';controller='subnets';identifier=@(1,'usage')},
            @{method='get';controller='subnets';identifier=@(1,'slaves')},
            @{method='get';controller='subnets';identifier=@(1,'slaves_recursive')},
            @{method='get';controller='subnets';identifier=@(1,'addresses')},
            @{method='get';controller='subnets';identifier=@(1,'addresses','fd13:6d20:29dc:cf27::1')}
            @{method='get';controller='subnets';identifier=@(1,'first_subnet',64)},
            @{method='get';controller='subnets';identifier=@(2,'all_subnets',24)},
            @{method='get';controller='subnets';identifier=@('custom_fields')},
            @{method='get';controller='subnets';identifier=@('cidr','10.65.22.0/24')},
            @{method='get';controller='subnets';identifier=@('search','10.65.22.0/24')},
            @{method='get';controller='addresses';identifier=@(1)},
            @{method='get';controller='addresses';identifier=@(1,'ping')},
            @{method='get';controller='addresses';identifier=@(1,1)},
            @{method='get';controller='addresses';identifier=@('search','10.65.22.1')},
            @{method='get';controller='addresses';identifier=@('search_hostname','test1')},
            @{method='get';controller='addresses';identifier=@('first_free',1)},
            @{method='get';controller='addresses';identifier=@('custom_fields')},
            @{method='get';controller='addresses';identifier=@('tags')},
            @{method='get';controller='addresses';identifier=@('tags',1)},
            @{method='get';controller='addresses';identifier=@('tags',2,'addresses')}
        )
    }
      
    context "Encryped request"{
        It "new-phpipamsession auth using encryped request" {
            New-PhpIpamSession -useAppkeyAuth -PhpIpamApiUrl http://127.0.0.1/api -AppID script -Appkey '5f40c5ba5730bdb93ca561efe5bae433'| Should Be true
        }

        it "Expand-PhpIpamTokenLife works after encryped request"{
            Expand-PhpIpamTokenLife |should  BeNullOrEmpty
        }

        it "query all user"{
            {$script:tempresult=Invoke-PhpIpamExecute -method get -controller user -identifiers @('all')}|should not  throw
            $script:tempresult.code |should not BeNullOrEmpty
        }
        
    }

}