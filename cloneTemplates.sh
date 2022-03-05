#!/bin/bash

# Fill Vanilla Ubuntu Instance IDs
# obtained during ./createImages.sh
source IMAGE_IDS.txt

# https://docs.aws.amazon.com/cli/latest/reference/ec2/run-instances.html
# To ensure faster instance launches, break up large requests into smaller
# batches. For example, create five separate launch requests for 100 instances
# each instead of one launch request for 500 instances.

main(){
	cloneStockholm ${@} &
	cloneFrankfurt ${@} &
}

cloneStockholm(){
	for i in $(seq 1 ${@})
	do
		process \
			${STOCKHOLM_TEMPLATE_IMAGE} \
			"eu-north-1" \
			"key-stockholm-0" \
			"t3.micro" &
	done
}

cloneFrankfurt(){
	for i in $(seq 1 ${@})
	do
		process \
			${FRANKFURT_TEMPLATE_IMAGE} \
			"eu-central-1" \
			"key-frankfurt-0" \
			"t2.micro" &
	done
}

process(){
	aws ec2 run-instances \
		--image-id "${1}" \
		--region "${2}" \
		--key-name "${3}" \
		--instance-type "${4}" \
		--security-groups "ssh-22" \
		--block-device-mappings "DeviceName=/dev/sda1,Ebs={VolumeSize=8}" \
		| grep "InstanceId" | sed -E -e 's/\ |.*:|\,//g' 1> /dev/null
}

./checkAWS.sh && main ${@} || ./awsCliNa.sh
