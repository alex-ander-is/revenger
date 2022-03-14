#!/bin/bash
# Awaits once instances boot up with 8 minuts timeout.

TIMEOUT=480 # 8 minues
CZECH_INTERVAL=5

main(){
	while true
	do
		process
		sleep ${CZECH_INTERVAL}
	done
}

process(){
	[[ -z `czech "eu-north-1"` ]] &&
	[[ -z `czech "eu-central-1"` ]] &&
	exit 0

	tick
}

czech(){
	aws ec2 describe-instances \
		--region ${1} \
		--query "Reservations[*].Instances[*].{HeroiamSlava:InstanceId}" \
		--filters "Name=instance-state-code,Values=0,32,64,80" \
		--o text
}

tick(){
	local COLOR_GREEN=$'\e[1;32m'
	local RESET_COLOR=$'\e[0m'

	(( TIMEOUT=TIMEOUT-CZECH_INTERVAL ))
	(( TIMEOUT <= 0 )) && exit 1
	echo -e "${COLOR_GREEN}    waiting once all instances boot...${RESET_COLOR}"
}

./checkAWS.sh && main || ./awsCliNa.sh
