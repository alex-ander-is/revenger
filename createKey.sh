#!/bin/bash
# Creates and downloads key pairs 'key-frankfurt-0.pem' & 'key-stockholm-0.pem'

main(){
	createKey
}

function createKey(){
	createKeyStockholm
	createKeyFrankfurt
	chmod 600 *.pem
}

function createKeyStockholm(){
	if ! aws ec2 create-key-pair \
		--region "eu-north-1" \
		--key-name "key-stockholm-0" \
		--key-type rsa \
		--query "KeyMaterial" \
		--output text > key-stockholm-0.pem
	then exit 1; fi
}

function createKeyFrankfurt(){
	if ! aws ec2 create-key-pair \
		--region "eu-central-1" \
		--key-name "key-frankfurt-0" \
		--key-type rsa \
		--query "KeyMaterial" \
		--output text > key-frankfurt-0.pem
	then exit 1; fi
}

./checkAWS.sh && main || ./awsCliNa.sh
