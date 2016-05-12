test_write_permission() {
	local TEST_FILE='test_file'
	touch "$TEST_FILE"
	echo "content" > "$TEST_FILE"

	rm "$TEST_FILE"
}

test_select_latest_kernel() {
	USE_LATEST=1
	select_kernel_deb
	select_kernel_ubu
}

test_get_latest_debian_kernel() {
	USE_LATEST=1
	select_kernel_deb
	get_kernel_archive
	#cleanupfiles
}

test_get_latest_ubuntu_precompiled_packages() {
	USE_LATEST=1
	print_kernels_ubu
	select_kernel_ubu
	get_precompiled_ubu_kernel	
	#cleanupfiles
}

test_spinner() {
	sleep 5 &
	spinner $!
	wait $!
}
