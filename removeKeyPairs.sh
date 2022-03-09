#!/bin/bash
# Removes default Key Pairs for Stockholm and Frankfurt

main(){
	aws ec2 delete-key-pair --region "eu-north-1" --key-name "key-stockholm-0" &&
	aws ec2 delete-key-pair --region "eu-central-1" --key-name "key-frankfurt-0" &&
	rm -f "key-frankfurt-0.pem" "key-stockholm-0.pem" ||
	interrupted
}

interrupted(){
	local COLOR_RED=$'\e[1;31m'
	local COLOR_GREEN=$'\e[1;32m'
	local COLOR_YELLOW=$'\e[1;33m'
	local RESET_COLOR=$'\e[0m'

	echo -e "${COLOR_YELLOW}The removing of Key Pairs was not succesfull.${RESET_COLOR}"
	exit 0
}

./checkAWS.sh && main || ./awsCliNa.sh
