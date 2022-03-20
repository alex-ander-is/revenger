#!/bin/bash
# Creates and downloads key pairs 'key-frankfurt-0.pem' & 'key-stockholm-0.pem'

KEY_STOCKHOLM_FILE="key-stockholm-0.pem"
KEY_FRANKFURT_FILE="key-frankfurt-0.pem"

main(){
	checkKeysExistance
	createKeys
}

checkKeysExistance(){
	local COLOR_RED=$'\e[1;31m'
	local RESET_COLOR=$'\e[0m'

	[[ -f ${KEY_STOCKHOLM_FILE} ]] &&
	echo "${COLOR_RED}The key file ${KEY_STOCKHOLM_FILE} for Stockholm already exists!${RESET_COLOR}" &&
	ls -all ${KEY_STOCKHOLM_FILE} &&
	exit 1

	[[ -f ${KEY_FRANKFURT_FILE} ]] &&
	ls -all ${KEY_FRANKFURT_FILE} &&
	echo "${COLOR_RED}The key file ${KEY_FRANKFURT_FILE} for Frankfurt already exists!${RESET_COLOR}" &&
	exit 1
}

createKeys(){
	createKeyStockholm
	createKeyFrankfurt
	chmod 600 *.pem
}

createKeyStockholm(){
	if ! aws ec2 create-key-pair \
		--region "eu-north-1" \
		--key-name "key-stockholm-0" \
		--key-type rsa \
		--query "KeyMaterial" \
		--o text > ${KEY_STOCKHOLM_FILE}
	then exit 1; fi
}

createKeyFrankfurt(){
	if ! aws ec2 create-key-pair \
		--region "eu-central-1" \
		--key-name "key-frankfurt-0" \
		--key-type rsa \
		--query "KeyMaterial" \
		--o text > ${KEY_FRANKFURT_FILE}
	then exit 1; fi
}

./checkAWS.sh && main || ./awsCliNa.sh
