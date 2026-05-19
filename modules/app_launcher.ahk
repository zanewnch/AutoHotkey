#Requires AutoHotkey v2.0+

; ============================================================
; App launcher hotkeys
; ============================================================
; App metadata lives in modules/app_registry.ahk. Keep hotkeys thin so paths
; and launch rules do not drift between startup and manual shortcuts.

; ============================================================
; Direct app keys
; ============================================================

Home::ActivateOrRunApp("brave")

End::ActivateOrRunApp("edge")

Ins::ActivateOrRunApp("cursor")

; ============================================================
; RCtrl app launcher layer
; ============================================================

RCtrl & Left::ActivateOrRunApp("vscode")

RCtrl & Up::ActivateOrRunApp("chrome", ["Google Chat", "Google 日曆"])

RCtrl & Down::ActivateOrRunApp("claude")

; ============================================================
; Ctrl app launcher layer
; ============================================================

^Backspace::ActivateOrRunApp("androidStudio")

^Left:: {
    ActivateOrRunApp("cursor")
    MoveCursorWorkbenchToPercentage()
    Send("{Blind}{vkFF}")
}

^Right::ActivateOrRunApp("edge", ["YouTube Music"])

^Up::ActivateOrRunApp("androidStudio")

^Down::ActivateOrRunApp("chrome")

^+Left::ActivateOrRunApp("webstorm")

^+Down::ActivateOrRunApp("copilot")

; ============================================================
; Copilot toggle
; ============================================================

!Space:: {
    if WinExist("ahk_exe Copilot.exe") {
        if WinActive("ahk_exe Copilot.exe")
            WinMinimize()
        else
            WinActivate()
    } else {
        ActivateOrRunApp("copilot")
    }
}

; ============================================================
; Maintenance hotkeys
; ============================================================
; Ctrl+Alt+F11: reinstall keyboard hook without reloading the whole script.
; Ctrl+Alt+F12: reload the script after editing.

^!F11::ResetKeyboardHook()

^!F12::Reload()
