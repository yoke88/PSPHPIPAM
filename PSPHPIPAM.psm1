
<#
.SYNOPSIS  
    A Powershell module for using the PHPIPAM API to automate some operation
.DESCRIPTION  
    This module uses the PHPIPAM REST API to manipulate and query Objects in PHPIPAM
    It is built to work with version 1.12
.NOTES  
    File Name    : PSPHPIPAM.psm1
    Author       : yoke88 yoke-msn@Hotmail.com
    Requires     : PowerShell V3
#>


$ScriptPath = Split-Path $MyInvocation.MyCommand.Path


try {
    Get-ChildItem "$ScriptPath\Functions" -Filter *.ps1 -Recurse| Select-Object -Expand FullName | ForEach-Object {
        $Function = Split-Path $_ -Leaf
        . $_
    }
} catch {
    Write-Warning ("{0}: {1}" -f $Function,$_.Exception.Message)
    Continue
}

#endregion
