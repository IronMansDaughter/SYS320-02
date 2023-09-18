#!/bin/bash

# Add and delete peers

while getopts 'hdau:e:' OPTION; do
	case "$OPTION" in
        	d) u_del=${OPTION} ;;
        	a) u_add=${OPTION} ;;
        	u) t_user=${OPTARG} ;;
        	e) check_user=${OPTARG} ;; # Add this line for the -e switch
        	h)
			echo ""
            		echo "Usage: $(basename $0) [-a] [-d] [-e username] -u username"
            		echo ""
            		exit 1
            		;;
        	*)
            		echo ""
            		echo "------------------------"
            		echo "|   Invalid value!!!!  |"
            		echo "------------------------"
            		echo "
		          /\___/\\		      
		         ( o   o )
		         (  =^=  )
		         (        )
		         (         )
		         (          )))))))))))"
		    	exit 1
		    	;;
    	esac
done

# Check to see if both -a and -d are empty or if they are both specified throw an error

if [[ (${u_del} == "" && ${u_add} == "") || (${u_del} != "" && ${u_add} != "") ]]; then
	echo "Please specify -a or -d and the -u and username."
    	exit 1
fi






# Check to see if -u is specified --------------------------------------------------

if [[ (${u_del} != "" || ${u_add} != "") && ${t_user} == "" ]]; 
then
    	echo "Please specify a user (-u)!"
    	echo "Usage: $(basename $0) [-a] [-d] -u username"
    	exit 1
fi







# Check if the user exists in wg0.conf (added for -e switch)
if [[ ${check_user} ]]; then
	if grep -q "# ${check_user} begin" wg0.conf; then
        	echo "User ${check_user} exists in wg0.conf"
    	else
        	echo "User ${check_user} does not exist in wg0.conf"
    	fi
    	
fi

# Delete a user

if [[ ${u_del} ]]; then
	    echo ""
	    echo "Deleting user . . . "
	    echo ""
	    echo " ███▒▒▒▒▒▒▒ 39%"
	    sleep 2
	    echo ""
	    echo " █████▒▒▒▒▒ 49%"
	    sleep 2
	    echo ""
	    echo " ███████▒▒▒ 76%"
	    sleep 2
	    echo ""
	    echo " ████████▒▒ 89%"
	    sleep 2
	    echo ""
	    echo "LOADING... ████████████ 99% "
	    sleep 2
	    echo ""
	    echo "LOADING... ████████▒▒▒▒ 69% "
	    sleep 1
	    echo " (｡•̀ᴗ-) Nice!!!!"
	    sleep 1
	    echo " Just Kidding"

	    sleep 3
	    echo ""
	    echo "Action Completed."
	    sed -i "/# ${t_user} begin/,/# ${t_user} end/d" wg0.conf
fi

# Add a user

if [[ ${u_add} ]]; then
	    echo "Create The User...."
	    bash peer.bash ${t_user}
fi
