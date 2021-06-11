#!/bin/bash

#-lists all css rules that are not being used on current folder html files

echo_useless()
{
	classes=$(grep ^[^@]\.*{$ $1 | sed 's/\.//g' | sed 's/{//g' | sed 's/#//g')

	for classe in $classes
	do
		grep $classe *.html > /dev/null ||
		echo "$classe Não utilizada"
	done
}

help()
{
	echo "Usage: css_inutil.sh file.css"
}

if [ ! -z "$1" ]
then
	help()
else
	echo_useless() $1
fi
