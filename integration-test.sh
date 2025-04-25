#!/bin/bash

sleep 5

if netstat -pnlt | grep 3000 ; then
    http_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)
    if [[ "$http_code" == 200 ]]; then
        echo "HTTP Status code test passed"
    else
        echo "HTTP Status code test is not 200"
        exit 1
    fi
else
    echo "Service dose not running"

fi