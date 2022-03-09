#!/bin/bash

main(){
	echo "Stockholm AMI Images: " && list "eu-north-1"
	echo "Frankfurt AMI Images: " && list "eu-central-1"
}

list(){
	aws ec2 describe-images \
		--owners "self" \
		--region ${1} \
		| grep "ImageId" | sed -E -e 's/\ |.*:|\,//g'
}

./checkAWS.sh && main || ./awsCliNa.sh
