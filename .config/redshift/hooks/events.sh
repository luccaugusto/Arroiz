#!/bin/bash

case $1 in
	period-changed)
		exec notify-send "Redshift" "Período mudou para $3"
esac
