test_write_permission() {
	local TEST_FILE='test_file'
	touch "$TEST_FILE"
	echo "content" > "$TEST_FILE"

	rm "$TEST_FILE"
}

test_reqexit() {
	source ${BATS_TEST_DIRNAME}/../functions
	reqexit
}

test_checkdeps() {
	source ${BATS_TEST_DIRNAME}/../variables
	source ${BATS_TEST_DIRNAME}/../functions
	check_deps
}

test_print_kernels() {
	source ${BATS_TEST_DIRNAME}/../variables
	source ${BATS_TEST_DIRNAME}/../functions
	print_kernels
}

test_select_kernel() {
	source ${BATS_TEST_DIRNAME}/../variables
	source ${BATS_TEST_DIRNAME}/../functions
	if [ "$1" = "latest" ]; then
		local USE_LATEST=1
	fi
	select_kernel
}

test_get_kernel_latest() {
	source ${BATS_TEST_DIRNAME}/../variables
	source ${BATS_TEST_DIRNAME}/../functions
	select_kernel
	local USE_LATEST=1
	get_kernel_archive
}
