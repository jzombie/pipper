# Pipper - Python Virtual Environment Manager

Pipper intends to make working with pip a bit easier.

Pipper is not intended to replace pip, and is intended to be used along-side pip.  If you're not using pip as your package manager, it is not recommended to use this project.

Pipper: **P**ackage **I**nstaller and **P**ython **P**roject **E**nvironment **R**unner

## Commands/Features

### Virtual Environment Preparation

- `pipper create`: Create a Python virtual environment. If you have more than one version of Python installed locally, you can do `pipper create python[python-version]`. (Note: Pipper uses the `venv` directory in your project and supports one environment at a time.)
- `pipper activate`: Activate a virtual environment; all other Pipper commands do this automatically for you.

### Virtual Environment Auto-Execution

The following commands automatically start the virtual environment for you and exit the virtual environment when done.

- `pipper install`: Install packages from a `requirements.txt` file (Note: if wanting to install a *specific* package, use `pip install [package-name]` instead).
- `pipper freeze`: Freeze installed packages to update the `requirements.txt` file.
- `pipper uninstall`: Uninstall packages listed in the `requirements.txt` file (Note: if wanting to uninstall a *specific* package, use `pip uninstall [package-name]` instead).
- `pipper run`: Run a Python script within the virtual environment.
- `pipper test`: Run unit tests within the virtual environment.

## Getting Started

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

### Custom Python Environment

To create a virtual environment with a custom Python interpreter, use the create command followed by the path or alias of the desired Python version. For example:

```bash
pipper create python3.8
```

This command will attempt to create a virtual environment using Python 3.8, if it's available on your system.

### Running Python Scripts

To run a Python script within the virtual environment, use the run command:

```bash
pipper run script.py
```

### Running Python Unit Tests

To run unit tests within the virtual environment, use the test command:

```bash
pipper test
```

By default, this command will discover and run unit tests located in the 'test' directory with filenames matching the pattern 'test*.py'.

You can also specify a custom source directory and file pattern using optional arguments as follows:

```bash
pipper test [source_directory] [file_pattern]
```

For example, to run tests located in the 'tests' directory with filenames ending in '_test.py', you can use:

```bash
pipper test tests '*_test.py'
```

Note: You can also do a "dry run" to just echo the command it "would have" generated via:

```bash
pipper test-try-run

# Produces:
# source venv/bin/activate && python -m unittest discover -s 'test' -p 'test*.py'
```

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
