# RICE
My Arch linux ricing.
 
## How to use this
- clone the repo and run the synchome script, located on .scripts folder
- install all programs from essentials.md and progs.md
- run mkfontdir to update fonts
- create crontab with scripts cronbat and datelog
- reboot

progs.txt is a list with all programs i have installed, run "cat progs.txt | sudo pacman -S -" to install all of them at once

## Config files you will find here:
+ .vimrc
+ .Xresources
+ .Xauthority
+ .scripts/
	* aNote
	* backup
	* cronbat
	* crontog
	* datelog
	* extract
	* i3batwarn
	* linkhandler
	* lockscreen
	* shownotes
	* syncgit
	* synchome
	* toggletouchpad
+ .bashrc
+ .bash\_aliases
+ .bash\_profile
+ .vim
+ .xinitrc
+ .config/
	* polybar
	* i3
	* qutebrowser
	* ranger
