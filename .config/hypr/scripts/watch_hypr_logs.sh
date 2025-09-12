#!/usr/bin/env sh

watch -n 0.1 "cat "$XDG_RUNTIME_DIR/hypr/$(echo $HYPRLAND_INSTANCE_SIGNATURE)/hyprland.log" | grep -v "efresh" | grep "rule" | tail -n 40"
