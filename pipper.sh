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
    *)
        echo "Usage: $0 {create|activate|install|freeze|uninstall}"
        ;;
esac
