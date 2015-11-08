#! /bin/bash

# Clear the terminal so we can see things
clear

# Source terminal colors
. ./colors.sh
# Source functions
. ./ubu_functions.sh

# Ensure root privledges
SUDO=''

# Init variables
NOW=$(date +%h%d_%H-%m-%S)
VERAPPEND=$(date +.%y%m%d)
DEPENDENCIES="lynx curl"
FOLDER="/tmp"
PLUS="${Cyan}[+]${Reg}"
UPDATENEEDED=0

echo -e "${PLUS} Checking Dependencies"
check_deps

echo -e "${PLUS} Changing to temporary directory to work in . . ."
cd $FOLDER 2>/dev/null || { echo "Unable to access temporary workspace ... exiting." >&2; exit 1; }
echo -e "${Cyan} \_ Temporary directory access granted:\t${Reg}${FOLDER}\n"

echo -e "${PLUS} Removing any conflicting remnants . . ."
if ls /tmp/linux-* 1> /dev/null 2>&1; then
	rm /tmp/linux-*
fi
echo -e "${Cyan} \_ Done${Reg}\n"

echo -e "${PLUS} Retrieving available kernel choices . . ."
print_kernels

echo -e "${PLUS} Processing selection"
get_kernel

echo -e "${PLUS} Installing kernel . . ."
${SUDO} dpkg -i linux*.deb
echo -e "${Cyan} \_ Done${Reg}\n"

echo -e "\t-----------------------------------------------------------------"
echo -e "\t---                                                           ---"
echo -e "\t---  If this script proved handy, buy me an espresso:         ---"
echo -e "\t---                                                           ---"
echo -e "\t---   ${Yellow}https://github.com/mtompkins/openAlgo${Reg}                   ---"
echo -e "\t---                                                           ---"
echo -e "\t-----------------------------------------------------------------"
echo -e "\n\n\n"

