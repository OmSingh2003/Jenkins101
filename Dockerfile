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

# Install Docker CLI (Client only) to interact with a Docker daemon
RUN apt-get update && apt-get install -y docker-ce-cli

# Switch back to Jenkins user for plugin installations and regular operation
USER jenkins

# Install required Jenkins plugins using the plugin management tool
# Let the tool resolve the latest compatible versions for most plugins
RUN jenkins-plugin-cli --plugins \
  # blueocean: Provides a modern, visual user interface (Note: No longer actively developed)
  blueocean:latest \
  # docker-workflow: Enables the use of Docker commands within Jenkins Pipelines
  docker-workflow:latest \
  # pipeline-github-lib: Allows loading external Groovy libraries from GitHub
  pipeline-github-lib:latest \
  # github-branch-source: Enables creating Multibranch Pipeline jobs from GitHub
  github-branch-source:latest \
  # git-client: Provides core Git functionality
  git-client:latest

# The container will now run Jenkins with these tools and plugins pre-installed.
