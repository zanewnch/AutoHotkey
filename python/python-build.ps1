#!/usr/bin/env pwsh
# 用 PyInstaller 打包成單一 exe
# 產出：python/dist/AutoHotkeyPy.exe

$ErrorActionPreference = "Stop"

Set-Location -Path $PSScriptRoot

# 用 python -m PyInstaller 執行（避免 pyinstaller.exe 沒在 PATH 上的問題）
python -m PyInstaller --version *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Installing pyinstaller..." -ForegroundColor Yellow
    python -m pip install pyinstaller
    if ($LASTEXITCODE -ne 0) {
        Write-Host "pip install pyinstaller failed." -ForegroundColor Red
        exit 1
    }
}

Remove-Item -Recurse -Force build, dist, AutoHotkeyPy.spec -ErrorAction SilentlyContinue

# --add-data "ui;ui"  把 HTML/CSS 一起打包（pywebview 需要）
# --uac-admin         exe 啟動時要求管理員權限
# --noconsole         不開 console 視窗
python -m PyInstaller --noconfirm `
    --onefile `
    --noconsole `
    --uac-admin `
    --name AutoHotkeyPy `
    --add-data "ui;ui" `
    main.py

$exe = Join-Path $PSScriptRoot "dist\AutoHotkeyPy.exe"
if ($LASTEXITCODE -eq 0 -and (Test-Path $exe)) {
    Write-Host ""
    Write-Host "Build OK: $exe" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "Build failed (exit=$LASTEXITCODE, exe exists=$((Test-Path $exe)))." -ForegroundColor Red
    exit 1
}
