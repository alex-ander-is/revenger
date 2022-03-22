#!/bin/bash
# Creates Security Group for SSH access via port 22

main(){
	local COLOR_GREEN=$'\e[1;32m'
	local COLOR_YELLOW=$'\e[1;33m'
	local RESET_COLOR=$'\e[0m'

	STOCKHOLM_SSH_SECURITY_GROUP=`aws ec2 describe-security-groups \
		--region "eu-north-1" \
		--group-names "ssh-22" \
		--query "SecurityGroups[*].[GroupId]" \
		--o text 2> /dev/null`

	if [[ -z ${STOCKHOLM_SSH_SECURITY_GROUP} ]]
	then
		STOCKHOLM_SECURITY_GROUP=`createSecurityGroup "eu-north-1"`
		STOCKHOLM_SECURITY_RULE=`createSecurityRule "eu-north-1"`
		echo -e "Stockholm: New SG ${COLOR_GREEN}ssh-22${RESET_COLOR}: ${COLOR_YELLOW}${STOCKHOLM_SECURITY_GROUP}${RESET_COLOR} with rule ${COLOR_YELLOW}${STOCKHOLM_SECURITY_RULE}${RESET_COLOR}"
	else
		 echo -e "Stockholm: SG ${COLOR_GREEN}ssh-22${RESET_COLOR} already exists"
	fi

	FRANKFURT_SSH_SECURITY_GROUP=`aws ec2 describe-security-groups \
		--region "eu-central-1" \
		--group-names "ssh-22" \
		--query "SecurityGroups[*].[GroupId]" \
		--o text 2> /dev/null`

	if [[ -z ${FRANKFURT_SSH_SECURITY_GROUP} ]]
	then
		FRANKFURT_SECURITY_GROUP=`createSecurityGroup "eu-central-1"`
		FRANKFURT_SECURITY_RULE=`createSecurityRule "eu-central-1"`
		echo -e "Frankfurt: New SG ${COLOR_GREEN}ssh-22${RESET_COLOR}: ${COLOR_YELLOW}${FRANKFURT_SECURITY_GROUP}${RESET_COLOR} with rule ${COLOR_YELLOW}${FRANKFURT_SECURITY_RULE}${RESET_COLOR}"
	else
		 echo -e "Frankfurt: SG ${COLOR_GREEN}ssh-22${RESET_COLOR} already exists"
	fi
}

createSecurityGroup(){
	aws ec2 create-security-group \
		--region ${1} \
		--group-name "ssh-22" \
		--description "Open SSH port 22" \
		--query "[GroupId]" \
		--o text
}
createSecurityRule(){
	aws ec2 authorize-security-group-ingress \
		--region ${1} \
		--group-name "ssh-22" \
		--protocol tcp \
		--port 22 \
		--cidr 0.0.0.0/0 \
		--query "SecurityGroupRules[*].[SecurityGroupRuleId]" \
		--o text
}

./checkAWS.sh && main || ./awsCliNa.sh
