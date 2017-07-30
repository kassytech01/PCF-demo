#!/bin/sh

result=$(curl -LI localhost:8080 -o /dev/null -w '%{http_code}\n' -s)

if [[ "$result" =~ "200" ]]; then
    exit 0
else
    exit 1
fi