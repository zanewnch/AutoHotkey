import ctypes
import subprocess

_user32 = ctypes.windll.user32

_MB_OK = 0x0
_MB_YESNO = 0x4
_MB_ICONEXCLAMATION = 0x30
_IDYES = 6


def _msgbox(text: str, title: str, style: int) -> int:
    return _user32.MessageBoxW(0, text, title, style)


def check_hypervisor_platform() -> None:
    try:
        result = subprocess.run(
            [
                "powershell",
                "-NoProfile",
                "-NonInteractive",
                "-Command",
                "(Get-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform).State",
            ],
            capture_output=True,
            text=True,
            timeout=30,
        )
    except Exception:
        return

    state = (result.stdout or "").strip()
    if not state or "Error" in state or "Exception" in state:
        return

    if state == "Disabled":
        ans = _msgbox(
            "HypervisorPlatform 被關閉了\n(通常是 BattlEye / anti-cheat 造成的)\n\n要重新啟用嗎？(需要重開機)",
            "HypervisorPlatform 檢查",
            _MB_YESNO | _MB_ICONEXCLAMATION,
        )
        if ans == _IDYES:
            # Start-Process -Verb RunAs 觸發 UAC 提權
            try:
                subprocess.Popen(
                    [
                        "powershell",
                        "-ExecutionPolicy",
                        "Bypass",
                        "-Command",
                        "Start-Process powershell -Verb RunAs -ArgumentList "
                        "'-Command \"Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -NoRestart\"'",
                    ]
                )
            except Exception:
                pass
    elif state == "EnablePending":
        _msgbox(
            "HypervisorPlatform 已設定啟用，請重開機完成設定。",
            "HypervisorPlatform 提醒",
            _MB_OK | _MB_ICONEXCLAMATION,
        )
