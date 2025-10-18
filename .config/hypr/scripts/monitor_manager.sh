#!/usr/bin/env sh

# quickly toggle between laptop-only, external-only, and all-monitors
# Usage: monitor-manager.sh [laptop|external|all]
# default is all

configure_monitor() {
	monitor_name="$1"

	# can't see shit in the auto resolution on my laptop screen, lol, too many pixels
	if [ "$monitor_name" = "eDP-1" ]; then
		resolution="1920x1200@120"
	else
		resolution="preferred"
	fi

	hyprctl keyword monitor "$monitor_name,$resolution,auto,1,bitdepth,e"
}

disable_monitor() {
	monitor_name="$1"
	hyprctl keyword monitor "$monitor_name,disable"
}

assign_workspaces() {
	monitor_name="$1"
	monitor_index="$2"

	start_ws=$((monitor_index * 10 + 1))
	end_ws=$((monitor_index * 10 + 10))

	for i in $(seq "$start_ws" "$end_ws"); do
		hyprctl keyword workspace "$i,monitor:$monitor_name"
	done
}

# Move all windows to the first 10 workspaces to prevent losing windows
# when switching monitor modes
move_windows_to_primary_workspaces() {
	clients=$(hyprctl -j clients | jq -r '.[] | "\(.address) \(.workspace.id)"')
	
	echo "$clients" | while read -r address workspace_id; do
		if [ "$workspace_id" -gt 10 ]; then
			target_ws=$(( ((workspace_id - 1) % 10) + 1 ))
			hyprctl dispatch movetoworkspacesilent "$target_ws,address:$address"
		fi
	done
}


mode="${1:-all}"

all_monitors=$(hyprctl -j monitors | jq -r '.[].name')
num_monitors=$(echo "$all_monitors" | wc -l)

laptop_monitor="eDP-1"

external_monitors=$(echo "$all_monitors" | grep -Ev "^eDP-[0-9]+$")
num_external=$(echo "$external_monitors" | grep -c .)

# Validation
case "$mode" in
	external)
		# Check if external monitors exist
		if [ "$num_external" -eq 0 ]; then
			echo "Error: No external monitors detected. Cannot use 'external' mode."
			exit 1
		fi
		;;
    all)
		;;
    laptop)
        ;;
	*)
		echo "Error: Invalid mode '$mode'"
		echo "Usage: monitor-manager.sh [laptop|external|all]"
		exit 1
		;;
esac

case "$mode" in
	laptop)
		# Move all windows to workspaces 1-10 before disabling monitors
		move_windows_to_primary_workspaces
		
		configure_monitor "$laptop_monitor"

		for monitor in $external_monitors; do
			disable_monitor "$monitor"
		done

		assign_workspaces "$laptop_monitor" 0
		primary_monitor="$laptop_monitor"
		;;

	external)
		disable_monitor "$laptop_monitor"

		monitor_index=0
		for monitor in $external_monitors; do
			configure_monitor "$monitor"
			assign_workspaces "$monitor" "$monitor_index"
			monitor_index=$((monitor_index + 1))
		done
		# Set first external monitor as primary
		primary_monitor=$(echo "$external_monitors" | head -n 1)
		;;

	all)
		# laptop first, then external monitors
		if [ -n "$laptop_monitor" ]; then
			ordered_monitors="$laptop_monitor"
			if [ -n "$external_monitors" ]; then
				ordered_monitors="$ordered_monitors $external_monitors"
			fi
		else
			ordered_monitors="$external_monitors"
		fi

		monitor_index=0
		for monitor in $ordered_monitors; do
			echo "configuring $monitor"
			configure_monitor "$monitor"
			assign_workspaces "$monitor" "$monitor_index"
			monitor_index=$((monitor_index + 1))
		done

		# Set first monitor (laptop if present) as primary
		primary_monitor=$(echo "$ordered_monitors" | head -n 1)
		;;
esac

# Add space for my bar
hyprctl keyword monitor ",addreserved,50,0,0,0"
echo "$primary_monitor" > ~/.config/hypr/primary_monitor
