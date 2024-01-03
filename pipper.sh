#!/bin/bash

set -e  # Exit immediately if any command returns a non-zero exit status.

# Default name for the virtual environment
VENV_NAME="venv"

# Function to create a virtual environment.
# Accepts an optional Python interpreter version as an argument.
create_venv() {
    local PYTHON
    # If a specific Python interpreter is provided, use it.
    if [ -n "$1" ]; then
        # Check if the specified Python interpreter exists.
        if command -v "$1" &>/dev/null; then
            PYTHON="$1"
        else
            # Exit if the specified interpreter is not found.
            echo "Error: Python interpreter '$1' not found."
            exit 1
        fi
    # Automatically select a Python interpreter if none is provided.
    elif command -v python3 &>/dev/null; then
        PYTHON=python3
    elif command -v python &>/dev/null; then
        PYTHON=python
    else
        # Exit if no suitable Python interpreter is found.
        echo "Error: Neither Python 3 nor Python is available."
        exit 1
    fi

    # Attempt to create a virtual environment with the chosen interpreter.
    if ! $PYTHON -m venv "$VENV_NAME"; then
        echo "Error: Failed to create virtual environment with $PYTHON."
        exit 1
    fi
    echo "Virtual environment '$VENV_NAME' created."

    # Activate the newly created virtual environment.
    printf "\n\n"
    activate_venv false
}

# Function to launch a sub-shell with the virtual environment activated.
launch_venv_shell() {
    if [ -d "$VENV_NAME" ]; then
        echo "Launching a sub-shell with the virtual environment activated..."

        # Define a command to activate the venv
        ACTIVATE_VENV="source $VENV_NAME/bin/activate"

        # Define a new PS1 prompt including 'pipper', Python version, virtual environment name, and current directory
        NEW_PS1="[pipper-shell python \$(python --version 2>&1 | cut -d ' ' -f 2) \$(basename $VENV_NAME)] \w \$"

        # Define a custom greeting message
        CUSTOM_GREETING=$'\nHello from pipper shell!'

        # Start a new shell instance with the venv activated and new PS1
        bash --init-file <(echo "$ACTIVATE_VENV; echo \"$CUSTOM_GREETING\"; export PS1=\"$NEW_PS1 \"")
    else
        echo "Virtual environment '$VENV_NAME' does not exist. Please create it first."
    fi
}



# Function to activate the virtual environment.
# Accepts a boolean argument to decide whether to activate it immediately.
activate_venv() {
    local activate="$1"
    if [ "$activate" = true ]; then
        # Activate the virtual environment.
        # shellcheck disable=SC1091
        # Purpose: This directive is used to disable ShellCheck warning SC1091.
        # Context: Warning SC1091 is triggered when ShellCheck encounters a 'source' or '.'
        #          command that includes a file not specified as input. This often happens
        #          when sourcing external scripts, such as activation scripts for virtual
        #          environments or other scripts that are not part of the project's repository.
        # Reason for Disabling: 
        # - The files being sourced are dynamically generated (like Python virtualenv's 'activate' script),
        #   and not available for ShellCheck to analyze.
        # - These files are standard and trusted, thus not posing a risk that necessitates ShellCheck analysis.
        # - Disabling this warning allows us to use such scripts without ShellCheck flagging them as issues,
        #   keeping the focus on actual potential problems in the script's own code.
        source "$VENV_NAME/bin/activate"
    else
        # Display instructions on how to activate the environment manually.
        printf "\n\n"
        echo "  To activate the virtual environment, run:"
        echo "  pipper shell"
        printf "\n\n"
    fi
}

# Function to install Python dependencies from a requirements file.
install_requirements() {
    if [ -f "requirements.txt" ]; then
        activate_venv true
        pip install -r requirements.txt
        echo "Requirements installed."
    else
        echo "requirements.txt not found."
    fi
}

# Function to freeze current Python dependencies into a requirements file.
freeze_requirements() {
    activate_venv true
    pip freeze > requirements.txt
    echo "Requirements frozen into requirements.txt."
}

# Function to uninstall Python dependencies listed in a requirements file.
uninstall_requirements() {
    if [ -f "requirements.txt" ]; then
        activate_venv true
        pip uninstall -y -r requirements.txt
        echo "Requirements uninstalled."
    else
        echo "requirements.txt not found."
    fi
}

# Function to run a specified Python script within the virtual environment.
run_script() {
    if [ -f "$1" ]; then
        activate_venv true
        python "$1"  # Execute the Python script
    else
        echo "Error: Script '$1' not found."
        exit 1
    fi
}

# Function to generate a command for running tests in dry-run mode.
run_tests_dry_run() {
    local source_dir="${1:-test}"
    local pattern="${2:-test*.py}"
    local command="source $VENV_NAME/bin/activate && python -m unittest discover -s '$source_dir' -p '$pattern'"

    # Return the generated command.
    echo "$command"
}

# Function to execute unit tests within the virtual environment.
run_tests() {
    local source_dir="${1:-test}"
    local pattern="${2:-test*.py}"
    local echo_flag=false

    # Check if '--echo' flag is used to print the command instead of executing.
    for arg in "$@"; do
        if [ "$arg" = "--echo" ]; then
            echo_flag=true
            break
        fi
    done

    # Check if the source directory for tests exists.
    # This prevents unittest from potentially discovering and running tests outside of intended locations.
    if [ ! -d "$source_dir" ]; then
        echo "Error: Source directory '$source_dir' does not exist."
        exit 1
    fi

    # Retrieve the command from run_tests_dry_run.
    local command
    command=$(run_tests_dry_run "$source_dir" "$pattern")

    # Either echo the command or execute it, based on the flag.
    if [ "$echo_flag" = true ]; then
        echo "$command"
    else
        eval "$command"
    fi
}

# Main command switch to execute the appropriate function based on input.
case $1 in
    create)
        create_venv "$2"
        ;;
    shell)
        launch_venv_shell
        ;;
    activate)
        activate_venv
        ;;
    install)
        install_requirements
        ;;
    freeze)
        freeze_requirements
        ;;
    uninstall)
        uninstall_requirements
        ;;
    run)
        run_script "$2"
        ;;
    test)
        run_tests "$2" "$3"
        ;;
    test-dry-run)
        run_tests_dry_run "$2" "$3"
        ;;
    *)
        # Note: "activate" is intentionally not included, as it is primarily for testing
        echo "Usage: $0 {create|shell|install|freeze|uninstall|run|test|test-dry-run}"
        ;;
esac
