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
	CONFIG=$CONFIG/
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
	mkdir $CONFIG
	cp $SRC/.config/kritadisplayrc $CONFIG
	cp $SRC/.config/kritarc $CONFIG
	cp $SRC/.config/kritashortcutsrc $CONFIG
	cp -r $SRC/.config/i3 $CONFIG
	cp -r $SRC/.config/i3status $CONFIG
	cp -r $SRC/.config/bspwm $CONFIG
	cp -r $SRC/.config/polybar $CONFIG
	cp -r $SRC/.config/pulse $CONFIG
	cp -r $SRC/.config/ranger $CONFIG
	cp -r $SRC/.config/redshift $CONFIG
	cp -r $SRC/.config/sxhkd $CONFIG
	cp -r $SRC/.config/transmission $CONFIG
	cp -r $SRC/.config/wal $CONFIG
	cp -r $SRC/.config/mpd $CONFIG
	cp -r $SRC/.config/ncmpcpp $CONFIG
}

if [ "$(basename $0)" == "bash" ]; then
	echo "Please run the script with ./deploy.sh not sh deploy.sh"
else
	#synchome
	user_cron_jobs
	sudo su && root_cron_jobs
fi
