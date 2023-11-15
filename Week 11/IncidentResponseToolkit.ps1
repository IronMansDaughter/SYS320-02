"""
Q&A: Explain why you selected those four cmdlets and the value it would provide for an incident investigation:

    I choose to get the logs for the system, application, powershell history, and the security. 
    The system and security event logs are wicked useful for getting user activity and seeing what the user was up to. 
    I also choose the application event logs becuase they are usful to see the user's application activity. 
    Lastly, I also did the powershell history because that's useful to see the commands the user was using for the scripts they were working on. 
"""



# Asks user what folder they want to say everything in or they can just hit enter and it'll save to the IncidentResponseToolKit
$folderPath = Read-Host "Enter the folder path to save the results or hit enter to save results to the IncidentReponseToolKit folder"
New-Item -ItemType Directory -Path "$folderPath\IncidentResponseToolKit" | Out-Null
New-Item -ItemType Directory -Path "$folderPath\IncidentResponseToolKit\csv" | Out-Null



# Gets running processes
Get-Process | Select-Object ProcessName, Path | Export-Csv -Path "$folderPath\IncidentResponseToolKit\csv\processes.csv" -NoTypeInformation
Write-Host "Processes saved to $folderPath\IncidentResponseToolKit\csv\processes.csv"



# Gets registered services
Get-WmiObject -Class Win32_Service | Select-Object Name, DisplayName, PathName | Export-Csv -Path "$folderPath\IncidentResponseToolKit\csv\services.csv" -NoTypeInformation
Write-Host "Services saved to $folderPath\IncidentResponseToolKit\csv\services.csv"



# Gets TCP network sockets
Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State | Export-Csv -Path "$folderPath\IncidentResponseToolKit\csv\tcpSockets.csv" -NoTypeInformation
Write-Host "TCP sockets saved to $folderPath\IncidentResponseToolKit\csv\tcpSockets.csv"



# gets user account info + level of privelege 
Get-WmiObject -Class Win32_UserAccount | Select-Object Name, FullName, Description, Privileges | Export-Csv -Path "$folderPath\IncidentResponseToolKit\csv\users.csv" -NoTypeInformation
Write-Host "User accounts saved to $folderPath\IncidentResponseToolKit\csv\users.csv"



# Gets network adapter config info
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE | Format-List IPAddress, DefaultIPGateway, DNSServerSearchOrder, DHCPServer | Export-Csv -Path "$folderPath\IncidentResponseToolKit\csv\networkAdapterConfiguration.csv" -NoTypeInformation
Write-Host "Network adapter configs saved to $folderPath\IncidentResponseToolKit\csv\networkAdapterConfiguration.csv"

# Below is the code for the 4 artifacts 

# Saves system event logs(CSV)
Get-EventLog -LogName System -Newest 1000 | Export-Csv -Path "$folderPath\IncidentResponseToolKit\csv\sysEventLogs.csv" -NoTypeInformation
Write-Host "System event logs saved to $folderPath\IncidentResponseToolKit\csv\sysEventLogs.csv"



# Saves security event logs(CSV)
Get-EventLog -LogName Security -Newest 1000 | Export-Csv -Path "$folderPath\IncidentResponseToolKit\csv\secEventLogs.csv" -NoTypeInformation
Write-Host "Security event logs saved to $folderPath\IncidentResponseToolKit\csv\secEventLogs.csv"



# Saves application event logs(CSV)
Get-EventLog -LogName Application -Newest 1000 | Export-Csv -Path "$folderPath\IncidentResponseToolKit\csv\appEventLogs.csv" -NoTypeInformation
Write-Host "Application event logs saved to $folderPath\IncidentResponseToolKit\csv\appEventLogs.csv"



# Saves PS(PowerShell) history(CSV)
Get-WinEvent Microsoft-Windows-PowerShell/Operational -MaxEvents 1000 | Export-Csv -Path "$folderPath\IncidentResponseToolKit\csv\psEventLogs.csv" -NoTypeInformation
Write-Host "PowerShell event logs saved to $folderPath\IncidentResponseToolKit\csv\psEventLogs.csv"

# Creates file hashes
function create_hash_file($num) {
    
    if ($num -eq 1) {
        $files = Get-ChildItem -Path "$folderPath\IncidentResponseToolKit\csv\*.csv"
       
        foreach ($file in $files) {
            Get-FileHash -Path $file.FullName -Algorithm SHA256 | Export-Csv -Path "$folderPath\IncidentResponseToolKit\csv\fileHashes.csv" -Append -NoTypeInformation
        }
    }
    elseif ($num -eq 2) {
        Get-FileHash -Path $zipPath -Algorithm SHA256 | Export-Csv -Path "$folderPath\IncidentResponseToolKit\zipHash.csv" -NoTypeInformation
    }
}

# Takes the file hashes for each CSV file and puts them into a new file:
create_hash_file(1)

#Zips results
$zipPath = "$folderPath\IncidentResponseToolKit\results.zip"
Compress-Archive -Path "$folderPath\IncidentResponseToolKit\csv\*" -DestinationPath $zipPath

# Gets the hash for the zip file and save it to a new file
create_hash_file(2)
