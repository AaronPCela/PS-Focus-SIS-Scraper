

function Add-RegistryUser {
    [CmdletBinding()]
    param (
        [String]$Username = $script:Username,
        [String]$CookiesFile = "user_$Username.json",
        [String]$DataFile = "user_$Username_data.json",
        [DateTime]$Expires = (Get-Date).AddMinutes(10),
        [DateTime]$LastUsed = (Get-Date),
        [String]$ExportPath = $script:ExportPath
    )

    $registry = Get-UserRegistry

    $registry.$Username = [Ordered]@{
        CookiesFile = $CookiesFile
        DataFile    = $DataFile
        Expires     = $Expires
        LastUsed    = $LastUsed
    }

    $registry | ConvertTo-Json -Depth 3 | Out-File -FilePath "$ExportPath\user_registry.json"
}


function Test-Expiration {
    [CmdletBinding()]
    param (
        [String]$Username = $script:Username
    )

    $currentDate = Get-Date
    $expirationDateTime = [datetime]((Get-UserRegistry).$Username.Expires)

    return !($currentDate -lt $expirationDateTime)
}


function Get-UserRegistry {
    [CmdletBinding()]
    param (
        [String]$ExportPath = $script:ExportPath
    )

    $RegistryPath = "$ExportPath\user_registry.json"

    if (Test-Path -Path $RegistryPath) {
        return Get-Content $RegistryPath | ConvertFrom-Json -AsHashTable
    }

    New-Item -Path $RegistryPath -ItemType File | Out-Null

    return @{}
}

