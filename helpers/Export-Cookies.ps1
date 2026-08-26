. "$PSScriptRoot\Get-UserHash.ps1"
. "$PSScriptRoot\Update-UserRegistry.ps1"


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

    $Cookies | Export-Clixml -Path $CookieFilePath
    
    # Update the config.json tracking registry so you know who is who
    Update-UserRegistry -Username $Username -FileName $FileName
}


