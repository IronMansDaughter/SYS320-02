#!/bin/bash

#Parse Apache log

APACHE_LOG="$1"

#This code simply checks to see if file exists and if not it will tell the user it does not exist and goodbye.

read -p "Please enter an apache log file." APACHE_LOG
if [[ ! -f ${APACHE_LOG} ]]
then
	echo "File does not exist, Good Bye :("
	echo "           
	         ,_     _
		 |\__,-~/
		 / _  _ |    ,--.
		(  @  @ )   / ,-'
		 \  _T_/-._( (
		 /         '. |
		|         _  \ |
		 \ \ '  /      |
		  || |-_\__   /
		 ((-/-------))" 
 		
	exit 1
fi


# Finds all the "bad IPs"
BAD_IPS=$(cat ${APACHE_LOG} | egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | awk ' { print $1 } '| sort -u)

# Makes an IPTables rule for every bad IP
for eachIP in ${BAD_IPS}
do
	echo "iptables -A INPUT -s ${eachIP} -j drop" | tee -a  badIPSnshit
done
clear
echo "An IPTables ruleset has been automatically generated: badIPSnshit"
