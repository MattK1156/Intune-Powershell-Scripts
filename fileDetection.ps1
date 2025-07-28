# Define log path
$LogFolder = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"
$LogFile = Join-Path $LogFolder "FileDetectionScript.log"

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
$ExitCode = 0

Write-Log "==== File Detection Script Started  Looking for $FilePath ===="

#Checks if path exists, if so, exits with code 1 to trigger remediation.
try {
    Write-Log "Searching for file under $FilePath"
    if (Test-Path -Path $FilePath) {
        $ExitCode = 1
    }
    else {
        Write-Log "Could not find $FilePath, it does not exist."
        Write-Host "Could not find $FilePath, it does not exist."
    }
}catch {
    Write-Log "ERROR. Unknown Exception occurred"
    Write-Host "ERROR. Unknown Exception occurred"
}
finally {
    Write-Log "==== File Detection Script Completed , Exiting with code $ExitCode ====`n"
    exit $ExitCode
}