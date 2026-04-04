#Requires AutoHotkey v2.0+  ; 指定需要 AutoHotkey v2.0 或更高版本才能執行此腳本

; ============================================================
; 應用程式快捷啟動模組
; ============================================================
; 這個模組使用 F1-F12 功能鍵和其他按鍵來快速啟動/切換應用程式
; 每個快捷鍵的邏輯都是：
;   1. 檢查應用程式是否已經在執行
;   2. 如果是 → 切換到該視窗（WinActivate）
;   3. 如果否 → 啟動該應用程式（Run）
; ============================================================

; ============================================================
; F1 - 開啟/切換到 LINE 通訊軟體
; ============================================================
; F1:: {
;     ; ahk_exe LINE.exe 透過執行檔名稱識別 LINE 視窗
;     if WinExist("ahk_exe LINE.exe") {
;         WinActivate()  ; LINE 已開啟，切換到該視窗
;     } else {
;         ; LINE 未開啟，從開始選單捷徑啟動
;         Run("C:\Users\user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\LINE\LINE.lnk")
;     }
; }

; ============================================================
; F2 - 開啟/切換到檔案總管（File Explorer）
; ============================================================
; F2:: {
;     ; ahk_class CabinetWClass 是檔案總管視窗的類別名稱
;     ; 使用 class 而非 exe 是因為 explorer.exe 同時也是桌面和工作列的程序
;     if WinExist("ahk_class CabinetWClass") {
;         WinActivate()  ; 檔案總管已開啟，切換到該視窗
;     } else {
;         ; 開啟新的檔案總管視窗
;         Run("explorer.exe")
;     }
; }

; ============================================================
; F3 - 開啟/切換到 YouTube Music（Edge PWA 應用程式）
; ============================================================
; F3:: {
;     ; 同時匹配視窗標題包含 "YouTube Music" 且執行檔為 msedge.exe
;     ; 這是因為 YouTube Music 是 Edge 的 PWA（漸進式網頁應用程式）
;     if WinExist("YouTube Music ahk_exe msedge.exe") {
;         WinActivate()  ; YouTube Music 已開啟，切換到該視窗
;     } else {
;         ; 從桌面捷徑啟動 YouTube Music PWA
;         Run("C:\Users\user\Desktop\YouTubeMusic.lnk")
;     }
; }

; ============================================================
; F4 - 開啟/切換到 Android Studio
; ============================================================
; F4:: {
;     ; studio64.exe 是 Android Studio 的 64 位元執行檔
;     if WinExist("ahk_exe studio64.exe") {
;         WinActivate()  ; Android Studio 已開啟，切換到該視窗
;     } else {
;         ; 從開始選單捷徑啟動 Android Studio
;         Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Android Studio\Android Studio.lnk")
;     }
; }

; ============================================================
; F5 - 開啟/切換到 Windsurf 編輯器
; ============================================================
; F5:: {
;     ; windsurf.exe 是 Windsurf 編輯器的執行檔
;     if WinExist("ahk_exe windsurf.exe") {
;         WinActivate()  ; Windsurf 已開啟，切換到該視窗
;     } else {
;         ; 透過 cmd 批次檔啟動 Windsurf
;         Run("C:\Users\user\AppData\Local\Programs\Windsurf\bin\windsurf.cmd")
;     }
; }

; ============================================================
; F6 - 開啟/切換到 Cursor 編輯器
; ============================================================
; F6:: {
;     ; cursor.exe 是 Cursor AI 編輯器的執行檔
;     if WinExist("ahk_exe cursor.exe") {
;         WinActivate()  ; Cursor 已開啟，切換到該視窗
;     } else {
;         ; 啟動 Cursor 編輯器
;         Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
;     }
;     ; 切換後自動將滑鼠移動到工作區預設位置（使用 utils.ahk 中的函數）
;     MoveCursorWorkbenchToPercentage()
; }

; ============================================================
; 已註解掉：F7 - Brave 瀏覽器（已改用下方的 Chrome）
; ============================================================
;F7:: {
;    if WinExist("ahk_exe brave.exe") {
;        WinActivate()
;    } else {
;        Run("C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe")
;    }
;}

; ============================================================
; F7 - 開啟/切換到 Google Chrome
; ============================================================
; F7::{
;     ; Chrome.exe 是 Google Chrome 瀏覽器的執行檔
;     if WinExist("ahk_exe Chrome.exe") {
;         WinActivate()  ; Chrome 已開啟，切換到該視窗
;     } else {
;         ; 從開始選單捷徑啟動 Chrome
;         Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk")
;     }
;     Return
; }

; ============================================================
; F8 - 開啟/切換到 Microsoft Edge
; ============================================================
; F8::{
;     ; msedge.exe 是 Microsoft Edge 瀏覽器的執行檔
;     if WinExist("ahk_exe msedge.exe") {
;         WinActivate()  ; Edge 已開啟，切換到該視窗
;     } else {
;         ; 從開始選單捷徑啟動 Edge
;         Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
;     }
; }

; ============================================================
; 已註解掉：F8 - ChatGPT 桌面應用程式
; ============================================================
;F8::{
;    ; 檢查 ChatGPT 桌面應用程式是否在執行
;    if WinExist("ahk_exe ChatGPT.exe") {
;        WinActivate()
;    } else {
;        ; 透過 Windows Store 應用程式 ID 啟動 ChatGPT
;        Run("shell:AppsFolder\OpenAI.ChatGPT-Desktop_2p2nqsd0c76g0!ChatGPT")
;    }
;}

; ============================================================
; F9 - 開啟/切換到 LocalFrontend（本地前端開發伺服器 - Edge PWA）
; ============================================================
; F9:: {
;     ; 匹配標題包含 "LocalFrontend" 且執行檔為 msedge.exe 的視窗
;     ; 這是一個 Edge PWA 應用程式，可能是本地開發伺服器的介面
;     if WinExist("LocalFrontend ahk_exe msedge.exe") {
;         WinActivate()  ; LocalFrontend 已開啟，切換到該視窗
;     } else {
;         ; 從桌面捷徑啟動 LocalFrontend PWA
;         Run("C:\Users\user\Desktop\LocalFrontend.lnk")
;     }
; }

; ============================================================
; F10 - 開啟/切換到 Notion 筆記軟體
; ============================================================
; F10:: {
;     ; notion.exe 是 Notion 桌面應用程式的執行檔
;     if WinExist("ahk_exe notion.exe") {
;         WinActivate()  ; Notion 已開啟，切換到該視窗
;     } else {
;         ; 啟動 Notion 桌面應用程式
;         Run("C:\Users\user\AppData\Local\Programs\Notion\Notion.exe")
;     }
; }

; ============================================================
; F11 - 開啟/切換到 Visual Studio 2022
; ============================================================
; F11:: {
;     ; devenv.exe 是 Visual Studio 的主要執行檔
;     if WinExist("ahk_exe devenv.exe") {
;         WinActivate()  ; Visual Studio 已開啟，切換到該視窗
;     } else {
;         ; 啟動 Visual Studio 2022 Community 版本
;         Run("C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe")
;     }
; }

; ============================================================
; F12 - 開啟/切換到 PyCharm Python IDE
; ============================================================
; F12:: {
;     ; pycharm64.exe 是 PyCharm 的 64 位元執行檔
;     if WinExist("ahk_exe pycharm64.exe") {
;         WinActivate()  ; PyCharm 已開啟，切換到該視窗
;     } else {
;         ; 從開始選單捷徑啟動 PyCharm
;         Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\JetBrains\PyCharm 2024.1.4.lnk")
;     }
; }

; ============================================================
; 已註解掉：PgUp - Microsoft Edge
; ============================================================
; PgUp:: {
;     if WinExist("ahk_exe msedge.exe") {
;         WinActivate()
;     } else {
;         Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
;     }
; }

; ============================================================
; 已註解掉：PgDn - Cursor 編輯器
; ============================================================
; PgDn:: {
;     if WinExist("ahk_exe cursor.exe") {
;         WinActivate()
;     } else {
;         Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
;     }
; }

; ============================================================
; Home 鍵 - 開啟/切換到 Brave 瀏覽器
; ============================================================
Home:: {
    ; brave.exe 是 Brave 瀏覽器的執行檔
    if WinExist("ahk_exe brave.exe") {
        WinActivate()  ; Brave 已開啟，切換到該視窗
    } else {
        ; 啟動 Brave 瀏覽器
        Run("C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe")
    }
}

; ============================================================
; End 鍵 - 開啟/切換到 Microsoft Edge
; ============================================================
End:: {
    ; msedge.exe 是 Microsoft Edge 的執行檔
    if WinExist("ahk_exe msedge.exe") {
        WinActivate()  ; Edge 已開啟，切換到該視窗
    } else {
        ; 從開始選單捷徑啟動 Edge
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
    }
}

; ============================================================
; Insert 鍵 - 開啟/切換到 Cursor 編輯器
; ============================================================
Ins:: {
    ; cursor.exe 是 Cursor AI 編輯器的執行檔
    if WinExist("ahk_exe cursor.exe") {
        WinActivate()  ; Cursor 已開啟，切換到該視窗
    } else {
        ; 啟動 Cursor 編輯器
        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
    }
}

; ============================================================
; 修飾鍵 + 按鍵 啟動應用程式
; ============================================================

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
; 已註解掉：右 Ctrl 開啟 IntelliJ IDEA（已改用 RCtrl + 方向鍵組合）
; ============================================================
;RCtrl:: {
;    ; 檢查 IntelliJ IDEA 是否已經在執行
;    if WinExist("ahk_exe idea64.exe") {
;        WinActivate()  ; 如果已開啟，切換到 IDEA 視窗
;    } else {
;        ; 如果沒開啟，執行 IntelliJ IDEA
;        Run("C:\\Program Files\\JetBrains\\IntelliJ IDEA 2024.1.4\\bin\\idea64.exe")
;    }
;}

; ============================================================
; RCtrl + Left 開啟/切換到 Visual Studio Code
; ============================================================
RCtrl & Left:: {
    if WinExist("ahk_exe Code.exe") {
        WinActivate()
    } else {
        Run(A_AppData "\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk")
    }
}

; ============================================================
; RCtrl + Up 開啟/切換到 Google Chrome（排除 PWA 視窗）
; ============================================================
RCtrl & Up:: {
    if WinExist("ahk_exe Chrome.exe") {
        ChromeWindows := WinGetList("ahk_exe Chrome.exe")
        for hwnd in ChromeWindows {
            WinTitle := WinGetTitle(hwnd)
            ; 排除 Chrome PWA 視窗（Google Chat、Google 日曆等）
            if !InStr(WinTitle, "Google Chat") && !InStr(WinTitle, "Google 日曆") {
                WinActivate(hwnd)
                return
            }
        }
        ; 所有視窗都是 PWA，開啟新的 Chrome
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk")
    } else {
        Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk")
    }
}

; ============================================================
; RCtrl + Down 開啟/切換到 Claude
; ============================================================
RCtrl & Down:: {
    if WinExist("ahk_exe Claude.exe") {
        WinActivate()
    } else {
        Run("shell:AppsFolder\Claude_pzs8sxrjxfjjc!Claude")
    }
}

; ============================================================
; 已註解掉：Ctrl+減號 開啟/切換到 Cursor 編輯器
; ============================================================
;^-:: {
;    ; 檢查 Cursor 是否已經在執行
;    if WinExist("ahk_exe cursor.exe") {
;        WinActivate()  ; 如果已開啟，切換到 Cursor 視窗
;    } else {
;        ; 如果沒開啟，執行 Cursor 編輯器
;        Run("C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe")
;    }
;    ; 呼叫函數將 Cursor 視窗移動到指定位置（定義在其他模組）
;    MoveCursorWorkbenchToPercentage()
;}

; ============================================================
; 已註解掉：Ctrl+等號 開啟/切換到 Windsurf 編輯器
; ============================================================
;^=:: {
;    ; 檢查 Windsurf 是否已經在執行
;    if WinExist("ahk_exe windsurf.exe") {
;        WinActivate()  ; 如果已開啟，切換到 Windsurf 視窗
;    } else {
;        ; 如果沒開啟，執行 Windsurf 編輯器
;        Run("C:\Users\user\OneDrive\桌面\Windsurf.lnk")
;    }
;}

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

; ============================================================
; Alt+Space 開啟/切換到 Microsoft Copilot
; ============================================================
!Space:: {
    if WinExist("ahk_exe Copilot.exe") {
        if WinActive("ahk_exe Copilot.exe") {
            WinMinimize()
        } else {
            WinActivate()
        }
    } else {
        Run("ms-copilot:")
    }
    Return
}

; ============================================================
; 在此處新增其他應用程式快捷鍵...
; ============================================================
