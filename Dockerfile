# Use an official Python base image
FROM python:3.12

# Avoid interactive dialogues by setting this environment variable
ENV DEBIAN_FRONTEND=noninteractive

# Copy project files
COPY . /pipper

# Ensure the script is executable
RUN chmod +x /pipper/pipper.sh

# Install Pipper globally
RUN ln -s /pipper/pipper.sh /usr/local/bin/pipper

# Set the working directory
WORKDIR /projects

# Set default entrypoint to Bash, allowing command overrides.
# By default, this will drop the user into an interactive Bash shell
# with Pipper enabled inside the container.
# Alternatively, an arbitrary command can be executed when invoking the container.
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["bash"]
