$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

$sep=[System.IO.Path]::DirectorySeparatorChar
$ModuleFileFolder=$here -replace '$($sep)Tests$($sep)',"$($sep)$ModuleName$($sep)"

. "$ModuleFileFolder\$sut"
$i=0
$top_folder=$here
do{
    if(test-path "$top_folder\phpipam_env_vars.ps1"){
        . "$top_folder\phpipam_env_vars.ps1"
        break
    }else{
        $i++
        $top_folder=join-path $top_folder ".."
    }
}until($i -gt 10)

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
