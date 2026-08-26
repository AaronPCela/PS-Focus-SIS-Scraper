

function Update-UserRegistry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]$Username,
        [Parameter(Mandatory = $true)]
        [String]$FileName
    )
    
    $RegistryPath = "$PSScriptRoot\..\$env:COOKIES_SAVE_DIR\config.json"
    $Registry = Get-UserRegistry
    
    if (Test-Path $RegistryPath) {
        $Registry = Get-Content $RegistryPath | ConvertFrom-Json -AsHashTable
    }
    
    $Registry[$Username] = @{
        "File" = $FileName
        "LastUsed" = (Get-Date).ToString()
        "Expires" = (Get-Date).AddMinutes(20).ToString()
    }
    
    $Registry | ConvertTo-Json | Set-Content $RegistryPath
}


function Get-UserCookiesFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]$Username
    )

    $Registry = Get-UserRegistry

    return $Registry.$Username ? $Registry.$Username.File : ""
}


function Test-SessionExpiration {
    [CmdletBinding()]
    param(
        [String]$Username
    )

    $Registry = Get-UserRegistry

    if (!$Registry.$Username) {
        return $true
    }

    return [DateTime]($Registry.$Username.Expires) -lt (Get-Date) ? $true : $false
}


function Get-UserRegistry {
    [CmdletBinding()]
    param (
        [String]$RegistryPath = "$PSScriptRoot\..\$env:COOKIES_SAVE_DIR\config.json"
    )

    if (Test-Path -Path $RegistryPath) {
        return Get-Content $RegistryPath | ConvertFrom-Json -AsHashTable
    }

    return @{}
}

