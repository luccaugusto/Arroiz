#!/bin/sh

if [ -f /tmp/current_layout ]
then
	current=$(cat /tmp/current_layout)
else
	current=$(hyprctl getoption general:layout | head -n 1)
fi

direction=${1:-next}

if [ "$direction" = "next" ]; then
	case "$current" in
		*scrolling*)
			hyprctl keyword general:layout "master"
			hyprctl dispatch layoutmsg "orientationleft"
			echo "master" > /tmp/current_layout
			;;
		*master*)
			hyprctl keyword general:layout "dwindle"
			echo "dwindle" > /tmp/current_layout
			;;
		*dwindle*)
			hyprctl keyword general:layout "master"
			hyprctl dispatch layoutmsg "orientationtop"
			echo "orientationtop" > /tmp/current_layout
			;;
		*orientationtop*)
			hyprctl keyword general:layout "scrolling"
			hyprctl dispatch layoutmsg "orientationleft"
			echo "scrolling" > /tmp/current_layout
			;;
	esac
elif [ "$direction" = "prev" ]; then
	case "$current" in
		*scrolling*)
			hyprctl keyword general:layout "master"
			hyprctl dispatch layoutmsg "orientationtop"
			echo "orientationtop" > /tmp/current_layout
			;;
		*orientationtop*)
			hyprctl keyword general:layout "dwindle"
			echo "dwindle" > /tmp/current_layout
			;;
		*dwindle*)
			hyprctl keyword general:layout "master"
			hyprctl dispatch layoutmsg "orientationleft"
			echo "master" > /tmp/current_layout
			;;
		*master*)
			hyprctl keyword general:layout "scrolling"
			hyprctl dispatch layoutmsg "orientationleft"
			echo "scrolling" > /tmp/current_layout
			;;
	esac

fi
