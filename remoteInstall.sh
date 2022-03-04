#!/bin/bash

# Fill IP addresses of vanilla instances
# by run ./listVanillasIPs.sh
STOCKHOLM_VANILLA_INSTANCE_IP=""
FRANKFURT_VANILLA_INSTANCE_IP=""

function main(){
	install "key-stockholm-1.pem" ${STOCKHOLM_VANILLA_INSTANCE_IP}
	install "key-frankfurt-1.pem" ${FRANKFURT_VANILLA_INSTANCE_IP}
}

function install(){
	scp -i "${1}" -o "StrictHostKeyChecking no" install.sh ubuntu@${2}:/home/ubuntu
	ssh -i "${1}" -o "StrictHostKeyChecking no" "ubuntu@${2}" chmod +x install.sh
	ssh -i "${1}" -o "StrictHostKeyChecking no" "ubuntu@${2}" ./install.sh
}

if ./checkAWS.sh; then
	main
else
	echo "AWS CLI not found, check https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
fi
