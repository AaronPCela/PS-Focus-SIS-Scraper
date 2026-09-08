

function Invoke-Authentication {
    [CmdletBinding()]
    param (
        [String]$Username = $script:Username,
        [String]$Password = $script:Password,
        [String]$FocusBaseUrl = $script:FocusBaseUrl
    )

    $WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession

    $FormBody = @{
        login = "true"
        data  = "username=$Username&password=$Password"
    }

    $RequestHeaders = @{
        "Accept"       = "application/json, text/html, */*"
        #"User-Agent"   = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
    }

    try {
        $LoginUrl = "$FocusBaseUrl/focus/"

        $Response = Invoke-WebRequest -Uri $LoginUrl `
            -Method Post `
            -Body $FormBody `
            -Headers $RequestHeaders `
            -WebSession $WebSession

        return $WebSession
    } catch {
        Write-Warning "Authentication failed. Error: $_"
        return $null
    }
}

