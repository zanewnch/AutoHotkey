#Requires AutoHotkey v2.0+

; ======================================
; Core Configuration
; ======================================
SendMode("Input")
SetTitleMatchMode(2)
SetWorkingDir(A_ScriptDir)

; ======================================
; Application Shortcuts (F1-F12)
; ======================================

; F1: LINE
F1:: {
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
    if WinExist("YouTube Music ahk_exe msedge.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\Desktop\YouTubeMusic.lnk")
    }
}

; F5: Android Studio
F5:: {
    if WinExist("ahk_exe studio64.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Android Studio\Android Studio.lnk")
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

F7:: {
    if WinExist("ahk_exe brave.exe") {
        WinActivate()
    } else {
        Run("C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe")
    }
}

F8:: {
    if WinExist("ahk_exe msedge.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
    }
}



; F9: LocalFrontend
F9:: {
    if WinExist("LocalFrontend ahk_exe msedge.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\Desktop\LocalFrontend.lnk")
    }
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

; F12: PyCharm
F12:: {
    if WinExist("ahk_exe pycharm64.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\JetBrains\PyCharm 2024.1.4.lnk")
    }
}

PgUp:: {
    if WinExist("ahk_exe msedge.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
    }
}



; PgDn: Cursor
PgDn:: {
    if WinExist("ahk_exe cursor.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
    }
}

Home:: {
    if WinExist("ahk_exe brave.exe") {
        WinActivate()
    } else {
        Run("C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe")
    }
}

End:: {
    if WinExist("ahk_exe msedge.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
    }
}

; Insert: Cursor
Ins:: {
    if WinExist("ahk_exe cursor.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
    }
}

; ======================================
; Keymap Enhancements
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
; Right Alt and Right Control Specific Shortcuts
; ======================================

; Right Alt opens Brave browser
RAlt:: {
    if WinExist("ahk_exe msedge.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
    }
}

; Right Control opens Cursor
RCtrl:: {
    if WinExist("ahk_exe cursor.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
    }
}