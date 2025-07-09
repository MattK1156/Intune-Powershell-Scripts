# Define log path
$LogFolder = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"
$LogFile = Join-Path $LogFolder "RemediationScript-RestartNotification.log"

# Ensure log folder and file exist
if (-not (Test-Path $LogFolder)) {
    New-Item -Path $LogFolder -ItemType Directory -Force | Out-Null
}
if (-not (Test-Path $LogFile)) {
    New-Item -Path $LogFile -ItemType File -Force | Out-Null
}

function Write-Log {
    param([string]$Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "$Timestamp - $Message"
}

Write-Log "==== Remediation Script Started ===="

# Uninstall path
$UninstallPath = "C:\Program Files (x86)\K-Lite Codec Pack\unins000.exe"
$SilentArgs = "/VERYSILENT /NORESTART"

try {
    if (Test-Path $UninstallPath) {
        Write-Log "Uninstaller found at: $UninstallPath"
        Write-Log "Executing silent uninstall..."
        
        Start-Process -FilePath $UninstallPath -ArgumentList $SilentArgs -Wait -NoNewWindow
        Write-Log "Uninstall process completed."
    }
    else {
        Write-Log "Uninstaller not found at: $UninstallPath"
        Write-Host "Uninstaller EXE not found."
    }
}
catch {
    Write-Log "Error during remediation"
    Write-Host "An error occurred during uninstallation."
}
finally {
    Write-Log "==== Remediation Script Ended ====`n"
}
