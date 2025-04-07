#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, and pipeline failures
trap 'echo "Error occurred at line $LINENO"' ERR

#-My rice deploy script, runs after you have your programs setup
#-Maybe i will write my own arch bootstrap script one day but
#-for now this script just sets up things specific to my setup.

log() {
	local level=$1
	shift
	echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$level] $*"
}


# configure pacman
enable_multilib()
{
	{
		echo "[multilib]"
		echo "Include = /etc/pacman.d/mirrorlist"
	} | sudo tee >> "/etc/pacman.conf"
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
# and limit total disk usage
setup_docker()
{
	# Check if docker-data-dir already exists
	[ ! -d /home/docker-data-dir ] && sudo mkdir /home/docker-data-dir

	# Check if source file exists before copying
	if [ -f etc/docker/daemon.json ]; then
		sudo mkdir -p /etc/docker
		sudo cp etc/docker/daemon.json /etc/docker/daemon.json
	else
		log "ERROR" "etc/docker/daemon.json not found"
		return 1
	fi
}

# Trackpad gestures
setup_trackpad_gestures()
{
	libinput-gestures-setup autostart start

	sudo cp etc/X11/xorg.conf.d/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
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
	cat etc/hosts | sed "s/{{hostname}}/$hostname/g" | sudo tee /etc/hosts
}

setup_groups()
{
	sudo groupadd uinput 2>/dev/null || true  # Don't fail if group exists
	sudo usermod -aG input,uinput,docker,wheel "$USER"
}

enable_fingerprint()
{
	install_pkg fprintd

	for finger in {left,right}-index-finger
	do
		fprintd-enroll -f "$finger" "$USER"
	done

	sudo systemctl enable fprintd.service

	{
		echo "#%PAM-1.0"
		echo ""
		echo "auth      sufficient pam_fprintd.so"
		echo "auth      include   system-login"
		echo "account   include   system-login"
		echo "password  include   system-login"
		echo "session   include   system-login"
	} | sudo tee > /etc/pam.d/system-local-login

	{
		echo "#%PAM-1.0"
		echo ""
		echo "auth       sufficient   pam_unix.so try_first_pass likeauth nullok"
		echo "auth       sufficient   pam_fprintd.so"
		echo "auth       include      login"
		echo "account    include      login"
		echo "password   include      login"
		echo "session    include      login"
	} | sudo tee> /etc/pam.d/ly
}

install_pkg()
{
	if ! sudo pacman --noconfirm --needed -S "$1"; then
		log "ERROR" "Failed to install package: $1"
		return 1
	fi
}

aur_install()
{
	if ! sudo -u "$USER" yay -S --noconfirm "$1"; then
		log "ERROR" "Failed to install AUR package: $1"
		return 1
	fi
}

install_nvim()
{
	aur_install "quick-lint-js"
	aur_install "phpactor"
	aur_install "eslint"
	aur_install "basedpyright"
	sudo npm i -g bash-language-server
	sudo npm i -g typescript typescript-language-server
	sudo npm i -g vscode-langservers-extracted
	aur_install python-lsp-server
	gem install --user-install rubocop
	gem install --user-install solargraph
	sudo npm install -g @olrtg/emmet-language-server
	sudo yarn add global yaml-language-server
	install_pkg neovim
}

install_yay()
{
	git clone https://aur.archlinux.org/yay.git
	pushd yay || return
	makepkg -si
	popd || return
	rm -rf yay
}

install_installers()
{
	log "INFO" "INSTALLING INSTALLERS:"
	log "INFO" "[1/7] enabling multilib"
	enable_multilib
	log "INFO" "[2/7] updating pacman and keyring"
	sudo pacman -Sy
	sudo pacman -Sy archlinux-keyring
	log "INFO" "[3/7] installing npm"
	install_pkg npm
	log "INFO" "[3/7] installing yarn"
	sudo npm i -g yarn
	log "INFO" "[5/7] installing ruby and ruby gems"
	install_pkg ruby
	log "INFO" "[6/7] installing pip"
	install_pkg python-pip
	log "INFO" "[7/7] installing yay"
	install_yay
	log "INFO" "INSTALLERS INSTALLED"
}

install_loop()
{
	log "INFO" "INSTALLING PACKAGES FROM PROGS LIST"
	pkg_count="$(wc -l < progs)"
	current_pkg=1

	while IFS= read -r pkg
	do
		log "INFO" "Installing $pkg [$current_pkg/$pkg_count]"
		install_pkg "$pkg"
		current_pkg=$((current_pkg + 1))
	done < progs
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

	systemctl --user enable kanata.service
}

maybe_enable_fingerprint() {
	answered=""
	while [ -z "$answered" ]; do
		read -rp "Do you want to enable fingerprint authentication? (yes/no): " answer
		case ${answer,,} in  # ${answer,,} converts to lowercase
			yes|y)
				enable_fingerprint
				answered="yes"
				;;
			no|n)
				log "INFO" "Fingerprint authentication not enabled."
				answered="no"
				;;
			*)
				echo "Please answer yes or no."
				;;
		esac
	done
}

enable_services()
{
	log "INFO" "Enabling services"
	log "INFO" "Enabling tlp service"
	sudo systemctl enable tlp.service
	log "INFO" "Services enabled"
}

if [ ! "$(basename "$0")" == "deploy.sh" ]; then
	log "ERROR" "Please run the script with ./deploy.sh not sh deploy.sh"
elif [ "$EUID" = 0 ]; then
	log "ERROR" "Do not run as root"
else
	./deploy_dotfiles.sh
	setup_hosts
	setup_groups
	install_installers
	install_nvim
	install_loop
	install_kanata
	install_eww
	enable_services
	user_cron_jobs
	maybe_enable_fingerprint
	enable_sudo_for_wheel
	enable_no_sudo_pacman_sy
	setup_trackpad_gestures
	setup_docker
	echo ""
	echo "Done! Enjoy your new arch install!"
	echo "Reboot for glory"
	echo "Reboot now? (y/n)"
	read -r answer
	case ${answer,,} in  # ${answer,,} converts to lowercase
		y*) reboot
		;;
	esac
fi
