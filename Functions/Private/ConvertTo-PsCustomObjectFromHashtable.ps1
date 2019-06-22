function ConvertTo-PsCustomObjectFromHashtable {
    [cmdletbinding()]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )][hashtable] $hashtable
    );

    begin { $i = 0; }

    process {
        return $([PSCustomObject]$hashtable )
    }
}
