#!/bin/bash
# Removes default Key Pairs for Stockholm and Frankfurt

main(){
	aws ec2 delete-security-group --region "eu-north-1" --group-name "ssh-22" &&
	aws ec2 delete-security-group --region "eu-central-1" --group-name "ssh-22" ||
	interrupted
}

interrupted(){
	local COLOR_RED=$'\e[1;31m'
	local COLOR_GREEN=$'\e[1;32m'
	local COLOR_YELLOW=$'\e[1;33m'
	local RESET_COLOR=$'\e[0m'

	echo -e "${COLOR_YELLOW}The removing of SSH Security Groups was not succesfull.${RESET_COLOR}"
	exit 0
}


./checkAWS.sh && main || ./awsCliNa.sh
