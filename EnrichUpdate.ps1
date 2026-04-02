if (Test-Path -Path "C:\Program Files (x86)\Enrich\jwalk.ini") {
    Write-Host "jwalk.ini already exists. Backing up and replacing the existing file."
    Copy-Item -Path "C:\Program Files (x86)\Enrich\jwalk.ini" -Destination "C:\Program Files (x86)\Enrich\jwalk_backup.ini" -Force
    Write-Host "Backed up existing jwalk.ini, renamed to jwalk_backup.ini. Now replacing with new jwalk.ini."
    Copy-Item -Path "$PSScriptRoot\jwalk.ini" -Destination "C:\Program Files (x86)\Enrich\jwalk.ini" -Force
}
else {
    Write-Host "jwalk.ini does not exist. Is Enrich installed? Please install Enrich before running this Install."
}
