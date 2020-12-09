# Install .NET SDK

# we use APT over curl, if you want nightlies, make a branch.
# we need 3.1 for notebooks for now, you can opt multiple versions

PACKAGE_LIST = "dotnet-sdk-3.1 powershell "

if [ "${INSTALL_DOTNET5}" = "true" ]; then

    PACKAGE_LIST = ${PACKAGE_LIST} + "dotnet-sdk-5.0 " 

    echo "Packages to verify are installed: ${PACKAGE_LIST}"
    apt-get-update-if-needed
    apt-get -y install --no-install-recommends ${PACKAGE_LIST} 2> >( grep -v 'debconf: delaying package configuration, since apt-utils is not installed' >&2 )
fi
