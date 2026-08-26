. "$PSScriptRoot\..\helpers\Export-Cookies.ps1"
. "$PSScriptRoot\..\helpers\Import-Cookies.ps1"


function Get-Authentication {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]$FocusUser,
        [Parameter(Mandatory = $true)]
        [String]$FocusPass
    )

    $ImportAttempt = Import-Cookies -Username $FocusUser

    if ($ImportAttempt) {
        return $ImportAttempt
    }

    $WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession

    # Payload for focus to authenticate
    $FormBody = @{
        login = "true"
        data  = "username=$FocusUser&password=$FocusPass"
    }

    $RequestHeaders = @{
        "Accept"       = "application/json, text/html, */*"
        # "User-Agent"   = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
    }

    try {
        Invoke-RestMethod `
            -Uri $env:FOCUS_BASE_URL `
            -Method Post `
            -Body $FormBody `
            -Headers $RequestHeaders `
            -WebSession $WebSession > $null

        $Cookies = $WebSession.Cookies.GetAllCookies()

        Export-Cookies -Cookies $Cookies
        
        return $WebSession
    }
    catch {
        Write-Error "The connection attempt returned an error: $_"
    }

}

