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
    apps := []

    ; Microsoft Copilot (protocol 啟動，不需驗證路徑)
    apps.Push({name: "Microsoft Copilot", exe: "Copilot.exe", path: "ms-copilot:", checkPath: false})

    ; Google Chrome
    apps.Push({name: "Google Chrome", exe: "Chrome.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk", checkPath: true})

    ; Microsoft Edge
    apps.Push({name: "Microsoft Edge", exe: "msedge.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk", checkPath: true})

    ; VSCode
    apps.Push({name: "Visual Studio Code", exe: "Code.exe", path: "C:\Users\zanew\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk", checkPath: true})

    ; Claude (Store app，不需驗證路徑)
    apps.Push({name: "Claude", exe: "Claude.exe", path: "shell:AppsFolder\Claude_pzs8sxrjxfjjc!Claude", checkPath: false})

    ; LINE
    apps.Push({name: "LINE", exe: "LINE.exe", path: "C:\Users\zanew\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\LINE\LINE.lnk", checkPath: true})

    ; Notion
    apps.Push({name: "Notion", exe: "Notion.exe", path: "C:\Users\zanew\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Notion.lnk", checkPath: true})

    StartupLaunchQueue := []

    ; 啟動獨立 exe 的 app
    for app in apps {
        StartupLaunchQueue.Push({type: "app", app: app})
    }

    ; Google Calendar (Chrome PWA - 用標題判斷是否已開啟)
    StartupLaunchQueue.Push({type: "pwa", name: "Google 日曆", titleMatch: "Google 日曆", path: "C:\Users\zanew\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\Google 日曆.lnk"})

    ; Google Chat (Chrome PWA - 用標題判斷是否已開啟)
    StartupLaunchQueue.Push({type: "pwa", name: "Google Chat", titleMatch: "Google Chat", path: "C:\Users\zanew\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome 應用程式\Google Chat.lnk"})

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

    item := StartupLaunchQueue.RemoveAt(1)

    if (item.type = "app") {
        app := item.app
        LaunchApp(app.name, app.exe, app.path, app.checkPath)
    } else if (item.type = "pwa") {
        LaunchPWA(item.name, item.titleMatch, item.path)
    }

    ; 不用 Sleep 卡住 AHK 主執行緒，讓 hotkeys/hook 在 startup 期間仍可回應。
    InstallKeybdHook(true, true)
    SetTimer(LaunchNextStartupItem, -1500)
}

; ============================================================
; 啟動單一應用程式（獨立 exe）
; ============================================================
LaunchApp(name, exe, path, checkPath) {
    ; 檢查是否已在執行
    if WinExist("ahk_exe " exe) {
        return  ; 已開啟，跳過
    }

    ; 驗證路徑是否存在
    if checkPath && !FileExist(path) {
        MsgBox("找不到 " name " 的啟動路徑:`n" path, "Startup 警告", "Icon!")
        return
    }

    ; 啟動應用程式
    try {
        Run(path)
    } catch as err {
        MsgBox("啟動 " name " 失敗:`n" err.Message, "Startup 錯誤", "Icon!")
    }
}

; ============================================================
; 啟動 Chrome PWA（用視窗標題判斷是否已開啟）
; ============================================================
LaunchPWA(name, titleMatch, path) {
    ; 用標題搜尋是否已開啟
    if WinExist(titleMatch) {
        return  ; 已開啟，跳過
    }

    ; 驗證路徑是否存在
    if !FileExist(path) {
        MsgBox("找不到 " name " 的啟動路徑:`n" path, "Startup 警告", "Icon!")
        return
    }

    ; 啟動 PWA
    try {
        Run(path)
    } catch as err {
        MsgBox("啟動 " name " 失敗:`n" err.Message, "Startup 錯誤", "Icon!")
    }
}
