#!/bin/bash
# Installs necessary packages, docker image and shut down the instance.

# Load values of
# STOCKHOLM_VANILLA_INSTANCE_ID & FRANKFURT_VANILLA_INSTANCE_ID
[[ -f "VANILLA_IDS.txt" ]] &&
source "VANILLA_IDS.txt" ||
exit 1

main(){
	STOCKHOLM_VANILLA_INSTANCE_IP=`getInstanceIP "eu-north-1" ${STOCKHOLM_VANILLA_INSTANCE_ID}`
	[[ -z ${STOCKHOLM_VANILLA_INSTANCE_IP} ]] && exit 1

	FRANKFURT_VANILLA_INSTANCE_IP=`getInstanceIP "eu-central-1" ${FRANKFURT_VANILLA_INSTANCE_ID}`
	[[ -z ${FRANKFURT_VANILLA_INSTANCE_IP} ]] && exit 1

	echo "Stockholm IP: " ${STOCKHOLM_VANILLA_INSTANCE_IP}
	echo "Frankfurt IP: " ${FRANKFURT_VANILLA_INSTANCE_IP}

	# TODO: Prevent the action in case there is more than one IP returned.
	install "key-stockholm-0.pem" ${STOCKHOLM_VANILLA_INSTANCE_IP} &
	install "key-frankfurt-0.pem" ${FRANKFURT_VANILLA_INSTANCE_IP}
}

getInstanceIP(){
	aws ec2 describe-instances \
		--region ${1} \
		--instance-ids ${2} \
		--query "Reservations[*].Instances[*].{HeroiamSlava:PublicIpAddress}" \
		--filters "Name=instance-state-code,Values=16" \
		--o text
}

install(){
	scp -i ${1} -o "StrictHostKeyChecking no" vpc-installer.sh ubuntu@${2}:/home/ubuntu
	ssh -i ${1} -o "StrictHostKeyChecking no" ubuntu@${2} chmod +x vpc-installer.sh
	ssh -i ${1} -o "StrictHostKeyChecking no" ubuntu@${2} ./vpc-installer.sh
}

./checkAWS.sh && main || ./awsCliNa.sh
