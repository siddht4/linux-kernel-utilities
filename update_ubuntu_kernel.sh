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

# Set overlap variables
DEPENDENCIES+="lynx "
# Check for Broadcom Wifi device and if found add to Dependencies
if lspci | grep "Network controller: Broadcom Corporation" > /dev/null ; then
	DEPENDENCIES+="bcmwl-kernel-source "
fi

# shellcheck disable=SC2034
BASEURL=kernel.ubuntu.com/~kernel-ppa/mainline/

if [ "$#" -gt 1 ]; then
	usage
elif [ "$1" = "latest" ]; then
	# shellcheck disable=SC2034
	USE_LATEST=1
elif [[ "$1" == "-v" || "$1" == "--version" ]]; then
		show_version
		exit 0
fi

shopt -s nocasematch
if [[ "$OS" != "ubuntu" ]]; then
	UPOS=${OS^^}
	if ! (whiptail --yesno --defaultno --title "Precompiled Ubuntu Kernel Updater" "This script is intended to update an Ubuntu distro.\n\nYour distro detected as [${UPOS}] ... continue anyway?" 20 80); then
		whip_msg  "Non-Ubuntu Distro Cancel" "Exiting and cleaning up."
		exit 0
	fi
fi

echo -e "${PLUS} Checking Dependencies"
check_deps

echo -e "${PLUS} Changing to temporary directory to work in . . ."
cd "$TMP_FLDR" 2>/dev/null || { echo "Unable to access temporary workspace ... exiting." >&2; exit 1; }
# shellcheck disable=SC2154
echo -e "${Cyan} \_ Temporary directory access granted:\t${Reg}${TMP_FLDR}\n"

echo -e "${PLUS} Removing any conflicting remnants . . ."
if ls /tmp/linux-* 1> /dev/null 2>&1; then
	rm /tmp/linux-*
fi
echo -e "${Cyan} \_ Done${Reg}\n"

echo -e "${PLUS} Retrieving available kernel choices . . ."

print_kernels_ubu

select_kernel_ubu

echo -e "${PLUS} Processing selection"
get_precompiled_ubu_kernel

echo -e "${PLUS} Installing kernel . . ."
${SUDO} dpkg -i linux*.deb
echo -e "${Cyan} \_ Done${Reg}\n"
