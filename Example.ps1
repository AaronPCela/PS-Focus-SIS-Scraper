Import-Module -Name "$PSScriptRoot/FocusSISScraper.psm1" -Force

Connect-FocusSIS -Username "000000" `
    -Password "0000" `
    -FocusBaseUrl "https://focus.domain.com/focus/" `
    -FocusDashboardURL "https://focus.domain.com/focus/Modules.php?modname=misc%2FPortal.php" `
    -ExportPath "$PSScriptRoot\Data\"

Write-Host "Testing Get-InitialContext..." -ForegroundColor Cyan
Write-Host (Get-InitialContext) | Out-String

Write-Host "Testing Get-DistrictNews..." -ForegroundColor Cyan
Write-Host (Get-DistrictNews) | Out-String

Write-Host "Testing Get-DistrictPosts..." -ForegroundColor Cyan
Write-Host (Get-DistrictPosts) | Out-String

Write-Host "Testing Get-CheckInBlock..." -ForegroundColor Cyan
Write-Host (Get-CheckInBlock) | Out-String

Write-Host "Testing Get-CustomBlocks..." -ForegroundColor Cyan
Write-Host (Get-CustomBlocks) | Out-String

Write-Host "Testing Get-StudentGrades..." -ForegroundColor Cyan
Write-Host (Get-StudentGrades) | Out-String

Write-Host "Testing Get-EnrollmentPlanner..." -ForegroundColor Cyan
Write-Host (Get-EnrollmentPlanner) | Out-String

Write-Host "Testing Get-EnrollmentReports..." -ForegroundColor Cyan
Write-Host (Get-EnrollmentReports) | Out-String
