Import-Module "$PSScriptRoot\..\..\FocusSISScraper.psm1" -Force

Describe 'Test-Expiration' {
    Context 'User session has expired' {
        BeforeEach {
            Mock Get-UserRegistry { return @{ "testuser" = @{ "LastUsed" = "8/27/2026 11:40:49 AM"; "Expires" = "8/27/2026 12:00:49 PM" } } } -ModuleName "FocusSISScraper"
            Mock Get-Date { return [datetime]"8/27/2026 12:30:00 PM" } -ModuleName "FocusSISScraper"

            $result = Test-Expiration -Username "testuser"
        }

        It 'Should return true for expired session' {
            $result | Should -Be $true
        }
    }

    Context 'User session has not expired' {
        BeforeEach {
            Mock Get-UserRegistry { return @{ "testuser" = @{ "LastUsed" = "8/27/2026 11:40:49 AM"; "Expires" = "8/27/2026 12:00:49 PM" } } } -ModuleName "FocusSISScraper"
            Mock Get-Date { return [datetime]"8/27/2026 11:30:00 AM" } -ModuleName "FocusSISScraper"

            $result = Test-Expiration -Username "testuser"
        }

        It 'Should return false for non-expired session' {
            $result | Should -Be $false
        }
    }
}