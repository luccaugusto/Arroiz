#!/bin/sh
other_screen=$(xrandr | grep -w connected | grep -v eDP-1 | awk '{print $1}')

#2560x1600 or 1920x1200
xrandr --output eDP-1 --mode 1920x1200 --pos 0x0 --rotate normal --output "$other_screen" --primary --auto --pos 1920x60 --rotate normal --output DP-2 --off --output HDMI-1 --off
