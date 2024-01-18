# Use an official Python base image
FROM python:3.11

# Avoid interactive dialogues by setting this environment variable
ENV DEBIAN_FRONTEND=noninteractive

# Copy project files
COPY . /pipper

# Install Pipper globally
RUN ln -s /pipper/pipper.sh /usr/local/bin/pipper

# Set the working directory
WORKDIR /projects

# Command to run when starting the container
CMD ["/bin/bash"]
