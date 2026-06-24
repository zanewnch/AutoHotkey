param(
    [Parameter(Mandatory = $true)]
    [string]$DeviceId,

    [Parameter(Mandatory = $true)]
    [string]$LogPath
)

$ErrorActionPreference = "Continue"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Add-Content -Path $LogPath -Value "$timestamp remove_builtin_keyboard start: $DeviceId"

$device = Get-PnpDevice -InstanceId $DeviceId -ErrorAction SilentlyContinue
if (-not $device) {
    Add-Content -Path $LogPath -Value "$timestamp remove_builtin_keyboard skipped: device not found"
    exit 0
}

& pnputil /remove-device $DeviceId 2>&1 | Add-Content -Path $LogPath

$after = Get-PnpDevice -InstanceId $DeviceId -ErrorAction SilentlyContinue
if ($after) {
    Add-Content -Path $LogPath -Value "$timestamp remove_builtin_keyboard result: still present, status=$($after.Status)"
    exit 1
}

Add-Content -Path $LogPath -Value "$timestamp remove_builtin_keyboard result: removed"
