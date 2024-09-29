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

# docker data-root to /home so it won't fill up my root partition with images
setup_docker_data_dir()
{
	sudo mkdir /home/docker-data-dir
	[ -d /etc/docker ] || sudo mkdir /etc/docker
	{
		echo "{"
		echo '    "data-root": "/home/docker-data-dir"'
		echo "}"
	} | sudo tee /etc/docker/daemon.json
}

# Cronjobs for low battery warning and log the time i spend on computer.
user_cron_jobs()
{
	(crontab -l ; echo "*/2 * * * * ~/.local/bin/batsinal >/dev/null 2>&1") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
	(crontab -l ; echo "* * * * * ~/.local/bin/datelog >/dev/null 2>&1	") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
}

setup_hosts()
{
	hostname="$(cat /etc/hostname)"
	{
		echo "# Static table lookup for hostnames."
		echo "# See hosts(5) for details."
		echo "127.0.0.1	localhost"
		echo "::1		localhost"
		echo "127.0.1.1	$hostname.localdomain	$hostname"
		echo "138.68.42.117	mail.luccaaugusto.xyz"
		echo "2604:a880:2:d0::54:a001	mail.luccaaugusto.xyz"
	} >> /etc/hosts
}

setup_groups()
{
	sudo groupadd uinput
	sudo usermod -aG input "$USER"
	sudo usermod -aG uinput "$USER"
}

enable_fingerprint()
{
	for finger in {left,right}-index-finger; do fprintd-enroll -f "$finger" "$USER"; done

	{
		sudo echo "#%PAM-1.0"
		sudo echo ""
		sudo echo "auth      sufficient pam_fprintd.so"
		sudo echo "auth      include   system-login"
		sudo echo "account   include   system-login"
		sudo echo "password  include   system-login"
		sudo echo "session   include   system-login"
	} > /etc/pam.d/system-local-login

	{
		sudo echo "#%PAM-1.0"
		sudo echo ""
		sudo echo "auth       sufficient   pam_unix.so try_first_pass likeauth nullok"
		sudo echo "auth       sufficient   pam_fprintd.so"
		sudo echo "auth       include      login"
		sudo echo "account    include      login"
		sudo echo "password   include      login"
		sudo echo "session    include      login"
	} > /etc/pam.d/ly
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

install_picom()
{
	git clone https://github.com/jonaburg/picom || return
	cd picom || return
	meson --buildtype=release . build
	ninja -C build
	sudo ninja -C build install
	cd ..
	rm -rf picom/
}

install_eww()
{
	git clone https://github.com/elkowar/eww || return
	cd eww || return

	# eww for X
	cargo build --release --no-default-features --features x11
	chmod +x target/release/eww
	[ -d ~/.local/bin/vendor ] || mkdir -p ~/.local/bin/vendor
	cp target/release/eww ~/.local/bin/vendor/xeww

	# eww for wayland
	cargo build --release --no-default-features --features=wayland
	chmod +x target/release/eww
	[ -d ~/.local/bin/vendor ] || mkdir -p ~/.local/bin/vendor
	cp target/release/eww ~/.local/bin/vendor/weww

	cd ../../..
	rm -rf eww/
}

install_kanata()
{
	git clone https://github.com/jtroo/kanata
	cd kanata || return
	cargo build
	[ -d ~/.local/bin/vendor ] || mkdir -p ~/.local/bin/vendor
	chmod +x target/debug/kanata
	cp target/debug/kanata ~/.local/bin/vendor/
	cd ../
	rm -rf kanata/
}

if [ ! "$(basename "$0")" == "deploy.sh" ]; then
	echo "Please run the script with ./deploy.sh not sh deploy.sh"
elif [ "$EUID" = 0 ]; then
	echo "Do not run as root"
else
	./deploy_dotfiles.sh
	setup_hosts
	setup_groups
	install_installers
	install_nvim
	install_loop
	install_picom
	install_kanata
	install_eww
	systemctl enable tlp.service
	systemctl --user enable kanata.service
	user_cron_jobs
	enable_fingerprint
	enable_sudo_for_wheel
	setup_docker_data_dir
fi
