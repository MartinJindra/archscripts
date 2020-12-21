#!/bin/bash
# save current week day 
day=$(date '+%u')
# if today is Friday then update
# if not just cache the updates
if [ $day == 5 ]; then
	read -p 'Want to update the system? (y/N) ' choice_update
	choice_update=${choice_update,,}
	# update system if user chooses to
	if [[ $choice_update == 'y' ]];
	then
		echo "Its $(date +"%A"), time to update"
		# use yay to upgrade packages if installed
		if command -V yay &> /dev/null;
		then
			echo Updating Packages
			yay -Syu
		# use pamac to upgrade packages if installed
		elif command -V pamac &> /dev/null;
		then
			echo Updating Packages
			sudo pamac update
		# use trizen to upgrade packages if installed
		elif command -V trizen &> /dev/null;
		then
			echo Updating Packages
			trizen -Syu
		# use pacman to upgrade packages if installed
		elif ! command -V pacman &> /dev/null;
		then
			echo Updating Packages
			sudo pacman -Syu
		fi
		# update flatpaks if installed
		if ! command -V flatpak &> /dev/null;
		then
			echo Updating Flatpaks
			flatpak update
		fi
		# update snaps if installed
		if ! command -V snap &> /dev/null;
		then
			echo Updating Snaps
			snap refresh
		fi
		# clear packages if paccache is installed
		if command -V paccache &> /dev/null;
		then
			paccache -d
			read -p 'Want to clean pacman cache? (y/N) ' choice_cache
			choice_cache=${choice_cache,,}
			if [[ $choice_cache == 'y' ]]; 
			then
				paccache -r
			fi
		fi
		# clear unused packages if yay is installed
		if command -V yay &> /dev/null;
		then
			read -p 'Want to removing unused dependencies? (y/N) ' choice_dep
			choice_dep=${choice_dep,,}
			if [[ choice_dep == 'y' ]];
			then	
				yay -Yc
			fi
		fi
		echo "Packages to clean:"
		pacman -Qtdq
		read -p 'Want to remove orphaned packages? (y/N) ' choice_orphend
		choice_orphend=${choice_orphend,,}	
		if [[ $choice_orphend == 'y' ]];
		then
			sudo pacman -Rsn $(pacman -Qtdq)
		fi
	fi
else
	# just downloads packages
	# it doesn't install them
	echo Pakete werden heruntergeladen
	sudo pacman -Syuw --needed --noconfirm
fi
