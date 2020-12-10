# Install .NET SDK

# we use APT over curl, if you want nightlies, make a branch.
# we need 3.1 for notebooks for now, you can opt multiple versions

INSTALL_DOTNET_PKGS = ${1:-"dotnet-sdk-3.1 powershell"}

    echo "Packages to verify are installed: ${PACKAGE_LIST}"
    apt-get-update-if-needed
    apt-get -y install --no-install-recommends ${PACKAGE_LIST} 2> >( grep -v 'debconf: delaying package configuration, since apt-utils is not installed' >&2 )
fi
