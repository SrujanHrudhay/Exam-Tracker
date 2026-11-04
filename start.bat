@echo off
cd /d "%~dp0"
echo Starting Exam Tracker...

:: Check if Node is installed
where node >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    start "" http://localhost:3000
    node server.js
) else (
    echo Node.js not detected. Using built-in Windows PowerShell server...
    start "" http://localhost:3000
    powershell -NoProfile -ExecutionPolicy Bypass -File server.ps1
)
