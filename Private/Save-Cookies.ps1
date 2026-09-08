

function Save-Cookies {
    [CmdletBinding()]
    param (
        [String]$Username = $script:Username,
        [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession = $script:WebSession,
        [String]$CookieRootPath = "$script:ExportPath\Cookies"
    )

    if (-not (Test-Path -Path $CookieRootPath)) {
        New-Item -ItemType Directory -Path $CookieRootPath | Out-Null
    }

    $CookieFilePath = Join-Path -Path $CookieRootPath -ChildPath "user_$Username.json"

    $WebSession.Cookies.GetAllCookies() | ConvertTo-Json -Depth 5 | Out-File -FilePath $CookieFilePath

    Add-RegistryUser
}

