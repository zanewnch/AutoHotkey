---
name: ahk-app-launcher-shortcuts
description: Maintain this AutoHotkey repo's app launcher shortcuts. Use when adding, changing, or validating F-key/app hotkeys in modules/app_launcher.ahk and app metadata in modules/app_registry.ahk, especially when launch behavior depends on Windows shortcuts, AppX AppsFolder IDs, or exe-based window activation.
---

# AHK App Launcher Shortcuts

## Workflow

1. Read `modules/app_launcher.ahk` and `modules/app_registry.ahk` first.
2. Verify app identity before editing:
   - Running exe: `Get-Process | Where-Object { $_.ProcessName -match '<name>' } | Select ProcessName,Path`
   - Start menu app IDs: `Get-StartApps | Where-Object { $_.Name -match '<name>' }`
   - Shortcuts: inspect `.lnk` targets with `WScript.Shell.CreateShortcut()`.
3. In `AppRegistry`, keep each app as `{type, name, exe, path}`.
4. In `app_launcher.ahk`, keep hotkeys thin: `F1::ActivateOrRunApp("key")`.
5. Validate with:
   - `powershell -ExecutionPolicy Bypass -File tests\ahk_static_checks.ps1`
   - `AutoHotkey64.exe /ErrorStdOut /Validate main.ahk` when AutoHotkey is installed.
6. Keep this skill in the repo and git-track it. Do not add `skills/` to `.gitignore`.

## Path Strategy

Use `exe` for activation and `path` only for launch fallback.

Prefer stable launch paths in this order:

1. Start Menu `.lnk` for normal desktop apps.
2. `shell:AppsFolder\<AppID>` for Microsoft Store/AppX apps.
3. Direct `.exe` path only when no stable shortcut or AppID exists.

Avoid `C:\Program Files\WindowsApps\...\app.exe` for Store/AppX apps because versioned package folders change.

## Current F-Key Map

```text
F1  copilot
F2  line
F3  comet
F4  chrome
F5  edge
F6  vscode
F7  vscodeInsider
F8  chatgpt
F9  codex
F10 visualStudio
F11 googleCalendar
F12 googleChat
```

## Known Stable Entries

```ahk
"copilot", {type: "app", name: "Microsoft Copilot", exe: "mscopilot.exe", path: "shell:AppsFolder\Microsoft.Copilot_8wekyb3d8bbwe!App", checkPath: false}
"chatgpt", {type: "app", name: "ChatGPT", exe: "ChatGPT.exe", path: "shell:AppsFolder\OpenAI.ChatGPT-Desktop_2p2nqsd0c76g0!ChatGPT", checkPath: false}
"codex", {type: "app", name: "Codex", exe: "Codex.exe", path: "shell:AppsFolder\OpenAI.Codex_2p2nqsd0c76g0!App", checkPath: false}
"comet", {type: "app", name: "Comet", exe: "comet.exe", path: UserProgramsPath("Comet.lnk")}
"vscodeInsider", {type: "app", name: "Visual Studio Code Insiders", exe: "Code - Insiders.exe", path: UserProgramsPath("Visual Studio Code - Insiders\Visual Studio Code - Insiders.lnk")}
"visualStudio", {type: "app", name: "Visual Studio", exe: "devenv.exe", path: CommonProgramsPath("Visual Studio.lnk")}
```
