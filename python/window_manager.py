import ctypes
import os
from typing import Optional

import psutil
import win32con
import win32gui
import win32process


def _iter_top_level_windows():
    results = []

    def handler(hwnd, _):
        if win32gui.IsWindowVisible(hwnd):
            results.append(hwnd)

    win32gui.EnumWindows(handler, None)
    return results


def find_window_by_exe(
    exe_name: str,
    title_contains: Optional[str] = None,
    title_excludes: Optional[str] = None,
) -> Optional[int]:
    exe_name = exe_name.lower()
    for hwnd in _iter_top_level_windows():
        try:
            _, pid = win32process.GetWindowThreadProcessId(hwnd)
            proc_name = psutil.Process(pid).name().lower()
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            continue
        if proc_name != exe_name:
            continue

        title = win32gui.GetWindowText(hwnd)
        if title_contains and title_contains.lower() not in title.lower():
            continue
        if title_excludes and title_excludes.lower() in title.lower():
            continue
        return hwnd
    return None


def activate_window(hwnd: int) -> None:
    if win32gui.IsIconic(hwnd):
        win32gui.ShowWindow(hwnd, win32con.SW_RESTORE)
    # SetForegroundWindow 在非前景程序呼叫時會被 Windows 擋掉；
    # 送一次 Alt 可以解除焦點鎖定。
    user32 = ctypes.windll.user32
    user32.keybd_event(0x12, 0, 0, 0)
    user32.keybd_event(0x12, 0, 2, 0)
    try:
        win32gui.SetForegroundWindow(hwnd)
    except Exception:
        pass


def activate_or_launch(
    exe_name: str,
    launch_target: str,
    title_contains: Optional[str] = None,
    title_excludes: Optional[str] = None,
) -> None:
    hwnd = find_window_by_exe(exe_name, title_contains, title_excludes)
    if hwnd:
        activate_window(hwnd)
        return
    try:
        os.startfile(launch_target)
    except OSError as ex:
        print(f"[launch failed] {launch_target}: {ex}")
