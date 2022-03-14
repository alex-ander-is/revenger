#!/bin/bash
# Awaits once instances have SSH servers ready with 8 minuts timeout.

TIMEOUT=480 # 8 minues
CZECH_INTERVAL=5

STOCKHOLM_INSTANCES_IPS=`./getInstancesIPs.sh -s`
FRANKFURT_INSTANCES_IPS=`./getInstancesIPs.sh -f`

main(){
	while true
	do
		process
		sleep ${CZECH_INTERVAL}
	done
}

process(){
	local STOCKHOLM_NOT_READY_IPS=""
	local FRANKFURT_NOT_READY_IPS=""

	for ip in ${STOCKHOLM_INSTANCES_IPS}
	do
		nc -z ${ip} 22 &> /dev/null ||
		STOCKHOLM_NOT_READY_IPS="${STOCKHOLM_NOT_READY_IPS}${ip} "
	done

	for ip in ${FRANKFURT_INSTANCES_IPS}
	do
		nc -z ${ip} 22 &> /dev/null ||
		FRANKFURT_NOT_READY_IPS="${FRANKFURT_NOT_READY_IPS}${ip} "
	done

	STOCKHOLM_INSTANCES_IPS=`echo ${STOCKHOLM_NOT_READY_IPS} | xargs`
	FRANKFURT_INSTANCES_IPS=`echo ${FRANKFURT_NOT_READY_IPS} | xargs`

	[[ -z ${STOCKHOLM_INSTANCES_IPS} ]] &&
	[[ -z ${FRANKFURT_INSTANCES_IPS} ]] &&
	exit 0

	tick
}

instanceReady(){
	WATCHER_STATE=${WAITING_FOR_SSH}
	watchSSHState
}

tick(){
	local COLOR_GREEN=$'\e[1;32m'
	local RESET_COLOR=$'\e[0m'

	(( TIMEOUT=TIMEOUT-CZECH_INTERVAL ))
	(( TIMEOUT <= 0 )) && exit 1
	echo -e "${COLOR_GREEN}    waiting once all SSH servers start...${RESET_COLOR}"
}

main
