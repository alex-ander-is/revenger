#!/bin/bash

# Fill IDs of vanilla instances
# obtained during ./createVanillaUbuntu.sh
STOCKHOLM_VANILLA_INSTANCE_ID="i-001d1ffbf44edbd2d"
FRANKFURT_VANILLA_INSTANCE_ID="i-001fcb7bdfa0dd0da"

main(){
	echo -n "Stockholm: Vanilla Ubuntu Instance ID: " && \
		createImage "eu-north-1" ${STOCKHOLM_VANILLA_INSTANCE_ID} "template.t3.micro-0"

	echo -n "Frankfurt: Vanilla Ubuntu Instance ID: " && \
		createImage "eu-central-1" ${FRANKFURT_VANILLA_INSTANCE_ID} "template.t2.micro-0"
}

createImage(){
	aws ec2 create-image \
		--region ${1} \
		--instance-id ${2} \
		--name ${3} \
		| grep "ImageId" | sed -E -e 's/\ |.*:|\,//g'
}

./checkAWS.sh && main || ./awsCliNa.sh
