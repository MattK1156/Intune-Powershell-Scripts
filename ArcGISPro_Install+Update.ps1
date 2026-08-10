$LogFolder = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"
$LogFile = Join-Path $LogFolder "ArcGISPro3.5.log"
$msipath = "$PSScriptRoot\ArcGISPro.msi"
$msppath = "$PSScriptRoot\ArcGISPro358.msp"

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

# Installs the ArcGIS Pro 3.5 Application, waits for it to finish so the second Msiexec command can run.
try{
    Start-Process msiexec.exe -ArgumentList "/i `"$msipath`" /qn ALLUSERS=1 ACCEPTEULA=YES" -Wait
    Write-Log "Successfully installed ArcGIS Pro 3.5"
    Write-Host "Successfully installed ArcGIS Pro 3.5"
}catch{
    Write-Log "ERROR: Failed to install ArcGIS Pro 3.5"
    Write-Host "ERROR: Failed to install ArcGIS Pro 3.5"
}
# Installs ArcGIS Pro 3.58 Patch
try{
    Start-Process msiexec.exe -ArgumentList "/p `"$msppath`" REINSTALLMODE=omus REINSTALL=ALL /qn" -Wait
    Write-Log "Successfully installed ArcGIS Pro 3.58 Patch"
}catch{
    Write-Log "ERROR: Failed to install ArcGIS Pro 3.58 Patch"
    Write-Host "ERROR: Failed to install ArcGIS Pro 3.58 Patch"
}

