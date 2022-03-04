#!/bin/bash

AWS_COMMAND="aws"

if command -v ${AWS_COMMAND} &> /dev/null
then
    exit 0
fi

exit 2
