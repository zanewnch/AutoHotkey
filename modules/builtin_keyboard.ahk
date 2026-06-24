#Requires AutoHotkey v2.0+

; Removes the MSI SteelSeries built-in keyboard after Windows login.
; Windows marks this PS/2 device as critical, so normal Disable-PnpDevice is blocked.
; Removing it requires elevation and may be restored by Windows after reboot.

RemoveBuiltinKeyboard() {
    deviceId := "ACPI\MSI0007\4&10CC4C72&0"
    logPath := A_ScriptDir "\AHK_DebugLog.txt"
    scriptPath := A_ScriptDir "\scripts\remove_builtin_keyboard.ps1"

    if (!BuiltinKeyboardIsPresent(deviceId)) {
        return
    }

    try {
        Run('*RunAs powershell.exe -NoProfile -ExecutionPolicy Bypass -File "' scriptPath '" -DeviceId "' deviceId '" -LogPath "' logPath '"', , "Hide")
    } catch as err {
        try {
            FileAppend(FormatTime(, "yyyy-MM-dd HH:mm:ss") " RemoveBuiltinKeyboard failed: " err.Message "`n", logPath, "UTF-8")
        }
    }
}

BuiltinKeyboardIsPresent(deviceId) {
    try {
        shell := ComObject("WScript.Shell")
        escapedDeviceId := StrReplace(deviceId, "'", "''")
        psCommand := 'powershell -NoProfile -NonInteractive -Command "if (Get-PnpDevice -InstanceId ''' escapedDeviceId ''' -ErrorAction SilentlyContinue) { ''present'' }"'
        exec := shell.Exec(psCommand)
        return Trim(exec.StdOut.ReadAll()) = "present"
    } catch {
        return false
    }
}
