#!/bin/bash

set -e  # Exit immediately on error

# Default name for the virtual environment
VENV_NAME="venv"

create_venv() {
    if [ -n "$1" ]; then
        if command -v "$1" &>/dev/null; then
            PYTHON="$1"
        else
            echo "Error: Python interpreter '$1' not found."
            exit 1
        fi
    elif command -v python3 &>/dev/null; then
        PYTHON=python3
    elif command -v python &>/dev/null; then
        PYTHON=python
    else
        echo "Error: Neither Python 3 nor Python is available."
        exit 1
    fi

    $PYTHON -m venv $VENV_NAME
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create virtual environment with $PYTHON."
        exit 1
    fi
    echo "Virtual environment '$VENV_NAME' created."

    echo ""
    echo ""
    activate_venv
}

activate_venv() {
    echo "To activate the virtual environment, run:"
    echo "source $VENV_NAME/bin/activate"
    printf "\n\n"
}

install_requirements() {
    if [ -f "requirements.txt" ]; then
        source $VENV_NAME/bin/activate  # Activate the virtual environment
        pip install -r requirements.txt
        echo "Requirements installed."
    else
        echo "requirements.txt not found."
    fi
}

freeze_requirements() {
    source $VENV_NAME/bin/activate  # Activate the virtual environment
    pip freeze > requirements.txt
    echo "Requirements frozen into requirements.txt."
}

uninstall_requirements() {
    if [ -f "requirements.txt" ]; then
        source $VENV_NAME/bin/activate  # Activate the virtual environment
        pip uninstall -y -r requirements.txt
        echo "Requirements uninstalled."
    else
        echo "requirements.txt not found."
    fi
}

run_script() {
    if [ -f "$1" ]; then
        source $VENV_NAME/bin/activate  # Activate the virtual environment
        python "$1"  # Run the Python script
    else
        echo "Error: Script '$1' not found."
    fi
}

run_tests_dry_run() {
    local source_dir="${1:-test}"
    local pattern="${2:-test*.py}"

    # Construct the command
    local command="source $VENV_NAME/bin/activate && python -m unittest discover -s '$source_dir' -p '$pattern'"

    # Echo the command
    echo "$command"
}

run_tests() {
    local source_dir="${1:-test}"
    local pattern="${2:-test*.py}"
    local echo_flag=false

    # Check for the '--echo' flag in all arguments
    for arg in "$@"; do
        if [ "$arg" = "--echo" ]; then
            echo_flag=true
            break
        fi
    done

    # Check if the source directory exists (this prevents unittest from potentially discovering and testing unintended locations)
    if [ ! -d "$source_dir" ]; then
        echo "Error: Source directory '$source_dir' does not exist."
        exit 1
    fi

    # Construct the command with an absolute path to the virtual environment
    local venv_path="$(pwd)/$VENV_NAME/bin/activate"
    local command="source $venv_path && python -m unittest discover -s '$source_dir' -p '$pattern'"

    # Echo the command if '--echo' flag is set
    if [ "$echo_flag" = true ]; then
        echo "$command"
    else
        # Execute the command within the same shell
        eval "$command"
    fi
}

# Command line arguments handling
case $1 in
    create)
        create_venv "$2"  # Pass the second argument to create_venv
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
        run_script "$2"  # Pass the second argument to run_script
        ;;
    test)
        run_tests "$2" "$3"
        ;;
    test-dry-run)
        run_tests_dry_run "$2" "$3"
        ;;
    *)
        echo "Usage: $0 {create|activate|install|freeze|uninstall|run|test|test-dry-run}"
        ;;
esac