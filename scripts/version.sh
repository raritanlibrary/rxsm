#!/bin/bash

# import env variables
if [[ -f .env ]]; then
    export $(cat .env | xargs)
fi

# grab necessary files from server
"C:/Program Files (x86)/WinSCP/WinSCP.com" > /dev/null << EOF
open ssh://$u:@$h -privatekey=$k
call cd c/Apache24/bin && ./httpd.exe -v >> ../VERSION
get -delete Apache24\VERSION tmp\APACHE
get "Program Files (x86)\freeSSHd\FreeSSHDService.exe" tmp\sshd.exe
EOF

# extract version number from exe
"powershell" > /dev/null << EOF
(Get-Command tmp\sshd.exe).FileVersionInfo.FileVersion | Out-File -Encoding Ascii -FilePath tmp\SSH
exit
EOF

# parse apache versions
currentA=`grep -oP '(?<=Apache\/)\S+' tmp/APACHE`
latestARaw=`curl -Ls https://en.wikipedia.org/wiki/Apache_HTTP_Server`
latestA=`grep -oP '(?<=release<\/a><\/th><td class="infobox-data"><div style="margin:0px;">)\d+\.\d+\.\d+' <<< "$latestARaw"`

# parse destiny versions
currentDRaw=`curl -Ls http://raritanlibrary.org:8080/`
currentD=`grep -oP '(?<=ReleaseInfo" class="PageFooter">)[^<]+' <<< "$currentDRaw"`
latestDRaw=`curl -Ls https://dcps.follettdestiny.com/`
latestD=`grep -oP '(?<=ReleaseInfo" class="PageFooter">)[^<]+' <<< "$latestDRaw"`

# parse freeSSHd versions
currentSRaw=`grep -oP '(\d+, )+' tmp/SSH`
currentS="${currentSRaw//, /.}"
latestSRaw=`curl -Ls http://www.freesshd.com/`
latestS=`grep -oP '(?<=download">freeSSHd )[\w.]+' <<< "$latestSRaw"`

# print info + cleanup
echo -e "\t\t  Current\tLatest"
echo -e "────────────────┬─────────────────────────"
echo -e "Apache \t\t│ $currentA\t$latestA"
echo -e "Destiny \t│ ${currentD//_/.}\t${latestD//_/.}"
echo -e "FreeSSHD \t│ ${currentS::-1}\t\t$latestS"
rm -rf tmp/*