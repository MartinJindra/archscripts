#!/bin/bash
! [[ -x "$(command -v checkupdates)" ]] && echo "Install package pacman-contrib" && exit 1

# save current week day
day=$(date '+%u')
# if today is Friday then update
# if not just cache the updates
! [ "$day" == 5 ] && exit

packages() {
    # use yay to upgrade packages if yay is installed
    [ -x "$(command -v yay)" ] && echo "Updating Packages" && yay -Syu && exit
		
    # use paru to upgrade packages if paru is installed
    [ -x "$(command -v paru)" ] && echo "Updating Packages" && paru -Syu && exit

    # use pamac to upgrade packages if pamac is installed
    [ -x "$(command -v pamac)" ] && echo "Updating Packages" && sudo pamac update -a && exit

    # use trizen to upgrade packages if trizen is installed
    [ -x "$(command -v trizen)" ] && echo "Updating Packages" && trizen -Syu && exit
		
    # use pacman to upgrade packages
    echo "Updating Packages" && sudo pacman -Syu

	# update flatpaks if flatpak is installed
    [ -x "$(command -v flatpak)" ] && echo Updating Flatpaks && flatpak update

	# update snaps if snap is installed
	[ -x "$(command -v snap)" ] && echo "Updating Snaps" && sudo snap refresh
}

cache() {
    # clear packages if paccache is installed
    [ -x "$(command -v paccache)" ] && paccache -d || return

    read -rp 'Want to clean pacman cache? (y/N) ' choice_cache
    [[ ${choice_cache,,} == 'y' ]] && sudo paccache -r

	# checks if orphan packages exists
	[[ "$(pacman -Qtdq | wc -l)" -eq 0 ]] && echo "No orphans packages were found" || (
        echo "Packages to clean:"
		read -rp 'Want to remove orphaned packages? (y/N) ' choice_orphend
		[[ ${choice_orphend,,} == 'y' ]] && sudo pacman -Rsn $(pacman -Qtdq)
    )
}

read -rp "$(checkupdates | wc -l) are ready to be upgraded. Want to update the system? (y/N) " choice_update &&
    [[ ${choice_update,,} == 'y' ]] &&
    (
            # update system if user chooses to
            echo "Its $(date +"%A"), time to update" && packages
        )

cache

# just downloads packages
# it doesn't install them
[ -x "$(command -v pacman)" ] && (
    echo "Pakete werden heruntergeladen"
    sudo pacman -Syuw --needed --noconfirm
)
