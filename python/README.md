# Python 版本

完整移植自 `main.ahk` + `modules/*.ahk`。

## 結構

```
python/
├── main.py              # 入口點：開機檢查 + 註冊所有模組
├── config.py            # 螢幕尺寸與座標常數
├── utils.py             # 滑鼠百分比移動
├── window_manager.py    # activate_or_launch（exe 偵測 + 視窗切換 / 啟動）
├── startup_check.py     # HypervisorPlatform 開機檢查
├── app_launcher.py      # 應用程式快捷啟動（Home/End/Ins/RCtrl/Ctrl+方向...）
├── key_remapping.py     # 按鍵重映射（LAlt→Ctrl、Ctrl+Tab→Alt+Tab、行首/行尾）
├── mouse_sim.py         # 滑鼠模擬（CapsLock+方向=滾輪、LAlt+Enter=左鍵...）
├── app_specific.py      # 應用程式專屬（Cursor 的 Ctrl+L）
├── python-run.ps1       # 啟動
├── python-build.ps1     # 打包 exe
└── requirements.txt
```

## 安裝依賴

```bash
python -m pip install -r requirements.txt
```

依賴：
- `keyboard` — 全域熱鍵
- `pywin32` — 視窗列舉 / 切換 (`win32gui`, `win32process`)
- `psutil` — 透過 PID 取得 exe 名稱

## 啟動

### 正式使用（背景執行，無視窗閃現）

雙擊 `run.vbs`，或：

```powershell
wscript.exe .\run.vbs
```

- 用 `pythonw.exe` → 沒有 console
- `.vbs` 透過 `ShellExecute "runas"` 提權 → 只會有 UAC 那一下，其他什麼都不會閃
- 只剩 pywebview 通知視窗本身會出現（關掉不影響背景運作，`Ctrl+Alt+S` 重開）

### 開發模式（看得到 print / 錯誤）

```powershell
.\python-run.ps1
```

會開啟一個 PowerShell console，Python 的 log 會印在上面。

- 預設熱鍵請見 `app_launcher.py`
- 離開：`Ctrl + Alt + Q`
- **注意**：`keyboard` 套件在部分環境需要 **系統管理員權限** 才能穩定攔截按鍵。若熱鍵在某些程式（如遊戲、VSCode terminal）失效，請用系統管理員身分重新啟動。

## 背景執行（不顯示 console 視窗）

用 `pythonw.exe` 代替 `python.exe`：

```bash
pythonw main.py
```

或寫成 `start.vbs` 雙擊啟動：

```vbs
CreateObject("Wscript.Shell").Run "pythonw.exe """ & CreateObject("Scripting.FileSystemObject").GetAbsolutePathName("main.py") & """", 0, False
```

## 打包成 exe（PyInstaller）

```powershell
.\python-build.ps1
```

script 會自動：
1. 檢查 / 安裝 `pyinstaller`
2. 清掉舊的 `build/` `dist/` `AutoHotkeyPy.spec`
3. 用 `--onefile --noconsole` 打包
4. 產出 `dist/AutoHotkeyPy.exe`

若要在啟動時跑管理員權限，編輯 `python-build.ps1` 在 pyinstaller 指令加上 `--uac-admin`。

## 開機自動啟動

兩種方式擇一：

### 1. 啟動資料夾（最簡單）

按 `Win + R` 輸入 `shell:startup` 開啟啟動資料夾，放入：
- `AutoHotkeyPy.exe` 的捷徑，或
- `start.vbs` 的捷徑（若使用 pythonw 方式）

### 2. 工作排程器（需要管理員權限時推薦）

```powershell
$action = New-ScheduledTaskAction -Execute "C:\path\to\AutoHotkeyPy.exe"
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
Register-ScheduledTask -TaskName "AutoHotkeyPy" -Action $action -Trigger $trigger -Principal $principal
```

## 與 AHK 版本並存

目前 AHK (`main.ahk`) 仍管理 `app_launcher` 以外的所有功能。
測試 Python 版時請先把 AHK 中對應的 hotkey 註解掉，或整個關閉 AHK，避免兩邊同時攔截導致衝突。
