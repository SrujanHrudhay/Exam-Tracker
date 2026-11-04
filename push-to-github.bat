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

:: Check if remote origin already exists
git remote get-url origin >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    for /f "tokens=*" %%u in ('git remote get-url origin') do set CURRENT_REPO=%%u
    echo Current remote: !CURRENT_REPO!
    echo.
) else (
    set /p REPO_URL="Enter your GitHub Repository URL (e.g. https://github.com/username/Exam-Tracker): "
    if not "!REPO_URL!"=="" (
        git remote add origin !REPO_URL!
        git branch -M main
    )
)

echo Checking for changes to commit...
git add .
set /p COMMIT_MSG="Enter commit message [press Enter for 'Update Exam Tracker']: "
if "%COMMIT_MSG%"=="" set COMMIT_MSG=Update Exam Tracker

git commit -m "%COMMIT_MSG%" >nul 2>&1

echo.
echo Syncing with remote repository...
git pull --rebase origin main >nul 2>&1

echo Pushing code to GitHub...
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo =======================================================
    echo [SUCCESS] Your Exam Tracker has been uploaded to GitHub!
    echo =======================================================
) else (
    echo.
    echo [NOTE] Push completed or requires checking your Git credentials.
)

echo.
pause
exit /b 0
