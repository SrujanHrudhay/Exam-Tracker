<#
.SYNOPSIS
    Exam Tracker - 1-Click Windows Web / Local Installer
.DESCRIPTION
    Installs Exam Tracker to %LOCALAPPDATA%\Programs\ExamTracker,
    creates Desktop and Start Menu shortcuts, and launches the app.
#>

param(
    [string]$RepoUrl = "https://github.com/SrujanHrudhay/Exam-Tracker",
    [switch]$LaunchAfterInstall = $true
)

$ErrorActionPreference = "Stop"

$installDir = Join-Path $env:LOCALAPPDATA "Programs\ExamTracker"
$desktop = [Environment]::GetFolderPath("Desktop")
$startMenu = [Environment]::GetFolderPath("Programs")

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "        Exam Tracker Setup Installer      " -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Installing to: $installDir" -ForegroundColor Gray

# If running from a local extracted folder, copy local files
$sourceDir = $PSScriptRoot
if ($sourceDir -and (Test-Path (Join-Path $sourceDir "index.html"))) {
    Write-Host "Copying files from local folder..." -ForegroundColor Green
    if (-not (Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir -Force | Out-Null }
    Copy-Item -Path "$sourceDir\*" -Destination $installDir -Recurse -Force
} else {
    # Download zip from repository
    Write-Host "Downloading latest version..." -ForegroundColor Green
    $zipPath = "$env:TEMP\ExamTracker-latest.zip"
    $zipUrl = "$RepoUrl/archive/refs/heads/main.zip"
    
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
        $extractTemp = "$env:TEMP\ExamTracker-extract"
        if (Test-Path $extractTemp) { Remove-Item $extractTemp -Recurse -Force }
        Expand-Archive -Path $zipPath -DestinationPath $extractTemp -Force
        
        $innerDir = (Get-ChildItem $extractTemp -Directory | Select-Object -First 1).FullName
        if (-not (Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir -Force | Out-Null }
        Copy-Item -Path "$innerDir\*" -Destination $installDir -Recurse -Force
        
        Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
        Remove-Item $extractTemp -Recurse -Force -ErrorAction SilentlyContinue
    } catch {
        Write-Warning "Could not download zip from $zipUrl: $_"
        Write-Host "Please download the zip manually from $RepoUrl and extract it." -ForegroundColor Red
        return
    }
}

# Create Shortcuts
$ws = New-Object -ComObject WScript.Shell
$targetVbs = Join-Path $installDir "Exam Tracker.vbs"
$ico = Join-Path $installDir "exam-tracker.ico"

# Desktop Shortcut
$scDesktop = $ws.CreateShortcut((Join-Path $desktop "Exam Tracker.lnk"))
$scDesktop.TargetPath = $targetVbs
$scDesktop.WorkingDirectory = $installDir
if (Test-Path $ico) { $scDesktop.IconLocation = "$ico,0" }
$scDesktop.Description = "Exam Tracker - Visual Timeline & Deadlines"
$scDesktop.Save()

# Start Menu Shortcut
$scStart = $ws.CreateShortcut((Join-Path $startMenu "Exam Tracker.lnk"))
$scStart.TargetPath = $targetVbs
$scStart.WorkingDirectory = $installDir
if (Test-Path $ico) { $scStart.IconLocation = "$ico,0" }
$scStart.Description = "Exam Tracker - Visual Timeline & Deadlines"
$scStart.Save()

Write-Host "`n[SUCCESS] Shortcuts created successfully on Desktop and Start Menu!" -ForegroundColor Green

if ($LaunchAfterInstall) {
    Write-Host "Launching Exam Tracker..." -ForegroundColor Cyan
    Start-Process -FilePath "wscript.exe" -ArgumentList "`"$targetVbs`"" -WorkingDirectory $installDir
}
