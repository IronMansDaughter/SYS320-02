# Storyline: This script can start & stop the Windows Calculator using Powershell 

Start-Process calc.exe
Start-Sleep -Seconds 3
# I kept getting an error here, but everything online says this is correct - I tried to also change the name of calculator name, I tried stop-service, and I even tried to get the id number for the calculator's process id
Stop-Process -Name calc
