$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$sep=[System.IO.Path]::DirectorySeparatorChar
$ModuleFileFolder=$here -replace "$($sep)Tests$($sep)","$($sep)$ModuleName$($sep)"

. "$ModuleFileFolder\$sut"
Describe "ConvertTo-HashtableFromPsCustomObject" {
    It "ConvertTo-HashtableFromPsCustomObject function test" {
        $cusObj=ConvertTo-HashtableFromPsCustomObject ([PSCustomObject]@{a = 1; b = 2 })
        $cusObj |Should -BeOfType Hashtable
        $cusObj.a |Should -be 1
        $cusObj.b |Should -be 2
    }
}
