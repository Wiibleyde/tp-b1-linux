#!/bin/bash
# Created : 2023-01-10 at 11am
# Nathan
# Simple script of backup for nextcloud
fileName="nextcloud_'date +%Y%m%d%H%M%S'.tar.gz"
rsync -Aazvx /var/www/tp5_nextcloud/ /srv/backup/$fileName
echo "Filename : $fileName saved in /srv/backup"

