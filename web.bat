@echo off

set "SCRIPT_PATH=%~dp0web-launcher.ps1"

if "%~1"=="" goto usage

goto run

:usage
echo.
echo Web Launcher CLI
echo.
echo Usage: web ^<domain or search term^>
echo.
echo Examples:
echo   web bing.com
echo   web baidu.com
echo   web weather
echo.
goto end

:run
echo Running Web Launcher...
echo Input: %~1
echo.

powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%SCRIPT_PATH%" "%~1"

:end
