# If someone visits the file and wonders why there are so many comments — bruh, I’ve got a weak memory and I forget things easily.

# Importing Jenkins image version 2.504.1 LTS with Java 21 preinstalled
FROM jenkins/jenkins:2.504.1-lts-jdk21

# Switch to root user to install packages and perform system-level operations
USER root

# Update package lists and install lsb-release (for detecting distro) and pip for Python 3
RUN apt-get update && apt-get install -y lsb-release python3-pip

# Download Docker's GPG key for package verification
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

# Add the Docker APT repository so Docker CLI can be installed
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Install Docker CLI
RUN apt-get update && apt-get install -y docker-ce-cli

# Switch back to Jenkins user for plugin installations
USER jenkins

# Install required Jenkins plugins for Blue Ocean and GitHub integration
RUN jenkins-plugin-cli --plugins \
  "blueocean:2.504.1-1 \
   docker-workflow:2.504.1-1 \
   pipeline-github-lib:1.0.0 \
   github-branch-source:1.0.0 \
   git-client:4.12.0"