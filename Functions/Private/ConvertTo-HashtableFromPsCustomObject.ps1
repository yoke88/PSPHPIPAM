function ConvertTo-HashtableFromPsCustomObject {
    [cmdletbinding()]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )] $inputObject
    );

    process {
        $output = @{ };
        $inputObject | Get-Member -MemberType *Property | % {
            $output.($_.name) = $inputObject.($_.name);
        }
        return $output;
    }
}
