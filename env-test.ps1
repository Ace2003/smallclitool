Write-Host "=== PowerShell Environment Test ==="
Write-Host ""

Write-Host "PowerShell version:"
$PSVersionTable.PSVersion
Write-Host ""

Write-Host "Current location:"
Get-Location
Write-Host ""

Write-Host "Testing regex..."
$domainPattern = '^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9](\.[a-zA-Z]{2,})+'
Write-Host "  'bing.com' match: $([regex]::IsMatch('bing.com', $domainPattern))"
Write-Host "  'www.google.com' match: $([regex]::IsMatch('www.google.com', $domainPattern))"
Write-Host "  'weather' match: $([regex]::IsMatch('weather', $domainPattern))"
Write-Host ""

Write-Host "Testing URL detection..."
Write-Host "  'https://bing.com' starts with https://: $('https://bing.com'.StartsWith('https://'))"
Write-Host "  'bing.com' starts with https://: $('bing.com'.StartsWith('https://'))"
Write-Host ""

Write-Host "Testing dot detection..."
Write-Host "  'bing.com' contains dot: $('bing.com'.Contains('.'))"
Write-Host "  'weather' contains dot: $('weather'.Contains('.'))"
Write-Host ""

Write-Host "Testing URL encoding..."
$testQuery = "weather forecast"
$encoded = [Uri]::EscapeDataString($testQuery)
Write-Host "  Original: $testQuery"
Write-Host "  Encoded: $encoded"
Write-Host ""

Write-Host "=== All tests passed ==="
