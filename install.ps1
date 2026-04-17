<#
.SYNOPSIS
    安装 Web Launcher CLI 工具到系统PATH
.DESCRIPTION
    此脚本将 Web Launcher CLI 添加到用户PATH环境变量中，
    使您可以在任何位置使用 `web` 命令
.EXAMPLE
    .\install.ps1
#>

param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Write-Status {
    param([string]$Message, [string]$Type = "Info")
    
    $color = switch ($Type) {
        "Success" { "Green" }
        "Error" { "Red" }
        "Warning" { "Yellow" }
        default { "White" }
    }
    
    Write-Host "[$Type] $Message" -ForegroundColor $color
}

try {
    $installPath = $PSScriptRoot
    $webBatPath = Join-Path $installPath "web.bat"
    $webPs1Path = Join-Path $installPath "web-launcher.ps1"
    
    Write-Status "开始安装 Web Launcher CLI..." "Info"
    
    if (-not (Test-Path $webBatPath) -or -not (Test-Path $webPs1Path)) {
        Write-Status "未找到必要的文件！请确保在正确的目录中运行安装脚本。" "Error"
        exit 1
    }
    
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    
    $installPathNormalized = $installPath.TrimEnd('\')
    
    $pathContainsDir = $userPath -like "*$installPathNormalized*" -or $machinePath -like "*$installPathNormalized*"
    
    if ($pathContainsDir -and -not $Force) {
        Write-Status "Web Launcher CLI 已经在系统PATH中了！" "Warning"
        Write-Status "如果需要重新安装，请使用 -Force 参数" "Info"
        exit 0
    }
    
    if ($Force -and $pathContainsDir) {
        Write-Status "正在移除旧的PATH条目..." "Info"
        $userPath = $userPath -replace [regex]::Escape("$installPathNormalized;"), "" -replace [regex]::Escape(";$installPathNormalized"), "" -replace [regex]::Escape($installPathNormalized), ""
        $userPath = $userPath.Trim(';')
    }
    
    Write-Status "正在添加到用户PATH环境变量..." "Info"
    $newPath = "$installPathNormalized;$userPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    
    Write-Status "安装成功！" "Success"
    Write-Host ""
    Write-Status "安装位置: $installPathNormalized" "Info"
    Write-Status "现在您可以在任何位置使用以下命令：" "Info"
    Write-Host ""
    Write-Host "  web bing.com          (打开 bing.com 网址)" -ForegroundColor Cyan
    Write-Host "  web 百度              (使用百度搜索"百度")" -ForegroundColor Cyan
    Write-Host "  web "天气预报"        (使用百度搜索"天气预报")" -ForegroundColor Cyan
    Write-Host "  web 新闻 -Engine google  (使用Google搜索)" -ForegroundColor Cyan
    Write-Host ""
    Write-Status "注意：请重新打开终端窗口以应用PATH变更。" "Warning"
    
}
catch {
    Write-Status "安装失败: $($_.Exception.Message)" "Error"
    exit 1
}
