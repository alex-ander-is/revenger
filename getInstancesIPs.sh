#!/bin/bash
# Lists IP addresses of instances in defined region

STOCKHOLM_INSTANCES_IPS_FILE="STOCKHOLM_INSTANCES_IPS.txt"
FRANKFURT_INSTANCES_IPS_FILE="FRANKFURT_INSTANCES_IPS.txt"

main(){
	[[ ${#} < 1 ]] &&
	echo -e "Stockholm:\n\n`listStockholm`\n" &&
	echo -e "Frankfurt:\n\n`listFrankfurt`\n" &&
	exit 0

	for p in ${@}
	do
		[[ ${p} == "-sf" || ${p} == "-fs" ]] &&
		listStockholm && listFrankfurt && exit 0

		[[ ${p} == "-s" || ${p} == "--stockholm" ]] && listStockholm
		[[ ${p} == "-f" || ${p} == "--frankfurt" ]] && listFrankfurt
		[[ ${p} == "-h" || ${p} == "--help" ]] && help
	done

	exit 0
}

listStockholm(){
	listIPs ${STOCKHOLM_INSTANCES_IPS_FILE} "eu-north-1"
}

listFrankfurt(){
	listIPs ${FRANKFURT_INSTANCES_IPS_FILE} "eu-central-1"
}

listIPs(){
	touch ${1}
	local list=`aws ec2 describe-instances \
		--region ${2} \
		--query "Reservations[*].Instances[*].{a:PublicIpAddress}" \
		--filters "Name=instance-state-code,Values=16" \
		--o text`
	echo $list > ${1}

	echo "${list}"
}

help(){
	echo "Usage: ${0} [-s | --stockholm] [-f | --frankfurt]"
}

./checkAWS.sh && main ${@} || ./awsCliNa.sh
