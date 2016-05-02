#!/bin/bash

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
DEPENDENCIES="gcc make fakeroot libncurses5 libncurses5-dev kernel-package build-essential pkg-config qt5-qmake libnotify-bin gnupg"
UPDATENEEDED=0
PLUS="${Cyan}[+]${Reg}"
USE_LATEST=0
