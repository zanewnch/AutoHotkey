# Launch Android Studio through WSL
# First, try to find studio.sh
$studioPath = wsl -e bash -c 'for p in /opt/android-studio/bin/studio.sh /usr/local/android-studio/bin/studio.sh ~/android-studio/bin/studio.sh; do [ -f "$p" ] && echo "$p" && exit 0; done; exit 1'
if ($LASTEXITCODE -eq 0) {
    Write-Host "Found Android Studio at: $studioPath"
    wsl -e bash -ic "$studioPath"
} else {
    Write-Host "Error: Could not find Android Studio installation in WSL."
    Write-Host "Please make sure Android Studio is installed in your WSL environment."
    Write-Host "Common installation paths are:"
    Write-Host "  - /opt/android-studio/bin/studio.sh"
    Write-Host "  - /usr/local/android-studio/bin/studio.sh"
    Write-Host "  - ~/android-studio/bin/studio.sh"
}


