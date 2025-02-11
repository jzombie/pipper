# Use an official Python base image
FROM python:3.12

# Avoid interactive dialogues by setting this environment variable
ENV DEBIAN_FRONTEND=noninteractive

# Copy project files
COPY . /pipper

# Install Pipper globally using the install command (sets executable permissions)
RUN install -m 755 /pipper/pipper.sh /usr/local/bin/pipper

# Set the working directory
WORKDIR /projects

# Set default entrypoint to Bash, allowing command overrides.
# By default, this will drop the user into an interactive Bash shell
# with Pipper enabled inside the container.
# Alternatively, an arbitrary command can be executed when invoking the container.
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["bash"]
