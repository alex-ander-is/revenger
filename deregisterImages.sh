#!/bin/bash
# Deregisters (removes) AMI images used to create new instances.
# and docker again.

IMAGE_IDS_FILE="IMAGE_IDS.txt"

[[ -f ${IMAGE_IDS_FILE} ]] || exit 1
source ${IMAGE_IDS_FILE}

main(){
	[[ -f ${IMAGE_IDS_FILE} ]] &&
	source ${IMAGE_IDS_FILE} &&

	[[ ! -z ${STOCKHOLM_TEMPLATE_IMAGE} ]] &&
	[[ ! -z ${FRANKFURT_TEMPLATE_IMAGE} ]] &&

	aws ec2 deregister-image --region "eu-north-1" --image-id ${STOCKHOLM_TEMPLATE_IMAGE} &&
	aws ec2 deregister-image --region "eu-central-1" --image-id ${FRANKFURT_TEMPLATE_IMAGE} &&

	# proceeed if there is no images on EC2 anymore
	rm -f ${IMAGE_IDS_FILE} ||

	interrupted
}

interrupted(){
	local COLOR_YELLOW=$'\e[1;33m'
	local RESET_COLOR=$'\e[0m'

	echo -e "${COLOR_YELLOW}The removing of AMI images was not succesfull.${RESET_COLOR}"
	exit 0
}


./checkAWS.sh && main || ./awsCliNa.sh
