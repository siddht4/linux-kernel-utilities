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

# Init variables
NOW=$(date +%h%d_%H-%m-%S)
VERAPPEND=$(date +.%y%m%d)
FOLDER="Build_$NOW"
OUTPUT="kernel_$NOW.tar.xz"
DEPENDENCIES="gcc make fakeroot libncurses5 libncurses5-dev kernel-package build-essential pkg-config libqt4-dev qt4-dev-tools qt4-qmake"
UPDATENEEDED=0
PLUS="${Cyan}[+]${Reg}"

if [ "$#" -gt 1 ]; then
	usage
fi
if [ "$#" -eq 1 ]; then
	if ! [[ -f "$1" ]]; then
		echo "$1 is not a file or does not exist." >&2
		exit 1
	fi
	OUTPUT=$1
else
	echo -e "If you have a local kernel archive, pass it as an argument to use it.\n"
	print_kernels
fi

echo -e "${PLUS} Checking Dependencies"
check_deps

echo -e "${PLUS} Creating a directory to build your kernel from source."
mkdir $FOLDER 2>/dev/null || { echo "You cannot create a directory here." >&2; exit 1; }
echo -e "    Directory Created:\t${Cyan}${FOLDER}${Reg}\n"

echo -e "${PLUS} Extracting your kernel . . ."
tar xf $OUTPUT -C ./$FOLDER || { echo "An error occured while extracting the archive." >&2; exit 1; }
EXTRACTED=$(ls $FOLDER/)
echo -e "    Extracted Folder:\t${Cyan}${FOLDER}/${EXTRACTED}${Reg}\n"

pushd $FOLDER/linux*

echo -e "${PLUS} Launching configuratino GUI \"make -s xconfig\"."
	make xconfig 2>/dev/null || { echo "Error occured while running \"make xconfig\"."; exit 1; }

echo -e "${PLUS} Cleaning the source tree and reseting kernel-package parameters . . ."
	fakeroot make-kpkg clean 1>/dev/null 2>/dev/null || { echo "Error occurred while running \"make-kpkg clean\"."; exit 1; }
echo -e "\_ ${Green}Cleaned${Reg}"

read -p "[?] Would you like to build the kernel now? This will take a while (y/N):" -n 1 -r
if [[ ! $REPLY  =~ ^[Yy]$ ]]; then
	echo -e "\n\nYou can build it later with:\nfakeroot make-kpkg -rootcmd --initrd --append-to-version=$VERAPPEND kernel_image kernel_headers"
	cleanup
	echo -e "${Green}[%] Exiting without compilation.${Reg}"
	popd
	exit 0
else
	echo -e "\n\n${PLUS} Compiling your kernel!"
	fakeroot time -f "\n\n\tTime Elapsed: %E\n\n" make-kpkg --rootcmd fakeroot --initrd --append-to-version=$VERAPPEND kernel_image kernel_headers || { echo "Something happened during the compilation process, but I can't help you."; exit 1; }
fi

read -p "[?] Kernel compiled successfully. Would you like to install? (y/N)" -n 1 -r
if [[ ! $REPLY  =~ ^[Yy]$ ]]; then
	echo -e "\n\nSkipping kernel installation . . ."
else
	echo -e "\_ ${Green}Installing kernel . . .${Reg}"
	$SUDO dpkg -i ../*.deb
fi

cleanup

echo -e "${Green}[%] Complete${Reg}"
