#Requires AutoHotkey v2.0+

; Removes the MSI SteelSeries built-in keyboard after Windows login.
; Windows marks this PS/2 device as critical, so normal Disable-PnpDevice is blocked.
; Removing it requires elevation and may be restored by Windows after reboot.

RemoveBuiltinKeyboard() {
    scriptPath := A_ScriptDir "\scripts\remove_builtin_keyboard.ps1"

    if (!BuiltinKeyboardMayBePresent()) {
        return
    }

    try {
        Run('*RunAs powershell.exe -NoProfile -ExecutionPolicy Bypass -File "' scriptPath '"', , "Hide")
    } catch {
    }
}

BuiltinKeyboardMayBePresent() {
    try {
        shell := ComObject("WScript.Shell")
        exec := shell.Exec('pnputil /enum-devices')
        output := exec.StdOut.ReadAll() exec.StdErr.ReadAll()
        return InStr(output, "VID_1038&PID_2038") > 0 || InStr(output, "MSI0007") > 0 || InStr(output, "SSPS2") > 0
    } catch {
        return false
    }
}
