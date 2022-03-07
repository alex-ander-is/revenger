#!/bin/bash
# Awaits once images are ready with 10 minuts timeout.

TIMEOUT=600 # 10 minues
CZECH_INTERVAL=2

main(){
	watchState
}

watchState(){
	while true
	do
		czechImagesState
		sleep ${CZECH_INTERVAL}
	done
}

czechImagesState(){
	local COLOR_GREEN=$'\e[1;32m'
	local RESET_COLOR=$'\e[0m'

	STOCKHOLM_STATE=`aws ec2 describe-images \
		--region "eu-north-1" \
		--owners "self" \
		--query "Images[*].State" \
		--o text`

	FRANKFURT_STATE=`aws ec2 describe-images \
		--region "eu-central-1" \
		--owners "self" \
		--query "Images[*].State" \
		--o text`

	[[ ${STOCKHOLM_STATE} == "available" ]] && \
	[[ ${FRANKFURT_STATE} == "available" ]] && \
	exit 0

	(( TIMEOUT=TIMEOUT-CZECH_INTERVAL ))
	(( TIMEOUT <= 0 )) && exit 1
	echo -e "${COLOR_GREEN}    waiting once images are created...${RESET_COLOR}"
}

./checkAWS.sh && main || ./awsCliNa.sh
