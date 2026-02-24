# AutoHotkey

Windows 開機自動啟動的 AutoHotkey v2 腳本，提供快捷鍵、應用程式啟動、滑鼠模擬，以及系統健康檢查功能。

## 需求

- AutoHotkey v2.0+
- Windows 10 / 11

## 專案結構

```
AutoHotkey/
├── main.ahk                    # 入口點：載入所有模組、執行開機檢查
└── modules/
    ├── config.ahk              # 全域設定（螢幕尺寸、滑鼠位置等變數）
    ├── utils.ahk               # 工具函數
    ├── app_launcher.ahk        # 應用程式快捷啟動
    ├── key_remapping.ahk       # 按鍵重映射
    ├── mouse_simulation.ahk    # 滑鼠模擬
    └── app_specific.ahk        # 應用程式專屬快捷鍵
```

---

## 功能說明

### 開機自動檢查（main.ahk）

每次 AHK 啟動時自動執行系統健康檢查：

#### HypervisorPlatform 檢查

> **背景**
>
> Claude Code CLI 在本地執行 Notion MCP 時不穩定，但透過 Claude 的 cowork local environment 功能執行相同操作卻可以正常運作（兩者使用的 MCP / plugin 機制不同）。
> 因此改用 cowork 作為操作 Notion 的方式。
>
> 然而 cowork local environment 需要 `HypervisorPlatform` 啟用才能正常運作。
> 若未啟用，建立 cowork 環境時會出現以下錯誤：
> ```
> RPC error -1: failed to ensure virtiofs mount: Plan9 mount failed: bad address
> ```
> 排查過程：起初以為是 WSL2 本身的問題，嘗試重啟 WSL、更新版本等方式，
> 後來確認 cowork 官方文件有明確要求 HypervisorPlatform 必須啟用，
> 才發現根本原因是 HypervisorPlatform 被關閉了。
>
> 進一步發現原因是 GTA Online（BattlEye）和 NBA 2K 的 anti-cheat 軟體會在安裝或啟動時自動 disable HypervisorPlatform，無法永久預防。
> 因此需要在每次開機時自動偵測並修復。

> **為什麼放在這裡？**
>
> 理想上，開機所需的系統檢查應該有一個獨立的 `main` 腳本統一管理，AutoHotkey 只負責快捷鍵邏輯。
> 但目前這個 AutoHotkey 腳本是唯一一個每次開機都確定會執行的腳本，
> 所以暫時將 HypervisorPlatform 的檢查邏輯放在這裡。
> 未來若有更多開機需要執行的任務，可以建立一個專門的開機腳本統一管理，再將這段邏輯移過去。

部分 anti-cheat 軟體（如 GTA Online 的 BattlEye、NBA 2K 的 anti-cheat）會在安裝或啟動時自動 disable `HypervisorPlatform`，導致 WSL2 / virtiofs / Docker 相關功能無法正常運作。

腳本會在每次開機時自動偵測並提示修復：

| 狀態 | 行為 |
|------|------|
| `Enabled` | 靜默通過，不打擾 |
| `Disabled` | 彈出提示，詢問是否重新啟用（需重開機） |
| `EnablePending` | 提醒重開機以完成啟用 |
| Feature 不存在 | 靜默跳過（相容不支援的 Windows 版本） |
| PowerShell 執行失敗 | 靜默跳過，不中斷 AHK 啟動 |

---

### 應用程式快捷啟動（app_launcher.ahk）

邏輯：若應用程式已開啟則切換到該視窗，否則啟動它。

| 快捷鍵 | 應用程式 |
|--------|----------|
| `Home` | Brave 瀏覽器 |
| `End` | Microsoft Edge |
| `Insert` | Cursor 編輯器 |
| `RCtrl` | IntelliJ IDEA |
| `Ctrl + Backspace` | Android Studio |
| `Ctrl + ←` | Cursor 編輯器（並調整視窗位置） |
| `Ctrl + →` | Microsoft Edge（排除 YouTube Music 視窗） |
| `Ctrl + ↑` | Android Studio |
| `Ctrl + ↓` | Google Chrome |
| `Ctrl + Shift + ←` | WebStorm |
| `Ctrl + Shift + ↓` | Microsoft Copilot |
| `Alt + Space` | Microsoft Copilot |

---

### 按鍵重映射（key_remapping.ahk）

#### 視窗切換
| 快捷鍵 | 功能 |
|--------|------|
| `Ctrl + Tab` | 模擬 Alt+Tab 切換視窗 |

#### 左 Alt → Ctrl（瀏覽器風格）

將左 Alt 鍵映射為 Ctrl，讓常用操作更順手：

| 快捷鍵 | 功能 |
|--------|------|
| `LAlt + A` | 全選 |
| `LAlt + C` | 複製 |
| `LAlt + X` | 剪下 |
| `LAlt + V` | 貼上 |
| `LAlt + S` | 儲存 |
| `LAlt + F` | 搜尋 |
| `LAlt + W` | 關閉分頁 |
| `LAlt + T` | 新增分頁 |
| `LAlt + R` | 重新整理 |
| `LAlt + Z` | 復原 |

#### 導航
| 快捷鍵 | 功能 |
|--------|------|
| `LAlt + ←` / `LAlt + ↑` | 移動游標到行首 |
| `LAlt + →` / `LAlt + ↓` | 移動游標到行尾 |
| `LAlt + Shift + ←` | 選取至行首 |
| `LAlt + Shift + →` | 選取至行尾 |

---

### 滑鼠模擬（mouse_simulation.ahk）

| 快捷鍵 | 功能 |
|--------|------|
| `CapsLock + Enter` | 滑鼠左鍵點擊 |
| `LAlt + Enter` | 滑鼠左鍵點擊 |
| `LAlt + Backspace` | 滑鼠右鍵點擊 |
| `CapsLock + ↑` | 滾輪向上 |
| `CapsLock + ↓` | 滾輪向下 |
| `CapsLock + ←` | 滾輪向左（水平捲動） |
| `CapsLock + →` | 滾輪向右（水平捲動） |

> CapsLock 本身的大小寫切換功能已被停用。

---

### 應用程式專屬快捷鍵（app_specific.ahk）

#### Cursor 編輯器
| 快捷鍵 | 功能 |
|--------|------|
| `Ctrl + L` | 將滑鼠移到 AI 聊天輸入框位置（螢幕 75%, 83%） |
