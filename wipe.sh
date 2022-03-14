#!/bin/bash

main(){
	local COLOR_GREEN=$'\e[1;32m'
	local RESET_COLOR=$'\e[0m'

	# Just in case you have forgotten to do so…
	chmod +x *.sh

 	# TODO: Check which steps are already done to avoid duplicates
 	./terminateInstances.sh
 	./watchForInstancesTermination.sh
	./removeKeyPairs.sh
	./removeSSHSecurityGroups.sh
	./listImages.sh
	./deregisterImages.sh
	echo -e "${COLOR_GREEN}[ FINISHED ]${RESET_COLOR}"
}

main
