#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; 
then
    echo "Not running as root"
    exit
else
	mirrorlist=/etc/pacman.d/mirrorlist
	mirrorlistbak=/etc/pacman.d/mirrorlist.bak
	read -p 'how many mirrors: 0 for all, -1 for aborting ' mirrors	
	if [[ $mirrors == -1 ]];
	then
		echo Aborting
	elif [[ $mirrors -gt -1 ]];
	then
		if [[ -f "$mirrorlistbak" ]];
		then
			rm /etc/pacman.d/mirrorlist.bak
		fi 
		if [[ -f "$mirrorlist" ]];
		then
			cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
		fi
		curl -s "https://www.archlinux.org/mirrorlist/?country=all&protocol=https&ip_version=4&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n $mirrors - > $mirrorlist
	fi
fi
