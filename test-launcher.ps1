<#
.SYNOPSIS
    测试 Web Launcher CLI 核心逻辑
.DESCRIPTION
    此脚本测试输入类型判断和URL生成逻辑，不实际打开浏览器
#>

param(
    [string]$InputText = "bing.com",
    [string]$Engine = "baidu"
)

function Test-Chinese {
    param([string]$Text)
    $chinesePattern = '[\u4e00-\u9fa5]'
    return [regex]::IsMatch($Text, $chinesePattern)
}

function Test-ValidDomain {
    param([string]$Domain)
    
    if ([string]::IsNullOrWhiteSpace($Domain)) {
        return $false
    }
    
    $domainPattern = '^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9](\.[a-zA-Z]{2,})+$'
    
    if ([regex]::IsMatch($Domain, $domainPattern)) {
        return $true
    }
    
    if ($Domain.StartsWith('www.')) {
        $withoutWWW = $Domain.Substring(4)
        return [regex]::IsMatch($withoutWWW, $domainPattern)
    }
    
    return $false
}

function Test-IsUrl {
    param([string]$Url)
    return $Url.StartsWith('http://') -or $Url.StartsWith('https://')
}

function Get-SearchUrl {
    param(
        [string]$Query,
        [string]$SearchEngine
    )
    
    $encodedQuery = [Uri]::EscapeDataString($Query)
    
    switch ($SearchEngine) {
        "baidu" { return "https://www.baidu.com/s?wd=$encodedQuery" }
        "google" { return "https://www.google.com/search?q=$encodedQuery" }
        "bing" { return "https://www.bing.com/search?q=$encodedQuery" }
        "duckduckgo" { return "https://duckduckgo.com/?q=$encodedQuery" }
        default { return "https://www.baidu.com/s?wd=$encodedQuery" }
    }
}

function Format-Url {
    param([string]$InputUrl)
    
    if (-not ($InputUrl.StartsWith('http://') -or $InputUrl.StartsWith('https://'))) {
        return "https://$InputUrl"
    }
    return $InputUrl
}

Write-Host "=== 测试 Web Launcher CLI ===" -ForegroundColor Blue
Write-Host "输入: $InputText" -ForegroundColor White
Write-Host "搜索引擎: $Engine" -ForegroundColor White
Write-Host ""

Write-Host "检测结果:" -ForegroundColor Yellow
Write-Host "  包含中文字符: $(Test-Chinese -Text $InputText)" -ForegroundColor Gray
Write-Host "  是有效域名: $(Test-ValidDomain -Domain $InputText)" -ForegroundColor Gray
Write-Host "  是完整URL: $(Test-IsUrl -Url $InputText)" -ForegroundColor Gray
Write-Host ""

Write-Host "生成的URL:" -ForegroundColor Cyan

$urlToOpen = ""
$detectedType = ""

if (Test-IsUrl -Url $InputText) {
    $urlToOpen = $InputText
    $detectedType = "完整URL"
}
elseif (Test-ValidDomain -Domain $InputText) {
    $urlToOpen = Format-Url -InputUrl $InputText
    $detectedType = "域名"
}
elseif ((Test-Chinese -Text $InputText) -or (-not $InputText.Contains('.'))) {
    $urlToOpen = Get-SearchUrl -Query $InputText -SearchEngine $Engine
    $detectedType = "搜索词"
}
else {
    $urlToOpen = Format-Url -InputUrl $InputText
    $detectedType = "其他（尝试作为URL打开）"
}

Write-Host "  检测类型: $detectedType" -ForegroundColor Green
Write-Host "  URL: $urlToOpen" -ForegroundColor White
Write-Host ""

Write-Host "=== 测试完成 ===" -ForegroundColor Blue
Write-Host "提示: 可以使用以下命令测试其他输入:" -ForegroundColor Gray
Write-Host "  .\test-launcher.ps1 -InputText 百度" -ForegroundColor Cyan
Write-Host "  .\test-launcher.ps1 -InputText https://google.com" -ForegroundColor Cyan
Write-Host "  .\test-launcher.ps1 -InputText 天气预报 -Engine google" -ForegroundColor Cyan
