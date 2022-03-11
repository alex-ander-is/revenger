#!/bin/bash

main(){
	./updateInstancesIPs.sh

	if [ -f STOCKHOLM_INSTANCES_IPS.txt ]
	then
		echo "Killing all bombardiers at Stockholm..."
		killbombardier "key-stockholm-0.pem" $(cat STOCKHOLM_INSTANCES_IPS.txt)
	fi

	if [ -f FRANKFURT_INSTANCES_IPS.txt ]
	then
		echo "Killing all bombardiers at Frankfurt..."
		killbombardier "key-frankfurt-0.pem" $(cat FRANKFURT_INSTANCES_IPS.txt)
	fi
}

killbombardier(){
	local key=${1}
	shift 1

	for ip in ${@}
	do
		process ${key} ${ip} &
	done
	wait
}

process(){
	echo "    ${2}"
	ssh \
		-o LogLevel=ERROR \
		-i ${1} \
		-o "StrictHostKeyChecking no" \
		"ubuntu@${2}" "sudo killall bombardier" &> /dev/null &&
	echo "${2}: bombardier killed successfully" ||
	echo "${2}: No bombardier has been found"
}

./checkAWS.sh && main ${@} || ./awsCliNa.sh
