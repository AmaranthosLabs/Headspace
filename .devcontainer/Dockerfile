# Headspace Dockerfile 

# repository to pull from - Microsoft Dotnet 5, Asp.Net
ARG REPO=mcr.microsoft.com/dotnet/aspnet

# Image we want from the repo: debian 10 - Slim see: https://stackoverflow.com/questions/59794891/how-does-debian-differ-from-debian-slim
FROM $REPO:5.0-buster-slim-amd64

# [Option] Install dotnet
ARG INSTALL_DOTNET5="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"
# [Option] Enable non-root Docker access in container
ARG ENABLE_NONROOT_DOCKER="true"
# [Option] Set the default OMZ theme
ARG OMZ_THEME="powerline"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG SOURCE_SOCKET=/var/run/docker-host.sock
ARG TARGET_SOCKET=/var/run/docker.sock
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY library-scripts/*.sh /tmp/library-scripts/
COPY dotfiles/* /tmp/dotfiles/

# Enable correct mode for dotnet watch (only mode supported in a container)
ENV DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Debian-10
    
# get Microsoft Repos

# install utils for setup
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt install -y --no-install-recommends \
    apt-utils curl wget sudo uidmap apt-transport-https ca-certificates lsb-release gnupg2
    
RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && sudo dpkg -i packages-microsoft-prod.deb
    
# Setup OS 
RUN sudo apt-get update \
    && sudo /bin/bash -c /tmp/scripts/setup-os.sh "${UPGRADE_PACKAGES}"

# setup user
RUN /tmp/scripts/setup-user.sh "${USERNAME}" 

# Use Docker script from script library to set up docker (inside this container)
RUN sudo /bin/bash -c /tmp/scripts/setup-docker.sh "${SOURCE_SOCKET}" "${TARGET_SOCKET}"

# Use Dotnet script from script library to set things up
RUN sudo /bin/bash -c /tmp/scripts/setup-dotnet.sh "${INSTALL_DOTNET}" "${USERNAME}"

# Clean up
RUN sudo apt-get autoremove -y \
    && sudo apt-get clean -y \
    && sudo rm -rf /var/lib/apt/lists/* /tmp/scripts/
