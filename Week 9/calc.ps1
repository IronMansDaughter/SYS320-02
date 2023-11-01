# Storyline: This script can start & stop the Windows Calculator using Powershell 

Start-Process calc.exe
Start-Sleep -Seconds 3
Stop-Process -Name win32calc

