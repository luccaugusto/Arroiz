#!/bin/bash

#-Operations with date and time

sum_hours()
{
    h1="$1";shift
    h2="$1";shift
	min1=${h1#[0-9]*:}
	min2=${h2#[0-9]*:}
	hor1=${h1%:[0-9]*}
	hor2=${h2%:[0-9]*}

	#remove beggining 0 so number is treated as decimal
	hor1=${hor1#0}
	hor2=${hor2#0}
	min1=${min1#0}
	min2=${min2#0}

    mins=$((min1 + min2))
    hs=$((hor1+hor2))

    if [ "$mins" -gt 59 ]
    then
        hs=$(( hs + 1 ))
        mins=$(( mins % 60 ))
    fi

    if [ $mins -lt 10 ]
    then
        mins="0$mins"
    fi
    if [ $hs -lt 10 ]
    then
        hs="0$hs"
    fi

    echo "$hs:$mins"
}

min2hour()
{
	if [ "$1" ]; then
    	T="$1";shift
    	H=$((T / 60))
    	M=$((T % 60))

		[ $H -lt 10 ] && H="0$H"
		[ $M -lt 10 ] && M="0$M"

    	echo "$H:$M"
	else
		show_help
	fi
}

subtract_time()
{
	if [ "$1" ] && [ "$2" ]; then
		d1=$1; shift
		d2=$1; shift
		min2=${d2#[0-9]*:}
		hor2=${d2%:[0-9]*}
		min1=${d1#[0-9]*:}
		hor1=${d1%:[0-9]*}

		#remove beggining 0 so number is treated as decimal
		hor1=${hor1#0}
		hor2=${hor2#0}
		min1=${min1#0}
		min2=${min2#0}

		if [ $min2 -gt $min1 ]; then
			hor1=$((hor1 - 1))
			min1=$((min1 + 60))
		fi

		mins=$((min1 - min2))
		hs=$((hor1 - hor2))

		total=$((hs*60 + mins))

		echo $total
	else
		show_help
	fi
}

show_help()
{
	echo "${0##*/} option [values]"
	echo "	-s (H1:M1) (H2:M2): subtracts H1:M1 from H2:M2"
	echo "	-m (minutes): converts from minutes to HH:MM"
	echo "	-a  (H1:M1) (H2:M2): adds H1:M1 to H2:M2"
}

case $1 in
	-s) shift; subtract_time "$1" "$2"
		;;
	-m) shift; min2hour "$1"
		;;
	-a) shift; sum_hours "$1" "$2"
		;;
	*) show_help
		;;
esac
