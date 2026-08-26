. "$PSScriptRoot\UserRegistry.ps1"


function Import-Cookies {
    [CmdletBinding()]
    param(
        [String]$Username = $env:FOCUS_USER
    )
    
    $FileName = Get-UserCookiesFile -Username $Username
    $CookiePath = "$PSScriptRoot\..\$env:COOKIES_SAVE_DIR\$FileName"
    
    if (($FileName -and (Test-Path $CookiePath)) -and !(Test-SessionExpiration -Username $Username)) {
        $WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession

        Get-Content -Raw -Path $CookiePath | `
            ConvertFrom-Json | `
            ForEach-Object {
                $Data = $_ | Select-Object * -ExcludeProperty TimeStamp
                
                # Add to session
                $WebSession.Cookies.Add([System.Net.Cookie]$Data)
            }
        Write-Host "Restored session for profile: $Username" -ForegroundColor Green
    } else {
        Write-Warning "The save was not found or the session expired for $Username.
            Please authenticate the user first."
    }

    return $WebSession
}

