# Define log path
$LogFolder = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"
$LogFile = Join-Path $LogFolder "DetectionScript-Infatica.log"

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

# Detection logic
$BaseRegistryPath = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
$TargetDisplayName = "Infatica P2B Network"
$ExpectedInstallPath = "C:\Program Files (x86)\Infatica P2B\"
$ExitCode = 0

Write-Log "==== Infatica Detection Started ===="

#Checks each child path in $BaseRegistryPath and finds one with a DisplayName of "Infatica P2B Network"
try {
    Write-Log "Searching for Infatica registry key under $BaseRegistryPath"

    $Key = Get-ChildItem -Path $BaseRegistryPath | ForEach-Object {
        try {
            $props = Get-ItemProperty -Path $_.PSPath
            if ($props.DisplayName -like "$TargetDisplayName*") {
                return $props
            }
        } catch {}
    } | Select-Object -First 1

    if (-not $Key) {
        Write-Log "Infatica not installed. Matching registry key not found."
        Write-Host "Infatica not installed. Registry key not found."
    }
    elseif (-not ($Key.PSObject.Properties.Name -contains "InstallLocation")) {
        Write-Log "Infatica installed but InstallLocation property missing."
        Write-Host "Infatica installed but InstallLocation missing."
    }
    else {
        $CurrentValue = $Key.InstallLocation
        Write-Log "Found InstallLocation = $CurrentValue."

        if ($CurrentValue -eq $ExpectedInstallPath) {
            Write-Log "Infatica install found and matches expected path."
            Write-Host "Infatica found"
            $ExitCode = 1
        }
        else {
            Write-Log "Infatica install path does not match expected. Found: $CurrentValue"
            Write-Host "Infatica install path mismatch."
        }
    }
}
catch {
    Write-Log "ERROR. Exception occurred: $_"
    Write-Host "Not Compliant. Error during detection."
}
finally {
    Write-Log "==== Infatica Detection Ended ====`n"
    exit $ExitCode
}
