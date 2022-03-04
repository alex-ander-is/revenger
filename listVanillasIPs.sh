#!/bin/bash

# Fill IDs of vanilla instances
# obtained during ./createVanillaUbuntu.sh
STOCKHOLM_VANILLA_INSTANCE_ID="i-"
FRANKFURT_VANILLA_INSTANCE_ID="i-"

main(){
	echo -n "Stockholm: Vanilla IP for " && \
		list "eu-north-1" ${STOCKHOLM_VANILLA_INSTANCE_ID}

	echo -n "Frankfurt: Vanilla IP for " && \
		list "eu-central-1" ${FRANKFURT_VANILLA_INSTANCE_ID}
}

function list(){
	aws ec2 describe-instances \
		--region ${1} \
		--query "Reservations[*].Instances[*].{heroiam:InstanceId,slava:PublicIpAddress}" \
		--output=text | grep ${2}
}

./checkAWS.sh && main || ./awsCliNa.sh
