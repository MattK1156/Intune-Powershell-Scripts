if (Test-Path -Path "C:/intunefiles/adobeuninstaller.txt") {
     exit 0
}
else {    
    New-Item -Path "C:/" -Name "intunefiles" -ItemType "Directory"
    New-Item -Path "C:/intunefiles" -Name "adobeuninstaller.txt" -ItemType "File" -Value "This file is strictly a flag for intune to determine if the adobe uninstaller intune app has been run or not."
    .\AdobeUninstaller.exe --all
    Remove-Item -Path "C:/intunefiles/adobeuninstaller.txt" -Force
    exit 1
}