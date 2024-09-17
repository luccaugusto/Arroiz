# My usefull scripts

A brief explanation of each script can be found bellow.

<!--startscripts-->
### batsinal
Notifies via notify-send when battery is bellow 10%,
also beeps if $BEEP is defined and the script beep exists
if there is more than 1 battery, the total percentage is the
average of the sum of the capacity of each battery

### batstatus
Echos to stdout the current capacity of each battery.
if util is passed as a argument, echoes the percent
of util capacity in relation to the original capacity.

### beep
Play a beep sound

### change_remote_url


### ch_wall
Shows me all files in my wallpaper repository and i can choose one to be my new wallpaper

### compress_time
Convert all the date files in my .time directory to a single csv file.
Drastically reduce the number of files in that folder

### compress_video


### css_inutil


### datelog
I have a cronjob run this every minute to log time spend on the computer in
`~/.time` for each day. Gives estimate of daily NEEThood.

### date_operations
Operations with date and time

### dexec
 Allows to execute a command in a running container selecting it by name

### dmen
dmenu_run with pywal colors

### dwmbar
Simple bar script for DWM

### extract
A general, all-purpose extraction script.
Default behavior: Extract archive into new directory
Behavior with `-c` option: Extract contents into current directory

### ff
Fuzzy finds files

### fonttools


### gcheckout
 git checkout wrapper so i always pull when checking out a branch

### gcom
Git pre commit hook, checks if there are any FIXME tags in files i`m commiting,
if there is any, abort the commit and force me to fix it

### homebackup
Backup important directories to directory specified.
 Exits if no directory was specified.
 Exits if the specified directory does not have space for backup
 run `backup` for help

### interactive_update


### jogar


### keyboard_layout
Sets my keyboard layout to en_us and pt_br, also remaps Caps to Ctrl

### launch_eww_bars


### launch_polybar
Launches polybar. Works for multiple monitors

### listman
List manuals for the installed programs

### lockscreen
Locks the screen, pauses songs and videos.

### mergebranch
 script so i don`t mess up any branches

### mktimelapse


### monitors
Helper for dealing with multiple monitors, works via dmenu

### mount_phone
Helper to mount android phones, works with dmenu

### mplayer
Starts mpd and opens ncmpcpp

### must_update
Warns me via notify-send when i should update (LIMIT + packages needing update).

### naoesquece
Script that controls a calendar with emails
New appointments can be created by sending an email with an add command
Can notify via email your close appointments

### newbranch
Cretes a new branch always updated from another branch.
Prompts with dmenu for the branch type: feature, bugfix or hotfix. If it is a hotfix branch, create it from master.

### plug


### powermenu
Shutdown, reboot or logout via rofi

### README.md


### rebasedev
 script so i don`t mess up any branches

### rec_webcam
Records my webcam

### reloadbar
kills current dwmbar so it reloads

### samedir
From Luke Smith`s dotfiles
Open a terminal window in the same directory as the currently active window.

### scratchpad
Scratchpad terminal for bspwm

### screencast
Records my screen to a file in ~/

### script_docs
Grabs the doc comments of all scripts in .scripts folder and output them in MD
to the README.md file in my rice repository.
doc comments are lines beggining with #-

### selectimgs


### set-alacritty-colors


### showtime
Show how long i have been using the computer.
-b argument show since when its counting.

### sound_control
Wrapper for controlling volume, makes bluetooth and computer volume the same

### sound_manager


### startup_progs
Runs programs after wm is launched. Basically an extension for bash_profile in this setup.
Also avoids any errors that might occur if a program runs before another one.
Example: if transmission runs before bspwm rules are set it will open on workspace 1

### syncsuck
updates my Suckless repository
Generates diff files for the changes i made automatically

### theme_manager


### toggle_redshift
Turns redshift on and off

### toggle_sidebar


### toggle_status_bar


### toggle_touchpad
Script to toggle the touchpad on/off

### toggle_wifi


### trata_img
 Trata imagens para subir pro meu portfolio
 Comprime para jpg com $QUALIDADE de qualidade e $ESCALA do tamanho,
 esses valores sao adequados para a resolução das minhas imagens (4096x4096 300dpi ou 2480x3508 300dpi),
 podem não ser adequados para outras resoluções

### treesize
Shows directories size in human readable format
Got it from vitor mansur, thanks

### update
 update all system packages,
 making sure to update the keyring first

### vendor/eww


### vendor/kanata


### vendor/protonmail


### wacontrols
Helper for manipulating wacom devices
only rotates it right now
<!--endscripts-->

