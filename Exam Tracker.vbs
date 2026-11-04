' Exam Tracker - One-Click Silent Desktop Launcher
' Runs completely hidden (no black command prompt window).
' Automatically uses Node.js if available, or falls back to Windows built-in PowerShell server.
' Edge / Chrome runs in native App Mode with profile cached cleanly in %LOCALAPPDATA%.

Option Explicit
Dim sh, fso, dir, url, profileDir, desktopPath, shortcutPath, link, hasNode, candidates, p

Set sh = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

dir = fso.GetParentFolderName(WScript.ScriptFullName)
sh.CurrentDirectory = dir
url = "http://localhost:3000"

' 1. Auto-create Desktop Shortcut on first run if it does not exist
On Error Resume Next
desktopPath = sh.SpecialFolders("Desktop")
shortcutPath = desktopPath & "\Exam Tracker.lnk"
If Not fso.FileExists(shortcutPath) Then
    Set link = sh.CreateShortcut(shortcutPath)
    link.TargetPath = WScript.ScriptFullName
    link.WorkingDirectory = dir
    If fso.FileExists(dir & "\exam-tracker.ico") Then
        link.IconLocation = dir & "\exam-tracker.ico, 0"
    End If
    link.Description = "Exam Tracker - Visual Timeline & Deadlines"
    link.WindowStyle = 1
    link.Save
End If
On Error GoTo 0

' 2. Ensure %LOCALAPPDATA%\ExamTracker\profile exists for browser data isolation
profileDir = sh.ExpandEnvironmentStrings("%LOCALAPPDATA%\ExamTracker\profile")
If Not fso.FolderExists(sh.ExpandEnvironmentStrings("%LOCALAPPDATA%\ExamTracker")) Then
    On Error Resume Next
    fso.CreateFolder(sh.ExpandEnvironmentStrings("%LOCALAPPDATA%\ExamTracker"))
    fso.CreateFolder(profileDir)
    On Error GoTo 0
End If

' 3. Start local server in the background (hidden window = 0)
hasNode = (sh.Run("cmd /c node -v >nul 2>&1", 0, True) = 0)

If hasNode Then
    sh.Run "cmd /c node server.js", 0, False
Else
    ' Zero-install fallback for users without Node.js
    sh.Run "powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File """ & dir & "\server.ps1""", 0, False
End If

WScript.Sleep 1000

' 4. Launch in App Window Mode (Frameless / dedicated window)
candidates = Array( _
    sh.ExpandEnvironmentStrings("%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"), _
    sh.ExpandEnvironmentStrings("%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"), _
    sh.ExpandEnvironmentStrings("%ProgramFiles%\Google\Chrome\Application\chrome.exe"), _
    sh.ExpandEnvironmentStrings("%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"), _
    sh.ExpandEnvironmentStrings("%LocalAppData%\Google\Chrome\Application\chrome.exe"), _
    sh.ExpandEnvironmentStrings("%LocalAppData%\Microsoft\Edge\Application\msedge.exe") _
)

For Each p In candidates
    If fso.FileExists(p) Then
        sh.Run """" & p & """ --app=" & url & " --user-data-dir=""" & profileDir & """", 1, False
        WScript.Quit
    End If
Next

' Fallback: If neither Edge nor Chrome is found, open default system browser
sh.Run url
