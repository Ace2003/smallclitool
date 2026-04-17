Write-Host "=== Simple Test ==="

$domainPattern = '^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9](\.[a-zA-Z]{2,})+'

Write-Host ""
Write-Host "Test 1: bing.com"
Write-Host "  Match: $([regex]::IsMatch('bing.com', $domainPattern))"

Write-Host ""
Write-Host "Test 2: www.google.com"
Write-Host "  Match: $([regex]::IsMatch('www.google.com', $domainPattern))"

Write-Host ""
Write-Host "Test 3: https://bing.com"
Write-Host "  Starts with http://: $('https://bing.com'.StartsWith('http://'))"
Write-Host "  Starts with https://: $('https://bing.com'.StartsWith('https://'))"

Write-Host ""
Write-Host "Test 4: Contains dot"
Write-Host "  'bing.com' contains dot: $('bing.com'.Contains('.'))"
Write-Host "  'weather' contains dot: $('weather'.Contains('.'))"

Write-Host ""
Write-Host "Test 5: URL encoding"
$testQuery = "weather forecast"
$encoded = [Uri]::EscapeDataString($testQuery)
Write-Host "  Original: $testQuery"
Write-Host "  Encoded: $encoded"

Write-Host ""
Write-Host "=== Test Complete ==="
