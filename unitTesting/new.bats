#!/usr/bin/env bats

load tests-helper

source ${BATS_TEST_DIRNAME}/../error_trap
source ${BATS_TEST_DIRNAME}/../functions
source ${BATS_TEST_DIRNAME}/../variables

@test "Test get architecture" {
    run stat /tmp
    [ $status = 0 ]
}
