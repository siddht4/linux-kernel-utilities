#! /bin/bash

# Clear the terminal so we can see things
clear

# Source terminal colors
. ./colors
# Source error trap
. ./error_trap
# Source variables
. ./variables
# Source functions
. ./functions

# Set overlap variables
DEPENDENCIES="lynx curl"
BASEURL=kernel.ubuntu.com/~kernel-ppa/mainline/

if [ "$#" -gt 1 ]; then
	usage
elif [ "$1" = "latest" ]; then
	USE_LATEST=1
fi

echo -e "${PLUS} Checking OS"
shopt -s nocasematch
if [[ "$OS" != "ubuntu" ]]; then
	echo -n -e "[?] ${Red}This script is intended to update an Ubuntu distro. ${Cyan}${OS}${Red} detected ... continue anyway? (y/N) ${Reg}"
	read INPUT
	if [[ ! $INPUT  =~ ^[Yy]$ ]]; then
		echo -e "\_ Exiting kernel installation."
		exit 0
	else
		echo -e "\_ ${Yellow}Continuing to install kernel . . .${Reg}\n"
	fi
fi

echo -e "${PLUS} Checking Dependencies"
check_deps

echo -e "${PLUS} Changing to temporary directory to work in . . ."
cd $TMP_FLDR 2>/dev/null || { echo "Unable to access temporary workspace ... exiting." >&2; exit 1; }
echo -e "${Cyan} \_ Temporary directory access granted:\t${Reg}${TMP_FLDR}\n"

echo -e "${PLUS} Removing any conflicting remnants . . ."
if ls /tmp/linux-* 1> /dev/null 2>&1; then
	rm /tmp/linux-*
fi
echo -e "${Cyan} \_ Done${Reg}\n"

echo -e "${PLUS} Retrieving available kernel choices . . ."
print_kernels

select_kernel

echo -e "${PLUS} Processing selection"
get_precompiled_ubu_kernel

echo -e "${PLUS} Installing kernel . . ."
${SUDO} dpkg -i linux*.deb
echo -e "${Cyan} \_ Done${Reg}\n"
