#Requires AutoHotkey v2.0+

; ============================================================
; Instagram 專用腳本
; ============================================================
; 功能：雙擊空白鍵 = 雙擊滑鼠左鍵
; 使用情境：瀏覽 Instagram 時快速按讚
; ============================================================

SendMode("Input")

; 雙擊空白鍵的時間間隔（毫秒）
global doubleClickThreshold := 300
global lastSpaceTime := 0

~Space:: {
    global lastSpaceTime
    currentTime := A_TickCount

    if (currentTime - lastSpaceTime < doubleClickThreshold) {
        ; 雙擊空白鍵偵測成功 -> 執行滑鼠雙擊
        Click(2)  ; 滑鼠左鍵雙擊
        lastSpaceTime := 0  ; 重置，避免連續觸發
    } else {
        lastSpaceTime := currentTime
    }
}
