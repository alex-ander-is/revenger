#!/bin/bash

main(){
	local COLOR_RED=$'\e[1;31m'
	local COLOR_GREEN=$'\e[1;32m'
	local COLOR_YELLOW=$'\e[1;33m'
	local RESET_COLOR=$'\e[0m'

	# Just in case you have forgotten to do so…
	chmod +x *.sh

 	# TODO: Check which steps are already done to avoid duplicates
	./createKey.sh &&
	./createSecurityGroup.sh &&
	./createVanillaUbuntu.sh &&
	./watchForInstancesStart.sh &&
	# Ugly workaround as even already running instance shouldn't have ssh ready
	sleep 10 &&
	./remoteInstall.sh &&
	./watchForInstancesStop.sh &&
	./createImages.sh &&
	./watchForImagesCreated.sh &&
	./terminateTemplate.sh &&
	echo -e "${COLOR_GREEN}[ DONE ]${RESET_COLOR}" &&
	exit

	echo -e "${COLOR_RED}[ ERROR ]${COLOR_YELLOW} Something wrong happened${RESET_COLOR} (Error Code: ${?})"
}

./checkAWS.sh && main || ./awsCliNa.sh
