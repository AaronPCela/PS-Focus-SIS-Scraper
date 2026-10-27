

function Invoke-Authentication {
    param (
        [Parameter(Mandatory)]
        [String]$Username,
        [Parameter(Mandatory)]
        [String]$Password,
        [Parameter(Mandatory)]
        [String]$FocusBaseUrl
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
        $Response = Invoke-WebRequest -Uri $FocusBaseUrl `
            -Method Post `
            -Body $FormBody `
            -Headers $RequestHeaders `
            -WebSession $WebSession
        
        return $WebSession
    } catch {
        Write-Error "Authentication failed. Error: $_"
        return $null
    }
}

