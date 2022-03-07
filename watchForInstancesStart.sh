#!/bin/bash
# Awaits once instances fully start with 8 minuts timeout.

# Load values of
# STOCKHOLM_VANILLA_INSTANCE_ID & FRANKFURT_VANILLA_INSTANCE_ID
source VANILLA_IDS.txt
TIMEOUT=480 # 8 minues
CZECH_INTERVAL=2

WAITING_FOR_INSTANCE=0
WAITING_FOR_SSH=1
WATCHER_STATE=${WAITING_FOR_INSTANCE}

main(){
	watchInstanceState
}

watchInstanceState(){
	while [[ ${WATCHER_STATE} == ${WAITING_FOR_INSTANCE} ]]
	do
		czechInstancesState
		sleep ${CZECH_INTERVAL}
	done
}

watchSSHState(){
	while [[ ${WATCHER_STATE} == ${WAITING_FOR_SSH} ]]
	do
		czechSSHState
		sleep ${CZECH_INTERVAL}
	done
}

czechInstancesState(){
	local COLOR_GREEN=$'\e[1;32m'
	local RESET_COLOR=$'\e[0m'

	[[ `aws ec2 describe-instances \
		--region "eu-north-1" \
		--query "Reservations[*].Instances[*].[State.Name]" \
		--filters "Name=instance-state-code,Values=16" \
		--o text` == "running" ]] && \

	[[ `aws ec2 describe-instances \
		--region "eu-central-1" \
		--query "Reservations[*].Instances[*].[State.Name]" \
		--filters "Name=instance-state-code,Values=16" \
		--o text` == "running" ]] &&

	instanceReady && return

	(( TIMEOUT=TIMEOUT-CZECH_INTERVAL ))
	(( TIMEOUT <= 0 )) && exit 1
	echo -e "${COLOR_GREEN}    waiting once instances start...${RESET_COLOR}"
}

czechSSHState(){
	nc -z $STOCKHOLM_VANILLA_INSTANCE_IP 22 && \
	nc -z $FRANKFURT_VANILLA_INSTANCE_IP 22 && \
	exit 0
}

instanceReady(){
	WATCHER_STATE=${WAITING_FOR_SSH}

	STOCKHOLM_VANILLA_INSTANCE_IP=`getInstanceIP "eu-north-1" ${STOCKHOLM_VANILLA_INSTANCE_ID}`
	[[ -z "$STOCKHOLM_VANILLA_INSTANCE_IP" ]] && exit 1

	FRANKFURT_VANILLA_INSTANCE_IP=`getInstanceIP "eu-central-1" ${FRANKFURT_VANILLA_INSTANCE_ID}`
	[[ -z "$FRANKFURT_VANILLA_INSTANCE_IP" ]] && exit 1

	watchSSHState
}

getInstanceIP(){
	aws ec2 describe-instances \
		--region ${1} \
		--instance-ids ${2} \
		--query "Reservations[*].Instances[*].{HeroiamSlava:PublicIpAddress}" \
		--filters "Name=instance-state-code,Values=16" \
		--output=text
}

./checkAWS.sh && main || ./awsCliNa.sh
