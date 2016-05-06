#!/bin/bash

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
DEPENDENCIES="gcc make fakeroot libncurses5 libncurses5-dev kernel-package \
						build-essential pkg-config qt5-qmake libnotify-bin gnupg"
BASEURL=kernel.org

if [ "$#" -gt 1 ]; then
	usage
fi

if [ "$#" -eq 1 ]; then
	if ! [[ -f "$1" ]]; then
		if [[ "$1" = "latest" ]]; then
			USE_LATEST=1
		elif [[ "$1" = "-h" || "$1" = "--help" ]]; then
			usage
		else
			error ${LINENO} "$1 is not a file or does not exist." 1
		fi
	else
		OUTPUT=$1
	fi
	
else
	echo -e "If you have a local kernel archive, pass it as an argument to use it.\n"
fi

echo -e "${PLUS} This build script uses QT to provide a menu for the user. Detecting . . ."
if ! check_qt; then \
	echo -e ""
	echo -e "${Yellow}[!] QT${Reg} wasn't detected. Installing the QT5-default package . . ."
	#$SUDO apt-get install -qq qt5-default > /dev/null
	sudobg apt-get -qq install qt5-default
	MSG="Installing QT5 default package"
	spinner $BGPID "$MSG"
	wait $BGPID
	sleep 10
fi

echo -e "${PLUS} Checking Balance of Dependencies"
check_deps

print_kernels

select_kernel

get_kernel_archive

check_sign

echo -e "${PLUS} Creating a directory to build your kernel from source."
mkdir $CMP_FLDR 2>/dev/null || error ${LINENO} "You cannot create a directory here." 1
echo -e " \_ Directory Created:\t${Cyan}${CMP_FLDR}${Reg}\n"

echo -ne "${PLUS} Extracting your kernel . . . "
tar xf $OUTPUT -C ./$CMP_FLDR &
spinner $!

# Check for successful extraction
wait $!
EXIT_STAT=$?
if [ $EXIT_STAT -ne 0 ]
then
	error ${LINENO} "An error occured while extracting the archive." $EXIT_STAT
fi

EXTRACTED=$(ls $CMP_FLDR/)
echo -e "\n \_ Extracted Folder:\t${Cyan}${CMP_FLDR}/${EXTRACTED}${Reg}\n"

pushd $CMP_FLDR/linux* 1>/dev/null 2>/dev/null

echo -e "${PLUS} Launching configuratino GUI \"make -s xconfig\"."
	make xconfig 2>/dev/null || error ${LINENO} "Error occured while running \"make xconfig\"." 1

echo -ne "${PLUS} Cleaning the source tree and reseting kernel-package parameters . . . "
	fakeroot make-kpkg clean 1>/dev/null 2>/dev/null || error ${LINENO} "Error occurred while running \"make-kpkg clean\"." 1
echo -e "\n \_ ${Green}Cleaned${Reg}\n"

read -p "[?] Would you like to build the kernel now? This will take a while (y/N):" -n 1 -r
if [[ ! $REPLY  =~ ^[Yy]$ ]]; then
	echo -e "\n\nYou can build it later with:\n   ${Yellow}fakeroot make-kpkg -rootcmd --initrd --append-to-version=$VERAPPEND kernel_image kernel_headers${Reg}"
	cleanup
	echo -e "\n\n${Green}[%] Exiting without compilation.${Reg}\n\n"
	popd 1>/dev/null 2>/dev/null
	exit 0
else
	echo -e "\n\n${PLUS} Compiling your kernel!"
	echo -e " \_ An alert notification will trigger when complete. Time for a stroll . . .\n\n"
	echo -e "--------------------------------------------------------------------------------------------------"
	countdown 'Compilation will begin in ' 10
	echo -e " -- ${Yellow}Starting Compilation${Reg} -- "
	echo -e "--------------------------------------------------------------------------------------------------\n\n"
	
	shopt -s nocasematch
	if [[ "$OS" == "debian" ]]; then

	fakeroot time -f "\n\n\tTime Elapsed: %E\n\n" make-kpkg --rootcmd fakeroot --initrd --append-to-version=$VERAPPEND kernel_image kernel_headers \
			|| error ${LINENO} "Something happened during the compilation process, but I can't help you." 1
	elif [[ "$OS" == "ubuntu" ]]; then
		echo "Not yet implemented"
		exit 0
	fi
	
	
fi

# Provide a user notification 
echo -e $'\a' && notify-send -i emblem-default "Kernel compliation completed."

read -p "[?] Kernel compiled successfully. Would you like to install? (y/N)" -n 1 -r
if [[ ! $REPLY  =~ ^[Yy]$ ]]; then
	dir=`pwd`
	pDir="$(dirname "$dir")"
	echo -e "\n\nYou can manually install the kernel with:\nsudo dpkg -i $pDir/*.deb"
	echo -e "\n \_ Skipping kernel installation . . ."
else
	echo -e "\n \_ ${Green}Installing kernel . . .${Reg}"
	$SUDO dpkg -i ../*.deb
fi

cleanup
popd 1>/dev/null 2>/dev/null

echo -e "${Green}[%] Complete${Reg}"
