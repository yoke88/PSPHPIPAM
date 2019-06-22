$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here\$sut"

Describe "Convert-IdentifiersArrayToHashTable" {
    It "Convert-IdentifiersArrayToHashTable function test" {
        $h=Convert-IdentifiersArrayToHashTable -Identifiers @('subnets',1)
        ($h|convertto-json)|Should -be (@{id='subnets';id2=1}|ConvertTo-Json)
        $h |should -BeOfType [Hashtable]
    }
}
