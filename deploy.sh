#-My rice deploy script, runs after https://larbs.xyz/larbs.sh.
#-Maybe i will write my own one day but now this script just sets up things specific to my setup.

# Have a cronjob to check for updates every hour
root_cron_jobs()
{
	(crontab -l ; echo "0 * * * * pacman -Sy >/dev/null") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
}

# Cronjobs for low battery warning and log the time i spend on computer.
user_cron_jobs()
{
	(crontab -l ; echo "*/2 * * * * ~/.local/bin/batsinal >/dev/null 2>&1") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
	(crontab -l ; echo "* * * * * ~/.local/bin/datelog >/dev/null 2>&1	") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
}

# Copies my scripts from the repository to my home directory
synchome()
{
	SRC="$(dirname $0)"
	CONFIG=$HOME/.config
	echo "copying ~/ files from $SRC"
	cp $SRC/.aliases $HOME
	cp $SRC/.bash_profile $HOME
	cp $SRC/.bashrc $HOME
	cp $SRC/.vimrc $HOME
	cp $SRC/.xinitrc $HOME
	cp $SRC/.xprofile $HOME
	cp $SRC/.Xresources $HOME
	cp $SRC/.tmux.conf $HOME

	echo "copying ~/ directories from $SRC"
	cp -r $SRC/.vim $HOME
	cp -r $SRC/.vimgolf $HOME
	cp -r $SRC/.time $HOME
	cp -r $SRC/.local/bin $HOME/.local/

	echo "copying .config files"
	cp $SRC/.config/kritadisplayrc $HOME/.config
	cp $SRC/.config/kritarc $HOME/.config
	cp $SRC/.config/kritashortcutsrc $HOME/.config
	cp -r $SRC/.config/i3 $HOME/.config
	cp -r $SRC/.config/i3status $HOME/.config
	cp -r $SRC/.config/bspwm $HOME/.config
	cp -r $SRC/.config/polybar $HOME/.config
	cp -r $SRC/.config/pulse $HOME/.config
	cp -r $SRC/.config/ranger $HOME/.config
	cp -r $SRC/.config/redshift $HOME/.config
	cp -r $SRC/.config/sxhkd $HOME/.config
	cp -r $SRC/.config/transmission $HOME/.config
	cp -r $SRC/.config/wal $HOME/.config
	cp -r $SRC/.config/mpd $HOME/.config
	cp -r $SRC/.config/ncmpcpp $HOME/.config
}

if [ "$(basename $0)" == "bash" ]; then
	echo "Please run the script with ./deploy.sh not sh deploy.sh"
else
	sudo su && root_cron_jobs()
	su $USER && user_cron_jobs()
	synchome
fi
