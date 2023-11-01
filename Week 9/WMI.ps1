#Storyline: Gets the network adapter info using the WMI class like in the class video and then also gets the DHCP server and the DNS server address
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE | Format-List IPAddress, DefaultIPGateway, DNSServerSearchOrder, DHCPServer
