@echo off
setlocal enabledelayedexpansion
title Exam Tracker Setup
cd /d "%~dp0"

echo =======================================================
echo               EXAM TRACKER - QUICK SETUP
echo =======================================================
echo.
echo Setting up Exam Tracker for you...
echo.

:: Run PowerShell script to create Desktop and Start Menu shortcuts
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ws = New-Object -ComObject WScript.Shell; " ^
  "$dir = (Get-Location).Path; " ^
  "$target = Join-Path $dir 'Exam Tracker.vbs'; " ^
  "$ico = Join-Path $dir 'exam-tracker.ico'; " ^
  "$desktop = [Environment]::GetFolderPath('Desktop'); " ^
  "$lnkDesktop = Join-Path $desktop 'Exam Tracker.lnk'; " ^
  "$sc = $ws.CreateShortcut($lnkDesktop); " ^
  "$sc.TargetPath = $target; " ^
  "$sc.WorkingDirectory = $dir; " ^
  "$sc.IconLocation = \"$ico,0\"; " ^
  "$sc.Description = 'Exam Tracker - Visual Timeline & Deadlines'; " ^
  "$sc.Save(); " ^
  "$startMenu = [Environment]::GetFolderPath('Programs'); " ^
  "$lnkStart = Join-Path $startMenu 'Exam Tracker.lnk'; " ^
  "$sc2 = $ws.CreateShortcut($lnkStart); " ^
  "$sc2.TargetPath = $target; " ^
  "$sc2.WorkingDirectory = $dir; " ^
  "$sc2.IconLocation = \"$ico,0\"; " ^
  "$sc2.Description = 'Exam Tracker - Visual Timeline & Deadlines'; " ^
  "$sc2.Save();"

echo [SUCCESS] Desktop Shortcut created on your Desktop!
echo [SUCCESS] Start Menu shortcut created!
echo.
echo =======================================================
echo You can now launch Exam Tracker at any time by
echo double-clicking the "Exam Tracker" icon on your Desktop.
echo =======================================================
echo.
set /p LAUNCH="Would you like to launch Exam Tracker right now? (Y/N) [default: Y]: "
if /i "%LAUNCH%"=="" set LAUNCH=Y
if /i "%LAUNCH%"=="Y" (
    echo Starting Exam Tracker...
    start "" "Exam Tracker.vbs"
)
exit /b 0
