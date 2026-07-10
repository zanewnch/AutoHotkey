#Requires AutoHotkey v2.0+

; ============================================================
; App registry and launch helpers
; ============================================================
; Centralizes app metadata so startup and hotkeys share one source of truth.

global AppRegistry := BuildAppRegistry()

BuildAppRegistry() {
    return Map(
        "androidStudio", {type: "app", name: "Android Studio", exe: "studio64.exe", launch: [
            {kind: "lnk", path: CommonProgramsPath("Android Studio\Android Studio.lnk")}
        ]},
        "brave", {type: "app", name: "Brave", exe: "brave.exe", launch: [
            {kind: "lnk", path: CommonProgramsPath("Brave.lnk")},
            {kind: "exe", path: "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"}
        ]},
        "chrome", {type: "app", name: "Google Chrome", exe: "Chrome.exe", install: [
            {kind: "winget", id: "Google.Chrome", source: "winget"}
        ], launch: [
            ; Chrome profiles are not separate apps; chrome.exe uses --profile-directory to select one.
            ; Profiles on this device: Default = richitech.com.tw (last used), Profile 1 = zane.
            ; F4 targets richitech.com.tw by opening Default. Every device has its own first profile
            ; named Default, so richitech.com.tw must remain that device's first Chrome profile.
            {kind: "exe", path: "C:\Program Files\Google\Chrome\Application\chrome.exe", args: '--profile-directory="Default"'},
            {kind: "lnk", path: CommonProgramsPath("Google Chrome.lnk")},
            {kind: "exe", path: "C:\Program Files\Google\Chrome\Application\chrome.exe"}
        ]},
        "claude", {type: "app", name: "Claude", exe: "Claude.exe", launch: [
            {kind: "appId", path: "shell:AppsFolder\Claude_pzs8sxrjxfjjc!Claude"}
        ]},
        "chatgpt", {type: "app", name: "ChatGPT", exe: "ChatGPT.exe", install: [
            {kind: "winget", id: "9PLM9XGG6VKS", source: "msstore"}
        ], launch: [
            {kind: "appId", path: "shell:AppsFolder\OpenAI.Codex_2p2nqsd0c76g0!App"}
        ]},
        "comet", {type: "app", name: "Comet", exe: "comet.exe", install: [
            {kind: "winget", id: "Perplexity.Comet", source: "winget"}
        ], launch: [
            {kind: "lnk", path: UserProgramsPath("Comet.lnk")},
            {kind: "exe", path: LocalAppDataPath("Perplexity\Comet\Application\comet.exe")}
        ]},
        "copilot", {type: "app", name: "Microsoft Copilot", exe: ["mscopilot.exe", "Copilot.exe"], install: [
            {kind: "winget", id: "XP9CXNGPPJ97XX", source: "msstore"}
        ], launch: [
            {kind: "appId", path: "shell:AppsFolder\Microsoft.Copilot_8wekyb3d8bbwe!App"},
            {kind: "uri", path: "ms-copilot:"}
        ]},
        "cursor", {type: "app", name: "Cursor", exe: "cursor.exe", launch: [
            {kind: "lnk", path: UserProgramsPath("Cursor\Cursor.lnk")},
            {kind: "lnk", path: CommonProgramsPath("Cursor\Cursor.lnk")},
            {kind: "exe", path: LocalAppDataPath("Programs\cursor\Cursor.exe")}
        ]},
        "edge", {type: "app", name: "Microsoft Edge", exe: "msedge.exe", install: [
            {kind: "winget", id: "Microsoft.Edge", source: "winget"}
        ], launch: [
            {kind: "lnk", path: CommonProgramsPath("Microsoft Edge.lnk")},
            {kind: "exe", path: "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"}
        ]},
        "chatgptClassic", {type: "app", name: "ChatGPT Classic", exe: "ChatGPT Classic.exe", install: [
            {kind: "winget", id: "9NT1R1C2HH7J", source: "msstore"}
        ], launch: [
            {kind: "appId", path: "shell:AppsFolder\OpenAI.ChatGPT-Desktop_2p2nqsd0c76g0!ChatGPT"}
        ]},
        "line", {type: "app", name: "LINE", exe: "LINE.exe", install: [
            {kind: "winget", id: "XPFCC4CD725961", source: "msstore"}
        ], launch: [
            {kind: "lnk", path: UserProgramsPath("LINE\LINE.lnk")},
            {kind: "exe", path: LocalAppDataPath("LINE\bin\LineLauncher.exe")}
        ]},
        "notion", {type: "app", name: "Notion", exe: "Notion.exe", install: [
            {kind: "winget", id: "Notion.Notion", source: "winget"}
        ], launch: [
            {kind: "lnk", path: UserProgramsPath("Notion.lnk")}
        ]},
        "visualStudio", {type: "app", name: "Visual Studio", exe: "devenv.exe", launch: [
            {kind: "lnk", path: CommonProgramsPath("Visual Studio.lnk")},
            {kind: "exe", path: "C:\Program Files\Microsoft Visual Studio\18\Professional\Common7\IDE\devenv.exe"},
            {kind: "exe", path: "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"},
            {kind: "exe", path: "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"},
            {kind: "exe", path: "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\devenv.exe"}
        ]},
        "vscode", {type: "app", name: "Visual Studio Code", exe: "Code.exe", install: [
            {kind: "winget", id: "Microsoft.VisualStudioCode", source: "winget"}
        ], launch: [
            {kind: "lnk", path: UserProgramsPath("Visual Studio Code\Visual Studio Code.lnk")},
            {kind: "exe", path: LocalAppDataPath("Programs\Microsoft VS Code\Code.exe")}
        ]},
        "vscodeInsider", {type: "app", name: "Visual Studio Code Insiders", exe: "Code - Insiders.exe", install: [
            {kind: "winget", id: "Microsoft.VisualStudioCode.Insiders", source: "winget"}
        ], launch: [
            {kind: "lnk", path: UserProgramsPath("Visual Studio Code - Insiders\Visual Studio Code - Insiders.lnk")},
            {kind: "exe", path: LocalAppDataPath("Programs\Microsoft VS Code Insiders\Code - Insiders.exe")}
        ]},
        "webstorm", {type: "app", name: "WebStorm", exe: "WebStorm.exe", launch: [
            {kind: "lnk", path: UserProgramsPath("JetBrains Toolbox\WebStorm.lnk")}
        ]},
        "googleCalendar", {type: "pwa", name: "Google Calendar", titleMatch: ["Google 日曆", "Google Calendar"], install: [
            {kind: "winget", id: "Google.Chrome", source: "winget"}
        ], launch: [
            {kind: "lnk", path: UserProgramsPath("Chrome Apps\Google 日曆.lnk")},
            {kind: "lnk", path: UserProgramsPath("Chrome 應用程式\Google 日曆.lnk")},
            {kind: "lnk", path: UserProgramsPath("Chrome Apps\Google Calendar.lnk")},
            {kind: "lnk", path: UserProgramsPath("Chrome 應用程式\Google Calendar.lnk")},
            {kind: "uri", path: "https://calendar.google.com/calendar/u/0/r"}
        ]},
        "googleChat", {type: "pwa", name: "Google Chat", titleMatch: "Google Chat", install: [
            {kind: "winget", id: "Google.Chrome", source: "winget"}
        ], launch: [
            {kind: "lnk", path: UserProgramsPath("Chrome Apps\Google Chat.lnk")},
            {kind: "lnk", path: UserProgramsPath("Chrome 應用程式\Google Chat.lnk")},
            {kind: "uri", path: "https://chat.google.com"}
        ]}
    )
}

CommonProgramsPath(relativePath) {
    return EnvGet("ProgramData") "\Microsoft\Windows\Start Menu\Programs\" relativePath
}

UserProgramsPath(relativePath) {
    return A_AppData "\Microsoft\Windows\Start Menu\Programs\" relativePath
}

LocalAppDataPath(relativePath) {
    return EnvGet("LOCALAPPDATA") "\" relativePath
}

GetRegisteredApp(key) {
    global AppRegistry

    if !AppRegistry.Has(key) {
        MsgBox("找不到 app 設定: " key, "App Registry 錯誤", "Icon!")
        return ""
    }

    return AppRegistry[key]
}

EnsureAppRunning(key) {
    app := GetRegisteredApp(key)
    if !IsObject(app)
        return false

    if (app.type = "pwa") {
        if FindExistingPwaWindow(app)
            return true
    } else {
        for exe in GetAppExeList(app) {
            if WinExist("ahk_exe " exe)
                return true
        }
    }

    return RunRegisteredApp(app)
}

ActivateOrRunApp(key, excludeTitles := "") {
    app := GetRegisteredApp(key)
    if !IsObject(app)
        return false

    if (app.type = "pwa") {
        hwnd := FindExistingPwaHwnd(app)
        if hwnd {
            ToggleAppWindow(hwnd)
            return true
        }
        return RunRegisteredApp(app)
    }

    hwnd := FindExistingAppWindowHwnd(app, excludeTitles)
    if hwnd {
        ToggleAppWindow(hwnd)
        return true
    }

    return RunRegisteredApp(app)
}

ActivateOrRunStartupApp(key, excludeTitles := "") {
    app := GetRegisteredApp(key)
    if !IsObject(app)
        return false

    if (app.type = "pwa") {
        hwnd := FindExistingPwaHwnd(app)
        if hwnd {
            WinActivate(hwnd)
            return true
        }
        return RunRegisteredApp(app)
    }

    if ActivateExistingAppWindow(app, excludeTitles)
        return true

    return RunRegisteredApp(app)
}

GetAppExeList(app) {
    if !app.HasProp("exe")
        return []

    return IsObject(app.exe) ? app.exe : [app.exe]
}

GetAppTitleList(app) {
    if !app.HasProp("titleMatch")
        return []

    return IsObject(app.titleMatch) ? app.titleMatch : [app.titleMatch]
}

FindExistingPwaWindow(app) {
    return !!FindExistingPwaHwnd(app)
}

FindExistingPwaHwnd(app) {
    for title in GetAppTitleList(app) {
        if WinExist(title)
            return WinGetID(title)
    }

    return 0
}

ActivateExistingAppWindow(app, excludeTitles := "") {
    hwnd := FindExistingAppWindowHwnd(app, excludeTitles)
    if !hwnd
        return false

    WinActivate(hwnd)
    return true
}

FindExistingAppWindowHwnd(app, excludeTitles := "") {
    for exe in GetAppExeList(app) {
        winTitle := "ahk_exe " exe

        if !WinExist(winTitle)
            continue

        if !IsObject(excludeTitles) || excludeTitles.Length = 0 {
            return WinGetID(winTitle)
        }

        for hwnd in WinGetList(winTitle) {
            title := WinGetTitle(hwnd)
            excluded := false

            for excludedTitle in excludeTitles {
                if InStr(title, excludedTitle) {
                    excluded := true
                    break
                }
            }

            if !excluded {
                return hwnd
            }
        }
    }

    return 0
}

ToggleAppWindow(hwnd) {
    if WinActive("ahk_id " hwnd)
        WinMinimize(hwnd)
    else
        WinActivate(hwnd)
}

RunRegisteredApp(app, allowInstall := true) {
    targets := ResolveLaunchTargets(app)

    if (targets.Length = 0) {
        return PromptInstallRegisteredApp(app, allowInstall, "找不到可用的啟動路徑。")
    }

    lastError := ""
    for target in targets {
        try {
            Run(target)
            return true
        } catch as err {
            lastError := err.Message
        }
    }

    if PromptInstallRegisteredApp(app, allowInstall, "啟動失敗:`n" lastError)
        return true

    MsgBox("啟動 " app.name " 失敗:`n" lastError, "App 啟動錯誤", "Icon!")
    return false
}

ResolveLaunchTarget(app) {
    targets := ResolveLaunchTargets(app)
    return targets.Length = 0 ? "" : targets[1]
}

ResolveLaunchTargets(app) {
    targets := []

    if app.HasProp("launch") {
        for candidate in app.launch {
            target := ResolveLaunchCandidate(candidate)
            if (target != "")
                targets.Push(target)
        }
    }

    if app.HasProp("path") {
        candidate := {kind: "legacy", path: app.path}
        if app.HasProp("checkPath")
            candidate.checkPath := app.checkPath

        target := ResolveLaunchCandidate(candidate)
        if (target != "")
            targets.Push(target)
    }

    return targets
}

ResolveLaunchCandidate(candidate) {
    if !candidate.HasProp("path")
        return ""

    checkPath := ShouldCheckLaunchPath(candidate)
    if checkPath && !FileExist(candidate.path)
        return ""

    if candidate.HasProp("args") && (candidate.args != "")
        return ShellArg(candidate.path) " " candidate.args

    return candidate.path
}

ShouldCheckLaunchPath(candidate) {
    if candidate.HasProp("checkPath")
        return candidate.checkPath

    if !candidate.HasProp("kind")
        return true

    return candidate.kind = "lnk" || candidate.kind = "exe" || candidate.kind = "legacy"
}

PromptInstallRegisteredApp(app, allowInstall, reason) {
    if !allowInstall || !HasInstallCandidates(app)
        return false

    result := MsgBox(reason "`n`n要用 winget 安裝 " app.name " 嗎？", "App 安裝確認", "YesNo Icon?")
    if (result != "Yes")
        return false

    if !InstallRegisteredApp(app)
        return false

    return RunRegisteredApp(app, false)
}

HasInstallCandidates(app) {
    return GetInstallCandidates(app).Length > 0
}

GetInstallCandidates(app) {
    if !app.HasProp("install")
        return []

    return IsArrayLike(app.install) ? app.install : [app.install]
}

IsArrayLike(value) {
    return IsObject(value) && value.HasProp("Length")
}

InstallRegisteredApp(app) {
    if !WingetIsAvailable() {
        MsgBox("找不到 winget，無法自動安裝 " app.name "。", "App 安裝警告", "Icon!")
        return false
    }

    lastError := ""
    for candidate in GetInstallCandidates(app) {
        command := BuildInstallCommand(candidate)
        if (command = "")
            continue

        exitCode := RunWait(command, , "Min")
        if (exitCode = 0)
            return true

        lastError := "winget exit code: " exitCode
    }

    MsgBox("安裝 " app.name " 失敗。`n" lastError, "App 安裝錯誤", "Icon!")
    return false
}

WingetIsAvailable() {
    try {
        RunWait('winget --version', , "Hide")
        return true
    } catch {
        return false
    }
}

BuildInstallCommand(candidate) {
    if !candidate.HasProp("kind") || candidate.kind != "winget"
        return ""

    command := "winget install --exact --accept-package-agreements --accept-source-agreements"

    if candidate.HasProp("source")
        command .= " --source " ShellArg(candidate.source)

    if candidate.HasProp("id")
        command .= " --id " ShellArg(candidate.id)
    else if candidate.HasProp("name")
        command .= " --name " ShellArg(candidate.name)
    else
        return ""

    return command
}

ShellArg(value) {
    return "`"" value "`""
}

ShowAppLaunchDiagnostics() {
    global AppRegistry

    report := ""
    for key, app in AppRegistry {
        target := ResolveLaunchTarget(app)
        status := target = "" ? "missing" : target
        installStatus := HasInstallCandidates(app) ? "installable" : "no installer"
        report .= key " -> " status " (" installStatus ")`n"
    }

    MsgBox(report, "App Launch Diagnostics")
}

ResetKeyboardHook() {
    InstallKeybdHook(true, true)
}
