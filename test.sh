#!/bin/bash

# Source terminal colors
. ./colors.sh

# Source functions - Simulate prototyping
# check_deps()
# cleanup()
# print_kernels()
# update()
. ./functions.sh

# Ensure root privledges
SUDO=''

if (( $EUID != 0 )); then
	SUDO='sudo'
fi

read -p "[?] Kernel compiled successfully. Would you like to install? (y/N)" -n 1 -r
if [[ ! $REPLY  =~ ^[Yy]$ ]]; then
	echo -e "\n\_ Skipping kernel installation . . ."
else
	echo -e "\n\_ ${Green}Installing kernel . . .${Reg}"
	$SUDO dpkg -i ../*.deb
	read -p "[?] Kernel installed successfully. Would you like to purge and reinstall external wifi driver [rtl8812AU_8821AU]? (y/N)" -n 1 -r
	if [[ ! $REPLY  =~ ^[Yy]$ ]]; then
		echo -e "\n\_ Skipping wifi installation . . ."
	else
	. ./dkms-wifi.sh
	echo -e "\n\n${PLUS} Compiling wifi driver and installing . . "
	dkms-wifi-install
fi

cleanup

echo -e "${Green}[%] Complete${Reg}"
