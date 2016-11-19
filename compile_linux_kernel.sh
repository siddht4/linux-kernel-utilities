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
DEPENDENCIES+="bc build-essential gnupg libnotify-bin libssl-dev pkg-config \
				time "

# shellcheck disable=SC2034
BASEURL=kernel.org

if ! [[ $1 =~ ^- ]]; then
	echo -e "DEPRICATED: Please use the standard argument form.\n"
	echo -e "Example: ${Yellow}./${0##*/} --latest${Reg}\n"
	echo -e "Try ${Yellow}--help${Reg} for more information.\n"
	exit 1
fi

# Parse arguments
parse_opts_comp "$@"

# shellcheck disable=SC2154
whip_msg  "${w_title_one}" "${w_msg_one}"

# Check if launched as root user
chk_root

# If not root, check member os sudo
if [[ $EUID -ne 0 ]]; then
	chk_sudoer
fi

# Check if remote session
isremote

echo -e "${PLUS} Checking Dependencies"

# Configure dependencies basted on local / remote
if [ -n "$SESSION_TYPE" ]; then
	DEPENDENCIES+="libncurses5 libncurses5-dev "
else
	DEPENDENCIES+="qt5-qmake "
fi

check_deps

# Check if remote session
if [ -n "$SESSION_TYPE" ]; then
	echo -e "${PLUS} Remote usage detected. Enabling ncurses . . ."
	USENCURSES=1
else
	echo -e "${PLUS} This build script uses QT to provide a menu for the user. Detecting . . ."
	check_qt5
	unset USENCURSES
fi

if ! [ $LOCALFILE ]; then
	select_kernel_deb
	get_kernel_archive
	check_sign
fi

echo -e "${PLUS} Creating a directory to build your kernel from source."
mkdir "$CMP_FLDR" 2>/dev/null || error ${LINENO} "You cannot create a directory here." 1
# shellcheck disable=SC2154
echo -e " \_ Directory Created:\t${Cyan}${CMP_FLDR}${Reg}\n"

MSG="Extracting your kernel . . . "
tar xf "$OUTPUT" -C ./"$CMP_FLDR" &
spinner $! "${MSG}"
# Check for successful extraction
wait $!
EXIT_STAT=$?
if [ $EXIT_STAT -ne 0 ]
then
	error ${LINENO} "An error occured while extracting the archive." $EXIT_STAT
fi

clearline
echo -e "${PLUS} Extracting your kernel . . ."
EXTRACTED=$(ls "$CMP_FLDR"/)
echo -e " \_ Extracted Folder:\t${Cyan}${CMP_FLDR}/${EXTRACTED}${Reg}\n"

pushd "$CMP_FLDR"/linux* &>/dev/null

echo -e "${PLUS} Cleaning the source tree and resetting kernel-package parameters . . . "
	make mrproper &>/dev/null || error ${LINENO} "Error occurred while running \"make mrproper\"." 1

# shellcheck disable=SC2154
echo -e " \_ ${Green}Done${Reg}\n"

if [ -n "$USENCURSES" ]; then
	echo -e "${PLUS} Launching NCURSES configuration \"make nconfig\"."
	make nconfig 2>/dev/null || error ${LINENO} "Error occured while running \"make nconfig\"." 1
else
	echo -e "${PLUS} Launching configuration GUI \"make xconfig\"."
	make xconfig 2>/dev/null || error ${LINENO} "Error occured while running \"make xconfig\"." 1
fi


echo -e "\n${PLUS} Disabling DEBUG INFO . . . "
scripts/config --disable DEBUG_INFO || error ${LINENO} "Error occurred while disabling DEBUG INFO." $?
echo -e " \_ ${Green}Done${Reg}\n"

echo -e "${PLUS} Cleaning the workspace after configuration . . . "
	make clean &>/dev/null || error ${LINENO} "Error occurred while running \"make clean clean\"." 1

echo -e " \_ ${Green}Cleaned${Reg}\n"

read -p "[?] Would you like to build the kernel now? This will take a while (y/N):" -n 1 -r
if [[ ! $REPLY  =~ ^[Yy]$ ]]; then
	echo -e "\n\nYou can build it later with:"
	MSG="make -j${NUMTHREADS} deb-pkg LOCALVERSION=-${VERAPPEND}${Reg}"
	# shellcheck disable=SC2154
    center-text "${LimeYellow}" "${MSG}" "${Reg}"
	cleanup
	echo -e "\n\n${Green}[%] Exiting without compilation.${Reg}\n\n"
	popd &>/dev/null
	exit 0
else
	echo -e "\n\n${PLUS} Compiling your kernel!"
	echo -e " \_ An alert notification will trigger when complete. Time for a stroll . . .\n\n"
	echo -e "--------------------------------------------------------------------------------------------------"
	countdown 'Compilation will begin in ' 10
	# shellcheck disable=SC2154
	echo -e " -- ${Yellow}Starting Compilation${Reg} -- "
	echo -e "--------------------------------------------------------------------------------------------------\n\n"

	/usr/bin/time -f "\n\n\tTime Elapsed: %E\n\n" make -j"${NUMTHREADS}" deb-pkg LOCALVERSION=-"${VERAPPEND}" \
			|| error ${LINENO} "Something happened during the kernel compilation process, but I can't help you." 1

	/usr/bin/time -f "\n\n\tTime Elapsed: %E\n\n" make -j"${NUMTHREADS}" modules LOCALVERSION=-"${VERAPPEND}" \
			|| error ${LINENO} "Something happened during the modules compilation process, but I can't help you." 1

fi

# Provide a user notification
echo -e $'\a' && notify-send -i emblem-default "Kernel compliation completed."

read -p "[?] Kernel compiled successfully. Would you like to install? (y/N)" -n 1 -r
if [[ ! $REPLY  =~ ^[Yy]$ ]]; then
	dir=$(pwd)
	pDir="$(dirname "$dir")"
	echo -e "\n\nYou can manually install the kernel with:"
	MSG="sudo dpkg -i $pDir/*.deb"
	center-text "${Yellow}" "${MSG}" "${Reg}"
	echo -e "\nYou will still have to handle the installation of modules from the source directory with:"
	MSG="sudo modules_install"
	center-text "${Yellow}" "${MSG}" "${Reg}"
	echo -e "\n${Yellow}[!]${Reg} Skipping kernel and modules installation . . ."
else
	echo -e "\n \_ ${Green}Installing kernel and modules . . .${Reg}"
	$SUDO dpkg -i ../*.deb
	$SUDO make modules_install
fi

cleanup
popd &>/dev/null

echo -e "${Green}[%] Complete${Reg}"
