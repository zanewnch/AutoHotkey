#Requires AutoHotkey v2.0+

; ======================================
; 滑鼠位置記錄腳本
; ======================================

; 設置基本配置
SendMode("Input")
SetTitleMatchMode(2)
SetWorkingDir(A_ScriptDir)

; 初始化位置變數
global cursorWorkbenchX := 0
global cursorWorkbenchY := 0
global ideAIChatX := 0
global ideAIChatY := 0
global browserAIChatX := 0
global browserAIChatY := 0
global browserAIMoeX := 0
global browserAIMoeY := 0

; 初始化計數器
global positionCounter := 0

; 初始化位置名稱映射
global positionNames := [
    "Cursor 工作區",
    "IDE AI 聊天室",
    "瀏覽器 AI 聊天",
    "瀏覽器 AI Moe"
]

; 快捷鍵：Ctrl+Alt+Shift+C 循環記錄位置
^!+c:: {
    global positionCounter
    
    ; 首次按下時顯示開始通知
    if (positionCounter = 0) {
        ShowNotification("開始記錄位置", "請將滑鼠移動到第一個位置: " . positionNames[1])
        positionCounter++
        Return
    }
    
    ; 記錄當前位置
    MouseGetPos(&currentX, &currentY)
    
    ; 根據計數器決定儲存到哪個變數
    if (positionCounter = 1) {
        cursorWorkbenchX := currentX
        cursorWorkbenchY := currentY
        ShowNotification("已記錄位置 1", positionNames[1] . " X=" . currentX . ", Y=" . currentY)
    } else if (positionCounter = 2) {
        ideAIChatX := currentX
        ideAIChatY := currentY
        ShowNotification("已記錄位置 2", positionNames[2] . " X=" . currentX . ", Y=" . currentY)
    } else if (positionCounter = 3) {
        browserAIChatX := currentX
        browserAIChatY := currentY
        ShowNotification("已記錄位置 3", positionNames[3] . " X=" . currentX . ", Y=" . currentY)
    } else if (positionCounter = 4) {
        browserAIMoeX := currentX
        browserAIMoeY := currentY
        ShowNotification("已記錄位置 4", positionNames[4] . " X=" . currentX . ", Y=" . currentY)
        
        ; 所有位置都記錄完成，生成配置檔案
        GenerateConfigFile()
        positionCounter := 0  ; 重置計數器
        ShowNotification("完成所有位置記錄", "配置已儲存至 mouse_positions.txt")
        Return
    }
    
    ; 增加計數器並提示下一個位置
    positionCounter++
    if (positionCounter <= 4) {
        ShowNotification("請記錄下一個位置", "移動滑鼠到: " . positionNames[positionCounter])
    }
    
    Return
}

; 顯示系統通知
ShowNotification(title, message) {
    TrayTip(message, title)
    SetTimer () => TrayTip(), -3000  ; 3秒後清除通知
}

; 生成配置檔案
GenerateConfigFile() {
    configContent := "
(
; 自動生成的滑鼠位置配置
; 時間: " . FormatTime(, "yyyy-MM-dd HH:mm:ss") . "

; Cursor 工作區位置
global cursorWorkbenchX := " . cursorWorkbenchX . "
global cursorWorkbenchY := " . cursorWorkbenchY . "

; IDE AI 聊天室位置
global ideAIChatX := " . ideAIChatX . "
global ideAIChatY := " . ideAIChatY . "

; 瀏覽器 AI 聊天位置
global browserAIChatX := " . browserAIChatX . "
global browserAIChatY := " . browserAIChatY . "

; 瀏覽器 AI Moe 位置
global browserAIMoeX := " . browserAIMoeX . "
global browserAIMoeY := " . browserAIMoeY . "
)"
    
    ; 寫入配置檔案
    FileDelete("mouse_positions.txt")
    FileAppend(configContent, "mouse_positions.txt")
}

; 顯示啟動通知
ShowNotification("滑鼠位置記錄工具已啟動", "按下 Ctrl+Alt+Shift+C 開始記錄位置") 