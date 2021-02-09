# archscripts

**archscripts** is my project to make archlinux management a little bit easier.

## update-arch

**update-system.sh** is a script that can be used to update archlinux. It's goal is that the system is only updated once per week to reduce the temptation of frequent updates.

If executed and it is not Friday it will just cache the new packages with `pacman -Syuw`. When it is the end of week then it will update the whole system this includes updates for

+ packages from the synced repositories
+ packages from the AUR using `yay`, `trizen` or `pamac`
+ snaps
+ flatpaks

And in the end, it will ask the user

1. if the pacman cache should be cleaned using `paccache -r`
2. if unused dependencies should be removed using `yay -Yc`
3. if orphaned packages should be removed using `pacman -Qtdq`

## update-mirrors

**update-mirrors.sh** will updated the `/etc/pacman.d/mirrorlist` for mirrors.

It should be executed with `sudo` and if done so, it will asks how many mirrors it should write to `/etc/pacman.d/mirrorlist`. It will test all mirrors from the default configuration, these configs are

+ https mirrors
+ IP-Version 4
+ active mirror status

### Add scripts to path
I generally prefer to use links to the scripts instead of copying them to `PATH`-directories.
```bash
chmod +x update-system.sh
chmod +x update-mirrors.sh
sudo ln -sf update-system.sh /usr/bin/update-system
sudo ln -sf update-mirrors.sh /usr/bin/update-mirrors
```

### Requirements

#### For `update-mirrors.sh`
Before executing the `update-mirror.sh` script please, insure that the package `pacman-contrib` is installed. To install the package, execute

```bash
sudo pacman -S --needed  pacman-contrib
```

#### For `update-system.sh`
The **update-arch.sh** script doesn't need any special dependecies. But a AUR-wrapper like [`yay`](https://github.com/Jguer/yay), [`trizen`](https://github.com/trizen/trizen) or [`pamac`](https://gitlab.manjaro.org/applications/pamac) would be useful to update AUR-packages.
To install them 
1. follow the links
2. clone one of these repositories with `git` 

     `git clone https://github.com/Jguer/yay.git`

     `git clone https://github.com/trizen/trizen.git`

     `git clone https://gitlab.manjaro.git/applications/pamac.git`
3. Then make a package and install it with 
    `makepkg -si`

