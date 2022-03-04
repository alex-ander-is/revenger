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

if ./checkAWS.sh; then
	main
else
	echo "AWS CLI not found, check https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
fi
