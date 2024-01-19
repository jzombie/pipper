![Python Logo](https://www.python.org/static/community_logos/python-logo-master-v3-TM.png)

[![CI](https://github.com/jzombie/pipper/workflows/CI/badge.svg)](https://github.com/jzombie/pipper/actions/workflows/ci.yml)
[![ShellCheck](https://github.com/jzombie/pipper/workflows/ShellCheck/badge.svg)](https://github.com/jzombie/pipper/actions/workflows/shellcheck.yml)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/b83c0ce7f8924db99be96d045ffc4503)](https://app.codacy.com/gh/jzombie/pipper/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

# Pipper - Python Virtual Environment Manager

Pipper is a lightweight pip wrapper, using very minimal code, written in Bash.

## Why Not Use Poetry (or something else)?

Pip is standard in Python but some of its most basic functionality is hard to use. Pipper was written to help me personally understand pip a little bit more, without introducing so much functionality that this project would become hard to maintain.

I got a distaste for using Poetry when trying to use it to install `tensorflow` on my Mac without hacking around with dependency configuration: https://github.com/python-poetry/poetry/issues/8271.  I also don't like the fact that Poetry doesn't use requirements.txt and it generally just feels slower to me than using pip.

Poetry seems to be a great tool, but it should be compatible with pip, I believe, not try to replace it.

Pipper does not intend to replace `pip`, and I apologize if it appears like it does.

## Commands/Features

Note: All commands can be run from *outside* of the virtual environment and will automatically launch as needed.

- `pipper create`: Create a Python virtual environment. If you have more than one version of Python installed locally, you can do `pipper create python[python-version]`. (Note: Pipper uses the `venv` directory in your project and supports one environment at a time.)
- `pipper shell`: Drops into a Bash sub-shell already configured with the virtual environment.
- `pipper install`: Install ALL packages from a `requirements.txt` file (Note: if wanting to install a *specific* package, use `pip install [package-name]` instead).
- `pipper freeze`: Freeze installed packages to update the `requirements.txt` file.
- `pipper uninstall`: Uninstall ALL packages listed in the `requirements.txt` file (Note: if wanting to uninstall a *specific* package, use `pip uninstall [package-name]` instead).
- `pipper run`: Run a Python script within the virtual environment.
- `pipper test`: Run unit tests within the virtual environment (via `unittest`).

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
pipper test-dry-run

# Produces:
# source venv/bin/activate && python -m unittest discover -s 'test' -p 'test*.py'
```

### Example Workflow

Here's an example of how to use Pipper to manage a Python project:

1. Create a virtual environment.

2. Activate the virtual environment (follow the displayed instructions).

3. Install project dependencies from a `requirements.txt` file.

4. As you work on your project and install new packages, periodically freeze the requirements.

## Docker (for a quick development environment)

```bash
# The Python version can be changed by modifying the Dockerfile directly
docker build -t pipper .

# Defaults to a Bash shell at the /projects directory of the container
docker run -it pipper
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Enjoy using Pipper for managing your Python virtual environments and dependencies! If you encounter any issues or have suggestions for improvements, feel free to contribute to the project on GitHub.
