
<#
.SYNOPSIS  
    A Powershell module for using the PHPIPAM API to automate some operation
.DESCRIPTION  
    This module uses the PHPIPAM REST API to manipulate and query Objects in PHPIPAM
    It is built to work with version 1.12 and above
.NOTES  
    File Name    : PSPHPIPAM.psm1
    Author       : yoke88 yoke-msn@Hotmail.com
    Requires     : PowerShell V3
#>

# file path in linux is case sensive,make sure 
$FunctionFolder = join-path -path $PSScriptRoot -ChildPath "Functions"
if (test-path $FunctionFolder) {
    Get-ChildItem $FunctionFolder -Filter *.ps1 -Recurse -Exclude "*.Tests.ps1", "*.tests.ps1" | Select-Object -Expand FullName | ForEach-Object {
        $ScriptPath = $_
        try {
            . $ScriptPath
        }
        catch {
            Write-Error -Message "Failed to import function in $ScriptPath"
        }   
    }
}else {
    Write-Error "check path $FunctionFolder exist and whether there is a typo"
}

disable-CertsCheck

# make convertto-json depth to max 100 defaults

$Script:PSDefaultParameterValues['convertto-json:Depth'] = 100
#endregion
