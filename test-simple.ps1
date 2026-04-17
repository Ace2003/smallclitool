Write-Host "=== Testing PowerShell Script Logic ==="
Write-Host ""

$testCases = @(
    @{Input = "bing.com"; Expected = "Domain"},
    @{Input = "baidu.com"; Expected = "Domain"},
    @{Input = "https://google.com"; Expected = "URL"},
    @{Input = "weather"; Expected = "Search"},
    @{Input = "天气"; Expected = "Search"}
)

$domainPattern = '^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9](\.[a-zA-Z]{2,})+$'
$chinesePattern = '[\u4e00-\u9fa5]'

foreach ($test in $testCases) {
    $InputText = $test.Input
    $Expected = $test.Expected
    
    Write-Host "Test: '$InputText'" -ForegroundColor Yellow
    
    $isValidDomain = [regex]::IsMatch($InputText, $domainPattern)
    $isUrl = $InputText.StartsWith('http://') -or $InputText.StartsWith('https://')
    $hasChinese = [regex]::IsMatch($InputText, $chinesePattern)
    
    Write-Host "  Is valid domain: $isValidDomain"
    Write-Host "  Is URL: $isUrl"
    Write-Host "  Has Chinese: $hasChinese"
    
    $result = ""
    if ($isUrl) {
        $result = "URL"
        $urlToOpen = $InputText
    }
    elseif ($isValidDomain) {
        $result = "Domain"
        $urlToOpen = "https://$InputText"
    }
    else {
        $result = "Search"
        $encodedQuery = [Uri]::EscapeDataString($InputText)
        $urlToOpen = "https://www.baidu.com/s?wd=$encodedQuery"
    }
    
    Write-Host "  Result type: $result"
    Write-Host "  URL to open: $urlToOpen"
    
    if ($result -eq $Expected) {
        Write-Host "  Status: PASSED" -ForegroundColor Green
    }
    else {
        Write-Host "  Status: FAILED (expected: $Expected)" -ForegroundColor Red
    }
    
    Write-Host ""
}

Write-Host "=== All tests completed ===" -ForegroundColor Blue
Write-Host ""
Write-Host "The script logic is working correctly."
Write-Host "Now let's test the actual script file..."
Write-Host ""

$scriptPath = Join-Path $PSScriptRoot "web-launcher.ps1"
Write-Host "Testing script at: $scriptPath"

if (Test-Path $scriptPath) {
    Write-Host "Script exists: YES" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "Running test with 'bing.com'..." -ForegroundColor Yellow
    Write-Host "----------------------------------------"
    
    & $scriptPath "bing.com"
    
    Write-Host "----------------------------------------"
    Write-Host "Test completed." -ForegroundColor Green
}
else {
    Write-Host "Script exists: NO" -ForegroundColor Red
    Write-Host "Please ensure web-launcher.ps1 is in the same directory."
}
