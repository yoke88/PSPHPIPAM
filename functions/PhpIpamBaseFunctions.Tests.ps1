$here = Split-Path -Parent $MyInvocation.MyCommand.Path
write-output $here

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).tolower().Replace(".tests.", ".")
write-output $sut
. "$here\$sut"

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

        }  -testcases @() -skip
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