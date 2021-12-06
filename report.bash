#!/bin/bash

if [ -f .env ]; then
    export $(cat .env | xargs)
fi

"C:\Program Files (x86)\WinSCP\WinSCP.com" << EOF
open ssh://$u:@$h -privatekey=$k
call perl C:/wwwStat/cgi-bin/awstats_buildstaticpages.pl -config=model -update -awstatsprog=C:/wwwStat/cgi-bin/awstats.pl -dir=C:/wwwStat
call cd c && tar -czvf wwwStat.tgz wwwStat/*
get -delete wwwStat.tgz tmp\wwwStat.tgz
EOF
"C:\Program Files\7-Zip\7z.exe" e tmp\\wwwStat.tgz -otmp
"C:\Program Files\7-Zip\7z.exe" x tmp\\wwwStat.tar -otmp