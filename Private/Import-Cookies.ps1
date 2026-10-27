

function Import-Cookies {    
    param (
        [Parameter(Mandatory)]
        [String]$Username,
        [Parameter(Mandatory)]
        [String]$ImportPath
    )

    $CookieFilePath = Join-Path -Path $ImportPath -ChildPath "user_$Username.xml"

    $ImportedCookie = Import-Clixml -Path $CookieFilePath
    
    return $ImportedCookie
}

