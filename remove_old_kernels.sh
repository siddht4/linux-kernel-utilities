#!/bin/bash

# Clear the terminal so we can see things
tput clear

# Source terminal colors
. ./colors
# Source error trap
. ./error_trap
# Source variables
. ./variables
# Source functions
. ./functions
# Source whiptail messages
. ./messages

chk_version

# Temporarily disable Sophos AntiVirus
if [ $AV -eq 1 ]; then
	if ${SUDO} /opt/sophos-av/bin/savdstatus | grep -w "on-access scanning is running" > /dev/null; then
		sophosOFF
		AV_ACTIVE=1
	fi
fi

# shellcheck disable=SC2154
echo -e "\n\n${Red}		++++++++++++++++++++++++++++++++"
echo -e "		+++       W A R N I N G      +++ "
echo -e "		++++++++++++++++++++++++++++++++\n\n"
# shellcheck disable=SC2154
echo -e "${Cyan}A reboot is recommended before running this script to ensure the current kernel tagged"
echo -e "as the boot kernel is indeed registered and old kernels properly marked for removal."
echo -e "If you have just installed or modified your existing kernel and do not reboot before"
echo -e "running this script it may render you system ${Red}INOPERABLE${Cyan} and that would indeed suck.\n\n"
echo -e "You have been warned."
# shellcheck disable=SC2154
echo -e "~the Mgmt${Reg}\n"

read -p "[?]Continue to automagically remove ALL old kernels? (y/N)" -n 1 -r
if [[ ! $REPLY  =~ ^[Yy]$ ]]; then
	echo -e "\n\nExiting kernel removal process."
	exit 0
else
	# shellcheck disable=SC2154
	echo -e "\n\_ ${Green}Removing ALL old kernels . . .${Reg}"
fi

# Ensure root privledges
SUDO=''

if (( EUID != 0 )); then
    SUDO='sudo'
fi

dpkg -l linux-* | awk '/^ii/{ print $2}' | grep -v -e "$(uname -r | cut -f1,2 -d"-")" | grep -e "[0-9]" | grep -E "(image|headers)" | xargs $SUDO apt-get -y purge

# Used to temporarily disable Sophos AntiVirus
if [ -s $HOME/.aliases/sophos ]; then
	sophosON
fi
