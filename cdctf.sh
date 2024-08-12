#!/bin/bash -i

function cdctf() {
	cd $(readlink /usr/share/cdctf/ctfdir)
	
	if [ -z $1 ]; then
		return
	fi

	dest=$(locate -red /usr/share/cdctf/db /$1$)
	if [ -z $dest ]; then
		echo "404 not found :("
	elif [ "$(file -b $dest)" != "directory" ]; then
		echo "406 not acceptable :O"
	else
		cd $dest
	fi
}
