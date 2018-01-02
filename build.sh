#!/usr/bin/env bash

# Source basic functions
source utils.sh

ISOFILE=$1

# Check arguments
for i in "$@" ; do
    if [[ $i == "gnome" ]] ; then
        print_success "Setting gnome monitors"
        GNOME=$i
        break
    fi
done

if [ -n "$GNOME" ]; then
	print_info "Display setting: Gnome"
	cp display/monitors_gnome.xml display/monitors.xml
else
	print_info "Display setting: Xorg-Standard"
	cp display/monitors_xorg.xml display/monitors.xml
fi

./clean.sh

if [ ! -f linux-image* ]; then
    print_info "Looking for kernel image..."
    if [ ! -f gpd-pocket-kernel-files.zip ]; then
	 if [ ! -f gpdpocket-20180102-kernel-files.zip ]; then
	    print_warning "Downloading kernel files...."
	    print_result \
	    $(curl -LOk https://bitbucket.org/simone_nunzi/gpdpocket-kernel/downloads/gpdpocket-20180102-kernel-files.zip) \
	    "Kernel files downloaded correctly!" \
	    "Kernel files download filed. Check previous log for error."
	fi
		print_info "Extracting kernel files..."
    	print_result \
    	$(unzip -qq -o gpdpocket-20180102-kernel-files.zip) \
    	"Zip extracted correctly!" \
    	"Zip failed to extract. Check previous log for error."
    else	    
        print_info "Extracting custom kernel files..."
        print_result \
        $(unzip -qq -o gpd-pocket-kernel-files.zip) \
        "Zip extracted correctly!" \
    	"Zip failed to extract. Check previous log for error."
    fi	
fi

if [ ! -f isorespin.sh ]; then
	print_warning "Isorespin script not found. Downloading it..."
	print_result $(curl -Lk -o isorespin.sh "https://drive.google.com/uc?export=download&id=0B99O3A0dDe67S053UE8zN3NwM2c") \
	"Isorespin downloaded correctly!" \
    "Isorespin failed to download. Check previous log for error."
fi

packages="xfonts-terminus "
packages+="thermald "
packages+="tlp "
packages+="va-driver-all "
packages+="vainfo "
packages+="libva1 "
packages+="i965-va-driver "
packages+="gstreamer1.0-libav "
packages+="gstreamer1.0-vaapi "
packages+="vlc "
packages+="python-gi "
packages+="gksu "
packages+="git "
packages+="python "
packages+="gir1.2-appindicator3-0.1"

chmod +x isorespin.sh

./isorespin.sh -i $ISOFILE \
	-l "*.deb" \
	-e "bcmwl-kernel-source" \
	-p "$packages" \
	-f display/20-intel.conf \
	-f display/30-monitor.conf \
	-f display/35-screen.conf \
	-f display/40-touch.conf \
	-f display/40-trackpoint.conf \
	-f display/console-setup \
	-f display/monitors.xml \
	-f display/adduser.local \
	-f display/90-scale \
	-f display/90-interface \
	-f display/wrapper-display.sh \
	-f audio/chtrt5645.conf \
	-f audio/HiFi.conf \
	-f audio/headphone-jack \
	-f audio/headphone-jack.sh \
	-f audio/wrapper-audio.sh \
	-f fan/gpdfand \
	-f fan/gpdfand.conf \
	-f fan/gpdfand.py \
	-f fan/gpdfand.service \
	-f fan/wrapper-fan.sh \
	-f network/99-local-bluetooth.rules \
	-f network/brcmfmac4356-pcie.txt \
	-f network/wrapper-network.sh \
	-f power/wrapper-power.sh \
	-c wrapper-audio.sh \
	-c wrapper-display.sh \
	-c wrapper-fan.sh \
	-c wrapper-network.sh \
	-c wrapper-power.sh \
	-g "" \
	-g "i915.fastboot=1 i915.semaphores=1 fbcon=rotate:1"


