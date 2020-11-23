# archscripts

**archscripts** is my project to make archlinux management a little bit easier.

## update-arch

**update-arch** is a script that can be used to update archlinux. It's goal is that the system is only updated once per week to reduce the temptation of frequent updates.

If executed and it is not Sunday it will just cache the new packages with `pacman -Syuw`. When it is the end of week then it will update the whole system this includes updates for

+ packages from the synced repositories
+ packages from the AUR using `yay`, `trizen` or `pamac`
+ snaps
+ flatpaks

And in the end, it will ask the user

1. if the pacman cache should be cleaned using `paccache -r`
2. if unused dependencies should be removed using `yay -Yc`
3. if orphaned packages should be removed using `pacman -Qtdq`

## update-mirrors

**update-mirrors** will updated the `/etc/pacman.d/mirrorlist` for mirrors.

It should be executed with `sudo` and if done so, it will asks how many mirrors it should write to `/etc/pacman.d/mirrorlist`. It will test all mirrors from the standard configuration, these configs are

+ https mirrors
+ IP-Version 4
+ active mirror status

**WARNING: Before using the update-mirror script please backup your `/etc/pacman.d/mirrorlist` with `sudo cp /etc/pacman.d/mirrorlist.bak`, because the script will overwrite the file.**
