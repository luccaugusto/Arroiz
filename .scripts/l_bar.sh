#!/bin/bash

separator='|'

keyboard_layout()
{

	#keyboard layout
	#layout=$(setxkbmap -query | grep layout | awk '{ print $2 }')
	layout=$(xset -q | grep LED | awk '{ print $10 }')
	case "$layout" in
		"00000000" | "00000001" | "00000002") layout="us";;
		"00001000" | "00001001" | "00001002") layout="br";;
	esac

	echo "$layout $separator"
}


backlight()
{
	#calculates the brightness in percent
	brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
	max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
	#uses python3 to get decimals
	l=$(echo "print($brightness/$max*100)" | python3)
	light=" ${l%.*}"
	echo "$light% $separator"
}
	
volume()
{
	#volume
	vol="$(pamixer --get-volume-human)"
	if [ "$vol" == "muted" ];then
		vol=" $vol"
	else
		vol=" $vol"
	fi
	echo "$vol $separator"
}

date_time()
{
	date '+%Y %b %d %I:%M%p'
}

wifi() {
	#wifi
	wifi=$(nmcli | grep ' connected' | awk '{for(i=2; i<= NF; i++) printf $i" "}')
	if [ -z "$wifi" ];then
		echo "Disconnected"
	else
		echo $(echo "$wifi" | sed 's/connected to//' )
	fi
}

ram()
{
	RAMSIZE=$(cat /proc/meminfo | grep MemTotal | awk '{print $2}')
	RAMFREE=$(cat /proc/meminfo | grep MemFree | awk '{print $2}')
	RAMUSED=$((RAMSIZE-RAMFREE)) 
	RAMPERC=$(python -c "print(round($RAMUSED/$RAMSIZE,2)*100,'%')")
	
	echo "RAM $RAMPERC used"
}

volume
backlight 
ram 
keyboard_layout 
batstatus 
date_time 
wifi
