Import-Module "$PSScriptRoot\..\..\FocusSISScraper.psm1" -Force

Describe 'Get-UserRegistry' {
    Context 'Registry file exists' {
        BeforeEach {
            Mock Test-Path { return $true } -ModuleName "FocusSISScraper"
            Mock Get-Content {
                return @('{', '"testuser": {', '"CookiesFile": "user_testuser.json",', '"DataFile": "user_testuser_data.json",', '"Expires": "8/27/2026 12:00:49 PM",', '"LastUsed": "8/27/2026 11:40:49 AM"', '}', '}')
            } -ModuleName "FocusSISScraper"
            Mock New-Item { return $null } -ModuleName "FocusSISScraper"

            $ExportPath = "TestDrive:\"
            $result = Get-UserRegistry -ExportPath $ExportPath
        }

        It 'Should return the correct registry data' {
            $result | Should -BeOfType [PSCustomObject]
            $result.testuser | Should -BeOfType [PSCustomObject]
            $result.testuser.CookiesFile | Should -Be "user_testuser.json"
            $result.testuser.DataFile | Should -Be "user_testuser_data.json"
            $result.testuser.Expires | Should -Be "8/27/2026 12:00:49 PM"
            $result.testuser.LastUsed | Should -Be "8/27/2026 11:40:49 AM"
            $result.count | Should -Be 1
        }
    }

    Context 'Registry file does not exist' {
        BeforeEach {
            Mock Test-Path { return $false } -ModuleName "FocusSISScraper"
            Mock Test-Path { return $true } -ParameterFilter { $Path -eq $ExportPath } -ModuleName "FocusSISScraper"
            Mock Get-Content { return $null } -ModuleName "FocusSISScraper"
            Mock New-Item { return $null } -ModuleName "FocusSISScraper"
            $ExportPath = "TestDrive:\"

            $result = Get-UserRegistry -ExportPath $ExportPath
        }

        It 'Should return an empty hashtable' {
            $result | Should -BeOfType [HashTable]
            $result.Count | Should -Be 0
        }

        It 'Should never try to read the registry file' {
            Should -Invoke -CommandName Get-Content -Times 0 -Exactly -ModuleName "FocusSISScraper"
        }

        It 'Should create the registry file' {
            Should -Invoke -CommandName New-Item -Times 1 -Exactly -ParameterFilter { $ItemType -eq "File" } -ModuleName "FocusSISScraper"
        }
    }
}