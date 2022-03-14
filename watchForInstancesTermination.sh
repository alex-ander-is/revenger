#!/bin/bash
# Awaits once all instances are terminated with 10 minuts timeout.

TIMEOUT=480 # 8 minues
CZECH_INTERVAL=10

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

	local STOCKHOLM_INSTANCES_IDS=`getInstances "eu-north-1"`
	local FRANKFURT_INSTANCES_IDS=`getInstances "eu-central-1"`

	[[ -z ${STOCKHOLM_INSTANCES_IDS} ]] &&
	[[ -z ${FRANKFURT_INSTANCES_IDS} ]] &&
	exit 0

	(( TIMEOUT=TIMEOUT-CZECH_INTERVAL ))
	(( TIMEOUT <= 0 )) && exit 1
	echo -e "${COLOR_GREEN}    waiting once instances are terminated...${RESET_COLOR}"
}

getInstances(){
	aws ec2 describe-instances \
		--region ${1} \
		--query "Reservations[*].Instances[*].{HeroiamSlava:InstanceId}" \
		--filters "Name=instance-state-code,Values=0,16,32,64,80" \
		--o text
}

./checkAWS.sh && main || ./awsCliNa.sh
