#!/bin/bash
# Creates vanilla Ubuntu instances. There will be installed all necessary
# packages incl. docker image and will be no need to do the installation again
# and again.

# Don't touch if you don't know what are you doing
STOCKHOLM_VANILLA_IMAGE_UBUNTU="ami-092cce4a19b438926"
FRANKFURT_VANILLA_IMAGE_UBUNTU="ami-0d527b8c289b4af7f"

main(){
	STOCKHOLM_VANILLA_INSTANCE_ID=`createInstance ${STOCKHOLM_VANILLA_IMAGE_UBUNTU} "eu-north-1" "key-stockholm-0" "t3.micro"`
	[[ -z ${STOCKHOLM_VANILLA_INSTANCE_ID} ]] && exit 1

	echo "Stockholm: Vanilla Ubuntu Instance ID: ${STOCKHOLM_VANILLA_INSTANCE_ID}"
	echo "STOCKHOLM_VANILLA_INSTANCE_ID=""${STOCKHOLM_VANILLA_INSTANCE_ID}" > VANILLA_IDS.txt

	FRANKFURT_VANILLA_INSTANCE_ID=`createInstance ${FRANKFURT_VANILLA_IMAGE_UBUNTU} "eu-central-1" "key-frankfurt-0" "t2.micro"`
	[[ -z ${FRANKFURT_VANILLA_INSTANCE_ID} ]] && exit 1

	echo "Frankfurt: Vanilla Ubuntu Instance ID: ${FRANKFURT_VANILLA_INSTANCE_ID}"
	echo "FRANKFURT_VANILLA_INSTANCE_ID=""${FRANKFURT_VANILLA_INSTANCE_ID}" >> VANILLA_IDS.txt
}


createInstance(){
	aws ec2 run-instances \
		--image-id ${1} \
		--region ${2} \
		--key-name ${3} \
		--security-groups "ssh-22" \
		--instance-type ${4} \
		--block-device-mappings "DeviceName=/dev/sda1,Ebs={VolumeSize=8}" \
		| grep "InstanceId" | sed -E -e 's/\ |.*:|\,//g'
}

./checkAWS.sh && main || ./awsCliNa.sh
