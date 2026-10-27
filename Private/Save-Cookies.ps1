

function Save-Cookies {
    param (
        [Parameter(Mandatory)]
        [String]$Username,
        [Parameter(Mandatory)]
        [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession,
        [Parameter(Mandatory)]
        [String]$ExportPath
    )

    if (-not (Test-Path -Path $ExportPath)) {
        New-Item -ItemType Directory -Path $ExportPath | Out-Null
    }

    $CookieFilePath = Join-Path -Path $ExportPath -ChildPath "user_$Username.xml"

    $WebSession | Export-Clixml -Path $CookieFilePath
}

