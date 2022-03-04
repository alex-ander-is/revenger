#!/bin/bash

# Fill IP addresses of vanilla instances
# by run ./listInstancesIPs.sh

function main(){
	STOCKHOLM_VANILLA_INSTANCE_IP=`get_instance_ip "eu-north-1"`
	FRANKFURT_VANILLA_INSTANCE_IP=`get_instance_ip "eu-central-1"`

	echo "Stockholm IP:" ${STOCKHOLM_VANILLA_INSTANCE_IP}
	echo "Frankfurt IP:" ${FRANKFURT_VANILLA_INSTANCE_IP}

	install "key-stockholm-1.pem" ${STOCKHOLM_VANILLA_INSTANCE_IP}
	install "key-frankfurt-1.pem" ${FRANKFURT_VANILLA_INSTANCE_IP}
}

function get_instance_ip(){
	aws ec2 describe-instances \
		--region ${1} \
		--query "Reservations[*].Instances[*].{slava:PublicIpAddress}" \
		--output=text
}

function install(){
	scp -i "${1}" -o "StrictHostKeyChecking no" install.sh ubuntu@${2}:/home/ubuntu
	ssh -i "${1}" -o "StrictHostKeyChecking no" "ubuntu@${2}" chmod +x install.sh
	ssh -i "${1}" -o "StrictHostKeyChecking no" "ubuntu@${2}" ./install.sh
}

./checkAWS.sh && main || ./awsCliNa.sh
