Import-Module "$PSscriptroot/../../FocusSISScraper.psm1" -Force

Describe 'Invoke-Authentication' {
    BeforeAll {
        $Username = "validuser"
        $Password = "validpassword"
        $FocusBaseUrl = "https://example.com"
    }

    Context 'When called with valid credentials' {
        BeforeEach {
            Mock Invoke-WebRequest {
                return @{
                    StatusCode = 200
                    Content    = '{"success":true,"error":null}'
                }
            } -ModuleName "FocusSISScraper"

            $result = Invoke-Authentication -Username $Username -Password $Password -FocusBaseUrl $FocusBaseUrl
        }

        It 'Should return a valid WebSession object' {
            $result | Should -Not -BeNullOrEmpty
            $result.GetType().FullName | Should -Be "Microsoft.PowerShell.Commands.WebRequestSession"
        }

        It 'Should call Invoke-WebRequest with the correct parameters' {
            Should -Invoke Invoke-WebRequest -ParameterFilter {
                $Uri -eq "$FocusBaseUrl/focus/"
                $Method -eq "Post" 
                $Body["login"] -eq "true"
                $Body["data"] -eq "username=$Username&password=$Password"
                $Headers["Accept"] -eq "application/json, text/html, */*"
                $WebSession -eq $script:WebSession
            } -ModuleName "FocusSISScraper"
        }
    }

    Context 'When called with invalid credentials' {
        BeforeEach {
            Mock Invoke-WebRequest {
                throw '{"success":false,"error":"Invalid credentials"}'
            } -ModuleName "FocusSISScraper"

            $result = Invoke-Authentication -Username $Username -Password "invalidpassword" -FocusBaseUrl $FocusBaseUrl
        }

        It 'Should return null for invalid credentials' {
            $result | Should -BeNullOrEmpty
        }

        It 'Should call Invoke-WebRequest with the correct parameters' {
            Should -Invoke Invoke-WebRequest -ParameterFilter {
                $Uri -eq "$FocusBaseUrl/focus/"
                $Method -eq "Post" 
                $Body["login"] -eq "true"
                $Body["data"] -eq "username=$Username&password=invalidpassword"
                $Headers["Accept"] -eq "application/json, text/html, */*"
                $WebSession -eq $script:WebSession
            } -ModuleName "FocusSISScraper"
        }
    }
}