#!/bin/bash

main(){
	echo "Stockholm: IPs" && list "eu-north-1"
	echo "Frankfurt: IPs" && list "eu-central-1"
}

function list(){
	aws ec2 describe-instances \
		--region ${1} \
		--query "Reservations[*].Instances[*].{HeroiamSlava:PublicIpAddress}" \
		--filters "Name=instance-state-code,Values=16" \
		--output=text
}

./checkAWS.sh && main || ./awsCliNa.sh
