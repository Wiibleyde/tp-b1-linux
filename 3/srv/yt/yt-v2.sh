#!/bin/bash
function downloadVid {
    ls /var/log/yt/ > /dev/null 2> /dev/null
    if [ $? -ne 0 ]; then
        echo "Error: /var/log/yt/ does not exist"
        exit 1
    fi
    rm .temp/error > /dev/null 2> /dev/null
    youtube-dl $1 -o "/home/nathan/Documents/Github/tp-b1-linux/3/srv/yt/downloads/%(title)s-%(id)s/%(title)s-%(id)s.%(ext)s" -f mp4 > /dev/null 2> /dev/null
    youtube-dl $1 --write-description -o "/home/nathan/Documents/Github/tp-b1-linux/3/srv/yt/downloads/%(title)s-%(id)s/description/%(title)s-%(id)s.%(ext)s" --skip-download > /dev/null 2> /dev/null
    id=$(youtube-dl $1 --get-id --skip-download --quiet)
    title=$(youtube-dl $1 --get-title --skip-download --quiet)
    echo "[$(date +"%Y/%m/%d %H:%M:%S")] Video $1 was downloaded. File path : /home/nathan/Documents/Github/tp-b1-linux/3/srv/yt/downloads/$title-$id/$title-$id.mp4" >> /var/log/yt/yt.log
    echo "Video $1 was downloaded."
    echo "File path: /home/nathan/Documents/Github/tp-b1-linux/3/srv/yt/downloads/$title-$id/$title-$id.mp4"    
}

while :
do
    url=$(cat /home/nathan/Documents/Github/tp-b1-linux/3/srv/yt/url.txt | head -n 1)
    if [ "$url" != "" ]; then
        echo "[$(date +"%Y/%m/%d %H:%M:%S")] Auto-downloading video $url" >> /var/log/yt/yt.log
        downloadVid $url
        sed -i '1d' /home/nathan/Documents/Github/tp-b1-linux/3/srv/yt/url.txt
    fi
    sleep 1
    echo "Waiting for new URL..."
done