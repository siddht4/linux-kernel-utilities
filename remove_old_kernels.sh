#!/bin/bash

. ./colors.sh

echo -e "\n\n${Red}		++++++++++++++++++++++++++++++++"
echo -e "		+++       W A R N I N G      +++ "
echo -e "		++++++++++++++++++++++++++++++++\n\n"
echo -e "${Cyan}A reboot is recommended before running this script to ensure the current kernel tagged"
echo -e "as the boot kernel is indeed registered and old kernels properly marked for removal."
echo -e "If you have just installed or modified your existing kernel and do not reboot before"
echo -e "running this script it may render you system ${Red}INOPERABLE${Cyan} and that would indeed suck.\n\n"
echo -e "You have been warned."
echo -e "~the Mgmt${Reg}\n"

read -p "[?]Continue to automagically remove ALL old kernels? (y/N)" -n 1 -r
if [[ ! $REPLY  =~ ^[Yy]$ ]]; then
	echo -e "\n\nExiting kernel removal process."
	exit 0
else
	echo -e "\_ ${Green}Removing ALL old kernels . . .${Reg}"
fi

# Ensure root privledges
SUDO=''

if (( $EUID != 0 )); then
    SUDO='sudo'
fi

dpkg -l linux-* | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e [0-9] | grep -E "(image|headers)" | xargs $SUDO apt-get -y purge
