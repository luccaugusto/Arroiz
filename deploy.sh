#!/bin/bash
#-My rice deploy script, runs after you have your programs setup
#-Maybe i will write my own arch bootstrap script one day but
#-for now this script just sets up things specific to my setup.

# configure pacman
enable_multilib()
{
	{
		echo "[multilib]"
		echo "Include = /etc/pacman.d/mirrorlist"
	} >> "/etc/pacman.conf"
}

enable_sudo_for_wheel()
{
	echo '%wheel ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo
}

enable_no_sudo_pacman_sy()
{
	echo "%wheel ALL=(ALL) NOPASSWD: /usr/bin/pacman -Sy" | sudo EDITOR='tee -a' visudo
}


# Cronjobs for low battery warning and log the time i spend on computer.
# Have a cronjob to check for package updates every hour
user_cron_jobs()
{
	(crontab -l ; echo "*/2 * * * * ~/.local/bin/batsinal >/dev/null 2>&1") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
	(crontab -l ; echo "* * * * * ~/.local/bin/datelog >/dev/null 2>&1	") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
	(crontab -l ; echo "0 * * * * pacman -Sy >/dev/null") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
}

setup_hosts()
{
	{
		echo "# Static table lookup for hostnames."
		echo "# See hosts(5) for details."
		echo "127.0.0.1	localhost"
		echo "::1		localhost"
		echo "127.0.1.1	main.localdomain	main"
		echo "138.68.42.117	mail.luccaaugusto.xyz"
		echo "2604:a880:2:d0::54:a001	mail.luccaaugusto.xyz"
	} >> /etc/hosts
}

install_pkg()
{
	pacman --noconfirm --needed -S "$1" >/dev/null 2>&1
}

aur_install()
{
	sudo -u "$USER" yay -S --noconfirm "$1" >/dev/null 2>&1
}

install_nvim()
{
	aur_install "quick-lint-js"
	aur_install "phpactor"
	aur_install "eslint"
	aur_install "basedpyright"
	npm i -g bash-language-server
	npm i -g typescript typescript-language-server
	npm i -g vscode-langservers-extracted
	aur_install python-lsp-server
	gem install --user-install rubocop
	gem install --user-install solargraph
	npm install -g @olrtg/emmet-language-server
	yarn global add yaml-language-server
	install_pkg neovim
}

install_yay()
{
	git clone https://aur.archlinux.org/yay.git
	pushd yay || return
	sudo makepkg -si
	popd || return
	rm -rf yay
}

install_installers()
{
	echo "INSTALLING INSTALLERS:"
	echo "[1/6] enabling multilib"
	enable_multilib
	echo "[2/6] updating pacman and keyring"
	pacman -Sy
	pacman -Sy archlinux-keyring
	echo "[3/6] installing npm"
	install_pkg npm
	echo "[4/6] installing ruby and ruby gems"
	install_pkg ruby
	echo "[5/6] installing pip"
	install_pkg python-pip
	echo "[6/6] installing yay"
	install_yay
	echo "INSTALLERS INSTALLED"
}

install_loop()
{
	echo "INSTALLING PACKAGES FROM PROGS LIST"
	pkg_count="$(wc -l < progs)"
	current_pkg=1

	while IFS= read -r pkg
	do
		echo "Installing $pkg [$current_pkg/$pkg_count]"
		install_pkg "$pkg"
		current_pkg=$((current_pkg + 1))
	done < progs
}

if [ ! "$(basename "$0")" == "deploy.sh" ]; then
	echo "Please run the script with ./deploy.sh not sh deploy.sh"
else
	./deploy_dotfiles.sh
	setup_hosts
	install_installers
	install_nvim
	install_loop
	systemctl enable tlp.service
	user_cron_jobs
fi
