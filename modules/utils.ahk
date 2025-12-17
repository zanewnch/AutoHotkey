#Requires AutoHotkey v2.0+  ; 指定需要 AutoHotkey v2.0 或更高版本才能執行此腳本

; ============================================================
; 工具函數模組
; ============================================================

; ============================================================
; MoveCursorWorkbenchToPercentage - 將滑鼠游標移動到螢幕的百分比位置
; ============================================================
; 參數說明：
;   xPercent - X 軸的百分比位置（預設使用 cursor_workbench_x_axis 全域變數）
;   yPercent - Y 軸的百分比位置（預設使用 global_y_axis 全域變數）
;
; 功能說明：
;   這個函數用來快速將滑鼠移動到螢幕上的特定位置
;   主要用於切換到 Cursor 編輯器時，自動將滑鼠定位到工作區
; ============================================================
MoveCursorWorkbenchToPercentage(xPercent := cursor_workbench_x_axis, yPercent := global_y_axis) {
    ; 宣告使用全域變數（預設的 X、Y 座標位置）
    global defaultXPos, defaultYPos

    ; 檢查是否使用預設的百分比值
    if (xPercent = cursor_workbench_x_axis && yPercent = global_y_axis) {
        ; 如果是預設值，直接使用已經計算好的預設座標位置
        ; 第三個參數 0 表示瞬間移動（不要動畫效果）
        MouseMove(defaultXPos, defaultYPos, 0)
    } else {
        ; 如果是自訂的百分比值，需要重新計算座標
        ; 宣告使用螢幕寬度和高度的全域變數
        global screenWidth, screenHeight

        ; 將百分比轉換為實際像素座標
        ; 例如：螢幕寬度 1920，百分比 50% -> xPos = 1920 * 0.5 = 960
        xPos := screenWidth * (xPercent / 100)
        yPos := screenHeight * (yPercent / 100)

        ; 將滑鼠移動到計算出的座標位置
        MouseMove(xPos, yPos, 0)
    }
    Return  ; 函數結束
}
