#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
#if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 #for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  #[ -x "$f" ] && . "$f"
 #done
 #unset f
#fi

# Authentication agent
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

setup_workspace()
{
	# set up monitor layout if another monitor is present
	connected_monitors="$(xrandr -q | grep -w connected)"
	# no other monitors
	if [ "$(echo "$connected_monitors" | wc -l)" = 1 ]; then
		sh "$HOME/.screenlayout/1600by900.sh"
	# other monitors and docked
	elif [ "$(cat /sys/devices/platform/dock.0/docked)" = 1 ]; then
		if [ "$(echo "$connected_monitors" | wc -l)" = 2 ]; then
			sh "$HOME/.screenlayout/two-screens-docked.sh"
		fi
	# other monitors and not docked
	else
		case "$connected_monitors" in
			*HDMI*) sh "$HOME/.screenlayout/hdmi-left.sh";;
			*DP-2*) sh "$HOME/.screenlayout/screen-stack.sh";;
		esac
	fi

	# set trackpoint speed
	xinput set-prop 15 "libinput Accel Speed" 0.8
}

#exec awesome
#exec bspwm
#exec dwm
