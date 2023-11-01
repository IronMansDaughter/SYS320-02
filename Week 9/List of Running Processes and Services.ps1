# Storyline: This script export the lists of running processes and services for my user into to seperate csv files
Get-Process | Select-Object ProcessName, Path, ID | `
Export-Csv -Path "C:\Users\Janelle Fisher\Desktop\processes.csv" -NoTypeInformation
Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object Name, Status, DisplayName | `
Export-Csv -Path "C:\Users\Janelle Fisher\Desktop\services.csv" -NoTypeInformation
Echo "Your files have been created, please check your desktop to see them!"
