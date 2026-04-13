import keyboard

_LALT_TO_CTRL = ["a", "c", "x", "v", "s", "f", "w", "t", "r", "z"]


def _ctrl_tab():
    keyboard.press("alt")
    keyboard.send("tab")
    keyboard.release("alt")


def _make_lalt_ctrl(letter: str):
    def handler():
        keyboard.send(f"ctrl+{letter}")

    return handler


def register():
    keyboard.add_hotkey("ctrl+tab", _ctrl_tab, suppress=True)

    for k in _LALT_TO_CTRL:
        keyboard.add_hotkey(f"left alt+{k}", _make_lalt_ctrl(k), suppress=True)

    keyboard.add_hotkey("left alt+left", lambda: keyboard.send("home"), suppress=True)
    keyboard.add_hotkey("left alt+right", lambda: keyboard.send("end"), suppress=True)
    keyboard.add_hotkey("left alt+up", lambda: keyboard.send("home"), suppress=True)
    keyboard.add_hotkey("left alt+down", lambda: keyboard.send("end"), suppress=True)

    keyboard.add_hotkey("left alt+shift+left", lambda: keyboard.send("shift+home"), suppress=True)
    keyboard.add_hotkey("left alt+shift+right", lambda: keyboard.send("shift+end"), suppress=True)
