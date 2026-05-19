import keyboard

import app_launcher
import app_specific
import key_remapping
import mouse_sim
import startup_check
import startup_ui

QUIT_HOTKEY = "ctrl+alt+q"
SHOW_HOTKEY = "ctrl+alt+s"


def main():
    startup_check.check_hypervisor_platform()

    mouse_sim.register()
    key_remapping.register()
    app_specific.register()
    report = app_launcher.register()

    keyboard.add_hotkey(QUIT_HOTKEY, startup_ui.signal_quit)
    keyboard.add_hotkey(SHOW_HOTKEY, startup_ui.show_window)

    startup_ui.show(report, QUIT_HOTKEY, SHOW_HOTKEY)


if __name__ == "__main__":
    main()
