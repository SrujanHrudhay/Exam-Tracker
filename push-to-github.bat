@echo off
setlocal enabledelayedexpansion
title Push Exam Tracker to GitHub
cd /d "%~dp0"

echo =======================================================
echo          PUSH EXAM TRACKER TO GITHUB REPOSITORY
echo =======================================================
echo.

where git >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Git is not installed on this system.
    echo Please install Git from https://git-scm.com/
    pause
    exit /b 1
)

if not exist ".git" (
    echo Initializing local Git repository...
    git init -b main
)

git add .
git commit -m "Initial commit: Exam Tracker Desktop & Web App"

echo.
set /p REPO_URL="Enter your GitHub Repository URL (e.g. https://github.com/username/exam-tracker.git): "

if "%REPO_URL%"=="" (
    echo.
    echo [INFO] No URL entered. You can link and push later with:
    echo        git remote add origin ^<your-github-url^>
    echo        git branch -M main
    echo        git push -u origin main
    echo.
    pause
    exit /b 0
)

echo.
echo Linking repository to %REPO_URL%...
git remote remove origin >nul 2>&1
git remote add origin %REPO_URL%
git branch -M main

echo Pushing code to GitHub...
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo =======================================================
    echo [SUCCESS] Your Exam Tracker has been uploaded to GitHub!
    echo =======================================================
) else (
    echo.
    echo [NOTE] If this is your first push or authentication is required,
    echo        please sign in when prompted by Git/GitHub.
)

pause
exit /b 0
