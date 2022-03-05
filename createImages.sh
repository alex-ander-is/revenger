#!/bin/bash

# Fill IDs of vanilla instances
# obtained during ./createVanillaUbuntu.sh
source VANILLA_IDS.txt

main(){
	STOCKHOLM_TEMPLATE_IMAGE=`createImage "eu-north-1" ${STOCKHOLM_VANILLA_INSTANCE_ID} "template.t3.micro-0"`
	echo "Stockholm template image ID:" ${STOCKHOLM_TEMPLATE_IMAGE}
	echo "STOCKHOLM_TEMPLATE_IMAGE="""${STOCKHOLM_TEMPLATE_IMAGE}"" > image_ids.source

	FRANKFURT_TEMPLATE_IMAGE=`createImage "eu-central-1" ${FRANKFURT_VANILLA_INSTANCE_ID} "template.t2.micro-0"`
	echo "Frankfurt template image ID:" ${FRANKFURT_TEMPLATE_IMAGE}
	echo "FRANKFURT_TEMPLATE_IMAGE="""${FRANKFURT_TEMPLATE_IMAGE}"" >> image_ids.source
}

createImage(){
	aws ec2 create-image \
		--region ${1} \
		--instance-id ${2} \
		--name ${3} \
		| grep "ImageId" | sed -E -e 's/\ |.*:|\,//g'
}

./checkAWS.sh && main || ./awsCliNa.sh
