# RICE

My arch linux ricing.
+ Bspwm or DWM (i3 config files kept because why not)
+ Bspwm has better multimonitor support.
+ DWM is suckless, simple and effective, but i haven't messed with it enough to get nice multimonitor support.
+ ST
+ Polybar (Really looking for a new panel to make the change, haven't found it yet)
+ Sxhkd
+ mpd + ncmpcpp
+ bash (Maybe zsh in the future)

Using pywal for all the system colors. (should i change to gruvbox?)

## Key Bindings
On bspwm all key bindings are handled by sxhkd. On dwm window manager specific actions are bind in config.h and generic key bindings such as opening a program are bind in sxhkd.

As it is extremelly hard to manually change the file to load or not load the bindings for bspwm or dwm on sxhkdrc the startup_progs script does it automattically. On the sxhkd directory, under the config directory, there are separate files for each wm and a common file called base. On startup the startup_progs dinamically creates sxhkdrc by running cat on the base file and the bindings file for the currently running wm.

## Colors
On the colors subject a important thing must be said. Pywal generates a colors-wal-dwm.h file that doesn't work for dwm, causing compile time errors.
On my set_colors script there is a part in which a colors-wal-dwm-real.h is created by duplicating the original file and sedding it to make it right.
Changing system colors without running this script won't change dwm colors.
The new file is stored in the same directory (~/.cache/wal), be careful when cleaning the cache.

## progs.txt
This file is a list of all the main programs i use, really simplifies the process of installing this rice on another system.
I still have to manually insert a program in this list everytime i download a relevant one, but i guess that's the way since my computer won't now what programs are relevant for me. 
Keeping the full list of installed programs (pacman -Qsomethingsomething) was messy and left many undesired programs.

## ~/ config files
+ .bash_aliases
+ .bash_profile
+ .bashrc
+ .vimrc
+ .xinitrc
+ .Xresources
+ .vim/ (folder)
+ .vimgolf/ (folder)
+ .time/ (folder to save time spent on pc)

## .scripts folder
Personal scripts folder, useful for the whole system

## .config folter
the .config folder includes the following configurations
+ kritadisplayrc $RICE/.config
+ kritarc $RICE/.config
+ kritashortcutsrc $RICE/.config
+ wall.jpg $RICE/.config
+ i3 
+ i3status
+ bspwm
+ polybar
+ pulse
+ ranger
+ redshift
+ sxhkd
+ transmission
+ wal
+ mpd
+ ncmpcpp

## Scrots

![gaps](scrot_gaps.png)
![gapless](scrot_gapless.png)
