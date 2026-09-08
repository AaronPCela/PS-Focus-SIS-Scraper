Import-Module "$PSScriptRoot\..\..\FocusSISScraper.psm1" -Force

Describe 'Save-Cookies' {
    BeforeEach {
        Mock Add-RegistryUser { return $null } -ModuleName "FocusSISScraper"
        Mock New-Item { return $null } -ModuleName "FocusSISScraper"
        Mock Out-File { return $null } -ModuleName "FocusSISScraper"

        $mockSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
        $cookieName  = "FocusSessionToken"
        $cookieValue = "abcdef123456789xyz"
        $cookiePath  = "/"
        $cookieDomain = "focus.example.com"

        $mockCookie = [System.Net.Cookie]::new($cookieName, $cookieValue, $cookiePath, $cookieDomain)
        $mockSession.Cookies.Add($mockCookie)

        $Username = "testuser"
        $CookieRootPath = "TestDrive:\Cookies"
    }

    Context 'Export folder exists' {
        BeforeEach {
            Mock Test-Path { return $true } -ModuleName "FocusSISScraper"

            Save-Cookies -Username $Username -WebSession $mockSession -CookieRootPath $CookieRootPath
        }

        It 'Should correctly set the cookie file path' {
            Should -Invoke -CommandName Out-File -Times 1 -ParameterFilter { 
                $FilePath -eq "TestDrive:\Cookies\user_testuser.json"
            } -ModuleName 'FocusSISScraper'
        }

        It 'It should not attempt to create the export directory' {
            Should -Invoke -CommandName New-Item -Times 0 -Exactly -ModuleName 'FocusSISScraper'
        }
    }

    Context 'Cookies folder does not yet exist.' {
        BeforeEach {
            Mock Test-Path { return $false } -ModuleName "FocusSISScraper"

            Save-Cookies -Username $Username -WebSession $mockSession -CookieRootPath $CookieRootPath
        }

        It 'Should create the export directory' {
            Should -Invoke -CommandName New-Item -Times 1 -Exactly -ModuleName 'FocusSISScraper'
        }

        It 'Should output the cookies to a file' {
            Should -Invoke -CommandName Out-File -Times 1 -Exactly -ModuleName 'FocusSISScraper'
        }
    }
}
