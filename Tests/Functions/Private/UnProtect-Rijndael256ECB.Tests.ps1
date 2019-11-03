$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

$sep=[regex]::Escape([System.IO.Path]::DirectorySeparatorChar)
$ModuleFileFolder=$here -replace [regex]::Escape("$($sep)Tests$($sep)"),"$($sep)$($ModuleName)$($sep)"

. "$ModuleFileFolder\$sut"

if ($PSVersionTable.PSEdition -ne 'Core') {
    Describe "Rijndael256" {
        It "UnProtect-Rijndael256ECB works" {
            unProtect-Rijndael256ECB -Key 5f40c5ba5730bdb93ca561efe5bae433 -CipherText 'jpWPzjok9ZYCeUwXGWP4rSsKr23wQ4yS3MVt6lsa0ko=' | Should Be 123
        }
    }
}
