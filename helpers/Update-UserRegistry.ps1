

function Update-UserRegistry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]$Username,
        [Parameter(Mandatory = $true)]
        [String]$FileName
    )
    
    $RegistryPath = "$PSScriptRoot\..\$env:COOKIES_SAVE_DIR\config.json"
    $Registry = @{}
    
    if (Test-Path $RegistryPath) {
        $Registry = Get-Content $RegistryPath | ConvertFrom-Json -AsHashTable
    }
    
    $Registry[$Username] = @{
        "File" = $FileName
        "LastUsed" = (Get-Date).ToString()
        "Experies" = (Get-Date).AddMinutes(20).ToString()
    }
    
    $Registry | ConvertTo-Json | Set-Content $RegistryPath
}

