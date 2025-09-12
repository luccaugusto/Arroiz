#!/bin/sh

if [ -f /tmp/current_layout ]
then
	current=$(cat /tmp/current_layout)
else
	current=$(hyprctl getoption general:layout | head -n 1)
fi

case "$current" in
	*master*)
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
esac
