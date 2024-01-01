#!/bin/bash

# Define the path to the pipper.sh script
PIPPER_SCRIPT="./pipper.sh"

# Helper function to check if a directory exists
dir_exists() {
    [ -d "$1" ]
}

# Helper function to check if a file exists
file_exists() {
    [ -f "$1" ]
}

# Function to run a test command, check its success, and handle expected failures
run_test() {
    test_command=$1
    test_title=$2
    expect_failure=${3:-false}

    echo "Running test: $test_title"
    eval $test_command
    result=$?

    if [ $result -ne 0 ]; then
        if [ "$expect_failure" = true ]; then
            echo "$test_title: Passed (Failure was expected)"
        else
            echo "$test_title: Failed"
            exit -1
        fi
    else
        if [ "$expect_failure" = true ]; then
            echo "$test_title: Failed (Success was unexpected)"
            exit -1
        else
            echo "$test_title: Passed"
        fi
    fi
}

# Function to run a test that is expected to fail
run_failure_test() {
    test_command=$1
    test_title=$2

    run_test "$test_command" "$test_title" true
}

# Test with an invalid Python version (failure is expected)
run_failure_test "$PIPPER_SCRIPT create python8" "Invalid Python Version Test"

# Test with a valid Python version (success is expected)
run_test "$PIPPER_SCRIPT create python3 && dir_exists venv" "Valid Python Version Test"

# Test the create_venv function (success is expected)
run_test "$PIPPER_SCRIPT create && dir_exists venv" "Create Virtual Environment Test"

# Test the activate_venv function (success is expected)
activate_output=$($PIPPER_SCRIPT activate | tr -d '\n')
expected_output="To activate the virtual environment, run:source venv/bin/activate"
run_test "[ \"$activate_output\" == \"$expected_output\" ]" "Activate Virtual Environment Test" 

# Test the install_requirements function (success is expected)
run_test "$PIPPER_SCRIPT create && echo 'requests==2.25.1' > requirements.txt && $PIPPER_SCRIPT install" "Install Requirements Test" 

# Test the freeze_requirements function (success is expected)
run_test "$PIPPER_SCRIPT create && echo 'requests==2.25.1' > requirements.txt && $PIPPER_SCRIPT freeze && file_exists requirements.txt" "Freeze Requirements Test" 

# Test the uninstall_requirements function (success is expected)
run_test "$PIPPER_SCRIPT create && echo 'requests==2.25.1' > requirements.txt && $PIPPER_SCRIPT install && $PIPPER_SCRIPT uninstall" "Uninstall Requirements Test" 

# Cleanup: Remove the virtual environment and requirements.txt
rm -rf venv requirements.txt
