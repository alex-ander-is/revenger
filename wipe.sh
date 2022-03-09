#!/bin/bash

main(){
	local COLOR_GREEN=$'\e[1;32m'
	local RESET_COLOR=$'\e[0m'

	# Just in case you have forgotten to do so…
	chmod +x *.sh

 	# TODO: Check which steps are already done to avoid duplicates
	./removeKeyPairs.sh
	./removeSSHSecurityGroups.sh
	./listImages.sh
	./deregisterImages.sh
	removeIPLists
	echo -e "${COLOR_GREEN}[ DONE ]${RESET_COLOR}"
}

removeIPLists(){
	[[ -f "STOCKHOLM_INSTANCES_IPS.txt" ]] &&
	rm -f "STOCKHOLM_INSTANCES_IPS.txt"

	[[ -f "FRANKFURT_INSTANCES_IPS.txt" ]] &&
	rm -f "FRANKFURT_INSTANCES_IPS.txt"
}

main
