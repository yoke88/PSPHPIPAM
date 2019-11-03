function Convert-IdentifiersArrayToHashTable {
    [cmdletbinding()]
    param(
        [parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [object[]]
        $Identifiers
    )
    $output = @{ }
    For ($i = 0; $i -lt $Identifiers.Count; $i++) {
        if ($i -eq 0) {
            $output.Add("id", $Identifiers[$i])
        }
        else {
            $output.add("id$($i+1)", $Identifiers[$i])
        }
    }
    return $output
}
