#!/bin/bash
youtube-dl $1 -o "download/%(title)s-%(id)s/%(title)s-%(id)s.%(ext)s" -f mp4
youtube-dl $1 --write-description -o "download/%(title)s-%(id)s/description/%(title)s-%(id)s.%(ext)s" --skip-download