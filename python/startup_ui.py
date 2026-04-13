import os
import sys

import webview


def _resource_dir() -> str:
    # PyInstaller --onefile 會把資源解壓到 sys._MEIPASS
    if hasattr(sys, "_MEIPASS"):
        return sys._MEIPASS  # type: ignore[attr-defined]
    return os.path.dirname(os.path.abspath(__file__))

_window = None


class _Api:
    def __init__(self, data: dict):
        self._data = data

    def get_data(self) -> dict:
        return self._data

    def close_window(self) -> None:
        if _window is not None:
            _window.hide()

    def quit_app(self) -> None:
        if _window is not None:
            _window.destroy()


def signal_quit() -> None:
    """Ctrl+Alt+Q 呼叫：徹底關閉 app（destroy 會讓 webview.start() 返回）。"""
    if _window is not None:
        _window.destroy()


def show_window() -> None:
    """Ctrl+Alt+S 呼叫：重新顯示被隱藏的通知視窗。"""
    if _window is not None:
        _window.show()


def _on_closing() -> bool:
    # X 按鈕或 Alt+F4：只隱藏視窗，不終結程式。
    # return False = 取消預設的關閉行為。
    if _window is not None:
        _window.hide()
    return False


def _report_to_payload(report: dict, quit_hotkey: str, show_hotkey: str) -> dict:
    return {
        "registered": [
            {"hotkey": e.hotkey, "name": e.name}
            for e in report["registered"]
        ],
        "skipped": [
            {"hotkey": e.hotkey, "name": e.name, "reason": e.skipped_reason or ""}
            for e in report["skipped"]
        ],
        "quit_hotkey": quit_hotkey,
        "show_hotkey": show_hotkey,
    }


def show(report: dict, quit_hotkey: str, show_hotkey: str) -> None:
    global _window
    payload = _report_to_payload(report, quit_hotkey, show_hotkey)
    api = _Api(payload)

    html_path = os.path.join(_resource_dir(), "ui", "index.html")

    _window = webview.create_window(
        "AutoHotkeyPy",
        url=html_path,
        js_api=api,
        width=660,
        height=720,
        min_size=(520, 520),
        background_color="#0a0b12",
    )
    _window.events.closing += _on_closing
    webview.start()
    # webview.start() 返回 = _window 已 destroy → 使用者真的要退出
    os._exit(0)
