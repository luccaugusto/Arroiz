#!/bin/bash

#Notes CRUD
#script for taking simple notes in the terminal

#TODO
#Check awk to format the strings to create notes and list notes
#Create add function
#Version controll Scripts

add_note()
{
	echo "This function adds a note"
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
}

case $1 in
	-l) list_notes
		;;
	-f) filter_notes
		;;
	-h) show_help
		;;
	*) add_note
		;;
esac
