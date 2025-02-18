#Requires AutoHotkey v2.0+

; ======================================
; Core Configuration
; ======================================
SendMode("Input")
SetTitleMatchMode(2)
SetWorkingDir(A_ScriptDir)

; ======================================
; Global Status Control

;我添加了三个全局状态控制变量：
;1. ENABLE_AUTO_INIT：控制脚本启动时的自动初始化
;默认设置为 false，禁用自动启动所有应用
;影响 ApplicationManager.Initialize()
;ENABLE_PRODUCTIVITY：控制生产力套件（F8功能）
;默认设置为 true，保持 F8 功能可用
;影响 ProductivitySuite.InitializeLayout() 和 F8 热键
;ENABLE_APP_LAUNCH：控制单个应用程序的快捷键启动
;默认设置为 true，保持功能键快捷方式可用
;影响所有功能键（F1-F13）的应用程序启动
; ======================================
global ENABLE_AUTO_INIT := false      ; Control automatic initialization
global ENABLE_PRODUCTIVITY := true    ; Control F8 productivity suite
global ENABLE_APP_LAUNCH := true      ; Control individual app launch hotkeys
global isGoogleTranslate := false     ; New global status: if false, skip googleTranslate

; ======================================
; Debug System
; ======================================
debugMode := true
debugFile := A_ScriptDir "\debug.log"

DebugLog(msg) {
    global debugMode, debugFile
    if debugMode {
        timeStamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss.fff")
        FileAppend("[" timeStamp "] " msg "`n", debugFile)
    }
}

; ======================================
; Global State Management
; ======================================
class ApplicationManager {
    static apps := [
        {
            name: "LINE",
            exe: "LINE.exe",
            path: "C:\Users\user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\LINE\LINE.lnk"
        },
        {
            name: "YouTube Music",
            exe: "msedge.exe",
            path: "C:\Users\user\Desktop\YouTubeMusic.lnk",
            isEdgeApp: true,
            title: "YouTube Music"
        },
        {
            name: "Android Studio",
            exe: "studio64.exe",
            path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Android Studio\Android Studio.lnk"
        },
        {
            name: "VS Code Insiders",
            exe: "Code - Insiders.exe",
            path: "C:\Users\user\AppData\Local\Programs\Microsoft VS Code Insiders\Code - Insiders.exe"
        },
        {
            name: "Cursor",
            exe: "cursor.exe",
            path: "C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe"
        },
        {
            name: "Edge",
            exe: "msedge.exe",
            path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk",
            isMainBrowser: true
        },
        {
            name: "Notion",
            exe: "notion.exe",
            path: "C:\Users\user\AppData\Local\Programs\Notion\Notion.exe"
        }
    ]

    static Initialize() {
        if (!ENABLE_AUTO_INIT) {
            DebugLog("ApplicationManager | Initialization disabled")
            return
        }

        DebugLog("ApplicationManager | Starting initialization")
        launchQueue := []

        ; First check existing processes
        for app in this.apps {
            if app.HasProp("isEdgeApp") && app.isEdgeApp {
                ; Handle Edge-based apps differently
                if !this.CheckEdgeApp(app.title) {
                    launchQueue.Push(app)
                }
            } else if app.HasProp("isMainBrowser") && app.isMainBrowser {
                ; Handle main Edge browser
                if !this.CheckMainEdge() {
                    launchQueue.Push(app)
                }
            } else {
                ; Handle regular applications
                if !WinExist("ahk_exe " app.exe) {
                    launchQueue.Push(app)
                }
            }
        }

        ; Launch missing applications
        if (launchQueue.Length > 0) {
            this.LaunchApps(launchQueue)
        }

        DebugLog("ApplicationManager | Regular apps initialization completed")

        ; Now handle ProductivitySuite apps separately to avoid duplication
        this.InitializeProductivityApps()
    }

    static InitializeProductivityApps() {
        launchQueue := []

        ; Check ProductivitySuite apps
        for app in ProductivitySuite.apps {
            found := false
            windows := WinGetList("ahk_exe msedge.exe")
            for hwnd in windows {
                title := WinGetTitle(hwnd)
                if InStr(title, app.title) {
                    found := true
                    ; Store the window handle for ProductivitySuite
                    ProductivitySuite.windowHandles[app.name] := hwnd
                    break
                }
            }
            if !found {
                launchQueue.Push({
                    name: app.name,
                    exe: "msedge.exe",
                    path: app.path,
                    isEdgeApp: true,
                    args: app.args,
                    title: app.title
                })
            }
        }

        ; Launch missing Productivity apps
        if (launchQueue.Length > 0) {
            this.LaunchApps(launchQueue)
            ; Give some time for windows to appear
            Sleep(1000)

            ; Update ProductivitySuite window handles
            windows := WinGetList("ahk_exe msedge.exe")
            for hwnd in windows {
                title := WinGetTitle(hwnd)
                for app in ProductivitySuite.apps {
                    if InStr(title, app.title) {
                        ProductivitySuite.windowHandles[app.name] := hwnd
                    }
                }
            }
        }

        DebugLog("ApplicationManager | Productivity apps initialization completed")
    }

    static CheckEdgeApp(title) {
        if WinExist("ahk_exe msedge.exe") {
            windows := WinGetList("ahk_exe msedge.exe")
            for hwnd in windows {
                if InStr(WinGetTitle(hwnd), title) {
                    return true
                }
            }
        }
        return false
    }

    static CheckMainEdge() {
        if WinExist("ahk_exe msedge.exe") {
            windows := WinGetList("ahk_exe msedge.exe")
            for hwnd in windows {
                title := WinGetTitle(hwnd)
                if !InStr(title, "--app=")
                    && !InStr(title, "GoogleTranslate")
                    && !InStr(title, "Perplexity")
                    && !InStr(title, "LocalFrontend")
                    && !InStr(title, "YouTube Music")
                    && !InStr(title, "Gemini") {
                    return true
                }
            }
        }
        return false
    }

    static LaunchApps(queue) {
        DebugLog("ApplicationManager | Launching " queue.Length " applications")

        ; Launch applications with a small delay between each
        for app in queue {
            try {
                if (app.isEdgeApp && app.args) {
                    ; Handle Edge apps with special arguments
                    shell := ComObject("WScript.Shell")
                    shortcut := shell.CreateShortcut(app.path)
                    actualCommand := shortcut.TargetPath " " shortcut.Arguments
                    Run(actualCommand " --force-device-scale-factor=1 " app.args)
                } else {
                    ; Launch regular applications
                    Run(app.path)
                }
                DebugLog("ApplicationManager | Launched: " app.name)
                Sleep(200)  ; Small delay between launches
            } catch as err {
                DebugLog("ApplicationManager | Error launching " app.name ": " err.Message)
            }
        }
    }
}

class ProductivitySuite {
    static apps := [
        {name: "Perplexity",
         path: "C:\Users\user\Desktop\Perplexity.lnk",
         exe: "msedge.exe",
         args: "--profile-directory=ProfilePPL",
         title: "Perplexity"
        },
        {name: "googleTranslate",
         path: "C:\Users\user\Desktop\googleTranslate.lnk",
         exe: "msedge.exe",
         args: "--app=https://translate.google.com",
         title: "GoogleTranslate"
        },
        {name: "Gemini",
         path: "C:\Users\user\Desktop\Gemini.lnk",
         exe: "msedge.exe",
         args: "--app=https://gemini.google.com",
         title: "Gemini"
        }
    ]

    static windowHandles := Map()
    static isLayoutInitialized := false
    static layoutConfig := Map()

    static InitializeLayout() {
        if (!ENABLE_PRODUCTIVITY) {
            DebugLog("ProductivitySuite | Layout initialization disabled")
            return
        }

        if (this.isLayoutInitialized) {
            return
        }

        ; Cache monitor layout configuration
        MonitorGetWorkArea(1, &L, &T, &R, &B)
        totalWidth := R - L
        if (!isGoogleTranslate) {
            this.layoutConfig := {
                left: L,
                top: T,
                width: totalWidth,
                height: B - T,
                perpWidth: Round(totalWidth * 0.7),
                geminiWidth: totalWidth - Round(totalWidth * 0.7)
            }
            DebugLog("ProductivitySuite | Initializing layout (GoogleTranslate disabled, 7:3 ratio)")
        } else {
            this.layoutConfig := {
                left: L,
                top: T,
                width: totalWidth,
                height: B - T,
                perpWidth: Round(totalWidth * 0.6),
                transWidth: Round(totalWidth * 0.2)
            }
            this.layoutConfig.geminiWidth := totalWidth - this.layoutConfig.perpWidth - this.layoutConfig.transWidth
            DebugLog("ProductivitySuite | Initializing layout (GoogleTranslate enabled)")
        }

        ; First update window handles to find existing windows
        this.UpdateWindowHandles()

        ; Only arrange windows if we need to launch new ones
        needsArrange := false
        if (!isGoogleTranslate) {
            for app in this.apps {
                if (app.name = "googleTranslate")
                    continue
                if !this.windowHandles.Has(app.name) {
                    needsArrange := true
                    break
                }
            }
        } else {
            for app in this.apps {
                if !this.windowHandles.Has(app.name) {
                    needsArrange := true
                    break
                }
            }
        }

        if (needsArrange) {
            this.ArrangeWindows(true)
        } else {
            DebugLog("ProductivitySuite | All windows exist, skipping arrangement")
        }

        this.isLayoutInitialized := true
    }

    static LaunchApps() {
        launchedPIDs := []

        ; Prepare all commands first
        commands := []
        for app in this.apps {
            if (!isGoogleTranslate && app.name = "googleTranslate")
                continue
            if !this.windowHandles.Has(app.name) {
                shell := ComObject("WScript.Shell")
                shortcut := shell.CreateShortcut(app.path)
                actualCommand := shortcut.TargetPath " " shortcut.Arguments
                commands.Push({
                    name: app.name,
                    cmd: actualCommand " --force-device-scale-factor=1 " app.args
                })
            }
        }

        ; Sort commands to ensure Perplexity is first, Gemini second, and GoogleTranslate third
        sortedCommands := []

        ; First add Perplexity if it exists
        for cmd in commands {
            if (cmd.name = "Perplexity") {
                sortedCommands.Push(cmd)
                break
            }
        }

        ; Then add Gemini if it exists
        for cmd in commands {
            if (cmd.name = "Gemini") {
                sortedCommands.Push(cmd)
                break
            }
        }

        ; Finally add remaining commands
        for cmd in commands {
            if (cmd.name != "Perplexity" && cmd.name != "Gemini") {
                sortedCommands.Push(cmd)
            }
        }

        ; Launch all apps simultaneously
        for cmd in sortedCommands {
            Run(cmd.cmd,,, &pid)
            launchedPIDs.Push({name: cmd.name, pid: pid})
            Sleep(10)  ; Minimal delay to prevent system overload
        }

        return launchedPIDs
    }

    static ArrangeWindows(isInitialSetup := false) {
        ; Update window handles first
        this.UpdateWindowHandles()

        ; Launch missing applications
        launchedPIDs := this.LaunchApps()

        ; Wait for new windows (shorter wait time for subsequent calls)
        if (launchedPIDs.Length > 0) {
            maxWait := isInitialSetup ? 5000 : 2000
            startTime := A_TickCount
            remainingPIDs := launchedPIDs.Length

            while (A_TickCount - startTime < maxWait && remainingPIDs > 0) {
                for pid in launchedPIDs {
                    if (pid.pid = 0)
                        continue

                    if WinExist("ahk_pid " pid.pid) {
                        this.windowHandles[pid.name] := WinGetID("ahk_pid " pid.pid)
                        pid.pid := 0  ; Mark as found
                        remainingPIDs--
                    }
                }
                Sleep(50)
            }
        }

        ; Position windows efficiently
        this.PositionWindows()

        ; Finally, ensure Perplexity is the active window
        if this.windowHandles.Has("Perplexity") {
            Sleep(100)  ; Small delay to ensure window activation works
            WinActivate("ahk_id " this.windowHandles["Perplexity"])
        }
    }

    static UpdateWindowHandles() {
        ; Clear invalid handles first
        for appName, hwnd in this.windowHandles {
            if !WinExist("ahk_id " hwnd) {
                this.windowHandles.Delete(appName)
            }
        }

        ; Find missing windows
        windows := WinGetList("ahk_exe msedge.exe")
        for hwnd in windows {
            title := WinGetTitle(hwnd)
            for app in this.apps {
                if (!isGoogleTranslate && app.name = "googleTranslate")
                    continue
                if !this.windowHandles.Has(app.name) {
                    if ((app.name = "Perplexity" && InStr(title, "Perplexity"))
                        || (app.name = "googleTranslate" && InStr(title, "GoogleTranslate"))
                        || (app.name = "Gemini" && InStr(title, "Gemini"))) {
                        this.windowHandles[app.name] := hwnd
                    }
                }
            }
        }
    }

    static PositionWindows() {
        ; Use cached layout configuration
        cfg := this.layoutConfig

        ; Position all windows in a single pass
        for appName, hwnd in this.windowHandles {
            try {
                if WinExist("ahk_id " hwnd) {
                    if (!isGoogleTranslate) {
                        switch appName {
                            case "Perplexity":
                                WinMove(hwnd,, cfg.left, cfg.top, cfg.perpWidth, cfg.height)
                                WinSetAlwaysOnTop(true, hwnd)
                            case "Gemini":
                                WinMove(hwnd,, cfg.left + cfg.perpWidth, cfg.top, cfg.geminiWidth, cfg.height)
                        }
                    } else {
                        switch appName {
                            case "Perplexity":
                                WinMove(hwnd,, cfg.left, cfg.top, cfg.perpWidth, cfg.height)
                                WinSetAlwaysOnTop(true, hwnd)
                            case "googleTranslate":
                                WinMove(hwnd,, cfg.left + cfg.perpWidth, cfg.top, cfg.transWidth, cfg.height)
                            case "Gemini":
                                WinMove(hwnd,, cfg.left + cfg.perpWidth + cfg.transWidth, cfg.top, cfg.geminiWidth, cfg.height)
                        }
                    }
                }
            } catch as err {
                DebugLog("ProductivitySuite | Error moving window: " err.Message)
            }
        }
    }

    static QuickActivate() {
        ; Activate windows in original order
        if (!isGoogleTranslate) {
            for appName in ["Perplexity", "Gemini"] {
                if this.windowHandles.Has(appName) {
                    WinActivate("ahk_id " this.windowHandles[appName])
                    Sleep(20)  ; Small delay between activations
                }
            }

            ; Extra activation of Perplexity at the end to ensure it's the current window
            if this.windowHandles.Has("Perplexity") {
                Sleep(100)  ; Slightly longer delay before final activation
                WinActivate("ahk_id " this.windowHandles["Perplexity"])
            }
        } else {
            for appName in ["Perplexity", "googleTranslate", "Gemini"] {
                if this.windowHandles.Has(appName) {
                    WinActivate("ahk_id " this.windowHandles[appName])
                    Sleep(20)  ; Small delay between activations
                }
            }

            ; Extra activation of Perplexity at the end to ensure it's the current window
            if this.windowHandles.Has("Perplexity") {
                Sleep(100)  ; Slightly longer delay before final activation
                WinActivate("ahk_id " this.windowHandles["Perplexity"])
            }
        }
    }
}

; Initialize layout when script starts
SetTimer InitLayout, -500  ; Reduced initial delay to 500ms

InitLayout() {
    ProductivitySuite.InitializeLayout()
}

; ======================================
; Window Management Functions
; ======================================
ActivateEdgeWindow(windowKey, includeText, excludeTexts, runPath) {
    static edgePIDs := Map()
    DebugLog("EDGE | Entering function " windowKey)

    ; First check all Edge windows for a match
    if WinExist("ahk_exe msedge.exe") {
        windows := WinGetList("ahk_exe msedge.exe")
        for hwnd in windows {
            title := WinGetTitle(hwnd)
            DebugLog("EDGE | Checking window: " title)

            if InStr(title, includeText) {
                ; Found matching window
                WinActivate(hwnd)
                edgePIDs[windowKey] := WinGetPID(hwnd)
                DebugLog("EDGE | Activated existing window: " title)
                return
            }
        }
    }

    ; No matching window found, create new instance
    DebugLog("EDGE | No matching window found, launching: " runPath)
    try {
        shell := ComObject("WScript.Shell")
        shortcut := shell.CreateShortcut(runPath)
        actualCommand := shortcut.TargetPath " " shortcut.Arguments
        Run(actualCommand " --force-device-scale-factor=1",,, &pid)

        ; Wait for the window and store PID
        startTime := A_TickCount
        while (A_TickCount - startTime < 10000) {  ; 10 second timeout
            if WinExist("ahk_pid " pid) {
                edgePIDs[windowKey] := pid
                WinActivate("ahk_pid " pid)
                DebugLog("EDGE | New window launched and activated")
                return
            }
            Sleep(100)
        }
        DebugLog("EDGE | Window creation timeout for PID: " pid)
    } catch as err {
        DebugLog("EDGE | Error launching window: " err.Message)
    }
}

; ======================================
; Hotkey Definitions
; ======================================

F7:: {
    DebugLog("F7 | Launching Microsoft Edge Main Browser")

    mainEdgeFound := false
    if WinExist("ahk_exe msedge.exe") {
        windows := WinGetList("ahk_exe msedge.exe")
        for hwnd in windows {
            title := WinGetTitle(hwnd)
            ; Skip app windows and specific applications
            if !InStr(title, "--app=")
                && !InStr(title, "GoogleTranslate")
                && !InStr(title, "Perplexity")
                && !InStr(title, "LocalFrontend")
                && !InStr(title, "YouTube Music")
                && !InStr(title, "Gemini") {
                WinActivate(hwnd)
                mainEdgeFound := true
                DebugLog("F7 | Found and activated main Edge window")
                break
            }
        }
    }

    if !mainEdgeFound {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
        DebugLog("F7 | No main Edge window found, launching new instance")
        Sleep(300)  ; Wait for Edge to start
        WinWait("ahk_exe msedge.exe")
        WinActivate("ahk_exe msedge.exe")
    }
}

F8:: {
    DebugLog("F8 | Hotkey triggered")

    if (!ENABLE_PRODUCTIVITY) {
        DebugLog("F8 | Productivity suite disabled")
        return
    }

    try {
        if (!ProductivitySuite.isLayoutInitialized) {
            DebugLog("F8 | Initializing layout for the first time")
            ProductivitySuite.InitializeLayout()
        } else {
            DebugLog("F8 | Layout already initialized, checking windows")
            ; Quick check if any window is missing
            needsRearrange := false
            for appName, hwnd in ProductivitySuite.windowHandles {
                if !WinExist("ahk_id " hwnd) {
                    DebugLog("F8 | Window missing for: " appName)
                    needsRearrange := true
                    break
                }
            }

            if (needsRearrange) {
                DebugLog("F8 | Rearranging windows")
                ProductivitySuite.ArrangeWindows(false)
            } else {
                DebugLog("F8 | All windows exist, using quick activate")
                ProductivitySuite.QuickActivate()
            }
        }
    } catch as err {
        DebugLog("F8 | Error: " err.Message)
    }
}

; ======================================
; Application Shortcuts
; ======================================

; F1: LINE
F1:: {
    if (!ENABLE_APP_LAUNCH) {
        DebugLog("F1 | App launch disabled")
        return
    }
    if WinExist("ahk_exe LINE.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\LINE\LINE.lnk")
    }
}

; F2: File Explorer
F2:: {
    if WinExist("ahk_class CabinetWClass") {
        WinActivate()
    } else {
        Run("explorer.exe")
    }
}

; F3: YouTube Music
F3:: {
    ActivateEdgeWindow("YouTube Music", "YouTube Music", "", "C:\Users\user\Desktop\YouTubeMusic.lnk")
}

; F4: Android Studio
F4:: {
    if WinExist("ahk_exe studio64.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Android Studio\Android Studio.lnk")
    }
}

; F5: VS Code Insiders
F5:: {
    if WinExist("ahk_exe Code - Insiders.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Local\Programs\Microsoft VS Code Insiders\Code - Insiders.exe")
    }
}

; F6: Cursor
F6:: {
    if WinExist("ahk_exe cursor.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
    }
}

; F9: LocalFrontend
F9:: {
    ActivateEdgeWindow("LocalFrontend", "LocalFrontend", "", "C:\Users\user\Desktop\LocalFrontend.lnk")
}

; F10: Notion
F10:: {
    if WinExist("ahk_exe notion.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Local\Programs\Notion\Notion.exe")
    }
}

; F11: Visual Studio
F11:: {
    if WinExist("ahk_exe devenv.exe") {
        WinActivate()
    } else {
        Run("C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe")
    }
}

; F13: PyCharm
F13:: {
    if WinExist("ahk_exe pycharm64.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\JetBrains\PyCharm 2024.1.4.lnk")
    }
}

; ======================================
; System Enhancements
; ======================================

; Alt+Tab Alternative
~LCtrl & Tab::Send("{Alt down}{Tab}{Alt up}")

; Browser-Style Shortcuts
!a::Send("^a")  ; Alt+A = Select All
!c::Send("^c")  ; Alt+C = Copy
!x::Send("^x")  ; Alt+X = Cut
!v::Send("^v")  ; Alt+V = Paste
!s::Send("^s")  ; Alt+S = Save
!f::Send("^f")  ; Alt+F = Search
!w::Send("^w")  ; Alt+W = Close Tab
!t::Send("^t")  ; Alt+T = New Tab
!r::Send("^r")  ; Alt+R = Refresh
!z::Send("^z")  ; Alt+Z = Undo

; Navigation Shortcuts
!Left::Send("{Home}")    ; Alt+Left = Move to line start
!Right::Send("{End}")    ; Alt+Right = Move to line end
!Up::Send("{Home}")      ; Alt+Up = Move to line start
!Down::Send("{End}")     ; Alt+Down = Move to line end

; Selection Shortcuts
!+Left::Send("+{Home}")    ; Alt+Shift+Left = Select all text to the left of the cursor
!+Right::Send("+{End}")    ; Alt+Shift+Right = Select all text to the right of the cursor

; ======================================
; Script Initialization
; ======================================
SetTimer InitScript, -500  ; Start initialization after 500ms

InitScript() {
    DebugLog("Starting script initialization")

    if (ENABLE_AUTO_INIT) {
        ; First initialize ApplicationManager to launch all apps
        ApplicationManager.Initialize()

        ; Wait a bit for Edge apps to fully initialize
        Sleep(2000)
    }

    if (ENABLE_PRODUCTIVITY) {
        ; Then initialize ProductivitySuite layout
        ProductivitySuite.InitializeLayout()
    }

    DebugLog("Script initialization completed")
}

DebugLog("Script ready for operation")
