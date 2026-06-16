$ErrorActionPreference = "Stop"

$repo = Split-Path -Parent $PSScriptRoot
$main = Get-Content -Raw -Path (Join-Path $repo "main.ahk")
$registry = Get-Content -Raw -Path (Join-Path $repo "modules\app_registry.ahk")
$startup = Get-Content -Raw -Path (Join-Path $repo "modules\startup.ahk")
$launcher = Get-Content -Raw -Path (Join-Path $repo "modules\app_launcher.ahk")

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

if ($startup -notmatch 'SetTimer\(StartupAutoSelect,\s*-1\)') {
    throw "startup.ahk must auto-select a startup profile before showing the prompt"
}

if ($startup -notmatch 'GetStartupProfileForDevice\(deviceName\s*:=\s*""\)') {
    throw "startup.ahk must resolve startup profile by device name"
}

if ($startup -notmatch 'case\s+"ZANEWANG-PC":[\s\S]*?return\s+"development"') {
    throw "ZANEWANG-PC must use the development startup profile"
}

if ($startup -notmatch 'default:\s*return\s+"prompt"') {
    throw "Unknown devices must fall back to the startup prompt"
}

if ($registry -notmatch 'ResolveLaunchTarget\(app\)') {
    throw "app_registry.ahk must resolve launch candidates before running apps"
}

if ($registry -notmatch 'ResolveLaunchCandidate\(candidate\)') {
    throw "app_registry.ahk must validate individual launch candidates"
}

if ($registry -notmatch 'ResolveLaunchTargets\(app\)') {
    throw "app_registry.ahk must keep all valid launch candidates so Run failures can fall through"
}

if ($registry -notmatch 'GetAppExeList\(app\)') {
    throw "app_registry.ahk must support multiple exe names per app"
}

$requiredLaunchFallbacks = @(
    'Chrome Apps\Google 日曆.lnk',
    'Chrome 應用程式\Google 日曆.lnk',
    'Chrome Apps\Google Chat.lnk',
    'Chrome 應用程式\Google Chat.lnk'
)

foreach ($fallback in $requiredLaunchFallbacks) {
    if (-not $registry.Contains($fallback)) {
        throw "Missing launch fallback: $fallback"
    }
}

$functionKeyApps = [ordered]@{
    F1 = "copilot"
    F2 = "line"
    F3 = "comet"
    F4 = "chrome"
    F5 = "edge"
    F6 = "vscode"
    F7 = "vscodeInsider"
    F8 = "chatgpt"
    F9 = "codex"
    F10 = "visualStudio"
    F11 = "googleCalendar"
    F12 = "googleChat"
}

$lastStartupIndex = -1
foreach ($entry in $functionKeyApps.GetEnumerator()) {
    $key = $entry.Key
    $app = $entry.Value

    if ($launcher -notmatch "(?m)^$key::ActivateOrRunApp\(`"$app`"") {
        throw "$key must launch $app"
    }

    $startupIndex = $startup.IndexOf("`"$app`"")
    if ($startupIndex -lt 0) {
        throw "Startup Development Mode must launch $app"
    }

    if ($startupIndex -lt $lastStartupIndex) {
        throw "Startup Development Mode app order must match F1-F12"
    }

    $lastStartupIndex = $startupIndex
}

Write-Host "AHK static checks passed"
