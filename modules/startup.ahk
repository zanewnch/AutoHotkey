#Requires AutoHotkey v2.0+

; ============================================================
; 開機程序模組 (Startup)
; ============================================================
; 開機時跳出 InputBox 選擇模式，自動啟動對應的應用程式
; 如果 app 已在執行則跳過，啟動前驗證路徑是否存在
; ============================================================

; 用 SetTimer 延遲執行，確保 auto-execute section 先完成，hotkeys 先註冊好
SetTimer(StartupPrompt, -1)

global StartupLaunchQueue := []

; ============================================================
; 啟動提示 - 讓使用者選擇模式
; ============================================================
StartupPrompt() {
    ; 建立自訂 GUI 視窗
    myGui := Gui("+AlwaysOnTop", "Startup 模式選擇")
    myGui.SetFont("s10")

    myGui.AddText("w280", "請輸入啟動模式:")
    myGui.AddText("w280", "1 = Development Mode（全部啟動）")
    myGui.AddText("w280", "0 = 跳過（不啟動任何 app）")

    ; 建立輸入框並設定 hint（灰色提示文字）
    editCtrl := myGui.AddEdit("w280 vModeInput")
    ; EM_SETCUEBANNER = 0x1501，設定 placeholder hint
    DllCall("SendMessage", "Ptr", editCtrl.Hwnd, "UInt", 0x1501, "Int", true, "Str", "輸入模式編號，例如: 1")

    ; 確認 & 取消按鈕
    btnOK := myGui.AddButton("w135 Default", "確認")
    btnCancel := myGui.AddButton("x+10 w135", "取消")

    ; 儲存結果的變數
    selectedMode := ""

    btnOK.OnEvent("Click", (*) => (selectedMode := myGui["ModeInput"].Value, myGui.Destroy()))
    btnCancel.OnEvent("Click", (*) => myGui.Destroy())
    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.OnEvent("Escape", (*) => myGui.Destroy())

    myGui.Show("w320")

    ; 等待視窗關閉
    WinWaitClose(myGui.Hwnd)

    ; 處理選擇結果
    switch selectedMode {
        case "1":
            LaunchDevelopmentMode()
        case "0", "":
            return
        default:
            MsgBox("無效的模式: " selectedMode, "Startup 警告", "Icon!")
    }
}
; ============================================================
; Development Mode - 啟動所有開發用 app
; ============================================================
LaunchDevelopmentMode() {
    global StartupLaunchQueue
    startupApps := [
        "copilot",
        "chrome",
        "edge",
        "vscode",
        "claude",
        "line",
        "notion",
        "googleCalendar",
        "googleChat"
    ]

    StartupLaunchQueue := []

    for appKey in startupApps
        StartupLaunchQueue.Push(appKey)

    SetTimer(LaunchNextStartupItem, -1)
}

LaunchNextStartupItem() {
    global StartupLaunchQueue

    if (StartupLaunchQueue.Length = 0) {
        ; 啟動流程結束後強制重新安裝 keyboard hook。
        ; 大量 app 啟動期間 Windows 可能因 LowLevelHooksTimeout 靜默移除 hook。
        InstallKeybdHook(true, true)
        return
    }

    appKey := StartupLaunchQueue.RemoveAt(1)
    EnsureAppRunning(appKey)

    ; 不用 Sleep 卡住 AHK 主執行緒，讓 hotkeys/hook 在 startup 期間仍可回應。
    InstallKeybdHook(true, true)
    SetTimer(LaunchNextStartupItem, -1500)
}
