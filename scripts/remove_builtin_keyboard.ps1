$ErrorActionPreference = "Continue"

$deviceIds = @(
    "ACPI\MSI0007\4&10CC4C72&0",
    "HID\VID_1038&PID_2038&MI_01&COL02\3&31E7735C&0&0001",
    "HID\VID_1038&PID_2038&MI_01&COL01\3&31E7735C&0&0000",
    "HID\VID_1038&PID_2038&MI_01&COL03\3&31E7735C&0&0002",
    "HID\VID_1038&PID_2038&MI_00\3&1A23E717&0&0000",
    "USB\VID_1038&PID_2038&MI_00\2&336DA45B&0&0000",
    "USB\VID_1038&PID_2038&MI_01\2&336DA45B&0&0001",
    "USB\VID_1038&PID_2038\1&79F5D87&4&4869",
    "{DE4BF873-915A-4D6D-B8C7-1EBF5F707588}\SSPS2\5&88E1CD&0&01"
)

foreach ($deviceId in $deviceIds) {
    $device = Get-PnpDevice -InstanceId $deviceId -ErrorAction SilentlyContinue
    if (-not $device) {
        continue
    }

    & pnputil /remove-device $deviceId *> $null
}
