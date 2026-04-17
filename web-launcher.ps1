<#
.SYNOPSIS
    Simple Web Launcher
.DESCRIPTION
    Opens default browser with domain or search term
#>

param([string]$InputText)

if ([string]::IsNullOrWhiteSpace($InputText)) {
    Write-Host "Usage: .\web-launcher.ps1 <domain or search term>"
    Write-Host "Example: .\web-launcher.ps1 bing.com"
    Write-Host "         .\web-launcher.ps1 weather"
    exit 0
}

Write-Host "Input: $InputText"

$domainPattern = '^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9](\.[a-zA-Z]{2,})+$'
$isValidDomain = [regex]::IsMatch($InputText, $domainPattern)

$isUrl = $InputText.StartsWith('http://') -or $InputText.StartsWith('https://')

$hasDot = $InputText.Contains('.')

$chinesePattern = '[\u4e00-\u9fa5]'
$hasChinese = [regex]::IsMatch($InputText, $chinesePattern)

Write-Host "Is valid domain: $isValidDomain"
Write-Host "Is URL: $isUrl"
Write-Host "Has dot: $hasDot"
Write-Host "Has Chinese: $hasChinese"

$urlToOpen = ""

if ($isUrl) {
    $urlToOpen = $InputText
    Write-Host "Detected: Full URL"
}
elseif ($isValidDomain) {
    $urlToOpen = "https://$InputText"
    Write-Host "Detected: Domain name"
}
else {
    $encodedQuery = [Uri]::EscapeDataString($InputText)
    $urlToOpen = "https://www.baidu.com/s?wd=$encodedQuery"
    Write-Host "Detected: Search term"
}

Write-Host "Opening: $urlToOpen"

Start-Process $urlToOpen

Write-Host "Done - browser should open now"
Start-Sleep -Milliseconds 500
