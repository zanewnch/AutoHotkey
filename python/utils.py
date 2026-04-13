import ctypes

from config import (
    CURSOR_WORKBENCH_X_PCT,
    DEFAULT_X,
    DEFAULT_Y,
    GLOBAL_Y_PCT,
    SCREEN_HEIGHT,
    SCREEN_WIDTH,
)


def move_cursor_to_percentage(x_pct: float | None = None, y_pct: float | None = None) -> None:
    if x_pct is None and y_pct is None:
        x, y = DEFAULT_X, DEFAULT_Y
    else:
        xp = CURSOR_WORKBENCH_X_PCT if x_pct is None else x_pct
        yp = GLOBAL_Y_PCT if y_pct is None else y_pct
        x = int(SCREEN_WIDTH * xp / 100)
        y = int(SCREEN_HEIGHT * yp / 100)
    ctypes.windll.user32.SetCursorPos(x, y)
