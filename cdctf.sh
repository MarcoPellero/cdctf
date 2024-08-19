#!/bin/bash -i

function cdctf() {
	cd $(readlink /usr/share/cdctf/ctfdir)
	
	if [ -z $1 ]; then
		return
	fi

	res=$(locate -red /usr/share/cdctf/db /$1$)
	if [ -z "$res" ]; then
		echo "404 not found :("
		return
	fi

	target=""
	while read line; do
		if [ "$(file -b $line)" != "directory" ]; then
			continue
		fi

		if [ ! -z "$target" ]; then
			echo "300 multiple choices :^("
			echo "$res"
			return
		fi

		target="$line"
	done <<< "$res"

	if [ -z "$target" ]; then
		echo "406 not acceptable :O (files, not directories, found)" # well it exists but is a file. unacceptable!
		echo "$res"
	else
		cd $target
	fi
}
