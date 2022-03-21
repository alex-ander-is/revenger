#!/bin/bash
# Creates and downloads key pairs

main(){
	local force=false

	while test $# != 0
	do
		case "$1" in
		-f|--force) force=true ;;
		--) shift; break;;
		esac
		shift
	done

	local MACHINE_SN=`system_profiler SPHardwareDataType | awk '/Serial\ Number/ {print $4}'`
	[[ -z ${MACHINE_SN} ]] && exit 1

	local COLOR_RED=$'\e[1;31m'
	local RESET_COLOR=$'\e[0m'

	KEY_STOCKHOLM="key-stockholm-${MACHINE_SN}"
	KEY_FRANKFURT="key-frankfurt-${MACHINE_SN}"

	! ${force} && [[ -f "${KEY_STOCKHOLM}.pem" ]] &&
	ls -all "${KEY_STOCKHOLM}.pem" &&
	echo "${COLOR_RED}The key file ${KEY_STOCKHOLM}.pem for Stockholm already exists!${RESET_COLOR}" &&
	exit 1

	! ${force} && [[ -f "${KEY_FRANKFURT}.pem" ]] &&
	ls -all ${KEY_FRANKFURT_FILE} &&
	echo "${COLOR_RED}The key file ${KEY_FRANKFURT}.pem for Frankfurt already exists!${RESET_COLOR}" &&
	exit 1

	${force} && rm -rf *.pem

	createKey "eu-north-1" ${KEY_STOCKHOLM}
	createKey "eu-central-1" ${KEY_FRANKFURT}

	chmod 600 *.pem
}

createKey(){
	aws ec2 create-key-pair \
		--region ${1} \
		--key-name ${2} \
		--key-type rsa \
		--query "KeyMaterial" \
		--o text > "${2}.pem" ||
	exit 1
}

./checkAWS.sh && main ${@} || ./awsCliNa.sh
