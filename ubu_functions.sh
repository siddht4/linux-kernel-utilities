#!/bin/bash

# Requires colors.sh - sourced in functions.sh

BASEURL=kernel.ubuntu.com/~kernel-ppa/mainline/
MINVER=4
FIELD=7

reqexit(){
	echo -e "${Red}Response not in the offered list of options. Interpreted as an exit request. Exiting.${Reg}"
	exit 0
}

check_deps(){
	for dep in $(echo ${DEPENDENCIES} | tr ' ' $'\n'); do
		printf '\t%-24s' "${dep}"
		if ! [ -z "`dpkg-query -W 2>&1 | grep $dep`" ]; then
			echo -e "${Green}Found${Reg}"
		else
			echo -e "${Red}Not Found${Reg}"
			UPDATENEEDED=1
		fi
	done
	echo ""
	if [ $UPDATENEEDED -eq 1 ]; then
		update
	fi
}

print_kernels(){
	TOTAL1=""
	TOTAL2=""
	COUNT=0
	for ver in $(curl -s ${BASEURL} | grep "v${MINVER}" | cut -d '>' -f 7 | awk '{print substr($0,1, length($0)-4)}'); do
		TOTAL="${TOTAL}\n$ver"
		DOWN="${DOWN}\n$ver"
	done
	echo -e "${Cyan} \_ Precompiled kernels available from ${Yellow}kernel.ubuntu.com:${Reg}"
	echo -ne "\n"
	for ver in $(echo -e $TOTAL); do
		((COUNT++))
		printf ' %-3s Linux %-20s' "${COUNT})" "`echo ${ver##*'/'}|cut -d '>' -f 7 | sed 's/-$//'`"
		[ $((COUNT%4)) -eq 0 ] && echo -e -n '\n'
	done
	NUMOPTS=$COUNT
	COUNT=0

	echo -n -e "\n\nSelect your desired kernel: "
	read INPUT
	# Check for non-integer
	if ! [ $INPUT -eq $INPUT 2>/dev/null ]; then
		reqexit
	fi
	# Check for non-offerred option
	if [ $INPUT -gt $NUMOPTS ]; then
		reqexit
	fi
	
	echo ""

	# Set low latency default to no	
	read -p "Do you want the lowlatency kernel? (y/[n]):" lowlatency
	case "$lowlatency" in
	   y* | Y*) lowlatency=1 ;;
	   *) lowlatency=0 ;;
	esac

	echo ""
}

get_arch(){
	echo -en "${Cyan} \_ Determining CPU type: "
	if [ "$(getconf LONG_BIT)" == "64" ]; then arch=amd64; else arch=i386; fi
	echo -e "${Yellow}${arch}${Reg}"
}

get_kernel(){
	get_arch
	for ver in $(echo -e $TOTAL); do
		((COUNT++))
		if [ $COUNT -eq $INPUT ]; then
			for verd in $(echo -e $DOWN); do
				((COUNTD++))
				if [ $COUNTD -eq $INPUT ]; then
					# Download Kernel
					if [ "$lowlatency" == "0" ]; then
						echo -e "${Cyan} \_ Locating source of ${ver} generic kernel packages.${Reg}"
						shared_header
						download generic header
						download generic image
					elif [ "$lowlatency" == "1" ]; then
						echo -e "${Cyan} \_ Locating source of ${ver} lowlatency kernel packages.${Reg}"
						shared_header
						download lowlatency header
						download lowlatency image
					fi
				fi				
			done
		fi
	done
	echo -e "${Cyan} \_ Done${Reg}\n"
}

shared_header(){
	echo -e "${Cyan} \_ Getting ${ver} shared header . . .${Reg}"
	eval curl -# -O $(lynx -dump -listonly -dont-wrap-pre ${BASEURL}${ver} | grep all | cut -d ' ' -f 4)
	err=$?
	if [ $err -ne 0 ]
	then
	    echo -e "Download package failure. Error code $err"
	    exit $err
	fi
}

download() {
	echo -e "${Cyan} \_ Getting ${ver} ${1} ${2}. . .${Reg}"
	eval curl -# -O $(lynx -dump -listonly -dont-wrap-pre ${BASEURL}${ver} | grep "$1" | grep "$2" | grep "$arch" | cut -d ' ' -f 4)
	err=$?
	if [ $err -ne 0 ]
	then
	    echo -e "Download package failure. Error code $err"
	    exit $err
	fi
}

update(){
	echo -e "${PLUS} Dependencies"
	printf "%-20s" "\_ Updating APT"
	$SUDO apt-get update 1>/dev/null 2>/dev/null
	echo -e "${Green}Complete${Reg}"
	printf "%-20s" "\_ Installing"
	$SUDO apt-get install -y $DEPENDENCIES 1>/dev/null 2>/dev/null
	echo -e "${Green}Complete${Reg}\n"
	return 1
}
