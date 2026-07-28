@echo off

:: Check for Administrator privileges
net session >nul 2>&1

if %errorlevel% neq 0 (
    color c
    echo.
    echo ============================================================
    echo ERROR: Administrator privileges are required.
    echo.
    echo Please right-click this file and select:
    echo "Run as administrator"
    echo ============================================================
    echo.
    pause
    exit /b 1
)

:: Administrator privileges confirmed
color a
echo Running with Administrator privileges.
echo Continuing with setup...
echo.
cd /d "%~dp0"
cd assets
powershell -NoProfile -ExecutionPolicy Bypass -File .\InstallWingetAndPrerequisites.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File .\CmdowSetup.ps1
pwsh -NoProfile -ExecutionPolicy Bypass -File .\CopyToWindowsStartupFolder.ps1
start "" "NanoBunFloppyGameLauncher.bat"
start "" "SetupDoneMsgbox.vbs"
exit

:: ----------------------------------------------------------------------------
:: ----------------------- Copyright (C) 2026 NanoBunTV -----------------------
:: ----------------------------------------------------------------------------
:: - This program is free software: you can redistribute it and/or modify it --
:: - under the terms of the GNU Affero General Public License as published by -
:: ------ the Free Software Foundation, either version 3 of the License, ------
:: ------------------ or (at your option) any later version. ------------------
:: ----------------------------------------------------------------------------
:: ----- This program is distributed in the hope that it will be useful, ------
:: ------ but WITHOUT ANY WARRANTY; without even the implied warranty of ------
:: ----------- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. -----------
:: ------- See the GNU Affero General Public License for more details. --------
:: ----------------------------------------------------------------------------
:: - You should have received a copy of the GNU Affero General Public License -
:: -- along with this program. If not, see <https://www.gnu.org/licenses/>. ---
:: ----------------------------------------------------------------------------