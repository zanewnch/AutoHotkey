#!/usr/bin/env pwsh
# 啟動 AutoHotkeyPy（背景執行，pythonw 無 console，含 UAC 提權）
# 除錯模式：如果要看 print / traceback，直接下 `python main.py`

# pyenv 等情況下 pythonw.exe 不在 admin session 的 PATH，用絕對路徑最穩
$pythonw = (& python -c "import sys, os; print(os.path.join(os.path.dirname(sys.executable), 'pythonw.exe'))").Trim()

if (-not (Test-Path $pythonw)) {
    Write-Host "pythonw.exe not found: $pythonw" -ForegroundColor Red
    exit 1
}

$mainPy = Join-Path $PSScriptRoot "main.py"
Start-Process -FilePath $pythonw `
    -ArgumentList "`"$mainPy`"" `
    -Verb RunAs `
    -WorkingDirectory $PSScriptRoot `
    -WindowStyle Hidden
