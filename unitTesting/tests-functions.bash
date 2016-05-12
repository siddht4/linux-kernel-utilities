test_write_permission() {
	local TEST_FILE='test_file'
	touch "$TEST_FILE"
	echo "content" > "$TEST_FILE"

	rm "$TEST_FILE"
}

test_select_latest_kernel() {
	if [ "$1" = "latest" ]; then
		USE_LATEST=1
	fi
	USE_LATEST=1
	select_kernel_deb
	select_kernel_ubu
}

test_get_latest_debian_kernal() {
	print_kernels debian
	USE_LATEST=1
	select_kernel
	get_kernel_archive
}

test_spinner() {
	sleep 5 &
	spinner $!
	wait $!
}
