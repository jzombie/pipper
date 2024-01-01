#!/bin/bash

set -e  # Exit immediately on error

# Default name for the virtual environment
VENV_NAME="venv"

# Functions
create_venv() {
    python -m venv $VENV_NAME
    echo "Virtual environment '$VENV_NAME' created."
}

activate_venv() {
    echo "To activate the virtual environment, run:"
    echo "source $VENV_NAME/bin/activate"
    echo ""
    echo ""
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
        create_venv
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
