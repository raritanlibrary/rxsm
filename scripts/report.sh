#!/bin/bash

if [[ -f .env ]]; then
    export $(cat .env | xargs)
fi

# Set program variables
p7zip="/c/Program Files\7-Zip\7z.exe"

# Calculate timestamps
timestamp=$(date +%y%m)

# Stop Apache server
bash scripts/service.sh apache stop

# Build pages on server
# Split log file 
# Send built files via a tarball file
"C:\Program Files (x86)\WinSCP\WinSCP.com" << EOF
open ssh://$u:@$h -privatekey=$k
call perl C:/wwwStat/cgi-bin/awstats_buildstaticpages.pl -config=model -update -awstatsprog=C:/wwwStat/cgi-bin/awstats.pl -dir=C:/wwwStat
mv Apache24/logs/access.log Apache24/logs/access.$timestamp.log
call touch /c/Apache24/logs/access.log
call cd c && tar -czvf wwwStat.tgz wwwStat/*
get -delete wwwStat.tgz tmp\wwwStat.tgz
EOF

# Unpack the pages sent from the server
"$p7zip" e tmp\\wwwStat.tgz -otmp
"$p7zip" x tmp\\wwwStat.tar -otmp

# Make new directory with appropriate timestamp
mkdir reports/$timestamp

# Cycle through tmp/wwwStat/ and change .html srcs
for i in tmp/wwwStat/*.html; do
    sed -i 's/src="\//src="/g' $i
done

# Move wwwStat directory to reports, delete temporary files
mv tmp/wwwStat/* reports/$timestamp
rm -rf tmp/*

# Don't restart Apache server until midnight
sleeptime=$(( $(date -f - +%s- <<< "tomorrow 00:00"$'\nnow') 0 ))
echo "Sleeping for $sleeptime seconds..."
sleep $sleeptime
bash scripts/service.sh apache start