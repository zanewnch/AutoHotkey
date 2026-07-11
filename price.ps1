$OutputFile = Join-Path $PSScriptRoot "Laptop-Info.txt"

$computer = Get-CimInstance Win32_ComputerSystem
$bios     = Get-CimInstance Win32_BIOS
$cpu      = Get-CimInstance Win32_Processor
$gpu      = Get-CimInstance Win32_VideoController
$disks    = Get-CimInstance Win32_DiskDrive
$os       = Get-CimInstance Win32_OperatingSystem
$ram      = Get-CimInstance Win32_PhysicalMemory
$physicalDisks = Get-PhysicalDisk -ErrorAction SilentlyContinue
$monitors = Get-CimInstance -Namespace root\WMI -ClassName WmiMonitorID -ErrorAction SilentlyContinue |
    Where-Object Active
$monitorDimensions = Get-CimInstance -Namespace root\WMI -ClassName WmiMonitorBasicDisplayParams -ErrorAction SilentlyContinue |
    Where-Object Active
$monitorConnections = Get-CimInstance -Namespace root\WMI -ClassName WmiMonitorConnectionParams -ErrorAction SilentlyContinue |
    Where-Object Active
$battery  = Get-CimInstance -Namespace root\WMI -ClassName BatteryStaticData -ErrorAction SilentlyContinue
$charge   = Get-CimInstance -Namespace root\WMI -ClassName BatteryFullChargedCapacity -ErrorAction SilentlyContinue
$batteryCycle = Get-CimInstance -Namespace root\WMI -ClassName BatteryCycleCount -ErrorAction SilentlyContinue | Select-Object -First 1
$activation = Get-CimInstance SoftwareLicensingProduct |
    Where-Object { $_.Name -like "Windows*" -and $_.PartialProductKey -and $_.LicenseStatus -eq 1 } |
    Select-Object -First 1

$designCapacity = if ($battery) { [double]$battery.DesignedCapacity } else { $null }
$fullCapacity   = if ($charge) { [double]$charge.FullChargedCapacity } else { $null }

# Some firmware does not expose the design capacity through WMI. In that case,
# use Windows' own battery report as a fallback.
if ($null -eq $designCapacity) {
    $batteryReportPath = Join-Path $env:TEMP "battery-report-$PID.html"
    try {
        powercfg /batteryreport /output $batteryReportPath | Out-Null
        $batteryReport = Get-Content -LiteralPath $batteryReportPath -Raw -ErrorAction Stop
        $designMatch = [regex]::Match($batteryReport, 'DESIGN CAPACITY</span></td><td>([\d,]+)\s*mWh', 'IgnoreCase')
        $fullMatch = [regex]::Match($batteryReport, 'FULL CHARGE CAPACITY</span></td><td>([\d,]+)\s*mWh', 'IgnoreCase')

        if ($designMatch.Success) {
            $designCapacity = [double]($designMatch.Groups[1].Value -replace ',', '')
        }
        if ($null -eq $fullCapacity -and $fullMatch.Success) {
            $fullCapacity = [double]($fullMatch.Groups[1].Value -replace ',', '')
        }
    } catch {
        # Leave battery details out when Windows cannot generate a report.
    } finally {
        Remove-Item -LiteralPath $batteryReportPath -Force -ErrorAction SilentlyContinue
    }
}

$biosDate = $null
if ($bios.ReleaseDate) {
    try {
        $biosDate = if ($bios.ReleaseDate -is [datetime]) {
            $bios.ReleaseDate.ToString("yyyy-MM-dd")
        } else {
            [Management.ManagementDateTimeConverter]::ToDateTime($bios.ReleaseDate).ToString("yyyy-MM-dd")
        }
    } catch {
        # Some firmware reports an invalid or non-DMTF BIOS release date.
    }
}

$diskInfo = if ($physicalDisks) {
    ($physicalDisks | ForEach-Object {
        "$($_.FriendlyName) / $([math]::Round($_.Size / 1GB)) GB / $($_.MediaType) $($_.BusType) / Health: $($_.HealthStatus)"
    }) -join "`n"
} else {
    ($disks | ForEach-Object {
        "$($_.Model) / $([math]::Round($_.Size / 1GB)) GB"
    }) -join "`n"
}

$gpuInfo = ($gpu | Where-Object { $_.Name -notmatch "Virtual" } | Select-Object -ExpandProperty Name) -join "`n"

$activationLine = if ($activation) { "Windows 啟用：已啟用" } else { "" }
$biosLine = if ($biosDate) { "BIOS 日期：$biosDate" } else { "" }
$batteryInfo = @(
    if ($null -ne $designCapacity) { "電池設計容量：$designCapacity mWh" }
    if ($null -ne $fullCapacity) { "目前充滿容量：$fullCapacity mWh" }
    if ($null -ne $designCapacity -and $designCapacity -gt 0 -and $null -ne $fullCapacity) {
        "電池健康度：約 $([math]::Round(($fullCapacity / $designCapacity) * 100, 1)) %"
    }
    if ($null -ne $batteryCycle.CycleCount) { "電池循環次數：$($batteryCycle.CycleCount)" }
)
$batterySection = if ($batteryInfo) { "電池：`n$($batteryInfo -join "`n")" } else { "" }

$ramTypeMap = @{
    20 = "DDR"
    21 = "DDR2"
    24 = "DDR3"
    26 = "DDR4"
    30 = "LPDDR4"
    34 = "DDR5"
    35 = "LPDDR5"
    36 = "HBM3"
}
$ramTypes = ($ram | ForEach-Object {
    if ($ramTypeMap.ContainsKey([int]$_.SMBIOSMemoryType)) {
        $ramTypeMap[[int]$_.SMBIOSMemoryType]
    } else {
        "Unknown (SMBIOS type $($_.SMBIOSMemoryType))"
    }
} | Select-Object -Unique) -join ", "
$ramCapacity = [math]::Round((($ram | Measure-Object -Property Capacity -Sum).Sum / 1GB))
$ramSpeed = ($ram | Measure-Object -Property ConfiguredClockSpeed -Maximum).Maximum

function ConvertFrom-EdidText {
    param([byte[]]$Bytes)
    return (-join ($Bytes | Where-Object { $_ -ne 0 } | ForEach-Object { [char]$_ })).Trim()
}

$screenInfo = if ($monitors) {
    ($monitors | Where-Object {
        ($monitorConnections | Where-Object InstanceName -eq $_.InstanceName | Select-Object -First 1).VideoOutputTechnology -eq 2147483648
    } | ForEach-Object {
        $monitor = $_
        $dimensions = $monitorDimensions | Where-Object InstanceName -eq $monitor.InstanceName | Select-Object -First 1
        $connection = $monitorConnections | Where-Object InstanceName -eq $monitor.InstanceName | Select-Object -First 1
        $manufacturer = ConvertFrom-EdidText $monitor.ManufacturerName
        $model = ConvertFrom-EdidText $monitor.UserFriendlyName
        if (-not $model) { $model = ConvertFrom-EdidText $monitor.ProductCodeID }
        $diagonal = if ($dimensions.MaxHorizontalImageSize -and $dimensions.MaxVerticalImageSize) {
            [math]::Round([math]::Sqrt(($dimensions.MaxHorizontalImageSize * $dimensions.MaxHorizontalImageSize) + ($dimensions.MaxVerticalImageSize * $dimensions.MaxVerticalImageSize)) / 2.54, 1)
        } else {
            $null
        }
        $size = if ($diagonal) { " / $diagonal inch" } else { "" }
        "$manufacturer $model$size"
    }) -join "`n"
}
$screenSection = if ($screenInfo) { "螢幕：$screenInfo" } else { "" }

$report = @"
筆電估價資訊
==============================
品牌：$($computer.Manufacturer)
型號：$($computer.Model)
序號：$($bios.SerialNumber)

CPU：$($cpu.Name)
記憶體：$ramCapacity GB $ramTypes ($ramSpeed MT/s)

硬碟：
$diskInfo

顯示卡：
$gpuInfo

$screenSection

作業系統：$($os.Caption)
$activationLine
$biosLine

$batterySection
==============================
"@

try {
    if (Test-Path -LiteralPath $OutputFile) {
        Remove-Item -LiteralPath $OutputFile -Force -ErrorAction Stop
    }

    New-Item -ItemType File -Path $OutputFile -Force -ErrorAction Stop | Out-Null
    $report | Set-Content -LiteralPath $OutputFile -Encoding UTF8 -ErrorAction Stop
} catch {
    Write-Error "無法建立報告檔案：$OutputFile`n$($_.Exception.Message)"
    exit 1
}

Write-Output $report

Write-Host "已輸出至：$OutputFile"














