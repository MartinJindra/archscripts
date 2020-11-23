#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; 
then
    echo "Not running as root"
    exit
else
	read -p 'mirrors (0 for all, -1 for aborting) ' mirrors	
	if [[ $mirrors == -1 ]];
	then
		echo Aborting
	else
		curl -s "https://www.archlinux.org/mirrorlist/?country=all&protocol=https&ip_version=4&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n $mirrors - > /etc/pacman.d/mirrorlist
	fi
fi
