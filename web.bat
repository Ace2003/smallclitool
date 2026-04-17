@echo off
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0web-launcher.ps1"

if "%~1"=="" (
    echo.
    echo 用法: web ^<域名或搜索词^> [选项]
    echo.
    echo 示例:
    echo   web bing.com          打开 bing.com 网址
    echo   web 百度              使用百度搜索"百度"
    echo   web "天气预报"        使用百度搜索"天气预报"
    echo   web 新闻 -Engine google  使用Google搜索"新闻"
    echo.
    echo 选项:
    echo   -Engine ^<搜索引擎^>     指定搜索引擎 (baidu, google, bing, duckduckgo)
    echo.
    exit /b 1
)

powershell.exe -ExecutionPolicy Bypass -File "%SCRIPT_DIR%" %*
