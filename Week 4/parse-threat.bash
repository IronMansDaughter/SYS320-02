#!/bin/bash

# Storyline: Extract IPs from emergingthreats.net and create a firewall ruleset

function create_badIPs() {

	wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules

	
	egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badips.txt

}



		if [[ -f badIPs.txt  ]]
		then
			read -p "The badIPs.txt file already exists. Would you like to redownload it? [y][n]: " answer
			case "$answer" in
				y|Y)
					echo  "Creating badIPs.txt..."
					create_badIPs
				;;
				n|N)
					echo "Not redownloading badIPs.txt..."
				;;
				*)	
					echo "Invalid value."
					exit 1
				;;
			esac

		else
			echo "The badIPs.txt file does not exist yet. Downloading file..."
			create_badIPs
		fi

while getopts 'icnfmp' OPTION ; do

	case "$OPTION" in
		i) iptables=${OPTION}
		;;
		c) cisco=${OPTION}
		;;
		f) wfirewall=${OPTION}
		;;
		m) macOS=${OPTION}
		;;
		p) parseCisco=${OPTION}
		;;
		*) 
			echo "Invalid Value"
			exit 1
		;;

	esac
done

# If iptables is input then create the iptables drop rule
if [[ ${iptables}  ]]
then
	for eachip in $(cat badips.txt)
	do
		echo "iptables -a input -s ${eachip} -j drop" | tee -a  badips.iptables
	done
	clear
	echo "Created IPTables firewall drop rules in file \"badips.iptables\""
fi

# Cisco thingy ma bobber
if [[ ${cisco} ]]
then
	egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0' badips.txt | tee badips.nocidr
	for eachip in $(cat badips.nocidr)
	do
		echo "deny ip host ${eachip} any" | tee -a badips.cisco
	done
	rm badips.nocidr
	clear
	echo 'Created IP Tables for firewall drop rules in file "badips.cisco"'
fi

# Windows Firewall
if [[ ${wfirewall} ]]
then
	egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0' badips.txt | tee badips.windowsform
	for eachip in $(cat badips.windowsform)
	do
		echo "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - ${eachip}\" dir=in action=block remoteip=${eachip}" | tee -a badips.netsh
	done
	rm badips.windowsform
	clear
	echo "Created IPTables for firewall drop rules in file \"badips.netsh\""
fi

# MacOS
if [[ ${macOS} ]]
then
	echo '
	scrub-anchor "com.apple/*"
	nat-anchor "com.apple/*"
	rdr-anchor "com.apple/*"
	dummynet-anchor "com.apple/*"
	anchor "com.apple/*"
	load anchor "com.apple" from "/etc/pf.anchors/com.apple"

	' | tee pf.conf

	for eachip in $(cat badips.txt)
	do
		echo "block in from ${eachip} to any" | tee -a pf.conf
	done
	clear
	echo "Created IP tables for firewall drop rules in file \"pf.conf\""
fi

# Parse Cisco
if [[ ${parseCisco} ]]
then
	wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.csv
	awk '/domain/ {print}' /tmp/targetedthreats.csv | awk -F \" '{print $4}' | sort -u > threats.txt
	echo 'class-map match-any BAD_URLS' | tee ciscothreats.txt
	for eachip in $(cat threats.txt)
	do
		echo "match protocol http host \"${eachip}\"" | tee -a ciscothreats.txt
	done
	rm threats.txt
	echo 'Cisco URL filters file successfully parsed and created at "ciscothreats.txt"'
fi
