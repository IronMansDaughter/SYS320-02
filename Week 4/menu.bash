#!/bin/bash

# Storyline: Menu for admin,VPN,and Security Functions

function invalid_opt() {

	echo ""
	echo "Invalid Option!"
	echo ""
	sleep 2


}
 
function menu() {

	clear
	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Exit"
	read -p "Please enter a choice above: " choice
	
	case "$choice" in  
	
		1) admin_menu
		;;
		
		2) security_menu
		;;
		
		3) exit 0
		;;
		
		*) 
			invalid_opt
			
			menu
		;;
	
	
	esac
	
	
	
	
	
}
function admin_menu(){

	clear
	echo "[L]ist Running Processes"
	echo "[N]etwork Sockets"
	echo "[V]PN Menu"
	echo "[4] Exit"
	read -p "Please enter a choice above: " choice
	
	case "$choice" in
		
		L|l) ps -ef |less
		;;
		
		N|n) netstat -an --inet |less
		;;
		
		V|v) vpn_menu
		;;
		
		4) exit 0
		;;
		
		*)
			invalid_opt
			admin_menu
			
		;;
	esac

admin_menu
}

function security_menu() {
    	clear
    	echo "[1] List open network sockets"
    	echo "[2] Check if any user besides root has a UID of 0"
    	echo "[3] Check the last 10 logged in users"
    	echo "[4] See currently logged in users"
    	echo "[5] Block list menu"
    	echo "[6] Back to admin menu"
    	echo "[7] Main Menu"
    	echo "[8] Exit"
    	read -p "Please enter a choice above: " choice

	case "$choice" in
        	1)
            	# Task 1: List open network sockets
            	netstat -tuln |less
            	;;
        	2)
            	# Task 2: Check if any user besides root has a UID of 0
            	grep -E '^[^:]+:[^:]+:0:' /etc/passwd | cut -d: -f1

            	sleep 5
            	;;
        	3)
            	# Task 3: Check the last 10 logged in users
            	last -n 10
            	sleep 5
            	;;
        	4)
            	# Task 4: See currently logged in users
            	who
            	sleep 4
            	;;
            	5)
            	block_menu
            	;;
        	6)
            	admin_menu
            	;;
        	7)
            	exit 0
            	;;
        	8)
            	menu
            	;;
        	*)
            	invalid_opt
            	;;
    	esac
security_menu
}




function vpn_menu() {
	
	clear
	echo "[A]dd a peer"
	echo "[D]elete a peer"
	echo "[B]ack to admin menu"
	echo "[M]ain Menu"
	echo "[E]xit"
	read -p "Please a select an option: " choice
	
	case "$choice" in
	
		A|a) 
		
		bash peer.bash
		tail -6 wg0.conf |less 
		
		;;
	
		D|d)
		read -p "Enter the username to delete from wg0.conf: " delete_user
            	# Add the user deletion logic here
            	sed -i "/# ${delete_user} begin/,/# ${delete_user} end/d" wg0.conf
            	echo "User $delete_user deleted from wg0.conf"
            	sleep 2
		;;
	
		B|b) admin_menu
		;;
	
		M|m) menu
		;;
	
		E|e) exit 0
		;;
	
		*)
		invalid_opt
		;;
	
	
	esac
vpn_menu


}

function block_menu() {

	clear

	echo "[C]iso Blocklist Generator"
	echo "[F]irewall - Windows Blocklist Generator"
	echo "[M]ac Blocklist Generator"
	echo "[I]PTables Blocklist Generator"
	echo "[P]arse Cisco"
	echo "[5] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in

		I|i) bash parse-threat.bash -i
		;;
		C|c) bash parse-threat.bash -c
		;;
		F|f) bash parse-threat.bash -f
		;;
		M|m) bash parse-threat.bash -m
		;;
		P|p) bash parse-threat.bash -p
		;;
		5) exit 0
		;;

		*)
			invalid_opt
		;;

	esac
block_menu
}

# Call function 
menu


