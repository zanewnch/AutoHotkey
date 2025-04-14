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

RCtrl:: {
    if WinExist("ahk_exe cursor.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
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

^Right:: {
    if WinExist("ahk_exe msedge.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
    }
    Send("{Blind}{vkFF}")
    Return
}

^Up:: {
    if WinExist("ahk_exe studio64.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Android Studio\Android Studio.lnk")
    }
    Return
}

^Down:: {
    if WinExist("ahk_exe brave.exe") {
        WinActivate()
    } else {
        Run("C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe")
    }
    Return
}

^+Left:: {
    if WinExist("ahk_exe windsurf.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\OneDrive\桌面\Windsurf.lnk")
    }
    Return
}

^+Down:: {
    Run("ms-copilot:")
    Return
} 