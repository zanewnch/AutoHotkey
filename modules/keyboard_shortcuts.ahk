#Requires AutoHotkey v2.0+  ; 指定需要 AutoHotkey v2.0 或更高版本才能執行此腳本

; ============================================================
; Alt+Tab 替代方案
; ============================================================
; ~ 前綴表示不阻止原本按鍵的功能
; LCtrl & Tab = 左 Ctrl + Tab 組合鍵
; 這行讓你用 Ctrl+Tab 來模擬 Alt+Tab 切換視窗
~LCtrl & Tab::Send("{Alt down}{Tab}{Alt up}")

; 保留原本 Alt+Tab 的功能，讓它正常運作不被干擾
; Return 表示什麼都不做，只是確保這個熱鍵被註冊
~!Tab::Return

; ============================================================
; 瀏覽器風格快捷鍵（將左 Alt 映射為 Ctrl）
; 這樣可以用左 Alt 代替 Ctrl 來執行常用操作
; <! 前綴表示只有左 Alt 會觸發，右 Alt 不會
; ============================================================
<!a::Send("^a")  ; 左Alt+A = 全選（相當於 Ctrl+A）
<!c::Send("^c")  ; 左Alt+C = 複製（相當於 Ctrl+C）
<!x::Send("^x")  ; 左Alt+X = 剪下（相當於 Ctrl+X）
<!v::Send("^v")  ; 左Alt+V = 貼上（相當於 Ctrl+V）
<!s::Send("^s")  ; 左Alt+S = 儲存（相當於 Ctrl+S）
<!f::Send("^f")  ; 左Alt+F = 搜尋/尋找（相當於 Ctrl+F）
<!w::Send("^w")  ; 左Alt+W = 關閉分頁（相當於 Ctrl+W）
<!t::Send("^t")  ; 左Alt+T = 新增分頁（相當於 Ctrl+T）
<!r::Send("^r")  ; 左Alt+R = 重新整理（相當於 Ctrl+R）
<!z::Send("^z")  ; 左Alt+Z = 復原（相當於 Ctrl+Z）

; ============================================================
; 導航快捷鍵（用左 Alt+方向鍵 快速移動游標）
; ============================================================
<!Left::Send("{Home}")   ; 左Alt+左鍵 = 移動游標到行首
<!Right::Send("{End}")   ; 左Alt+右鍵 = 移動游標到行尾
<!Up::Send("{Home}")     ; 左Alt+上鍵 = 移動游標到行首
<!Down::Send("{End}")    ; 左Alt+下鍵 = 移動游標到行尾

; ============================================================
; 滑鼠點擊模擬（不用滑鼠也能點擊）
; ============================================================
CapsLock & Enter::Click         ; Caps Lock + Enter = 滑鼠左鍵點擊
<!Enter::Click                  ; 左Alt + Enter = 滑鼠左鍵點擊
<!Backspace::Click("Right")     ; 左Alt + Backspace = 滑鼠右鍵點擊

; ============================================================
; 選取文字快捷鍵（用左 Alt+Shift+方向鍵 選取文字）
; ============================================================
<!+Left::Send("+{Home}")   ; 左Alt+Shift+左鍵 = 選取游標左邊到行首的所有文字
<!+Right::Send("+{End}")   ; 左Alt+Shift+右鍵 = 選取游標右邊到行尾的所有文字

; ============================================================
; 已註解掉：右 Alt 鍵快捷啟動（按一下 RAlt 開啟/切換到 Edge）
; ============================================================
; RAlt:: {
;    ; 檢查 Microsoft Edge 是否已經在執行
;    if WinExist("ahk_exe msedge.exe") {
;        WinActivate()  ; 如果已開啟，切換到 Edge 視窗
;    } else {
;        ; 如果沒開啟，執行 Edge 瀏覽器
;        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
;    }
;}

; ============================================================
; 已註解掉：右 Ctrl 開啟 Cursor 編輯器（已改用下方的 IntelliJ IDEA）
; ============================================================
;RCtrl:: {
;    if WinExist("ahk_exe cursor.exe") {
;        WinActivate()
;    } else {
;        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
;    }
;}

; ============================================================
; 右 Ctrl 鍵快捷啟動（按一下 RCtrl 開啟/切換到 IntelliJ IDEA）
; ============================================================
RCtrl:: {
    ; 檢查 IntelliJ IDEA 是否已經在執行
    if WinExist("ahk_exe idea64.exe") {
        WinActivate()  ; 如果已開啟，切換到 IDEA 視窗
    } else {
        ; 如果沒開啟，執行 IntelliJ IDEA
        Run("C:\\Program Files\\JetBrains\\IntelliJ IDEA 2024.1.4\\bin\\idea64.exe")
    }
}

; ============================================================
; Ctrl+減號 開啟/切換到 Cursor 編輯器
; ============================================================
^-:: {
    ; 檢查 Cursor 是否已經在執行
    if WinExist("ahk_exe cursor.exe") {
        WinActivate()  ; 如果已開啟，切換到 Cursor 視窗
    } else {
        ; 如果沒開啟，執行 Cursor 編輯器
        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
    }
    ; 呼叫函數將 Cursor 視窗移動到指定位置（定義在其他模組）
    MoveCursorWorkbenchToPercentage()
}

; ============================================================
; Ctrl+等號 開啟/切換到 Windsurf 編輯器
; ============================================================
^=:: {
    ; 檢查 Windsurf 是否已經在執行
    if WinExist("ahk_exe windsurf.exe") {
        WinActivate()  ; 如果已開啟，切換到 Windsurf 視窗
    } else {
        ; 如果沒開啟，執行 Windsurf 編輯器
        Run("C:\Users\user\OneDrive\桌面\Windsurf.lnk")
    }
}

; ============================================================
; Ctrl+Backspace 開啟/切換到 Android Studio
; ============================================================
^Backspace:: {
    ; 檢查 Android Studio 是否已經在執行
    if WinExist("ahk_exe studio64.exe") {
        WinActivate()  ; 如果已開啟，切換到 Android Studio 視窗
    } else {
        ; 如果沒開啟，執行 Android Studio
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Android Studio\Android Studio.lnk")
    }
}

; ============================================================
; Ctrl+左方向鍵 開啟/切換到 Cursor 編輯器並調整視窗位置
; ============================================================
^Left:: {
    ; 檢查 Cursor 是否已經在執行
    if WinExist("ahk_exe cursor.exe") {
        WinActivate()  ; 如果已開啟，切換到 Cursor 視窗
    } else {
        ; 如果沒開啟，執行 Cursor 編輯器
        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
    }
    ; 呼叫函數將 Cursor 視窗移動到指定位置
    MoveCursorWorkbenchToPercentage()
    ; 發送一個空白虛擬按鍵，防止系統預設行為（如視窗管理）被觸發
    Send("{Blind}{vkFF}")
    Return
}

; ============================================================
; 已註解掉：Ctrl+左方向鍵 開啟 IntelliJ IDEA（已改用上方的 Cursor）
; ============================================================
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

; ============================================================
; 已註解掉：Ctrl+右方向鍵 開啟 ChatGPT（已改用下方的 Edge）
; ============================================================
;^Right:: {
;    ; 檢查 ChatGPT 桌面應用程式是否在執行
;    if WinExist("ahk_exe ChatGPT.exe") {
;        WinActivate()
;    } else {
;        ; 透過 Windows Store 應用程式 ID 啟動 ChatGPT
;        Run("shell:AppsFolder\OpenAI.ChatGPT-Desktop_2p2nqsd0c76g0!ChatGPT")
;    }
;    Send("{Blind}{vkFF}")
;    Return
;}

; ============================================================
; Ctrl+右方向鍵 開啟/切換到 Edge（排除 YouTube Music 視窗）
; ============================================================
^Right:: {
    ; 檢查 Edge 是否在執行
    if WinExist("ahk_exe msedge.exe") {
        ; 取得所有 Edge 視窗的清單
        EdgeWindows := WinGetList("ahk_exe msedge.exe")
        ; 遍歷所有 Edge 視窗
        for hwnd in EdgeWindows {
            WinTitle := WinGetTitle(hwnd)  ; 取得視窗標題
            ; 如果這個視窗不是 YouTube Music，就切換到它
            if !InStr(WinTitle, "YouTube Music") {
                WinActivate(hwnd)
                return
            }
        }
        ; 如果所有 Edge 視窗都是 YouTube Music，開啟新的 Edge 視窗
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
    } else {
        ; 如果 Edge 沒有在執行，開啟 Edge
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
    }
}

; ============================================================
; Ctrl+上方向鍵 開啟/切換到 Android Studio
; ============================================================
^Up:: {
    ; 檢查 Android Studio 是否已經在執行
    if WinExist("ahk_exe studio64.exe") {
        WinActivate()  ; 如果已開啟，切換到 Android Studio 視窗
    } else {
        ; 如果沒開啟，執行 Android Studio
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Android Studio\Android Studio.lnk")
    }
    Return
}

; ============================================================
; Ctrl+下方向鍵 開啟/切換到 Google Chrome
; ============================================================
^Down::{
    ; 檢查 Chrome 是否已經在執行
    if WinExist("ahk_exe Chrome.exe") {
        WinActivate()  ; 如果已開啟，切換到 Chrome 視窗
    } else {
        ; 如果沒開啟，執行 Chrome 瀏覽器
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk")
    }
    Return
}

; ============================================================
; Ctrl+Shift+左方向鍵 開啟/切換到 WebStorm
; ============================================================
^+Left:: {
    ; 檢查 WebStorm 是否已經在執行
    if WinExist("ahk_exe WebStorm.exe") {
        WinActivate()  ; 如果已開啟，切換到 WebStorm 視窗
    } else {
        ; 如果沒開啟，執行 WebStorm
        Run("C:\Users\user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\JetBrains Toolbox\WebStorm.lnk")
    }
    Return
}

; ============================================================
; Ctrl+Shift+下方向鍵 開啟 Microsoft Copilot
; ============================================================
^+Down:: {
    ; 使用 ms-copilot: 協定啟動 Microsoft Copilot
    Run("ms-copilot:")
    Return
}
