#!/bin/sh

#-Script that controls a calendar with emails
#-New appointments can be created by sending an email with an add command
#-Can notify via email your close appointments

serverhostname="mail"
found_hostname="$(cat /etc/hostname)"
header="date,time,description"
#email is used to ssh to server and fetch remote commands
email="lucca@luccaaugusto.xyz"
#subject is used to filter emails that contain commands
subject="Naoesquece"
notificationsubject="Não Esquece Hein"

if [ "$found_hostname" = "$serverhostname" ]
then
	appointmentsfile="/home/${email%%@*}/personalspace/appointments.csv"
else
	appointmentsfile="$REPOS/personalspace/appointments.csv"
fi


fetchemailappointments()
{
	state=0
	date=""
	time=""
	body=""
	description=""
	errfile="$HOME/.${0##*/}.log"
	mailquery="${0##*/}.mailquery"

	# query the server for unseen emails with subject=$subject
	# outputs email body and date.received to a file so line breaks are preserved
	# marks these emails as seen
	# cats the file so we get it's contents locally
	if [ "$found_hostname" = "$serverhostname" ]
	then
		doveadm fetch -u ${email%%@*} 'body date.received' mailbox inbox subject $subject > $mailquery &&
		doveadm flags add -u ${email%%@*} '\Seen' mailbox inbox unseen subject $subject &&
		doveadm move -u ${email%%@*} Trash mailbox inbox seen subject $subject
	else
		(ssh "$email" "doveadm fetch 'body date.received' mailbox inbox subject $subject > $mailquery &&
			doveadm flags add '\Seen' mailbox inbox unseen subject $subject &&
			doveadm move Trash mailbox inbox seen subject $subject &&
			cat $mailquery" > "$mailquery")
	fi
	while IFS= read -r line || [ -n "$line" ]
	do
		case "$state" in
			0) #expect body
				[ "${line%%:*}" = "body" ] && state=1
				;;
			1) #read until find spend or receive
				#concatenate line for future error reporting
				body="$body|$line"
				date="${line%% *}"
				isdate="$(date -d ${date} 2>/dev/null)"
				if [ "$isdate" ]
				then
					state=2
					time="${line#* }"
					time="${time%% *}"
					description="${line#* }"
					description="${description#* }"
				elif [ "${line%%:*}" = "date.received" ]
				then
					#read until date and did not get command, something is wrong with the email
					{
						echo "${0##*/} ERROR:"
						echo "    Command not found in email"
						echo "    body: $body"
						echo "====Please do this one manually"
					} >> "$errfile"

					state=0
					body=""
				fi
				;;
			2) #read until find date.received
				if [ "${line%%:*}" = "date.received" ]
				then
					addappointment "$date" "$time" "$description"

					#Reset to read next
					state=0
					body=""
				fi
				;;
		esac

	done < "$mailquery"
	rm "$mailquery"

	#format log file and notify
	[ -e "$errfile" ] &&
		sed 's/|/\n    /g' < "$errfile" > "$errfile.aux" &&
		mv "$errfile.aux" "$errfile" &&
		notify-send "${0##*/} ERROR" "There were errors processing email logged appointments. See $errfile"
}

fetchupdates()
{
	fetchemailappointments
}

addappointment()
{
	date="$1"; shift
	time="$1"; shift
	description="$1"; shift

	if [ -z "$date" ] ||
		[ -z "$time" ] ||
		[ -z "$description" ]
	then
		echo "Missing parameters. Usage:"
		echo "${0##*/} add (date) (time) (description)"
	else

		case "$date" in
			*-*)year=${date%%-*}
				month=${date%-*}
				month=${month#*-}
				day=${date##*-}
				;;
			*/*)year=${date%/*}
				year=${year%/*}
				month=${date%/*}
				month=${month#*/}
				day=${date##*/}
				;;
			*) #unkown date
				echo "Unknown date format, please use YYYY-MM-DD or YYYY/MM/DD"
				return
				;;
		esac

		#current year is default
		[ "$year" = "$month" ] && year="$(date +%Y)"

		echo "$year/$month/$day,$time,$description" >> "$appointmentsfile"

		#sort appointments by date
		tail -n +2 "$appointmentsfile" | sort -o "$appointmentsfile.aux" &&
			echo "$header" > "$appointmentsfile" &&
			cat "$appointmentsfile.aux" >> "$appointmentsfile" &&
			rm "$appointmentsfile.aux"
	fi
}

notifyappointment()
{
	#get appointments for tomorrow and exactly seven days ahead

	msg=""
	weekday="$(date +%A)"
	tomorrow="$(date -d tomorrow +%Y/%m/%d)"
	aweekfromnow="$(date -d "next $weekday" +%Y/%m/%d)"

	while IFS= read -r aptmt || [ -n "$aptmt" ]
	do
		[ "$aptmt" = "$header" ] && continue

		aptdate="${aptmt%%,*}"

		if [ "$aptdate" = "$tomorrow" ]
		then
			msg="$msg""Tomorrow at ${aptmt#*,}\n"
		elif [ "$aptdate" = "$aweekfromnow" ]
		then
			msg="$msg""Next week ($weekday) at ${aptmt#*,}\n"
		fi
	done < $appointmentsfile

	if [ "$msg" ]
	then
		# if running from server, just run dovecot-lda, else use ssh
		if [ "$found_hostname" = "$serverhostname" ]
		then
			printf "From: ${email%%@*}-${0##*/}\nTo: ${email%%@*}\nSubject: $notificationsubject \nContent-Type: text/plain; charset=\"UTF-8\"\n\n$msg" | /usr/lib/dovecot/dovecot-lda -d ${email%%@*}
		else
			(ssh "$email" "printf \"From: ${email%%@*}-${0##*/}\nTo: ${email%%@*}\nSubject: $notificationsubject \nContent-Type: text/plain; charset=\"UTF-8\"\n\n$msg\" | /usr/lib/dovecot/dovecot-lda -d ${email%%@*}")
		fi
	fi
}

showappointmentsfile()
{
	column -s',' -t < "$appointmentsfile"
}

#RUNNING
[ -e "$appointmentsfile" ] ||
	echo "$header" > "$appointmentsfile"

[ "$1" ] && arg="$1" && shift
case "$arg" in
	add)
		addappointment "$1" "$2" "$3"
		;;
	edit)
		"$EDITOR" "$appointmentsfile"
		;;
	fetch)
		fetchupdates
		;;
	notify)
		notifyappointment
		;;
	show)
		showappointmentsfile "$1"
		;;
	*)
		echo "usage: ${0##*/} ( command )"
		echo "commands:"
		echo "		add: (date) (time) (description) "
		echo "		edit: Opens the appointmentsfile with EDITOR"
		echo "		fetch: Fetches appointments registered by email"
		echo "		show [past]: Shows the current month transactions. If 'full' is passed as argument,"
		;;
esac
