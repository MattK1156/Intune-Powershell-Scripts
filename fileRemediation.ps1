# Define log path
$LogFolder = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"
$LogFile = Join-Path $LogFolder "FileReplacementScript.log"

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

# Variables
$FilePath = "C:\ESD\test.txt"
$ServerPath = "\\provision\Software\Replacement\test.txt"

Write-Log "==== File Replacement Script Started  swapping $FilePath with $ServerPath ===="

#Tries to transfer file, catches errors if it fails.
try {
    Copy-Item -Path $ServerPath -Destination $FilePath -Force
    Write-Log "Successfully replaced file in the destination $FilePath"
    Write-Host "Successfully replaced file in the destination $FilePath"
}catch {
    Write-Log "ERROR. Unknown Exception occurred, could not transfer file."
    Write-Host "ERROR. Unknown Exception occurred, could not transfer file."
}
finally {
    Write-Log "==== File Replacement Script Completed ====`n"
}