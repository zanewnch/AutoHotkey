import ctypes

_user32 = ctypes.windll.user32
SCREEN_WIDTH = _user32.GetSystemMetrics(0)
SCREEN_HEIGHT = _user32.GetSystemMetrics(1)

CURSOR_WORKBENCH_X_PCT = 25
GLOBAL_Y_PCT = 50

DEFAULT_X = int(SCREEN_WIDTH * CURSOR_WORKBENCH_X_PCT / 100)
DEFAULT_Y = int(SCREEN_HEIGHT * GLOBAL_Y_PCT / 100)
