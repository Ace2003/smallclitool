<#
.SYNOPSIS
    Install Web Launcher CLI to system PATH
.DESCRIPTION
    This script adds Web Launcher CLI to user PATH environment variable
.EXAMPLE
    .\install.ps1
#>

param(
    [switch]$Force
)

$ErrorActionPreference = "Continue"

Write-Host "========================================"
Write-Host "Web Launcher CLI - Installation"
Write-Host "========================================"
Write-Host ""

$installPath = $PSScriptRoot
$webBatPath = Join-Path $installPath "web.bat"
$webPs1Path = Join-Path $installPath "web-launcher.ps1"

Write-Host "Checking files..."
Write-Host "  Installation path: $installPath"
Write-Host "  web.bat exists: $(Test-Path $webBatPath)"
Write-Host "  web-launcher.ps1 exists: $(Test-Path $webPs1Path)"
Write-Host ""

if (-not (Test-Path $webBatPath) -or -not (Test-Path $webPs1Path)) {
    Write-Host "ERROR: Required files not found!" -ForegroundColor Red
    Write-Host "Please run this script from the correct directory." -ForegroundColor Red
    pause
    exit 1
}

Write-Host "Getting current PATH..."
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
Write-Host "  Current user PATH: $userPath"
Write-Host ""

$installPathNormalized = $installPath.TrimEnd('\')

Write-Host "Checking if already in PATH..."
$pathContainsDir = $userPath -like "*$installPathNormalized*"
Write-Host "  Already in PATH: $pathContainsDir"
Write-Host ""

if ($pathContainsDir -and -not $Force) {
    Write-Host "Web Launcher CLI is already in system PATH!" -ForegroundColor Yellow
    Write-Host "Use -Force parameter to reinstall." -ForegroundColor Yellow
    pause
    exit 0
}

if ($Force -and $pathContainsDir) {
    Write-Host "Removing old PATH entries..." -ForegroundColor Yellow
    
    $userPath = $userPath -replace [regex]::Escape("$installPathNormalized;"), ""
    $userPath = $userPath -replace [regex]::Escape(";$installPathNormalized"), ""
    $userPath = $userPath -replace [regex]::Escape($installPathNormalized), ""
    $userPath = $userPath.Trim(';')
    
    Write-Host "  Done"
    Write-Host ""
}

Write-Host "Adding to user PATH environment variable..." -ForegroundColor Green

$newPath = "$installPathNormalized;$userPath"

Write-Host "  New PATH: $newPath"
Write-Host ""

try {
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "SUCCESS! Installation complete." -ForegroundColor Green
}
catch {
    Write-Host "ERROR: Failed to set PATH: $($_.Exception.Message)" -ForegroundColor Red
    pause
    exit 1
}

Write-Host ""
Write-Host "========================================"
Write-Host "Installation Summary"
Write-Host "========================================"
Write-Host ""
Write-Host "  Location: $installPathNormalized"
Write-Host ""
Write-Host "You can now use these commands from anywhere:"
Write-Host ""
Write-Host "  web bing.com          (Open bing.com)" -ForegroundColor Cyan
Write-Host "  web weather           (Search weather)" -ForegroundColor Cyan
Write-Host "  web 'weather forecast'  (Search with spaces)" -ForegroundColor Cyan
Write-Host "  web news -Engine google  (Use Google search)" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT: Please restart your terminal to apply PATH changes." -ForegroundColor Yellow
Write-Host ""
pause
