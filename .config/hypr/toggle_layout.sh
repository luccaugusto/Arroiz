#!/bin/sh

current=$(hyprctl getoption general:layout | head -n 1)

case "$current" in
	*master*)
 		hyprctl keyword general:layout "dwindle"
		;;
	*dwindle*)
 		hyprctl keyword general:layout "master"
		;;
esac
