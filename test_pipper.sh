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
    eval "$test_command"
    result=$?

    if [ $result -ne 0 ]; then
        if [ "$expect_failure" = true ]; then
            echo "$test_title: Passed (Failure was expected)"
        else
            echo "$test_title: Failed"
            exit 1
        fi
    else
        if [ "$expect_failure" = true ]; then
            echo "$test_title: Failed (Success was unexpected)"
            exit 1
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
expected_output="  To activate the virtual environment, run:  pipper shell"
run_test "[ \"$activate_output\" == \"$expected_output\" ]" "Activate Virtual Environment Test" 

# Test the install_requirements function (success is expected)
run_test "$PIPPER_SCRIPT create && echo 'requests==2.25.1' > requirements.txt && $PIPPER_SCRIPT install" "Install Requirements Test" 

# Test the freeze_requirements function (success is expected)
run_test "$PIPPER_SCRIPT create && echo 'requests==2.25.1' > requirements.txt && $PIPPER_SCRIPT freeze && file_exists requirements.txt" "Freeze Requirements Test" 

# Test the uninstall_requirements function (success is expected)
run_test "$PIPPER_SCRIPT create && echo 'requests==2.25.1' > requirements.txt && $PIPPER_SCRIPT install && $PIPPER_SCRIPT uninstall" "Uninstall Requirements Test" 

# Function to test pipper run
test_pipper_run() {
    # Create a temporary Python script
    echo "print('Hello, World!')" > temp_script.py

    # Run the script using pipper
    run_output=$($PIPPER_SCRIPT run temp_script.py 2>&1)

    # Check if the output is as expected
    expected_output="Hello, World!"
    if [ "$run_output" == "$expected_output" ]; then
        echo "Pipper Run Test: Passed"
    else
        echo "Pipper Run Test: Failed"
        echo "Expected: '$expected_output', but got: '$run_output'"
        exit 1
    fi

    # Cleanup: Remove the temporary script
    rm -f temp_script.py
}

# Test the pipper run command (success is expected)
test_pipper_run

# Function to test pipper run_tests with a dry run
test_pipper_run_tests_dry_run() {
    # Default args

    # Construct the expected output command
    expected_command="source venv/bin/activate && python -m unittest discover -s 'test' -p 'test*.py'"

    # Get the actual output command
    actual_output=$($PIPPER_SCRIPT test-dry-run)

    # Check if the actual output matches the expected command
    if [ "$actual_output" == "$expected_command" ]; then
        echo "Pipper Run Tests Echo Command Test: Passed"
    else
        echo "Pipper Run Tests Echo Command Test: Failed"
        echo "Expected: '$expected_command', but got: '$actual_output'"
        exit 1
    fi

    ####

    # Custom location

    # Construct the expected output command
    expected_command="source venv/bin/activate && python -m unittest discover -s 'custom-test-dir' -p 'test*.py'"

    # Get the actual output command
    actual_output=$($PIPPER_SCRIPT test-dry-run 'custom-test-dir' 'test*.py')

    # Check if the actual output matches the expected command
    if [ "$actual_output" == "$expected_command" ]; then
        echo "Pipper Run Tests Echo Command Test: Passed"
    else
        echo "Pipper Run Tests Echo Command Test: Failed"
        echo "Expected: '$expected_command', but got: '$actual_output'"
        exit 1
    fi
}


# Test the pipper run_tests command with --echo flag (success is expected)
test_pipper_run_tests_dry_run

# Test that test runner fails if test location is unavailable (failure is expected)
run_failure_test "$PIPPER_SCRIPT test" "Invalid Python Test Location"

# Function to test changing to sub_tree and running a Python script
test_sub_tree_run() {
    # Ensure the sub_tree directory exists
    mkdir -p sub_tree

    # Create a Python script in the sub_tree directory
    echo "import os" > sub_tree/sub_tree.py
    echo "print(os.getcwd())" >> sub_tree/sub_tree.py

    # Get the absolute path to the pipper.sh script
    PIPPER_SCRIPT_ABS="$(cd "$(dirname "$PIPPER_SCRIPT")" && pwd)/$(basename "$PIPPER_SCRIPT")"

    # Change to the sub_tree directory and run the script using pipper
    run_output=$(cd sub_tree && "$PIPPER_SCRIPT_ABS" run sub_tree.py 2>&1)

    # Check if the output is as expected
    expected_output=$(cd sub_tree && pwd) # "abs_path/pipper/sub_tree"

    if [ "$run_output" == "$expected_output" ]; then
        echo "Sub Tree Run Test: Passed"
    else
        echo "Sub Tree Run Test: Failed"
        echo "Expected: '$expected_output', but got: '$run_output'"
        exit 1
    fi

    # Cleanup: Remove the sub_tree directory
    rm -rf sub_tree
}


# Test the pipper run command in sub_tree (success is expected)
test_sub_tree_run

# Function to test launching a shell from any subdirectory
test_shell_from_sub_tree() {
    # Ensure the sub_tree directory exists
    mkdir -p sub_tree

    # Get the absolute path to the pipper.sh script
    PIPPER_SCRIPT_ABS="$(cd "$(dirname "$PIPPER_SCRIPT")" && pwd)/$(basename "$PIPPER_SCRIPT")"

    # Change to the sub_tree directory and launch the shell using pipper
    run_output=$(cd sub_tree && $PIPPER_SCRIPT_ABS shell -c "pwd" 2>&1)

    # Check if the output is as expected
    expected_output=$(cd sub_tree && pwd)

    if [[ "$run_output" == *"$expected_output"* ]]; then
        echo "Shell from Sub Tree Test: Passed"
    else
        echo "Shell from Sub Tree Test: Failed"
        echo "Expected: '$expected_output', but got: '$run_output'"
        exit 1
    fi

    # Cleanup: Remove the sub_tree directory
    rm -rf sub_tree
}

# Test launching the shell from a subdirectory (success is expected)
test_shell_from_sub_tree


# Cleanup: Remove the virtual environment and requirements.txt
rm -rf venv requirements.txt
