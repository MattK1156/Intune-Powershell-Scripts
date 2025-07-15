# Define log path
$LogFolder = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"
$LogFile = Join-Path $LogFolder "DetectionScript-CodecPack.log"

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
$TargetDisplayName = "K-Lite Codec Pack"
$ExpectedInstallPath = "C:\Program Files (x86)\K-Lite Codec Pack\"
$ExitCode = 0

Write-Log "==== K-lite Detection Script Started ===="

#Checks each child path in $BaseRegistryPath and finds one with a DisplayName key of "K-Lite Codec Pack"
try {
    Write-Log "Searching for K-Lite registry key under $BaseRegistryPath"

    $Key = Get-ChildItem -Path $BaseRegistryPath | ForEach-Object {
        try {
            $props = Get-ItemProperty -Path $_.PSPath
            if ($props.DisplayName -like "$TargetDisplayName*") {
                return $props
            }
        } catch {}
    } | Select-Object -First 1

    if (-not $Key) {
        Write-Log "K-Lite not installed. Matching registry key not found."
        Write-Host "K-Lite not installed. Registry key not found."
    }
    elseif (-not ($Key.PSObject.Properties.Name -contains "InstallLocation")) {
        Write-Log "K-Lite installed but InstallLocation property missing."
        Write-Host "K-Lite installed but InstallLocation missing."
    }
    else {
        $CurrentValue = $Key.InstallLocation
        Write-Log "Found Install Location = $CurrentValue."

        if ($CurrentValue -eq $ExpectedInstallPath) {
            Write-Log "K-Lite install found and matches expected path."
            Write-Host "K-Lite found"
            $ExitCode = 1
        }
        else {
            Write-Log "K-Lite install path does not match expected. Found: $CurrentValue"
            Write-Host "K-Lite install path mismatch."
        }
    }
}
catch {
    Write-Log "ERROR. Exception occurred: $_"
    Write-Host "Not Compliant. Error during detection."
}
finally {
    Write-Log "==== K-lite Detection Script Completed ====`n"
    exit $ExitCode
}
