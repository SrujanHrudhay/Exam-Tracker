' Exam Tracker - Legacy start.vbs redirecting to Exam Tracker.vbs
Set sh = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
dir = fso.GetParentFolderName(WScript.ScriptFullName)
sh.CurrentDirectory = dir
sh.Run """" & dir & "\Exam Tracker.vbs""", 1, False
