test_write_permission() {
	local TEST_FILE='test_file'
	touch "$TEST_FILE"
	echo "content" > "$TEST_FILE"

	rm "$TEST_FILE"
}

test_get_arch() {
	source ${BATS_TEST_DIRNAME}/../error_trap
	source ${BATS_TEST_DIRNAME}/../functions
	source ${BATS_TEST_DIRNAME}/../variables
	get_arch
}

test_reqexit() {
	source ${BATS_TEST_DIRNAME}/../error_trap
	source ${BATS_TEST_DIRNAME}/../functions
	source ${BATS_TEST_DIRNAME}/../variables
	reqexit
}

test_checkdeps() {
	source ${BATS_TEST_DIRNAME}/../error_trap
	source ${BATS_TEST_DIRNAME}/../functions
	source ${BATS_TEST_DIRNAME}/../variables
	check_deps
}

test_print_kernels_debian() {
	source ${BATS_TEST_DIRNAME}/../error_trap
	source ${BATS_TEST_DIRNAME}/../functions
	source ${BATS_TEST_DIRNAME}/../variables
	
	print_kernels debian
}

test_print_kernels_ubuntu() {
	source ${BATS_TEST_DIRNAME}/../error_trap
	source ${BATS_TEST_DIRNAME}/../functions
	source ${BATS_TEST_DIRNAME}/../variables
	
	print_kernels ubuntu
}

test_select_latest_kernel() {
	source ${BATS_TEST_DIRNAME}/../error_trap
	source ${BATS_TEST_DIRNAME}/../functions
	source ${BATS_TEST_DIRNAME}/../variables
	
	if [ "$1" = "latest" ]; then
		USE_LATEST=1
	fi
	USE_LATEST=1
	select_kernel
}

test_get_latest_debian_kernal() {
	source ${BATS_TEST_DIRNAME}/../error_trap
	source ${BATS_TEST_DIRNAME}/../functions
	source ${BATS_TEST_DIRNAME}/../variables
	
	print_kernels debian
	USE_LATEST=1
	select_kernel
	get_kernel_archive
}

test_spinner() {
	source ${BATS_TEST_DIRNAME}/../error_trap
	source ${BATS_TEST_DIRNAME}/../functions
	source ${BATS_TEST_DIRNAME}/../variables
	
	sleep 5 &
	spinner $!
	wait $!
	EXIT_STAT=$?
	if [ $EXIT_STAT -ne 0 ]; then
		error ${LINENO} "An error occured while extracting the archive." $EXIT_STAT
	fi
}

test_countdown() {
	source ${BATS_TEST_DIRNAME}/../error_trap
	source ${BATS_TEST_DIRNAME}/../functions
	source ${BATS_TEST_DIRNAME}/../variables
	
	countdown TestMessage 5
}

test_update() {
	source ${BATS_TEST_DIRNAME}/../error_trap
	source ${BATS_TEST_DIRNAME}/../functions
	source ${BATS_TEST_DIRNAME}/../variables
	
	update
}
