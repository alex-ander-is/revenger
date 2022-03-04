#!/bin/bash

# Don't touch if you don't know what are you doing
STOCKHOLM_VANILLA_IMAGE_UBUNTU="ami-092cce4a19b438926"
FRANKFURT_VANILLA_IMAGE_UBUNTU="ami-0d527b8c289b4af7f"

main(){
	echo -n "Stockholm: Vanilla Ubuntu Instance ID: " && createStockholm
	echo -n "Frankfurt: Vanilla Ubuntu Instance ID: " && createFrankfurt
}

function createStockholm(){
	aws ec2 run-instances \
		--image-id "${STOCKHOLM_VANILLA_IMAGE_UBUNTU}" \
		--region "eu-north-1" \
		--key-name "key-stockholm-1" \
		--security-groups "default" \
		--instance-type "t3.micro" \
		--block-device-mappings "DeviceName=/dev/sda1,Ebs={VolumeSize=8}" \
		| grep "InstanceId" | sed -E -e 's/\ |.*:|\,//g'
}

function createFrankfurt(){
	aws ec2 run-instances \
		--image-id "${FRANKFURT_VANILLA_IMAGE_UBUNTU}" \
		--region "eu-central-1" \
		--key-name "key-frankfurt-1" \
		--security-groups "default" \
		--instance-type "t2.micro" \
		--block-device-mappings "DeviceName=/dev/sda1,Ebs={VolumeSize=8}" \
		| grep "InstanceId" | sed -E -e 's/\ |.*:|\,//g'
}

./checkAWS.sh && main || ./awsCliNa.sh
