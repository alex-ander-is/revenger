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

./checkAWS.sh && main || ./awsCliNa.sh
