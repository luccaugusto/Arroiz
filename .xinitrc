#!/bin/bash

[ -f ~/.xprofile ] && . ~/.xprofile

#turn numlock on
numlockx

#exec bspwm -c ~/.config/bspwm/bspwmrc
exec i3
