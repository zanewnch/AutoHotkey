import keyboard
import psutil
import win32gui
import win32process

from utils import move_cursor_to_percentage


def _active_window_exe() -> str | None:
    hwnd = win32gui.GetForegroundWindow()
    if not hwnd:
        return None
    try:
        _, pid = win32process.GetWindowThreadProcessId(hwnd)
        return psutil.Process(pid).name().lower()
    except (psutil.NoSuchProcess, psutil.AccessDenied):
        return None


def _on_l(e):
    # 只處理 key down；key up 讓它自然走
    if e.event_type != "down":
        return True
    # 沒按 Ctrl → 純字母 L，一定放行
    if not keyboard.is_pressed("ctrl"):
        return True
    # Ctrl+L：只在 Cursor 內吃掉 + 移動滑鼠；其他 app（Chrome 等）放行原本功能
    if _active_window_exe() == "cursor.exe":
        move_cursor_to_percentage(75, 83)
        return False
    return True


def register():
    keyboard.hook_key("l", _on_l, suppress=True)
