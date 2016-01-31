#!/bin/bash

# Script to purge and recompile wifi via dkms
dkms-wifi-install(){
	MODULE="rtl8812AU_8821AU_linux" \
	MODULE_VERSION="1.0" \
	MODULE_SRC_PATH="/usr/src/"

	$SUDO dkms remove "${MODULE}/${MODULE_VERSION}" --all
	$SUDO dkms add "${MODULE}/${MODULE_VERSION}"
	$SUDO dkms build "${MODULE}/${MODULE_VERSION}"
	$SUDO dkms install --force "${MODULE}/${MODULE_VERSION}"
}


