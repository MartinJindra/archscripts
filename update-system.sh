#!/bin/bash
! [[ -x "$(command -v checkupdates)" ]] && echo "required package pacman-contrib is not installed" && exit 1

# save current week day
day=$(date '+%u')

echo "Checking for updates ..."
upgradable=$(checkupdates | wc -l)

packages() {

    if [[ "$upgradable" -eq 0 ]]; then echo "There are currently no package updates."; return
    else echo "$upgradable updates available." && read -rp "update the system? (y/N) " choice_update; fi
    if [[ ${choice_update,,} != 'y' ]]; then return; fi

    # update system if user chooses to
    echo "It's $(date +"%A"), time to update"

    # use paru to upgrade packages if paru is installed
    if [ -x "$(command -v paru)" ]; then echo "Updating Packages ..." && paru -Syu;

    # use yay to upgrade packages if yay is installed
    elif [ -x "$(command -v yay)" ]; then echo "Updating Packages ..." && yay -Syu;

    # use pamac to upgrade packages if pamac is installed
    elif [ -x "$(command -v pamac)" ]; then echo "Updating Packages ..." && sudo pamac update -a;

    # use trizen to upgrade packages if trizen is installed
    elif [ -x "$(command -v trizen)" ]; then echo "Updating Packages ..." && trizen -Syu;

    # use pacman to upgrade packages
    else echo "Updating Packages ..." && sudo pacman -Syu; fi

    # update flatpaks if flatpak is installed
    [ -x "$(command -v flatpak)" ] && echo "Updating Flatpaks" && flatpak update

    # update snaps if snap is installed
    [ -x "$(command -v snap)" ] && echo "Updating Snaps" && sudo snap refresh
}

cache() {
    # clear packages if paccache is installed
    [ -x "$(command -v paccache)" ] && paccache -d || return

    read -rp 'Clean pacman cache? (y/N) ' choice_cache
    [[ ${choice_cache,,} == 'y' ]] && sudo paccache -r

    # checks if orphan packages exists
    if [[ "$(pacman -Qtdq | wc -l)" -eq 0 ]]; then echo "No orphans packages were found";
    else
        read -rp 'Want to remove orphaned packages? (y/N) ' choice_orphend
        [[ ${choice_orphend,,} == 'y' ]] && sudo pacman -Rsn "$(pacman -Qtdq)"
    fi
}

# if today is Friday then update
# if not just cache the updates
if [ "$day" == 5 ];
then
    packages
    cache
else
    # just downloads packages
    # it doesn't install them
    [[ -x "$(command -v pacman)" ]] && [[ "$upgradable" -gt 0 ]] && (
        echo "packages are being downloaded"
        sudo pacman -Syuw --needed --noconfirm
    )
fi

