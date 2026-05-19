import os
from dataclasses import dataclass, field
from typing import Callable, Optional

import keyboard

from utils import move_cursor_to_percentage
from window_manager import activate_or_launch


@dataclass
class HotkeyEntry:
    hotkey: str
    name: str
    exe: str
    launch: str
    title_excludes: Optional[str] = None
    post_action: Optional[Callable[[], None]] = None
    skipped_reason: Optional[str] = field(default=None, init=False)


ENTRIES: list[HotkeyEntry] = [
    HotkeyEntry("home", "Brave", "brave.exe",
                r"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"),
    HotkeyEntry("end", "Edge", "msedge.exe",
                r"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk"),
    HotkeyEntry("insert", "Cursor", "cursor.exe",
                r"C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe"),
    HotkeyEntry("right ctrl", "IntelliJ IDEA", "idea64.exe",
                r"C:\Program Files\JetBrains\IntelliJ IDEA 2024.1.4\bin\idea64.exe"),
    HotkeyEntry("ctrl+backspace", "Android Studio", "studio64.exe",
                r"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Android Studio\Android Studio.lnk"),
    HotkeyEntry("ctrl+left", "Cursor (+ workbench)", "cursor.exe",
                r"C:\Users\user\AppData\Local\Programs\cursor\Cursor.exe",
                post_action=move_cursor_to_percentage),
    HotkeyEntry("ctrl+right", "Edge (skip YouTube Music)", "msedge.exe",
                r"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk",
                title_excludes="YouTube Music"),
    HotkeyEntry("ctrl+up", "Android Studio", "studio64.exe",
                r"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Android Studio\Android Studio.lnk"),
    HotkeyEntry("ctrl+down", "Chrome", "chrome.exe",
                r"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk"),
    HotkeyEntry("ctrl+shift+left", "WebStorm", "webstorm.exe",
                r"C:\Users\user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\JetBrains Toolbox\WebStorm.lnk"),
    HotkeyEntry("ctrl+shift+down", "Copilot", "copilot.exe", "ms-copilot:"),
    HotkeyEntry("alt+space", "Copilot", "copilot.exe", "ms-copilot:"),
]


def _target_exists(target: str) -> bool:
    # 非絕對路徑視為 protocol / shell alias（ms-copilot: 等），交給系統處理
    if not os.path.isabs(target):
        return True
    return os.path.exists(target)


def _make_handler(entry: HotkeyEntry):
    def handler():
        activate_or_launch(entry.exe, entry.launch, title_excludes=entry.title_excludes)
        if entry.post_action:
            entry.post_action()

    return handler


def register() -> dict:
    registered: list[HotkeyEntry] = []
    skipped: list[HotkeyEntry] = []

    for entry in ENTRIES:
        if not _target_exists(entry.launch):
            entry.skipped_reason = "target not found"
            skipped.append(entry)
            continue
        keyboard.add_hotkey(entry.hotkey, _make_handler(entry), suppress=True)
        registered.append(entry)

    return {"registered": registered, "skipped": skipped}
