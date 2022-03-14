#!/bin/bash
# Makes defined number of clones from previously created images

IMAGE_IDS_FILE="IMAGE_IDS.txt"

[[ -f ${IMAGE_IDS_FILE} ]] || exit 1
source ${IMAGE_IDS_FILE}

# https://docs.aws.amazon.com/cli/latest/reference/ec2/run-instances.html
# To ensure faster instance launches, break up large requests into smaller
# batches. For example, create five separate launch requests for 100 instances
# each instead of one launch request for 500 instances.

main(){
	for p in ${@}
	do
		[[ ${p} == "-sf" || ${p} == "-fs" ]] &&
		shift &&
		cloneBoth ${@} &&
		exit 0

		[[ ${p} == "-s" || ${p} == "--stockholm" ]] &&
		shift &&
		cloneStockholm ${@} &&
		exit 0

		[[ ${p} == "-f" || ${p} == "--frankfurt" ]] &&
		shift &&
		cloneFrankfurt ${@} &&
		exit 0

		[[ ${p} == "-h" || ${p} == "--help" ]] &&
		help &&
		exit 0
	done

	cloneBoth ${@}
}

cloneBoth(){
	cloneStockholm ${@} &
	cloneFrankfurt ${@} &
	wait
}

cloneStockholm(){
	[[ -z ${STOCKHOLM_TEMPLATE_IMAGE} ]] && interrupted "eu-north-1"

	for i in $(seq 1 ${@})
	do
		process \
			${STOCKHOLM_TEMPLATE_IMAGE} \
			"eu-north-1" \
			"key-stockholm-0" \
			"t3.micro" \
			${i}
	done
}

cloneFrankfurt(){
	[[ -z ${FRANKFURT_TEMPLATE_IMAGE} ]] && interrupted "eu-central-1"

	for i in $(seq 1 ${@})
	do
		process \
			${FRANKFURT_TEMPLATE_IMAGE} \
			"eu-central-1" \
			"key-frankfurt-0" \
			"t2.micro" \
			${i}
	done
}

process(){
	echo "    creating new instance no. ${5} in ${2}"
	aws ec2 run-instances \
		--image-id ${1} \
		--region ${2} \
		--key-name ${3} \
		--instance-type ${4} \
		--security-groups "ssh-22" \
		--block-device-mappings "DeviceName=/dev/sda1,Ebs={VolumeSize=8}" \
		| grep "InstanceId" | sed -E -e 's/\ |.*:|\,//g' 1> /dev/null
}

interrupted(){
	local COLOR_RED=$'\e[1;31m'
	local COLOR_YELLOW=$'\e[1;33m'
	local RESET_COLOR=$'\e[0m'

	echo -e "${COLOR_RED}The clonning of templates in ${COLOR_YELLOW}${1}${COLOR_RED} region was not succesfull.${RESET_COLOR}"
	exit 1
}

help(){
	echo "Usage: ${0} [-s | --stockholm] [-f | --frankfurt] [10]"
}


./checkAWS.sh && main ${@} || ./awsCliNa.sh
