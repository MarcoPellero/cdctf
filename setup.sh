#!/bin/bash

if [ ! -z $1 ]; then
	echo "Usage: $0 [path to your ctf folder]"
	exit 0
elif [ "$(whoami)" != "root" ]; then
	echo "Warning: this setup script uses commands that require root privileges; you may want to run it with sudo"
	echo
fi

echo "Setting up link to ctf directory & plocate db"
mkdir /usr/share/cdctf
ln -s $(realpath $1) /usr/share/cdctf/ctfdir
updatedb -U /usr/share/cdctf/ctfdir -o /usr/share/cdctf/db

echo "Setting up systemd updater service"
ln -s $(pwd)/updater.sh /usr/bin/cdctf_updater.sh
cp $(pwd)/cdctf.service /etc/systemd/system/cdctf.service

echo "Starting & enabling service"
systemctl start cdctf
systemctl enable cdctf

echo "Sourcing cdctf script"
source ./cdctf.sh

echo
echo "To add cdctf as a usable command, add \`source $(pwd)/cdctf.sh\` to your .bashrc"
