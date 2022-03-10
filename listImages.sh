#!/bin/bash

main(){
	STOCKHOLM_IMAGES=`list "eu-north-1"`
	FRANKFURT_IMAGES=`list "eu-central-1"`
	[[ ! -z ${STOCKHOLM_IMAGES} ]] &&
	echo "Stockholm AMI Images: ${STOCKHOLM_IMAGES}"

	[[ ! -z ${FRANKFURT_IMAGES} ]] &&
	echo "Frankfurt AMI Images: ${FRANKFURT_IMAGES}"

	exit 0
}

list(){
	aws ec2 describe-images \
		--owners "self" \
		--region ${1} \
		| grep "ImageId" | sed -E -e 's/\ |.*:|\,//g'
}

./checkAWS.sh && main || ./awsCliNa.sh
