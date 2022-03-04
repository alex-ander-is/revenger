#!/bin/bash

main(){
	echo "Stockholm: IPs" && list "eu-north-1"
	echo "Frankfurt: IPs" && list "eu-central-1"
}

function list(){
	aws ec2 describe-instances \
		--region ${1} \
		--query "Reservations[*].Instances[*].PublicIpAddress" \
		--output=text
}

if ./checkAWS.sh; then
	main
else
	echo "AWS CLI not found, check https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
fi
