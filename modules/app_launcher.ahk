#Requires AutoHotkey v2.0+

; ============================================================
; App launcher hotkeys
; ============================================================
; App metadata lives in modules/app_registry.ahk. Keep hotkeys thin so paths
; and launch rules do not drift between startup and manual shortcuts.

; ============================================================
; Direct app keys
; ============================================================

F1::ActivateOrRunApp("copilot")

F2::ActivateOrRunApp("line")

F3::ActivateOrRunApp("comet")

F4::ActivateOrRunApp("chrome", ["Google Chat", "Google 日曆"])

F5::ActivateOrRunApp("edge", ["YouTube Music"])

; 原本：F6 = vscode
; F6::ActivateOrRunApp("vscode")
F6::ActivateOrRunApp("cursor")

; 原本：F7 = vscodeInsider
; F7::ActivateOrRunApp("vscodeInsider")
F7::ActivateOrRunApp("vscode")

; 原本：F8 = ChatGPT Classic
; F8::ActivateOrRunApp("chatgptClassic")
; 原本：F8 = cursor
; F8::ActivateOrRunApp("cursor")
F8::ActivateOrRunApp("powershell")

F9::ActivateOrRunApp("chatgpt")

F10::ActivateOrRunApp("notion")

; 原本：F11 = googleCalendar
; F11::ActivateOrRunApp("googleCalendar")
F11::ActivateOrRunApp("googleChat")

; 原本：F12 = googleChat
; F12::ActivateOrRunApp("googleChat")
F12::ActivateOrRunApp("googleCalendar")

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

; 點一下右 Alt：開啟 / 切換 Microsoft Copilot。
; 等放開才觸發，避免按住右 Alt 再按其他鍵時立刻跳出 Copilot。
; 左 Alt 仍走 key_remapping.ahk 的 Ctrl 風格映射。
RAlt:: {
    KeyWait("RAlt")
    if (A_PriorKey = "RAlt")
        ActivateOrRunApp("copilot")
}

; 暫時停用：Alt + Space = Copilot toggle
; !Space:: {
;     if WinExist("ahk_exe mscopilot.exe") {
;         if WinActive("ahk_exe mscopilot.exe")
;             WinMinimize()
;         else
;             WinActivate()
;     } else {
;         ActivateOrRunApp("copilot")
;     }
; }

; ============================================================
; Maintenance hotkeys
; ============================================================
; Ctrl+Alt+F10: show resolved app launch candidates.
; Ctrl+Alt+F11: reinstall keyboard hook without reloading the whole script.
; Ctrl+Alt+F12: reload the script after editing.

^!F10::ShowAppLaunchDiagnostics()

^!F11::ResetKeyboardHook()

^!F12::Reload()
