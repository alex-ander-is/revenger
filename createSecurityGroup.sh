#!/bin/bash
# Creates Security Group for SSH access via port 22

main(){
	echo -n 'Stockholm: Security Group "ssh-22" ID: ' && createSecurityGroup "eu-north-1"
	echo -n 'Frankfurt: Security Group "ssh-22" ID: ' && createSecurityGroup "eu-central-1"
}

createSecurityGroup(){
	if ! aws ec2 create-security-group \
		--region "${1}" \
		--group-name "ssh-22" \
		--description "Open SSH port 22" \
		| grep "GroupId" | sed -E -e 's/\ |.*:|\,//g'
	then exit 1; fi

	if ! aws ec2 authorize-security-group-ingress \
		--region "${1}" \
		--group-name "ssh-22" \
		--protocol tcp \
		--port 22 \
		--cidr 0.0.0.0/0 \
		&> /dev/null
	then exit 1; fi
}

./checkAWS.sh && main || ./awsCliNa.sh
