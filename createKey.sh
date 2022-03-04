#!/bin/bash

main(){
	createKey
}

function createKey(){
	createKeyStockholm
	createKeyFrankfurt
	chmod 600 *.pem
}

function createKeyStockholm(){
	aws ec2 create-key-pair \
	--region "eu-north-1" \
	--key-name "key-stockholm-1" \
	--key-type rsa \
	--query "KeyMaterial" \
	--output text > key-stockholm-1.pem
}

function createKeyFrankfurt(){
	aws ec2 create-key-pair \
	--region "eu-central-1" \
	--key-name "key-frankfurt-1" \
	--key-type rsa \
	--query "KeyMaterial" \
	--output text > key-frankfurt-1.pem
}

./checkAWS.sh && main || ./awsCliNa.sh
