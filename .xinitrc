#!/bin/bash

[ -f ~/.xprofile ] && . ~/.xprofile
[ -f ~/.Xresources ] && xrdb .Xresources

exec bspwm
