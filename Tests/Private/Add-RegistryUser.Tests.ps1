Import-Module "$PSScriptRoot\..\..\FocusSISScraper.psm1" -Force


Describe 'Add-RegistryUser' {
    BeforeAll {
        New-Item "TestDrive:\Registry" -ItemType Directory -Force
    }

    BeforeEach {
            Mock Get-Date { return [datetime]"8/27/2026 12:30:00 PM" } -ModuleName "FocusSISScraper"

            $Username = "testuser"
            $CookieFile = "user_testuser.json"
            $DataFile = "user_testuser_data.json"
            $Expires = "8/27/2026 12:40:00 PM"
            $LastUsed = "8/27/2026 12:30:00 PM"
            $ExportPath = "TestDrive:\Registry"
    }

    Context 'Export non-existing user data to registry' {
        BeforeEach {
            Mock Get-UserRegistry { return @{} } -ModuleName "FocusSISScraper"
            Mock Out-File { return $null } -ModuleName "FocusSISScraper"

            Add-RegistryUser `
                -Username $Username `
                -CookiesFile $CookieFile `
                -DataFile $DataFile `
                -Expires $Expires `
                -LastUsed $LastUsed `
                -ExportPath $ExportPath
        }

        It 'Should add the correct user data to the registry' {
            Should -Invoke Out-File -ParameterFilter {
                $FilePath -eq "TestDrive:\Registry\user_registry.json"
                $InputObject -eq @{
                    testuser = @{
                        CookiesFile = "user_testuser.json"
                        DataFile    = "user_testuser_data.json"
                        Expires     = "8/27/2026 12:40:00 PM"
                        LastUsed    = "8/27/2026 12:30:00 PM"
                    }
                }
            } -ModuleName "FocusSISScraper"
        }
    }

    Context 'Export existing user data to registry' {
        BeforeEach {
            Mock Get-UserRegistry { return @{ "testuser" = @{ "LastUsed" = "8/27/2026 11:40:49 AM"; "Expires" = "8/27/2026 12:00:49 PM" } } } -ModuleName "FocusSISScraper"

            Add-RegistryUser `
                -Username $Username `
                -CookiesFile $CookieFile `
                -DataFile $DataFile `
                -Expires $Expires `
                -LastUsed $LastUsed `
                -ExportPath $ExportPath
        }

        It 'Should update the existing user data in the registry' {
            # Assert
            (Get-Content "TestDrive:\Registry\user_registry.json").Trim() | Should -Be @(
                '{', 
                    '"testuser": {', 
                        '"CookiesFile": "user_testuser.json",',
                        '"DataFile": "user_testuser_data.json",',
                        '"Expires": "2026-08-27T12:40:00",',
                        '"LastUsed": "2026-08-27T12:30:00"'
                    '}', 
                '}'
            )
        }
    }
}