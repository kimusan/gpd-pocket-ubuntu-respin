#!/bin/bash

ISOFILE=$1

if [ ! -f linux-image* ]; then
    echo "Kernel image not found"

    if [ ! -f gpdpocket-kernel-wifi-sound-display.zip ]; then
    	echo "Download kernel files"
    	wget -O gpdpocket-kernel-wifi-sound-display.zip https://www.dropbox.com/s/fgohikbsb9aehyu/gpdpocket-kernel-wifi-sound-display.zip?dl=1 
    fi

    echo "Extracting kernel files..."
    unzip gpdpocket-kernel-wifi-sound-display.zip
fi

echo "Overwrite working monitors.xml"
rm monitors.xml
mv monitors_working.xml monitors.xml

if [ ! -f isorespin.sh ]; then
	echo "Isorespin script not found. Downloading it..."
	wget -O isorespin.sh "https://drive.google.com/uc?export=download&id=0B99O3A0dDe67S053UE8zN3NwM2c"
fi

./isorespin.sh -i $ISOFILE -l "*.deb" -p "libproc-daemon-perl libproc-pid-file-perl liblog-dispatch-perl thermald" -f 90x11-rotate_and_scale -f HiFi.conf -f chtrt5645.conf -f brcmfmac4356-pcie.txt -f wrapper-fix-sound-wifi.sh -f wrapper-rotate-and-scale.sh -f gpdfand -f gpdfand.service -f wrapper-gpd-fan-control.sh -f monitors.xml -f adduser.local -c wrapper-rotate-and-scale.sh -c wrapper-fix-sound-wifi.sh -c wrapper-gpd-fan-control.sh -g "i915.fastboot=1 fbcon=rotate:1 intel_pstate=disable"




