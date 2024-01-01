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

# Function to exit with -1 on failure
exit_on_failure() {
    echo "$1"
    exit -1
}

# Test with an invalid Python version
echo "Testing with an invalid Python version..."
$PIPPER_SCRIPT create python8
if [ $? -ne 0 ]; then
    echo "Test with invalid Python version passed"
else
    exit_on_failure "Test with invalid Python version failed"
fi

# Test with a valid Python version
echo "Testing with a valid Python version..."
$PIPPER_SCRIPT create python3
if [ $? -eq 0 ] && dir_exists "venv"; then
    echo "Test with valid Python version passed"
else
    exit_on_failure "Test with valid Python version failed"
fi

# Test the create_venv function
echo "Testing create_venv function..."
$PIPPER_SCRIPT create
if [ $? -eq 0 ] && dir_exists "venv"; then
    echo "create_venv test passed"
else
    exit_on_failure "create_venv test failed"
fi

# Test the activate_venv function
echo "Testing activate_venv function..."
output=$($PIPPER_SCRIPT activate | tr -d '\n')  # Remove newlines for comparison
expected_output="To activate the virtual environment, run:source venv/bin/activate"

if [ "$output" == "$expected_output" ]; then
    echo "activate_venv test passed"
else
    exit_on_failure "activate_venv test failed"
fi

# Test the install_requirements function
echo "Testing install_requirements function..."
$PIPPER_SCRIPT create  # Create the virtual environment
if [ $? -eq 0 ]; then
    # Use a real package for testing
    echo "requests==2.25.1" > requirements.txt
    $PIPPER_SCRIPT install
    if [ $? -eq 0 ]; then
        echo "install_requirements test passed"
    else
        exit_on_failure "install_requirements test failed"
    fi
else
    exit_on_failure "install_requirements test failed (preparation step)"
fi

# Test the freeze_requirements function
echo "Testing freeze_requirements function..."
$PIPPER_SCRIPT create  # Create the virtual environment
if [ $? -eq 0 ]; then
    echo "package1==1.0" > requirements.txt
    $PIPPER_SCRIPT freeze
    if [ $? -eq 0 ] && file_exists "requirements.txt"; then
        echo "freeze_requirements test passed"
    else
        exit_on_failure "freeze_requirements test failed"
    fi
else
    exit_on_failure "freeze_requirements test failed (preparation step)"
fi

# Test the uninstall_requirements function
echo "Testing uninstall_requirements function..."
$PIPPER_SCRIPT create  # Create the virtual environment
if [ $? -eq 0 ]; then
    # Use a real package for testing
    echo "requests==2.25.1" > requirements.txt
    $PIPPER_SCRIPT install  # Install requirements
    if [ $? -eq 0 ]; then
        $PIPPER_SCRIPT uninstall
        if [ $? -eq 0 ]; then
            echo "uninstall_requirements test passed"
        else
            exit_on_failure "uninstall_requirements test failed"
        fi
    else
        exit_on_failure "uninstall_requirements test failed (install step)"
    fi
else
    exit_on_failure "uninstall_requirements test failed (preparation step)"
fi

# Cleanup: Remove the virtual environment and requirements.txt
rm -rf venv requirements.txt
