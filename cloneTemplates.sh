#!/bin/bash

# Fill Vanilla Ubuntu Instance IDs:
STOCKHOLM_TEMPLATE_IMAGE="ami-"
FRANKFURT_TEMPLATE_IMAGE="ami-"

# Don't touch if you don't know what are you doing
STOCKHOLM_INSTANCE_TYPE="t3.micro"
FRANKFURT_INSTANCE_TYPE="t2.micro"

# Verify Security Groups Names
STOCKHOLM_SECURITY_GROUPS="launch-wizard-22"
FRANKFURT_SECURITY_GROUPS="launch-wizard-37"


# https://docs.aws.amazon.com/cli/latest/reference/ec2/run-instances.html
# To ensure faster instance launches, break up large requests into smaller
# batches. For example, create five separate launch requests for 100 instances
# each instead of one launch request for 500 instances.

main(){
	echo "Stockholm:"
	for i in $(seq 1 ${@})
	do
		cloneStockholm
	done

	echo "Frankfurt:"
	for i in $(seq 1 ${@})
	do
		cloneFrankfurt
	done
}

function cloneStockholm(){
	aws ec2 run-instances \
		--image-id "${STOCKHOLM_TEMPLATE_IMAGE}" \
		--region "eu-north-1" \
		--key-name "key-stockholm-1" \
		--instance-type "${STOCKHOLM_INSTANCE_TYPE}" \
		--security-groups "${STOCKHOLM_SECURITY_GROUPS}" \
		--block-device-mappings "DeviceName=/dev/sda1,Ebs={VolumeSize=8}" \
		| grep "InstanceId" | sed -E -e 's/\ |.*:|\,//g'
}

function cloneFrankfurt(){
	aws ec2 run-instances \
		--image-id "${FRANKFURT_TEMPLATE_IMAGE}" \
		--region "eu-central-1" \
		--key-name "key-frankfurt-1" \
		--instance-type ${FRANKFURT_INSTANCE_TYPE} \
		--security-groups "${FRANKFURT_SECURITY_GROUPS}" \
		--block-device-mappings "DeviceName=/dev/sda1,Ebs={VolumeSize=8}" \
		| grep "InstanceId" | sed -E -e 's/\ |.*:|\,//g'
}

./checkAWS.sh && main ${@} || ./awsCliNa.sh
