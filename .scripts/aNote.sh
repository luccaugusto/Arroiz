#!/bin/bash

#Notes CRUD
#script for taking simple notes in the terminal

#TODO
#Check awk to format the strings to create notes and list notes
#Create add function
#Version controll Scripts

add_note()
{
	if [ ! -f .notes ]; then
		touch .notes
	fi
	read NOTE_NUMBER<<<$(awk 'END{print $1}' .notes)
	NOTE_NUMBER=$((NOTE_NUMBER+1))
	DATE=`date +%Y-%m-%d`
	NOTE=$1
	shift
	if [ ! -z "$2"];then
		TAG=$2
		shift
	else
		TAG=""
	fi
	echo "$NOTE_NUMBER $DATE '$NOTE' $TAG">>.notes
	
}

list_notes()
{
	echo "This function lists all notes"
}

filter_notes()
{
	echo "This function lists all notes that contain WORD"
}

urgent_note()
{
	echo "This function adds urgent notes"
}

show_help()
{
	echo "						aNote [SOME NOTE] [SOME TAG]: Adds a note to a specific Tag"
	echo "						aNote -l: List all Notes"
	echo "						aNote -f [WORD]: Search for notes with that word"
	echo "						aNote -u [1/2/3] [SOME NOTE] [SOME TAG]: specifies urgency to SOME NOTE in SOME TAG, 1 being the highest"
	echo "						aNote -r [NUMBER OF NOTE]: remove note"
}

case $1 in
	-l) list_notes
		;;
	-f) filter_notes
		;;
	-h) show_help
		;;
	*) add_note "$1" "$2"
		;;
esac
