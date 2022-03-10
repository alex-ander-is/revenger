#!/bin/bash
# Removes default Key Pairs for Stockholm and Frankfurt

main(){
	aws ec2 delete-security-group --region "eu-north-1" --group-name "ssh-22" &> /dev/null &&
	aws ec2 delete-security-group --region "eu-central-1" --group-name "ssh-22" &> /dev/null ||
	interrupted
}

interrupted(){
	local COLOR_YELLOW=$'\e[1;33m'
	local RESET_COLOR=$'\e[0m'

	echo -e "${COLOR_YELLOW}The removing of SSH Security Groups was not succesfull.${RESET_COLOR}"
	exit 0
}

./checkAWS.sh && main || ./awsCliNa.sh
