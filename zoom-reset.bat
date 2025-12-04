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
    REM If successful, close automatically (Zoom is launching)
    if !ERRORLEVEL! EQU 0 (
        exit /b 0
    )
    echo.
    pause
    exit /b !ERRORLEVEL!
)

REM PowerShell not found
echo PowerShell is required but not installed.
echo.

REM Check if winget is available
where winget >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo To install, run:
    echo   winget install Microsoft.PowerShell
    echo.
    set /p INSTALL="Install now? (y/N): "
    if /i "!INSTALL!"=="y" (
        winget install Microsoft.PowerShell --accept-source-agreements --accept-package-agreements
        echo.
        echo If installation succeeded, please close this window and run zoom-reset.bat again.
    )
) else (
    echo Please install PowerShell from:
    echo   - Microsoft Store: Search for "PowerShell"
    echo   - Or download from: https://aka.ms/powershell
)

echo.
pause
exit /b 1
