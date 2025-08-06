#Requires AutoHotkey v2.0+

; Alt+Tab Alternative
~LCtrl & Tab::Send("{Alt down}{Tab}{Alt up}")

; Preserve Alt+Tab functionality
~!Tab::Return

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
!Left::Send("{Home}")  ; Alt+Left = Move to line start
!Right::Send("{End}")  ; Alt+Right = Move to line end
!Up::Send("{Home}")  ; Alt+Up = Move to line start
!Down::Send("{End}")  ; Alt+Down = Move to line end

; Mouse Click (Left Click)
CapsLock & Enter::Click  ; Caps Lock + Enter = Left Click
!Enter::Click  ; Alt + Enter = Left Click

; Mouse Click (Right Click)
!Backspace::Click("Right")  ; Alt + Backspace = Right Click

; Selection Shortcuts
!+Left::Send("+{Home}")  ; Alt+Shift+Left = Select all text to the left of the cursor
!+Right::Send("+{End}")  ; Alt+Shift+Right = Select all text to the right of the cursor

; Right Alt and Right Control Specific Shortcuts
RAlt:: {
    if WinExist("ahk_exe msedge.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
    }
}
;RCtrl:: {
;    if WinExist("ahk_exe cursor.exe") {
;        WinActivate()
;    } else {
;        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
;    }
;}

RCtrl:: {
    if WinExist("ahk_exe idea64.exe") {
        WinActivate()
    } else {
        Run("C:\\Program Files\\JetBrains\\IntelliJ IDEA 2024.1.4\\bin\\idea64.exe")
    }
}

; Additional Ctrl Shortcuts
^-:: {
    if WinExist("ahk_exe cursor.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
    }
    MoveCursorWorkbenchToPercentage()
}

^=:: {
    if WinExist("ahk_exe windsurf.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\OneDrive\桌面\Windsurf.lnk")
    }
}

^Backspace:: {
    if WinExist("ahk_exe studio64.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Android Studio\Android Studio.lnk")
    }
}

; Windows Key Shortcuts (Changed to Ctrl)
^Left:: {
    if WinExist("ahk_exe cursor.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
    }
    MoveCursorWorkbenchToPercentage()
    Send("{Blind}{vkFF}")
    Return
}

;^Left:: {
;     if WinExist("ahk_exe idea64.exe") {
;        WinActivate()
;    } else {
;        Run("C:\\Program Files\\JetBrains\\IntelliJ IDEA 2024.1.4\\bin\\idea64.exe")
;    }
;    MoveCursorWorkbenchToPercentage()
;    Send("{Blind}{vkFF}")
;    Return
;}

;^Right:: {
;    ; Check if ChatGPT is running (window title or exe)
;    if WinExist("ahk_exe ChatGPT.exe") {
;        WinActivate()
;    } else {
;        Run("shell:AppsFolder\OpenAI.ChatGPT-Desktop_2p2nqsd0c76g0!ChatGPT")
;    }
;    Send("{Blind}{vkFF}")
;    Return
;}

^Right:: {
    ; Check if Edge exists but exclude YouTube Music windows
    if WinExist("ahk_exe msedge.exe") {
        ; Get all Edge windows
        EdgeWindows := WinGetList("ahk_exe msedge.exe")
        for hwnd in EdgeWindows {
            WinTitle := WinGetTitle(hwnd)
            ; Skip if this is YouTube Music
            if !InStr(WinTitle, "YouTube Music") {
                WinActivate(hwnd)
                return
            }
        }
        ; If all Edge windows are YouTube Music, open a new Edge window
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
    }
}

^Up:: {
    if WinExist("ahk_exe studio64.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Android Studio\Android Studio.lnk")
    }
    Return
}


^Down::{
    if WinExist("ahk_exe Chrome.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk")
    }
    Return
}

;^Down:: {
;    if WinExist("ahk_exe Arc.exe") {
;        WinActivate()
;    } else {
;        Run("C:\Users\user\AppData\Local\Microsoft\WindowsApps\Arc.exe")
;    }
;    Return
;}

^+Left:: {
    if WinExist("ahk_exe webstorm64.exe") {
        WinActivate()
    } else {
        Run("webstorm")
    }
    Return
}

^+Down:: {
    Run("ms-copilot:")
    Return
} 