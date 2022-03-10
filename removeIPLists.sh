#!/bin/bash

main(){
	[[ -f "STOCKHOLM_INSTANCES_IPS.txt" ]] &&
	rm -f "STOCKHOLM_INSTANCES_IPS.txt"

	[[ -f "FRANKFURT_INSTANCES_IPS.txt" ]] &&
	rm -f "FRANKFURT_INSTANCES_IPS.txt"
}

main
