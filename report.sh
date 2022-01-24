#!/bin/bash

if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# Build pages on server and send them via SSH
"C:\Program Files (x86)\WinSCP\WinSCP.com" << EOF
open ssh://$u:@$h -privatekey=$k
call perl C:/wwwStat/cgi-bin/awstats_buildstaticpages.pl -config=model -update -awstatsprog=C:/wwwStat/cgi-bin/awstats.pl -dir=C:/wwwStat
call cd c && tar -czvf wwwStat.tgz wwwStat/*
get -delete wwwStat.tgz tmp\wwwStat.tgz
EOF

# Unpack the pages sent from the server
"C:\Program Files\7-Zip\7z.exe" e tmp\\wwwStat.tgz -otmp
"C:\Program Files\7-Zip\7z.exe" x tmp\\wwwStat.tar -otmp

# Make new directory with appropriate timestamp
reportDir=$(date +%Y%m%d)
mkdir reports/$reportDir

# Cycle through tmp/wwwStat/ and change .html srcs
for i in tmp/wwwStat/*.html; do
    sed -i 's/src="\//src="/g' $i
done

# Move wwwStat directory to reports, delete temporary files
mv tmp/wwwStat/* reports/$reportDir
rm -rf tmp/*