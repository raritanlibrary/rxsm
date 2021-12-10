#!/bin/bash

if [ -f .env ]; then
    export $(cat .env | xargs)
fi

"C:\Program Files (x86)\WinSCP\WinSCP.com" << EOF
open ssh://$u:@$h -privatekey=$k
call cd c/Apache24/bin && ./httpd.exe -v >> ../VERSION
get -delete Apache24\VERSION tmp\VERSION
EOF
#grep tmp/VERSION
rm -rf tmp/*