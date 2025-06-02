#Requires AutoHotkey v2.0+

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

; F4: Android Studio
F4:: {
    if WinExist("ahk_exe studio64.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Android Studio\Android Studio.lnk")
    }
}

; F5: Windsurf
F5:: {
    if WinExist("ahk_exe windsurf.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Local\Programs\Windsurf\bin\windsurf.cmd")
    }
}

; F6: Cursor
F6:: {
    if WinExist("ahk_exe cursor.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
    }
    MoveCursorWorkbenchToPercentage()
}

; F7: Brave Browser
;F7:: {
;    if WinExist("ahk_exe brave.exe") {
;        WinActivate()
;    } else {
;        Run("C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe")
;    }
;}


F7::{
    if WinExist("ahk_exe Arc.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Local\Microsoft\WindowsApps\Arc.exe")
    }
    Return
}



F8::{
    if WinExist("ahk_exe msedge.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
    }
}

; F8: ChatGPT
;F8::{
;    ; Check if ChatGPT is running ;(window title or exe)
;    if WinExist("ahk_exe ChatGPT.exe") {
;        WinActivate()
;    } else {
;        Run;("shell:AppsFolder\OpenAI.ChatGPT-Desktop_2p2nqsd0c76g0!ChatGPT")
;    }
;}

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

; PgUp: Microsoft Edge
; PgUp:: {
;     if WinExist("ahk_exe msedge.exe") {
;         WinActivate()
;     } else {
;         Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
;     }
; }

; PgDn: Cursor
; PgDn:: {
;     if WinExist("ahk_exe cursor.exe") {
;         WinActivate()
;     } else {
;         Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
;     }
; }

; Home: Brave Browser
Home:: {
    if WinExist("ahk_exe brave.exe") {
        WinActivate()
    } else {
        Run("C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe")
    }
}

; End: Microsoft Edge
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

; Add other function key shortcuts here... 