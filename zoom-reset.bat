@echo off
REM Zoom Reset - Fixes Error 1132 and other Zoom issues
REM Just run: zoom-reset.bat

setlocal EnableDelayedExpansion

echo.
echo   ============================================
echo        Zoom Reset ^& Reinstall Tool
echo      Fixes Error 1132 and other issues
echo   ============================================
echo.

set "SCRIPT_DIR=%~dp0"
set "MAIN_SCRIPT=%SCRIPT_DIR%zoom-reset-and-reinstall.ps1"

REM Check if pwsh is available
where pwsh >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    pwsh "%MAIN_SCRIPT%" %*
    exit /b %ERRORLEVEL%
)

REM PowerShell not found - try to install it
echo Installing required component (PowerShell)...
echo.

REM Check if winget is available
where winget >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Installing via Windows Package Manager...
    winget install Microsoft.PowerShell --accept-source-agreements --accept-package-agreements
    
    echo.
    echo Installation complete! Please close this window and run zoom-reset.bat again.
    pause
    exit /b 0
)

REM No winget - give manual instructions
echo.
echo Automatic installation not available.
echo.
echo Please install PowerShell from the Microsoft Store:
echo   1. Open Microsoft Store
echo   2. Search for "PowerShell"
echo   3. Click Install
echo   4. Run this script again
echo.
echo Or download from: https://aka.ms/powershell
echo.
pause
exit /b 1
