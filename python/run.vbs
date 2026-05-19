' 無視窗啟動 AutoHotkeyPy（背景執行，含 UAC 提權）
' 雙擊即可；連 PowerShell 視窗都不會閃現。

Set fso = CreateObject("Scripting.FileSystemObject")
scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
mainPy = scriptDir & "\main.py"

' pyenv 下 pythonw.exe 不在 admin PATH，必須先解析絕對路徑
Set shell = CreateObject("Wscript.Shell")
tempFile = fso.GetSpecialFolder(2) & "\ahkpy_pythonw_path.txt"
resolverCmd = "cmd /c python -c ""import sys, os; print(os.path.join(os.path.dirname(sys.executable), 'pythonw.exe'))"" > """ & tempFile & """"
shell.Run resolverCmd, 0, True  ' 0 = 隱藏窗; True = 等完成

If Not fso.FileExists(tempFile) Then
    MsgBox "Failed to resolve pythonw.exe path. Is Python on PATH?", vbCritical, "AutoHotkeyPy"
    WScript.Quit 1
End If

Set f = fso.OpenTextFile(tempFile, 1)
pythonwPath = Trim(f.ReadAll())
f.Close
fso.DeleteFile tempFile

If Not fso.FileExists(pythonwPath) Then
    MsgBox "pythonw.exe not found at: " & pythonwPath, vbCritical, "AutoHotkeyPy"
    WScript.Quit 1
End If

' ShellExecute 第 4 參數 "runas" 觸發 UAC；第 5 參數 0 = 完全隱藏視窗
Set shellApp = CreateObject("Shell.Application")
shellApp.ShellExecute pythonwPath, Chr(34) & mainPy & Chr(34), scriptDir, "runas", 0
