#!/usr/bin/env bats

load tests-helper
load tests-functions

source ${BATS_TEST_DIRNAME}/../error_trap
source ${BATS_TEST_DIRNAME}/../colors
source ${BATS_TEST_DIRNAME}/../functions
source ${BATS_TEST_DIRNAME}/../variables

## Test to ensure BATS itself is working

@test "Confirm BATS is working properly" {
	result="$(echo 2+2 | bc)"
	assert_equal ${result} 4
}

## Actual tests
# Test Sourcing of Files
@test "Confirm colors" {
	run stat ${BATS_TEST_DIRNAME}/../colors
	assert_success
}

@test "Confirm variables" {
	run stat ${BATS_TEST_DIRNAME}/../variables
	assert_success
}

@test "Confirm functions" {
	run stat ${BATS_TEST_DIRNAME}/../functions
	assert_success
}

@test "Test local folder write permission" {
	run test_write_permission
	assert_success
}

@test "Test detect architecture" {
	run get_arch
	assert_success
}

@test "Test request exit" {
	run reqexit
	assert_success
}

@test "Test check dependencies" {
	run check_deps
	assert_success
}

@test "Test retrieving debian kernel archives list" {
	run get_debian_list
	assert_success
}

@test "Test retrieving ubuntu precompiled kernel list" {
	run print_kernels_ubu
	assert_success
}

@test "Test selecting latest kernel option" {
	run test_select_latest_kernel latest
	assert_success
}

#This will download and delete an archive which can be a substantial amount of time
@test "Test retrieving the lastest debian kernel" {
	#skip
	run test_get_latest_debian_kernal latest
	assert_success
}

@test "Test feedback spinner" {
	run test_spinner
	assert_success
}

@test "Test countdown timer" {
	run countdown TestMessage 5
	assert_success
}

@test "Test direct call to update function" {
	run update
	assert_success
}
