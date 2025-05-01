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
# Note: Some specified versions (e.g., 1.0.0) are very old and should likely be updated.
RUN jenkins-plugin-cli --plugins \
  # blueocean: Provides a modern, visual user interface for viewing Jenkins Pipelines. (Note: No longer actively developed)
  "blueocean:2.504.1-1 \
   # docker-workflow: Enables the use of Docker commands within Jenkins Pipelines (e.g., docker.build(), docker.image().inside() {}). Relies on Docker CLI.
   docker-workflow:2.504.1-1 \
   # pipeline-github-lib: Allows loading external Groovy libraries (Shared Libraries) directly from GitHub repositories using @Library('github.com/...') syntax in Jenkinsfiles.
   pipeline-github-lib:1.0.0 \
   # github-branch-source: Enables creating Multibranch Pipeline jobs that automatically discover branches and pull requests in GitHub repositories/organizations and manage corresponding Jenkins jobs.
   github-branch-source:1.0.0 \
   # git-client: Provides the core low-level Git functionality (clone, fetch, checkout etc.) required by Jenkins and other plugins like github-branch-source or the standard Git SCM. (Version 4.12.0 is outdated)
   git-client:4.12.0"

# The container will now run Jenkins with these tools and plugins pre-installed.