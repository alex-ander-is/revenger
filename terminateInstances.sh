#!/bin/bash
# Terminates all instances

main(){
	./removeIPLists.sh

	STOCKHOLM_INSTANCES_IDS=`getInstances "eu-north-1"`
	FRANKFURT_INSTANCES_IDS=`getInstances "eu-central-1"`

	[[ -z ${STOCKHOLM_INSTANCES_IDS} ]] || terminate "eu-north-1" ${STOCKHOLM_INSTANCES_IDS} &
	[[ -z ${FRANKFURT_INSTANCES_IDS} ]] || terminate "eu-central-1" ${FRANKFURT_INSTANCES_IDS}
}

getInstances(){
	aws ec2 describe-instances \
		--region ${1} \
		--query "Reservations[*].Instances[*].{HeroiamSlava:InstanceId}" \
		--filters "Name=instance-state-code,Values=0,16,32,64,80" \
		--o text
}

terminate(){
	local region=${1}
	shift 1

	for id in ${@}
	do
		echo "    terminating ${id} from ${region}"
		aws ec2 terminate-instances \
			--region ${region} \
			--instance-ids ${id} \
			1> /dev/null
	done
}

./checkAWS.sh && main || ./awsCliNa.sh
