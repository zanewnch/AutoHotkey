$ErrorActionPreference = "Stop"

$repo = Split-Path -Parent $PSScriptRoot
$main = Get-Content -Raw -Path (Join-Path $repo "main.ahk")

if ($main -notmatch '(?m)^#SingleInstance\s+Force\s*$') {
    throw "main.ahk must use #SingleInstance Force"
}

if ($main -notmatch 'SetTimer\(RefreshKeyboardHook,\s*-\d+\)') {
    throw "main.ahk must schedule the first keyboard hook refresh"
}

if ($main -notmatch 'SetTimer\(RefreshKeyboardHook,\s*\d+\)') {
    throw "RefreshKeyboardHook must keep running periodically"
}

if ($main -notmatch 'RefreshKeyboardHook\(\)\s*\{[\s\S]*InstallKeybdHook\(true,\s*true\)') {
    throw "RefreshKeyboardHook must reinstall the keyboard hook"
}

Write-Host "AHK static checks passed"
