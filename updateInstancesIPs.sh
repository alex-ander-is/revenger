#!/bin/bash

main(){
	updateIPs "STOCKHOLM_INSTANCES_IPS.txt" "eu-north-1"
	updateIPs "FRANKFURT_INSTANCES_IPS.txt" "eu-central-1"
}

updateIPs(){
	touch ${1}

	aws ec2 describe-instances \
		--region ${2} \
		--query "Reservations[*].Instances[*].{a:PublicIpAddress}" \
		--filters "Name=instance-state-code,Values=16" \
		--o text > ${1}
}

./checkAWS.sh && main || ./awsCliNa.sh
