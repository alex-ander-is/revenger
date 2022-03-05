#!/bin/bash

# Fill IDs of vanilla instances
# obtained during ./createVanillaUbuntu.sh
source VANILLA_IDS.txt

main(){
	runTemplate "eu-north-1" ${STOCKHOLM_VANILLA_INSTANCE_ID}
	runTemplate "eu-central-1" ${FRANKFURT_VANILLA_INSTANCE_ID}
}

function runTemplate(){
	aws ec2 start-instances \
		--region ${1} \
		--instance-ids ${2} \
		| grep "InstanceId" | sed -E -e 's/\ |.*:|\,//g'
}

./checkAWS.sh && main || ./awsCliNa.sh
