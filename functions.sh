#!/bin/bash

# Requires colors.sh - sourced in functions.sh

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

cleanup(){
	fakeroot rm $OUTPUT -f
}

print_kernels(){
	echo "Kernels Available from https://www.kernel.org:"
	TOTAL1=""
	TOTAL2=""
	COUNT=0
	for ver in $(curl -s https://kernel.org | grep "Download complete tarball" | cut -d '.' -f 2- | cut -d '"' -f 1); do
		TOTAL="${TOTAL}\nhttps://$ver"
	done
	echo -ne "\n"
	for ver in $(echo -e $TOTAL); do
		((COUNT++))
		printf ' %-3s Linux %-15s' "${COUNT})" "`echo ${ver##*'/'}|cut -d - -f 2- | sed 's/.tar.xz//g'`"
		[ $((COUNT%3)) -eq 0 ] && echo -e -n '\n'
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
	for ver in $(echo -e $TOTAL); do
		((COUNT++))
		if [ $COUNT -eq $INPUT ]; then
			echo -e "${PLUS} Downloading Kernel"
			echo -e " \_ Saving as ${Cyan}${OUTPUT}${Reg}"
			echo -e "\nVer: ${ver}     Output: ${OUTPUT}\n"
			TEMPFILES+=( "$OUTPUT" )
			eval curl -# $ver -o "$OUTPUT"
			err=$?
			if [ $err -ne 0 ]
			then
				error "Func: print_kernels" "Download source failure." $err
			fi
		fi
	done
}

update(){
	echo -e "${PLUS} Dependencies"
	printf "%-20s" " \_ Updating APT"
	$SUDO apt-get update 1>/dev/null 2>/dev/null
	echo -e "${Green}Complete${Reg}"
	printf "%-20s" " \_ Installing"
	$SUDO apt-get install -y $DEPENDENCIES 1>/dev/null 2>/dev/null
	echo -e "${Green}Complete${Reg}\n"
	return 1
}

countdown(){
	local txt=$1
	local secs=$2
	while [ $secs -gt 0 ]; do
	echo -ne "$txt $secs\033[0K\r"
	sleep 1
	: $((secs--))
	done
}

spinner(){
    local pid=$1
    local delay=0.25
    local spinstr='|/-\'
    while [ "$(ps | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# TRAPS
TEMPFILES=( )
cleanupfiles() {
  rm -f "${TEMPFILES[@]}"
}
trap cleanupfiles 0

error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo -e "\n${Red}Error on or near line ${parent_lineno}:${Reg} ${message} - exiting with status ${code}"
  else
    echo -e "\n${Red}Error on or near line ${parent_lineno}${Reg} - exiting with status ${code}"
  fi
  exit "${code}"
}
trap 'error ${LINENO}' ERR