#!/bin/bash
# Awaits once instances fully start with 8 minuts timeout.

# Load values of
# STOCKHOLM_VANILLA_INSTANCE_ID & FRANKFURT_VANILLA_INSTANCE_ID
source VANILLA_IDS.txt
TIMEOUT=480 # 8 minues
CZECH_INTERVAL=2

main(){
	watchState
}

watchState(){
	while true
	do
		czechInstancesState
		sleep ${CZECH_INTERVAL}
	done
}

czechInstancesState(){
	local COLOR_GREEN=$'\e[1;32m'
	local RESET_COLOR=$'\e[0m'

	STOCKHOLM_STATE=`aws ec2 describe-instances \
		--region "eu-north-1" \
		--query "Reservations[*].Instances[*].[State.Name]" \
		--filters "Name=instance-state-code,Values=16" \
		--o text`

	FRANKFURT_STATE=`aws ec2 describe-instances \
		--region "eu-central-1" \
		--query "Reservations[*].Instances[*].[State.Name]" \
		--filters "Name=instance-state-code,Values=16" \
		--o text`

	[[ ${STOCKHOLM_STATE} == "running" ]] && \
	[[ ${FRANKFURT_STATE} == "running" ]] && \
	exit 0

	(( TIMEOUT=TIMEOUT-CZECH_INTERVAL ))
	(( TIMEOUT <= 0 )) && exit 1
	echo -e "${COLOR_GREEN}    waiting once instances start...${RESET_COLOR}"
}

./checkAWS.sh && main || ./awsCliNa.sh
