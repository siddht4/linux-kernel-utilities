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

# Set overlap variables						
#DEPENDENCIES+="build-essential dkms gnupg libncurses5 libncurses5-dev libnotify-bin \
#				libssl-dev pkg-config qt5-qmake sudo time "
DEPENDENCIES+="build-essential gnupg libnotify-bin libssl-dev pkg-config \
				sudo time "
									
BASEURL=kernel.org

if [ "$#" -gt 1 ]; then
	usage
fi

if [ "$#" -eq 1 ]; then
	if ! [[ -f "$1" ]]; then
		if [[ "$1" = "latest" ]]; then
			USE_LATEST=1
		elif [[ "$1" = "-h" || "$1" = "--help" || "$1" = "usage" ]]; then
			usage
		else
			shopt -s nullglob
			PROFILES=(profiles/*)	
			for FILE in ${PROFILES[@]}; do
				if [[ "profiles/$1" == "${FILE}" ]]; then 
					. profiles/$1
					$1
				fi
			done
			error ${LINENO} "$1 is not a file or the profile does not exist." 1
		fi
	else
		OUTPUT=$1
		LOCALFILE=1
	fi
	
else
	echo -e "If you have a local kernel archive, pass it as an argument to use it.\n"
fi

whip_msg  "${w_title_one}" "${w_msg_one}"

# Check if launched as root user
chk_root

# If not root, check member os sudo
if [[ $EUID -ne 0 ]]; then
	chk_sudoer
fi

echo -e "${PLUS} Checking Dependencies"
DEPENDENCIES+="libncurses5 libncurses5-dev qt5-qmake "
check_deps

echo -e "${PLUS} This build script uses QT to provide a menu for the user. Detecting . . ."
check_qt5

if ! [ $LOCALFILE ]; then
	select_kernel_deb
	get_kernel_archive
	check_sign
fi

echo -e "${PLUS} Creating a directory to build your kernel from source."
mkdir $CMP_FLDR 2>/dev/null || error ${LINENO} "You cannot create a directory here." 1
echo -e " \_ Directory Created:\t${Cyan}${CMP_FLDR}${Reg}\n"

MSG="Extracting your kernel . . . "
tar xf $OUTPUT -C ./$CMP_FLDR &
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
EXTRACTED=$(ls $CMP_FLDR/)
echo -e " \_ Extracted Folder:\t${Cyan}${CMP_FLDR}/${EXTRACTED}${Reg}\n"

pushd $CMP_FLDR/linux* &>/dev/null

echo -e "${PLUS} Cleaning the source tree and resetting kernel-package parameters . . . "
	make mrproper &>/dev/null || error ${LINENO} "Error occurred while running \"make mrproper\"." 1

echo -e " \_ ${Green}Done${Reg}\n"

echo -e "${PLUS} Launching configuration GUI \"make -s xconfig\"."
	make xconfig 2>/dev/null || error ${LINENO} "Error occured while running \"make xconfig\"." 1

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
	echo -e " -- ${Yellow}Starting Compilation${Reg} -- "
	echo -e "--------------------------------------------------------------------------------------------------\n\n"
					
	/usr/bin/time -f "\n\n\tTime Elapsed: %E\n\n" make -j${NUMTHREADS} deb-pkg LOCALVERSION=-${VERAPPEND} \
			|| error ${LINENO} "Something happened during the kernel compilation process, but I can't help you." 1
			
	/usr/bin/time -f "\n\n\tTime Elapsed: %E\n\n" make -j${NUMTHREADS} modules LOCALVERSION=-${VERAPPEND} \
			|| error ${LINENO} "Something happened during the modules compilation process, but I can't help you." 1
	
fi

# Provide a user notification 
echo -e $'\a' && notify-send -i emblem-default "Kernel compliation completed."

read -p "[?] Kernel compiled successfully. Would you like to install? (y/N)" -n 1 -r
if [[ ! $REPLY  =~ ^[Yy]$ ]]; then
	dir=`pwd`
	pDir="$(dirname "$dir")"
	echo -e "\n\nYou can manually install the kernel with:\n${Yellow}sudo dpkg -i $pDir/*.deb${Reg}"
	echo -e "\nYou will still have to handle the installation of modules from the source directory with:\n${Yellow}sudo modules_install${Reg}"
	echo -e "\n \_ Skipping kernel and modules installation . . ."
else
	echo -e "\n \_ ${Green}Installing kernel and modules . . .${Reg}"
	$SUDO dpkg -i ../*.deb
	$SUDO make modules_install
fi

cleanup
popd &>/dev/null

echo -e "${Green}[%] Complete${Reg}"
