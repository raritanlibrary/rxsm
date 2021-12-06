#!/bin/bash

if [ -f .env ]; then
    export $(cat .env | xargs)
fi

if [ $1 == "apache" ]; then
    if [$2 == "stop"]; then
        w="C:/Apache24/bin/httpd.exe -k stop"
    elif [$2 == "start"]; then
        w="C:/Apache24/bin/httpd.exe -k start"
    else
        w="C:/Apache24/bin/httpd.exe -k stop && C:/Apache24/bin/httpd.exe -k start"
    fi
elif [ $1 == "destiny" ]; then
    if [$2 == "stop"]; then
        w="net stop Destiny"
    elif [$2 == "start"]; then
        w="net start Destiny"
    else
        w="net stop Destiny && sleep 12 && net start Destiny"
    fi
else
    echo "ERROR - Cannot run without defined argument"
    exit 1
fi

"C:\Program Files (x86)\WinSCP\WinSCP.com" << EOF
open ssh://$u:@$h -privatekey=$k
call $w
EOF