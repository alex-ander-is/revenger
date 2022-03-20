#!/bin/bash

main(){
	local COLOR_GREEN=$'\e[1;32m'
	local RESET_COLOR=$'\e[0m'
	echo "${COLOR_GREEN}Firing via CyberReaper...${RESET_COLOR}"
	./watchForInstancesStart.sh &&
	./watchForSSHStart.sh || exit 1

	fireFromStockholm &
	fireFromFrankfurt &
	wait
}

fireFromStockholm(){
	local STOCKHOLM_INSTANCES_IPS=`./getInstancesIPs.sh -s`

	for ip in ${STOCKHOLM_INSTANCES_IPS}
	do
		fire "key-stockholm-0.pem" ${ip} &
	done
	wait
}

fireFromFrankfurt(){
	local FRANKFURT_INSTANCES_IPS=`./getInstancesIPs.sh -f`

	for ip in ${FRANKFURT_INSTANCES_IPS}
	do
		fire "key-frankfurt-0.pem" ${ip} &
	done
	wait
}

fire(){
	local KEY=${1}
	local IP=${2}
	shift 2

	echo "    🔥 ${IP}"
	ssh \
		-i ${KEY} \
		-o "LogLevel ERROR" \
		-o "IdentitiesOnly yes" \
		-o "StrictHostKeyChecking no" \
		-o "UserKnownHostsFile /dev/null" \
		"ubuntu@${IP}" \
			screen -dm \
				sudo docker run \
				--rm \
				--pull always egideon/cyber-reaper:latest
}

main
