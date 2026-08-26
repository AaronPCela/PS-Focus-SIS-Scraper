. "$PSScriptRoot\Get-UserHash.ps1"
. "$PSScriptRoot\UserRegistry.ps1"


function Export-Cookies {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Net.CookieCollection]$Cookies,
        [string]$Username = $env:FOCUS_USER
    )
    
    $FileName = Get-UserHash -Username $Username
    $CookieRootPath = "$PSScriptRoot\..\$env:COOKIES_SAVE_DIR\"
    $CookieFilePath = "$CookieRootPath" + "$FileName"
    
    if (-not (Test-Path $CookieRootPath)) {
        mkdir $CookieRootPath
    }

    $Cookies | ConvertTo-Json -Depth 5 | Out-File -Path $CookieFilePath
    
    # Update the config.json tracking registry so you know who is who
    Update-UserRegistry -Username $Username -FileName $FileName
}


