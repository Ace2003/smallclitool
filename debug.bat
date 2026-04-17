@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Web Launcher CLI - Debug Mode
echo ========================================
echo.

echo Checking environment...
echo  Script location: %~dp0
echo  Full script path: %~dp0web-launcher.ps1
echo.

if NOT EXIST "%~dp0web-launcher.ps1" (
    echo ERROR: web-launcher.ps1 not found at: %~dp0web-launcher.ps1
    pause
    exit /b 1
)
echo  web-launcher.ps1 found: OK
echo.

echo Checking PowerShell...
where powershell.exe >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: powershell.exe not found in PATH
    pause
    exit /b 1
)
echo  PowerShell found: OK
echo.

echo Testing PowerShell execution...
powershell.exe -ExecutionPolicy Bypass -NoProfile -Command "Write-Host 'PowerShell test: OK'; exit 0"
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: PowerShell execution failed
    pause
    exit /b 1
)
echo.

if "%~1"=="" (
    echo No input provided. Use: debug.bat ^<domain or search term^>
    echo Example: debug.bat bing.com
    pause
    exit /b 1
)

echo Input: %*
echo.

echo Running with debug output...
echo Command: powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0web-launcher.ps1" %*
echo.

powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0web-launcher.ps1" %*

echo.
echo ========================================
echo Execution complete. Error level: %ERRORLEVEL%
echo ========================================
pause
