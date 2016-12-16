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

# Reset GETOPTS
OPTIND=1

# Set overlap variables
DEPENDENCIES+="lynx "

# shellcheck disable=SC2034
BASEURL=kernel.ubuntu.com/~kernel-ppa/mainline/

if ! [[ $# == 0 ]]; then
	if [[ $1 =~ ^- ]]; then
		echo -e "DEPRICATED: Please use the standard argument form (${Yellow}--latest${Reg}).\n"
		echo -e "Example: ${Yellow}./${0##*/} --latest${Reg}\n"
		echo -e "Try ${Yellow}--help${Reg} for more information.\n"
		exit 1
	fi
fi
# Parse arguments
parse_opts_ubu "$@"

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

echo -e "${PLUS} Checking AntiVirus flag and disabling if necessary"
if [ $AV -eq 1 ]; then
	if ${SUDO} /opt/sophos-av/bin/savdstatus | grep -w "on-access scanning is running" > /dev/null; then
		sophosOFF
		AV_ACTIVE=1
	fi
fi

echo -e "${PLUS} Installing kernel . . ."
${SUDO} dpkg -i linux*.deb
echo -e "${Cyan} \_ Done${Reg}\n"
