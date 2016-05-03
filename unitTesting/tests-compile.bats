#!/usr/bin/env bats

load tests-helper
load tests-functions

## Test to ensure BATS itself is working

@test "Confirm BATS is working properly" {
	result="$(echo 2+2 | bc)"
	assert_equal ${result} 4
}

## Actual tests
@test "Test local folder write permission" {
	run test_write_permission
	assert_success
}

# Test Sourcing of Files
@test "Confirm colors" {
	run stat ${BATS_TEST_DIRNAME}/../colors
	assert_success
}

@test "Confirm variables" {
	run stat ${BATS_TEST_DIRNAME}/../compile_variables
	assert_success
}

@test "Confirm functions" {
	run stat ${BATS_TEST_DIRNAME}/../functions
	assert_success
}

@test "Test request exit" {
	run test_reqexit
	assert_success
}

@test "Test check dependencies" {
	run test_checkdeps
	assert_success
}

@test "Test retrieving kernel list" {
	run test_print_kernels
	assert_success
}

@test "Test selecting kernel with latest option" {
	run test_select_kernel latest
	assert_success
}

@test "Test retrieving the lastest kernel" {
	skip
	run test_get_kernel_latest latest
	assert_success
}
