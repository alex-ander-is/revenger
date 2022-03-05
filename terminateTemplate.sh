#!/bin/bash
# Terminates the template instance to avoid confusion

source VANILLA_IDS.txt

main(){
	echo -n "Terminating Instance: " && terminate "eu-north-1" ${STOCKHOLM_VANILLA_INSTANCE_ID}
	echo -n "Terminating Instance: " && terminate "eu-central-1" ${FRANKFURT_VANILLA_INSTANCE_ID}
}

terminate(){
	aws ec2 terminate-instances \
		--region ${1} \
		--instance-ids ${2} \
		| grep "InstanceId" | sed -E -e 's/\ |.*:|\,//g'
}

./checkAWS.sh && main || ./awsCliNa.sh
