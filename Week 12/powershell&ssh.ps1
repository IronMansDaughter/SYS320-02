cls
# Login to a remote SSH server
#New-SSHSession -ComputerName '192.168.4.22' -Credential (Get-Credential sys320)


<#

while ($True) {

    # Add a prompt to run commands
    $the_cmd = Read-Host -Prompt "Please enter a command"

    # Run command on remote SSH server
    (Invoke-SSHCommand -index 0 'ps -ef').Output
}

#>



Set-SCPFile -ComputerName '192.168.4.22' -Credential (Get-Credential sys320) `
-RemotePath '/home/sys320' -LocalFile '.\tdex.jpeg'

# It should be noted that the server that we are trying to connect to is not working currently, so this is just the code from the video provide through class! Thanks!
