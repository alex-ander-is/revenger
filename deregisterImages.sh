#!/bin/bash
# Deregisters (removes) AMI images used to create new instances.
# and docker again.

IMAGE_IDS_FILE="IMAGE_IDS.txt"

main(){
	[[ -f ${IMAGE_IDS_FILE} ]] &&
	source ${IMAGE_IDS_FILE} &&
	aws ec2 deregister-image --region "eu-north-1" --image-id ${STOCKHOLM_TEMPLATE_IMAGE} &&
	aws ec2 deregister-image --region "eu-central-1" --image-id ${FRANKFURT_TEMPLATE_IMAGE} &&
	rm -f ${IMAGE_IDS_FILE} ||
	interrupted
}

interrupted(){
	local COLOR_RED=$'\e[1;31m'
	local COLOR_GREEN=$'\e[1;32m'
	local COLOR_YELLOW=$'\e[1;33m'
	local RESET_COLOR=$'\e[0m'

	echo -e "${COLOR_YELLOW}The removing of AMI images was not succesfull.${RESET_COLOR}"
	exit 0
}


./checkAWS.sh && main || ./awsCliNa.sh
