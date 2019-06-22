#TODO Every Public Function should using cmdletbinding()
Context "Module Baseline" -tag "PROJECT"{
    $ModuleName = "PSPHPIPAM"
    if (Get-Module $ModuleName -ErrorAction SilentlyContinue) {
        Remove-Module $ModuleName -Force
    }

    Describe 'Module Validation' {
        It "Module manifest is valid" {
            {
                Test-ModuleManifest -Path "$PSScriptRoot\..\$($ModuleName).psd1" -ErrorAction stop -WarningAction SilentlyContinue
            } | should -not -Throw
        }
        It "Module can import" {
            {
                Import-Module -Name "$PSScriptRoot\..\$($ModuleName).psm1" -ErrorAction stop -WarningAction SilentlyContinue
            } | Should -not -Throw
        }
    }

    $commandsInModule = Get-Command -Module $ModuleName | Where-Object {
        $_.CommandType -ne 'Alias' -and
        $_.Verb -notin  @('get','search') -and
        $_.name -notin  @('set-idear')

    }
    foreach ($command in $commandsInModule) {
        Context "Command $($command.name)"  {
            It "Command $($command.name) should use CmdletBinding" {
                $command.cmdletbinding | Should -be $true
            }

            It "Command $($command.name) should have examples and description included" {
                $help = Get-help -Name $command -Full
                $help.description | should -Not -BeNullOrEmpty
                $help.examples | should -not -BeNullOrEmpty
            }
        }
    }
}
