$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here\$sut"

if(test-path "$here\..\..\phpipam_env_vars.ps1"){
    . "$here\..\..\phpipam_env_vars.ps1"
}else{
    throw "can not found $("$here\..\..\phpipam_env_vars.ps1")"
}

Describe "Disable-CertsCheck" {
    # url with non public cert
    $exampleUrl = $PHPIPAM_HTTPS_URL
    try {
        Invoke-WebRequest $exampleUrl  -ErrorAction stop
    } catch {
        $e = $_
    }

    if ($e.Exception.HResult -eq -2147467259) {
        $isNetworkOk = $false
        $isSkip=!$isNetworkOk
    }
    It "Disable-CertsCheck should throw when using default setting" -skip:$isSkip {
        $e = { Invoke-WebRequest $exampleUrl  -ErrorAction stop } | Should -throw -PassThru
        $e.Exception.HResult | Should -BeExactly -2146233087
    }
    It "Disable-CertsCheck should not throw" -skip:$isSkip {
        {
            Disable-CertsCheck
            Invoke-WebRequest $exampleUrl -ErrorAction stop
        } | should -not -throw
    }
}
