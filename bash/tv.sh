#!/bin/bash

channels=E5-svt1,E6-svt2,E10-tv3,E8-tv4,SE8-kanal5,E7-tv6,E11-tv4plus,SE7-svt24,SE14-tv4sport,SE15-mtv,SE16-barnkanalen,SE11-oppnakanalen,S36-kanal9,57-tv8

if [[ "$1" == "" ]]; then

    chs=$(echo $channels|tr "," "\n")
    echo "tv.sh: channels:"
    for ch in $chs; do
        echo "* ${ch##*-}"
    done
    exit 0
fi

mplayer \
-vf crop=700:410:: \
-zoom \
-tv \
driver=v4l2:device=/dev/video0:norm=PAL:chanlist=europe-west:alsa=1:adevice=hw.1:audiorate=48000:immediatemode=0:amode=0:buffersize=32:channels=$channels:width=720:height=576:outfmt=i420 \
tv://$1

