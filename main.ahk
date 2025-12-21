#Requires AutoHotkey v2.0+  ; 指定需要 AutoHotkey v2.0 或更高版本才能執行此腳本

; ============================================================
; 主程式入口點 - AutoHotkey 腳本的核心設定檔
; ============================================================
; 這個檔案是整個 AHK 腳本的入口點，負責：
;   1. 設定全域運行參數
;   2. 載入各個功能模組
;   3. 定義一些基礎的快捷鍵
; ============================================================

; ============================================================
; 核心設定（Core Configuration）
; ============================================================

; #InputLevel 1 - 設定熱鍵的輸入層級為 1
; 輸入層級決定熱鍵之間的優先順序（0-100）
; 層級較高的熱鍵可以觸發層級較低的熱鍵
; 預設層級是 0，設為 1 可以讓這些熱鍵觸發其他層級 0 的熱鍵
#InputLevel 1

; #UseHook false - 不使用鍵盤鉤子來實現熱鍵
; false = 使用 RegisterHotkey() 方法（較輕量）
; true = 使用鍵盤鉤子（可以攔截更多按鍵，但較耗資源）
#UseHook false

; SendMode("Input") - 設定按鍵發送模式為 "Input"
; Input 模式是最快速、最可靠的按鍵模擬方式
SendMode("Input")

; SetTitleMatchMode(2) - 設定視窗標題匹配模式為 2（部分匹配）
; 模式 2：標題中任何位置包含指定文字即可匹配
SetTitleMatchMode(2)

; SetWorkingDir(A_ScriptDir) - 設定工作目錄為腳本所在資料夾
; 確保 #Include 指令和檔案操作都基於腳本位置
SetWorkingDir(A_ScriptDir)

; ============================================================
; 載入功能模組（Include Modules）
; ============================================================
; 使用 #Include 指令載入其他 .ahk 檔案
; 載入順序很重要：config 和 utils 必須先載入，因為其他模組會用到它們定義的變數和函數

#Include modules/config.ahk           ; 全域設定（螢幕尺寸、滑鼠位置等變數）
#Include modules/utils.ahk            ; 工具函數（MoveCursorWorkbenchToPercentage 等）
#Include modules/app_launcher.ahk     ; 應用程式快捷啟動（啟動/切換各種程式）
#Include modules/key_remapping.ahk    ; 按鍵重映射（Alt→Ctrl、導航鍵等）
#Include modules/mouse_simulation.ahk ; 滑鼠模擬（點擊、滾輪控制）
#Include modules/app_specific.ahk     ; 應用程式專屬快捷鍵（僅在特定程式中生效）

; ============================================================
; 修復標準 Ctrl 組合鍵（Fix for Standard Ctrl Key Combinations）
; ============================================================
; 問題：因為上面設定了 #InputLevel 1，可能會影響到標準的 Ctrl 組合鍵
; 解決：將這些熱鍵設為 #InputLevel 0，並使用 ~ 前綴讓原本功能穿透
;
; #InputLevel 0 - 降低以下熱鍵的層級到 0
; ~ 前綴 - 不阻止按鍵的原本功能
; Return - 什麼都不做，只是確保熱鍵被註冊但不干擾原本行為
#InputLevel 0
~^a::Return  ; 穿透 Ctrl+A（全選）
~^c::Return  ; 穿透 Ctrl+C（複製）
~^v::Return  ; 穿透 Ctrl+V（貼上）
~^x::Return  ; 穿透 Ctrl+X（剪下）
~^z::Return  ; 穿透 Ctrl+Z（復原）
~^y::Return  ; 穿透 Ctrl+Y（重做）
~^f::Return  ; 穿透 Ctrl+F（尋找）
~^s::Return  ; 穿透 Ctrl+S（儲存）
#InputLevel 1  ; 恢復輸入層級為 1

; ============================================================
; 滑鼠模擬快捷鍵（Mouse Simulation Shortcuts）
; ============================================================

; SetCapsLockState("AlwaysOff") - 強制關閉 Caps Lock 燈號
; 這樣可以把 Caps Lock 鍵重新利用為修飾鍵，而不會影響大小寫切換
SetCapsLockState("AlwaysOff")

; CapsLock::Return - 單獨按下 Caps Lock 時什麼都不做
; 這防止了 Caps Lock 的原本功能（切換大小寫）
CapsLock::Return
