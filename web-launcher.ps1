<#
.SYNOPSIS
    CLI工具 - 输入域名或中文搜索词快速打开默认浏览器
.DESCRIPTION
    此脚本可以：
    1. 输入域名（如 bing.com）直接打开对应网址
    2. 输入中文字符（如 百度）使用默认搜索引擎搜索
.PARAMETER InputText
    要打开的域名或搜索词
.PARAMETER Engine
    指定搜索引擎 (baidu, google, bing, duckduckgo)
.EXAMPLE
    .\web-launcher.ps1 bing.com
    .\web-launcher.ps1 百度
    .\web-launcher.ps1 "天气预报" -Engine google
#>

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$InputText,
    
    [Parameter(Position=1)]
    [ValidateSet("baidu", "google", "bing", "duckduckgo")]
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

try {
    $urlToOpen = ""
    
    if (Test-IsUrl -Url $InputText) {
        $urlToOpen = $InputText
    }
    elseif (Test-ValidDomain -Domain $InputText) {
        $urlToOpen = Format-Url -InputUrl $InputText
    }
    elseif ((Test-Chinese -Text $InputText) -or (-not $InputText.Contains('.'))) {
        $urlToOpen = Get-SearchUrl -Query $InputText -SearchEngine $Engine
    }
    else {
        $urlToOpen = Format-Url -InputUrl $InputText
    }
    
    Write-Host "正在打开: $urlToOpen"
    
    Start-Process $urlToOpen
}
catch {
    Write-Error "打开浏览器失败: $($_.Exception.Message)"
    exit 1
}
