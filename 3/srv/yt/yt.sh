#!/bin/bash
ls /var/log/yt/ 2> /dev/null > /dev/null
if [ $? -ne 0 ]; then
    echo "Error: /var/log/yt/ does not exist"
    exit 1
fi
rm .temp/error > /dev/null 2> /dev/null
ls download 2> /dev/null > /dev/null
if [ $? -ne 0 ]; then
    echo "Error: downloads/ does not exist"
    exit 1
fi
youtube-dl $1 -o "downloads/%(title)s-%(id)s/%(title)s-%(id)s.%(ext)s" -f mp4 > /dev/null 2> /dev/null
youtube-dl $1 --write-description -o "downloads/%(title)s-%(id)s/description/%(title)s-%(id)s.%(ext)s" --skip-download > /dev/null 2> /dev/null
id=$(youtube-dl $1 --get-id --skip-download --quiet)
title=$(youtube-dl $1 --get-title --skip-download --quiet)
echo "[$(date +"%Y/%m/%d %H:%M:%S")] Video $1 was downloaded. File path : /srv/yt/yt/downloads/$title-$id/$title-$id.mp4" >> /var/log/yt/yt.log
echo "Video $1 was downloaded."
echo "File path: downloads/$title-$id/$title-$id.mp4"