# Pipper - Python Virtual Environment Manager

Pipper intends to make working with pip a bit easier.

## Features

- Create a Python virtual environment.
- Activate a virtual environment.
- Install packages from a `requirements.txt` file.
- Freeze installed packages to update the `requirements.txt` file.
- Uninstall packages listed in the `requirements.txt` file.

## Usage

### Installation

Note: Pipper requires a Bash shell.

Pipper can be used without installation by running the `pipper.sh` script directly. However, if you want to make it globally accessible, you can install it as follows:

1. Clone the Pipper repository to your local machine:

```bash
git clone https://github.com/jzombie/pipper.git
```

2. Navigate to the Pipper directory:

```bash
cd pipper
```

3. Make the `pipper.sh` script executable:

```bash
chmod +x pipper.sh
```

4. Create a symbolic link to the script in a directory that's in your system's `PATH`, such as `/usr/local/bin`:

```bash
sudo ln -s $(pwd)/pipper.sh /usr/local/bin/pipper
```

Now, you can use Pipper as a global command by typing `pipper` in your terminal.

### Commands

Pipper supports the following commands:

- `create`: Create a Python virtual environment.

- `activate`: Display activation instructions for the virtual environment.

- `install`: Install packages listed in the `requirements.txt` file in the virtual environment.

- `freeze`: Freeze the installed packages into the `requirements.txt` file.

- `uninstall`: Uninstall ALL packages listed in the `requirements.txt` file from the virtual environment.

### Custom Python Environment

To create a virtual environment with a custom Python interpreter, use the create command followed by the path or alias of the desired Python version. For example:

```bash
pipper create python3.8
```

This command will attempt to create a virtual environment using Python 3.8, if it's available on your system.

### Example Workflow

Here's an example of how to use Pipper to manage a Python project:

1. Create a virtual environment.

2. Activate the virtual environment (follow the displayed instructions).

3. Install project dependencies from a `requirements.txt` file.

4. As you work on your project and install new packages, periodically freeze the requirements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Enjoy using Pipper for managing your Python virtual environments and dependencies! If you encounter any issues or have suggestions for improvements, feel free to contribute to the project on GitHub.
