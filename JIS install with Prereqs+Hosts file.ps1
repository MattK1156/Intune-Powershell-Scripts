$LogFolder = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"
$LogFile = Join-Path $LogFolder "JIS_Install.log"

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

# Adds Required lines to hosts file for JIS access
try{
    Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "IPaddresshere	fullyqualifieddomainname", "ipaddresshere 	domainnamehere"
    Write-Log "Successfully added entries to hosts file"
}catch{
    Write-Log "ERROR: Failed to add entries to hosts file"
    Write-Host "ERROR: Failed to add entries to hosts file"
}
# Installs Visual Basic Runtime
try{
    Start-Process -FilePath "$PSScriptRoot\vbrun60sp6.exe" -ArgumentList "/q" -Wait
    Write-Log "Successfully installed Visual Basic Runtime"
}catch{
    Write-Log "ERROR: Failed to install Visual Basic Runtime"
    Write-Host "ERROR: Failed to install Visual Basic Runtime"
}

try{
    Start-Process -FilePath "$PSScriptRoot\JIS_Install.bat" -Wait
    Write-Log "Successfully ran JIS_Install.bat"
    Write-Host "Successfully ran JIS_Install.bat"
}catch{
    Write-Log "ERROR: Failed to run JIS_Install.bat"
    Write-Host "ERROR: Failed to run JIS_Install.bat"
}
