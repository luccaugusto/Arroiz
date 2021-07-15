# My usefull scripts

A brief explanation of each script can be found bellow.

<!--startscripts-->
### README.md


### anote
Simple script for taking notes in the terminal.
Notes are saved in $NOTES_PATH directory or $HOME/.notes if $NOTES_PATH is not set
run `anote -h` for help

### backup
Backup important directories to directory specified.
 Exits if no directory was specified.
 Exits if the specified directory does not have space for backup
 run `backup` for help

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

### ch_wall
Shows me all files in my wallpaper repository and i can choose one to be my new wallpaper

### cheatsheet
Opens a terminal with a man document showing the
important system bindings and some general info

### data_hora
Operations with date and time

### datelog
I have a cronjob run this every minute to log time spend on the computer in
`~/.time` for each day. Gives estimate of daily NEEThood.

### discord_old


### dmen
dmenu_run with pywal colors

### dwarffortress
launches dwarffortress

### dwmbar
Simple bar script for DWM

### extract
A general, all-purpose extraction script.
Default behavior: Extract archive into new directory
Behavior with `-c` option: Extract contents into current directory

### freepacman


### gcheckout


### keyboard_layout
Sets my keyboard layout to en_us and pt_br

### launch_polybar
Launches polybar. Works for multiple monitors

### listman
List manuals for the installed programs

### lockscreen
Locks the screen, pauses songs and videos.

### mktimelapse


### monitors
Helper for dealing with multiple monitors, works via dmenu

### mount_phone
Helper to mount android phones, works with dmenu

### mplayer
Starts mpd and opens ncmpcpp

### must_update
Warns me via notify-send when i should update (LIMIT + packages needing update).

### newbranch
Basically an alias for creating a new branch on git always from develop

### powermenu
Shutdown or reboot via dmenu

### rebasedev
 nanvix script so i don`t mess up any branches

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

### set_colors
Set my system colors using pywal

### shownotes
Show all untagged notes as a notification via notify-send

### showtime
Show how long i have been using the computer.
-b argument show since when its counting.

### sound_control
Wrapper for controlling volume, makes bluetooth and computer volume the same

### startup_progs
runs programs after wm is setup
avoids any errors that might occur if a program runs before another one
Example: if transmission-gtk runs before bspwm rules are set it will open on workspace 1

### syncrice
Sync my rice repository
if a string is passed as a argument uses this string as a commit message

### syncsuck
updates my Suckless repository
Generates diff files for the changes i made automatically

### tibia
Launches tibia

### timer
Chess like timer
$1 is how long the first timer should run
$2 is how long the second timer should run

### toggle_redshift
Turns redshift on and off

### toggle_touchpad
Script to toggle the touchpad on/off

### trata_img
 Trata imagens para subir pro meu portfolio
 Comprime para jpg com $QUALIDADE de qualidade e $ESCALA do tamanho,
 esses valores sao adequados para a resolução das minhas imagens (4096x4096 300dpi ou 2480x3508 300dpi),
 podem não ser adequados para outras resoluções

### treesize
Shows directories size in human readable format
Got it from vitor mansur, thanks

### wacontrols
Helper for manipulating wacom devices
only rotates it right now

### work/README.md


### work/bate_ponto
Keeps track of the time i have been working.
Uses the -i sed GNU extension

### work/css_inutil.sh
lists all css rules that are not being used on current folder html files

### work/faltam
Work script, notifies how long till i have worked my shift

### work/init_wp
Starts services and programs for wordpress development.

### work/ta_na_hora_de_brincar
Counts how long i have been working and notifies me via notify-send
when its almost over.
Also notifies me if its getting close to the rush hour.

### work/tecuida
Reminds me to take a break
<!--endscripts-->

