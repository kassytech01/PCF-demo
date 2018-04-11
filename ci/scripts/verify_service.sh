#!/bin/bash

function verify_service(){
    result=$(curl -LI localhost:80/pcf-demo/ -o /dev/null -w '%{http_code}\n' -s)

    if [[ "$result" =~ "200" ]]; then
        return 0
    else
        return 1
    fi
}

NEXT_WAIT_TIME=0
until verify_service || [ $NEXT_WAIT_TIME -eq 10 ]; do
   sleep $(( NEXT_WAIT_TIME++ ))
   echo $NEXT_WAIT_TIME
done