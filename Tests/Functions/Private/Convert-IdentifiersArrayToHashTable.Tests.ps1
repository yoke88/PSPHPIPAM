$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$ModuleName="PSPHPIPAM"
$sep=[System.IO.Path]::DirectorySeparatorChar
$ModuleFileFolder=$here -replace '$($sep)Tests$($sep)',"$($sep)$ModuleName$($sep)"

. "$ModuleFileFolder\$sut"

Describe "Convert-IdentifiersArrayToHashTable" {
    It "Convert-IdentifiersArrayToHashTable function test" {
        $h=Convert-IdentifiersArrayToHashTable -Identifiers @('subnets',1)
        ($h|convertto-json)|Should -be (@{id='subnets';id2=1}|ConvertTo-Json)
        $h |should -BeOfType [Hashtable]
    }
}
