#-My rice deploy script, runs after you have your programs setup
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
	cp $SRC/.emacs $HOME
	cp $SRC/.xinitrc $HOME
	cp $SRC/.Xresources $HOME
	cp $SRC/.tmux.conf $HOME
	cp $SRC/.gitconfig $HOME

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

setup_hosts()
{
	echo "# Static table lookup for hostnames." >> /etc/hosts
	echo "# See hosts(5) for details." >> /etc/hosts
	echo "127.0.0.1	localhost" >> /etc/hosts
	echo "::1		localhost" >> /etc/hosts
	echo "127.0.1.1	main.localdomain	main" >> /etc/hosts
	echo "138.68.42.117	mail.luccaaugusto.xyz" >> /etc/hosts
	echo "2604:a880:2:d0::54:a001	mail.luccaaugusto.xyz" >> /etc/hosts
}

install_pkg()
{
	sudo pacman --noconfirm --needed -S "$1" >/dev/null 2>&1
}

aur_install()
{
	$aurhelper -S --noconfirm "$1" >/dev/null 2>&1
}

install_nvim()
{
	install_pkg "quick-lint-js"
	aur_install "phpactor"
	npm i -g bash-language-server
	npm i-g typescript typescript-language-server
	npm i -g vscode-langservers-extracted
	pip install python-lsp-server
	gem install rubocop
	gem install --user-install solargraph
	npm install -g @olrtg/emmet-language-server
	install_pkg neovim
}

install_loop()
{
	install_pkg npm
	install_pkg gem
	install_nvim
}

if [ "$(basename $0)" == "bash" ]; then
	echo "Please run the script with ./deploy.sh not sh deploy.sh"
else
	synchome
	user_cron_jobs
	setup_hosts
	sudo systemctl enable tlp.service
	sudo su && root_cron_jobs
fi
