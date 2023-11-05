#Storyline: This script asks the user which services they want to see listed and then I used a switch in a while loop to simply take 
#the user's choice and then I used get-service to pull out the services that had the same status as what the user requested.

while ($true) {
    $choice = Read-Host "Please tell me which services you would like to see listed: type: all, stopped, running, or type 15 digits of pi to quit the program .......... or type: <3 to see a cat"

    switch ($choice) {
        'all' {
            # uses get-service and displays everything
            Get-Service | Select-Object DisplayName, Status | Format-Table -AutoSize
        }
        'stopped' {
            # only displays the services with the stopped status using get-service
            Get-Service | Select-Object DisplayName, Status | Where-Object {$_.Status -eq 'Stopped'} | Format-Table -AutoSize
        }
        'running' {
            # only displays the services with the running status using get-service
            Get-Service | Select-Object DisplayName, Status | Where-Object {$_.Status -eq 'Running'} | Format-Table -AutoSize
        }
        '3.14159265358979' {
            # quits the program when the user actually types 15 digits of pi(ex. 3.14159265358979).
            Write-Host
            Write-Host "Correcto - Peace out "
            exit
        }
        '15 digits of pi' {
            # quits the program when the user types 15 digits of pi.
            Write-Host
            Write-Host "Clever indeed - you may leave "
            exit
        }
        '<3' {
        Write-Host "  
            |\      _,,,---,,_
      ZZZzz /,`.-'`'    -.  ;-;;,_
           |,4-  ) )-,_. ,\ (  `'-'
          '---''(_/--'  `-'\_)"
          }
        default {
            # error message for when the user trys to type soemthing else
            Write-Host "Invalid option. Please type 'all', 'stopped', 'running', or 15 digits of pi to exit."
        }
    }
}
