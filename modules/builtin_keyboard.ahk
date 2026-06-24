#Requires AutoHotkey v2.0+

; Removes the MSI SteelSeries built-in keyboard after Windows login.
; Windows marks this PS/2 device as critical, so normal Disable-PnpDevice is blocked.
; Removing it requires elevation and may be restored by Windows after reboot.

RemoveBuiltinKeyboard() {
    deviceIds := [
        "ACPI\MSI0007\4&10CC4C72&0",
        "HID\VID_1038&PID_2038&MI_01&COL02\3&31E7735C&0&0001"
    ]
    logPath := A_ScriptDir "\AHK_DebugLog.txt"
    scriptPath := A_ScriptDir "\scripts\remove_builtin_keyboard.ps1"

    for deviceId in deviceIds {
        if (!BuiltinKeyboardIsPresent(deviceId)) {
            continue
        }

        try {
            Run('*RunAs powershell.exe -NoProfile -ExecutionPolicy Bypass -File "' scriptPath '" -DeviceId "' deviceId '" -LogPath "' logPath '"', , "Hide")
        } catch as err {
            try {
                FileAppend(FormatTime(, "yyyy-MM-dd HH:mm:ss") " RemoveBuiltinKeyboard failed for " deviceId ": " err.Message "`n", logPath, "UTF-8")
            }
        }
    }
}

BuiltinKeyboardIsPresent(deviceId) {
    try {
        shell := ComObject("WScript.Shell")
        exec := shell.Exec('pnputil /enum-devices /instanceid "' deviceId '"')
        output := exec.StdOut.ReadAll() exec.StdErr.ReadAll()
        return InStr(output, deviceId) > 0
    } catch {
        return false
    }
}
