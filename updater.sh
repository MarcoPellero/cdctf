#!/bin/bash

last_update=0

inotifywait -rme create /usr/share/cdctf/ctfdir |
bash -c '
while read filename eventlist eventfile
do
	echo "$(date +%s%3N)"
done' |
while read timestamp
do
	if (( $timestamp < $last_update )); then
		continue
	fi

	echo "timestamp is $timestamp; updating db"
	last_update=$(date +%s%3N)
	updatedb -U /usr/share/cdctf/ctfdir -o /usr/share/cdctf/db
done
