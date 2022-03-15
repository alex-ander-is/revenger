#!/bin/bash

main(){
	local STOCKHOLM_INSTANCES_IPS=`./getInstancesIPs.sh -s`
	local FRANKFURT_INSTANCES_IPS=`./getInstancesIPs.sh -f`

	echo "Killing all dockers"

	for ip in ${STOCKHOLM_INSTANCES_IPS}
	do
		kill "key-stockholm-0.pem" ${ip} &
	done

	for ip in ${FRANKFURT_INSTANCES_IPS}
	do
		kill "key-frankfurt-0.pem" ${ip} &
	done

	wait
}

kill(){
	DOCKER_ID=`sshCommand ${1} ${2} "sudo docker ps -a -q"`
	[[ ! -z ${DOCKER_ID} ]] &&
	sshCommand ${1} ${2} "sudo docker kill ${DOCKER_ID}" &&
	echo "    ${2} ${DOCKER_ID}"
}

sshCommand(){
	ssh \
		-i ${1} \
		-o "LogLevel ERROR" \
		-o "IdentitiesOnly yes" \
		-o "StrictHostKeyChecking no" \
		-o "UserKnownHostsFile /dev/null" \
		"ubuntu@${2}" ${3}
}

./checkAWS.sh && main ${@} || ./awsCliNa.sh
