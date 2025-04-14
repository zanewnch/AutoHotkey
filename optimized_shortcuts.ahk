#Requires AutoHotkey v2.0+

; Use #InputLevel to prioritize standard Ctrl key operations
#InputLevel 1
#UseHook false  ; Changed from #UseHook to prevent interference with standard Ctrl key operations

; ======================================
; Core Configuration
; ======================================
SendMode("Input")
SetTitleMatchMode(2)
SetWorkingDir(A_ScriptDir)

; Initialize screen dimensions at script startup
screenWidth := A_ScreenWidth  ; 獲取螢幕寬度，一次性計算
screenHeight := A_ScreenHeight  ; 獲取螢幕高度，一次性計算

; Initialize percentage values as variables
cursor_workbench_x_axis := 25  ; 預設 X 軸百分比為 25%，用於 Cursor IDE 工作區
global_y_axis := 50  ; 預設 Y 軸百分比為 50%，通用設置

; Initialize default cursor positions as global variables (for Cursor IDE)
defaultXPos := screenWidth * (cursor_workbench_x_axis / 100)  ; 預設 X 軸位置
defaultYPos := screenHeight * (global_y_axis / 100)  ; 預設 Y 軸位置

; ======================================
; Utility Functions
; ======================================

; Function to move mouse cursor to a percentage position on the screen
MoveCursorWorkbenchToPercentage(xPercent := cursor_workbench_x_axis, yPercent := global_y_axis) {
    global defaultXPos, defaultYPos  ; 使用預存的預設位置
    if (xPercent = cursor_workbench_x_axis && yPercent = global_y_axis) {
        MouseMove(defaultXPos, defaultYPos, 0)  ; 移動滑鼠游標到預設位置
    } else {
        global screenWidth, screenHeight
        xPos := screenWidth * (xPercent / 100)
        yPos := screenHeight * (yPercent / 100)
        MouseMove(xPos, yPos, 0)  ; 移動滑鼠游標到指定位置
    }
    Return
}

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
        Run("C:\Users\user\OneDrive\桌面\Windsurf.lnk")
    }
}

; F6: Cursor
F6:: {
    if WinExist("ahk_exe cursor.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
    }
    MoveCursorWorkbenchToPercentage()  ; 移動滑鼠游標到 X:25%, Y:50% 的位置
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

; Preserve Alt+Tab functionality
~!Tab::Return  ; This allows the system's Alt+Tab to work normally

; Browser-Style Shortcuts (using simple Send commands)
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

; ======================================
; Fix for Standard Ctrl Key Combinations
; ======================================

; Explicitly pass through common Ctrl key shortcuts to ensure they work
; This ensures Ctrl+A, Ctrl+C, Ctrl+V etc. work as expected
#InputLevel 0
~^a::Return  ; Pass through Ctrl+A (Select All)
~^c::Return  ; Pass through Ctrl+C (Copy)
~^v::Return  ; Pass through Ctrl+V (Paste)
~^x::Return  ; Pass through Ctrl+X (Cut)
~^z::Return  ; Pass through Ctrl+Z (Undo)
~^y::Return  ; Pass through Ctrl+Y (Redo)
~^f::Return  ; Pass through Ctrl+F (Find)
~^s::Return  ; Pass through Ctrl+S (Save)
#InputLevel 1

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

; ======================================
; Additional Ctrl Shortcuts
; ======================================

^-:: {
    if WinExist("ahk_exe cursor.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
    }
    MoveCursorWorkbenchToPercentage()  ; 移動滑鼠游標到 X:25%, Y:50% 的位置
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

; ======================================
; Windows Key Shortcuts (Changed to Ctrl)
; ======================================

; Ctrl+Left: Cursor
^Left:: {
    if WinExist("ahk_exe cursor.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
    }
    MoveCursorWorkbenchToPercentage()  ; 移動滑鼠游標到 X:25%, Y:50% 的位置
    Send("{Blind}{vkFF}")  ; 防止系統處理視窗移動
    Return  ; 防止系統預設行為
}

; Ctrl+Right: Microsoft Edge
^Right:: {
    if WinExist("ahk_exe msedge.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
    }
    Send("{Blind}{vkFF}")  ; 防止系統處理視窗移動
    Return  ; 防止系統預設行為
}

; Ctrl+Up: Android Studio
^Up:: {
    if WinExist("ahk_exe studio64.exe") {
        WinActivate()
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Android Studio\Android Studio.lnk")
    }
    Return  ; 防止系統預設行為
}

; Ctrl+Down: Brave Browser
^Down:: {
    if WinExist("ahk_exe brave.exe") {
        WinActivate()
    } else {
        Run("C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe")
    }
    Return  ; 防止系統預設行為
}

; Ctrl+Shift+Left: Windsurf IDE
^+Left:: {
    if WinExist("ahk_exe windsurf.exe") {
        WinActivate()
    } else {
        Run("C:\Users\user\OneDrive\桌面\Windsurf.lnk")
    }
    Return  ; 防止系統預設行為
}

; Ctrl+Shift+Down: Windows Copilot
^+Down:: {
    Run("ms-copilot:")  ; 嘗試使用 ms-copilot: 協議來開啟 Copilot
    Return  ; 防止系統預設行為
}

; ======================================
; Mouse Simulation Shortcuts
; ======================================

; Disable Caps Lock default functionality
SetCapsLockState("AlwaysOff")  ; 完全禁用 Caps Lock 的預設大小寫切換功能，保持關閉狀態
CapsLock::Return  ; 單獨按下 Caps Lock 時不執行任何操作

; Scroll Up
CapsLock & Up::Send("{WheelUp}")  ; Caps Lock + Up = Scroll Up (滾輪幅度根據 Windows OS 預設滑鼠設定)

; Scroll Down
CapsLock & Down::Send("{WheelDown}")  ; Caps Lock + Down = Scroll Down (滾輪幅度根據 Windows OS 預設滑鼠設定)

; Scroll Left
CapsLock & Left::Send("{WheelLeft}")  ; Caps Lock + Left = Scroll Left (滾輪幅度根據 Windows OS 預設滑鼠設定)

; Scroll Right
CapsLock & Right::Send("{WheelRight}")  ; Caps Lock + Right = Scroll Right (滾輪幅度根據 Windows OS 預設滑鼠設定)

; Mouse Click (Left Click)
!Enter::Click  ; Alt + Enter = Left Click

; Mouse Click (Right Click)
!Backspace::Click("Right")  ; Alt + Backspace = Right Click

; ======================================
; Tab + Arrow Keys for Mouse Movement (Touchpad Simulation)
; ======================================

; Initialize mouse movement variables
mouseMoveStep := 70  ; 預設移動步長 (像素)

; Disable Tab default functionality when used with arrow keys
Tab::Return  ; 避免單獨按 Tab 時產生 Tab 字元

; Tab + Up = Move mouse cursor up
Tab & Up:: {
    MouseMove(0, -mouseMoveStep, 0, "R")
    Return
}

; Tab + Down = Move mouse cursor down
Tab & Down:: {
    MouseMove(0, mouseMoveStep, 0, "R")
    Return
}

; Tab + Left = Move mouse cursor left
Tab & Left:: {
    MouseMove(-mouseMoveStep, 0, 0, "R")
    Return
}

; Tab + Right = Move mouse cursor right
Tab & Right:: {
    MouseMove(mouseMoveStep, 0, 0, "R")
    Return
}

; Tab + Enter = Left Click (to complement the touchpad simulation)
Tab & Enter::Click

; Tab + Backspace = Right Click
Tab & Backspace::Click("Right")

; ======================================
; Cursor IDE Specific Shortcuts
; ======================================

#HotIf WinActive("ahk_exe cursor.exe")
^L:: {
    MoveCursorWorkbenchToPercentage(75, global_y_axis)  ; 移動滑鼠游標到 X:75%, Y:50% 的位置
    Return
}
#HotIf