#Requires AutoHotkey v2.0+

; ============================================================
; App registry and launch helpers
; ============================================================
; Centralizes app metadata so startup and hotkeys share one source of truth.

global AppRegistry := BuildAppRegistry()

BuildAppRegistry() {
    return Map(
        "androidStudio", {type: "app", name: "Android Studio", exe: "studio64.exe", path: CommonProgramsPath("Android Studio\Android Studio.lnk")},
        "brave", {type: "app", name: "Brave", exe: "brave.exe", path: "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"},
        "chrome", {type: "app", name: "Google Chrome", exe: "Chrome.exe", path: CommonProgramsPath("Google Chrome.lnk")},
        "claude", {type: "app", name: "Claude", exe: "Claude.exe", path: "shell:AppsFolder\Claude_pzs8sxrjxfjjc!Claude", checkPath: false},
        "copilot", {type: "app", name: "Microsoft Copilot", exe: "Copilot.exe", path: "ms-copilot:", checkPath: false},
        "cursor", {type: "app", name: "Cursor", exe: "cursor.exe", path: LocalAppDataPath("Programs\cursor\Cursor.exe")},
        "edge", {type: "app", name: "Microsoft Edge", exe: "msedge.exe", path: CommonProgramsPath("Microsoft Edge.lnk")},
        "line", {type: "app", name: "LINE", exe: "LINE.exe", path: UserProgramsPath("LINE\LINE.lnk")},
        "notion", {type: "app", name: "Notion", exe: "Notion.exe", path: UserProgramsPath("Notion.lnk")},
        "vscode", {type: "app", name: "Visual Studio Code", exe: "Code.exe", path: UserProgramsPath("Visual Studio Code\Visual Studio Code.lnk")},
        "webstorm", {type: "app", name: "WebStorm", exe: "WebStorm.exe", path: UserProgramsPath("JetBrains Toolbox\WebStorm.lnk")},
        "googleCalendar", {type: "pwa", name: "Google Calendar", titleMatch: "Google 日曆", path: UserProgramsPath("Chrome Apps\Google 日曆.lnk")},
        "googleChat", {type: "pwa", name: "Google Chat", titleMatch: "Google Chat", path: UserProgramsPath("Chrome 應用程式\Google Chat.lnk")}
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
        if WinExist(app.titleMatch)
            return true
    } else if WinExist("ahk_exe " app.exe) {
        return true
    }

    return RunRegisteredApp(app)
}

ActivateOrRunApp(key, excludeTitles := "") {
    app := GetRegisteredApp(key)
    if !IsObject(app)
        return false

    if (app.type = "pwa") {
        if WinExist(app.titleMatch) {
            WinActivate()
            return true
        }
        return RunRegisteredApp(app)
    }

    if ActivateExistingAppWindow(app.exe, excludeTitles)
        return true

    return RunRegisteredApp(app)
}

ActivateExistingAppWindow(exe, excludeTitles := "") {
    winTitle := "ahk_exe " exe

    if !WinExist(winTitle)
        return false

    if !IsObject(excludeTitles) || excludeTitles.Length = 0 {
        WinActivate()
        return true
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
            WinActivate(hwnd)
            return true
        }
    }

    return false
}

RunRegisteredApp(app) {
    checkPath := !app.HasProp("checkPath") || app.checkPath

    if checkPath && !FileExist(app.path) {
        MsgBox("找不到 " app.name " 的啟動路徑:`n" app.path, "App 啟動警告", "Icon!")
        return false
    }

    try {
        Run(app.path)
        return true
    } catch as err {
        MsgBox("啟動 " app.name " 失敗:`n" err.Message, "App 啟動錯誤", "Icon!")
        return false
    }
}

ResetKeyboardHook() {
    InstallKeybdHook(true, true)
}
