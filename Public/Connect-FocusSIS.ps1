

function Connect-FocusSIS {
    param (
        [Parameter(Mandatory)]
        [String]$Username,
        [Parameter(Mandatory)]
        [String]$Password,
        [Parameter(Mandatory)]
        [String]$FocusBaseURL,
        [Parameter(Mandatory)]
        [String]$FocusDashboardURL,
        [Parameter(Mandatory)]
        [String]$ExportPath
    )

    $Websession = Invoke-Authentication -Username $Username `
        -Password $Password `
        -FocusBaseUrl $FocusBaseURL
    
    Save-Cookies -Username $Username `
        -WebSession $Websession `
        -ExportPath $ExportPath

    $WebContent = (Invoke-WebRequest -Uri $FocusDashboardURL -WebSession $WebSession).Content
    $WebContent | Out-File "$PSScriptRoot\..\Data.txt"

    $global:StudentData = Expand-StudentData -WebContent $WebContent
}