import ctypes

import keyboard

_user32 = ctypes.windll.user32

_MOUSEEVENTF_LEFTDOWN = 0x0002
_MOUSEEVENTF_LEFTUP = 0x0004
_MOUSEEVENTF_RIGHTDOWN = 0x0008
_MOUSEEVENTF_RIGHTUP = 0x0010
_MOUSEEVENTF_WHEEL = 0x0800
_MOUSEEVENTF_HWHEEL = 0x01000

_WHEEL_DELTA = 120

_caps_held = False


def _click_left():
    _user32.mouse_event(_MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
    _user32.mouse_event(_MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)


def _click_right():
    _user32.mouse_event(_MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0)
    _user32.mouse_event(_MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0)


def _wheel(delta: int, horizontal: bool = False):
    flag = _MOUSEEVENTF_HWHEEL if horizontal else _MOUSEEVENTF_WHEEL
    _user32.mouse_event(flag, 0, 0, delta, 0)


def _force_caps_off():
    VK_CAPITAL = 0x14
    if _user32.GetKeyState(VK_CAPITAL) & 1:
        _user32.keybd_event(VK_CAPITAL, 0, 0, 0)
        _user32.keybd_event(VK_CAPITAL, 0, 2, 0)


def _on_caps_lock(e):
    global _caps_held
    _caps_held = e.event_type == "down"
    return False  # CapsLock 自己永遠不送出，避免切換大小寫


def _on_enter(e):
    if e.event_type == "down" and _caps_held:
        _click_left()
        return False
    return True


def _on_arrow(direction: str):
    def handler(e):
        if e.event_type == "down" and _caps_held:
            if direction == "up":
                _wheel(_WHEEL_DELTA)
            elif direction == "down":
                _wheel(-_WHEEL_DELTA)
            elif direction == "left":
                _wheel(-_WHEEL_DELTA, horizontal=True)
            elif direction == "right":
                _wheel(_WHEEL_DELTA, horizontal=True)
            return False
        return True

    return handler


def register():
    _force_caps_off()
    keyboard.hook_key("caps lock", _on_caps_lock, suppress=True)
    keyboard.hook_key("enter", _on_enter, suppress=True)
    keyboard.hook_key("up", _on_arrow("up"), suppress=True)
    keyboard.hook_key("down", _on_arrow("down"), suppress=True)
    keyboard.hook_key("left", _on_arrow("left"), suppress=True)
    keyboard.hook_key("right", _on_arrow("right"), suppress=True)

    keyboard.add_hotkey("left alt+enter", _click_left, suppress=True)
    keyboard.add_hotkey("left alt+backspace", _click_right, suppress=True)
