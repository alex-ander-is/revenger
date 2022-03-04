#!/bin/bash

main(){
	echo "Stockholm AMIs" && list "eu-north-1"
	echo "Frankfurt AMIs" && list "eu-central-1"
}

function list(){
	aws ec2 describe-images \
		--owners "self" \
		--region ${1} \
		| grep "ImageId" | sed -E -e 's/\ |.*:|\,//g'
}

./checkAWS.sh && main || ./awsCliNa.sh
