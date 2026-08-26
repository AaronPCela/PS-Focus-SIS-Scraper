

function Import-EnvFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]$EnvPath
    )
    if (Test-Path $EnvPath) {
        Get-Content $EnvPath | ForEach-Object {
            # Skip empty lines or comment lines starting with #
            if ($_ -and -not $_.StartsWith('#')) {
                # Split the line at the first '=' sign
                $Key, $Value = $_ -split '=', 2
                
                # Trim whitespace and set the environment variable in only this process
                [System.Environment]::SetEnvironmentVariable($Key.Trim(), $Value.Trim(), 'Process')
            }
        }
    } else {
        Write-Error ".env file not found!"
    }

}

