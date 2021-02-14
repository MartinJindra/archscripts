#!/bin/bash
# save current week day 
day=$(date '+%u')
# if today is Friday then update
# if not just cache the updates
if [ "$day" == 5 ]; then
	read -rp 'Want to update the system? (y/N) ' choice_update
	choice_update=${choice_update,,}
	# update system if user chooses to
	if [[ $choice_update == 'y' ]];
	then
		echo "Its $(date +"%A"), time to update"
		# use yay to upgrade packages if yay is installed
		if [ -x "$(command -v yay)" ];
		then
			echo Updating Packages
			yay -Syu
		# use paru to upgrade packages if paru is installed
		elif [ -x "$(command -v paru)" ];
		then
			echo Updating Packages
			paru -Syu
		# use pamac to upgrade packages if pamac is installed
		elif [ -x "$(command -v pamac)" ];
		then
			echo Updating Packages
			sudo pamac update -a
		# use trizen to upgrade packages if trizen is installed
		elif [ -x "$(command -v trizen)" ];
		then
			echo Updating Packages
			trizen -Syu
		# use pacman to upgrade packages 
		else 
			echo Updating Packages
			sudo pacman -Syu
		fi
		# update flatpaks if installed
		if [ -x "$(command flatpak)" ];
		then
			echo Updating Flatpaks
			flatpak update
		fi
		# update snaps if installed
		if [ -x "$(command snap)" ];
		then
			echo Updating Snaps
			sudo snap refresh
		fi
		# clear packages if paccache is installed
		if [ -x "$(command paccache)" ];
		then
			paccache -d
			read -rp 'Want to clean pacman cache? (y/N) ' choice_cache
			choice_cache=${choice_cache,,}
			if [[ $choice_cache == 'y' ]]; 
			then
				paccache -r
			fi
		fi
		# clear unused packages if yay is installed
		if [ -x "$(command yay)" ];
		then
			read -rp 'Want to removing unused dependencies? (y/N) ' choice_dep
			choice_dep=${choice_dep,,}
			if [[ "$choice_dep" == 'y' ]];
			then	
				yay -Yc
			fi
		fi
		# checks if orphan packages exists
		if [[ "$(pacman -Qtdq | wc -l)" -eq 0 ]];
		then
			echo "No orphans packages were found"
		else
			echo "Packages to clean:"
			read -rp 'Want to remove orphaned packages? (y/N) ' choice_orphend
			choice_orphend=${choice_orphend,,}	
			if [[ $choice_orphend == 'y' ]];
			then
				sudo pacman -Rsn $(pacman -Qtdq)
			fi
		fi
	fi
else
	# just downloads packages
	# it doesn't install them
	if [ -x "$(command -v pacman)" ];
	then
		echo Pakete werden heruntergeladen
		sudo pacman -Syuw --needed --noconfirm
	fi
fi

