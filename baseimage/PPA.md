# Working with the Ubuntu Personal Package Archive (PPA) for OBC

## Introduction
The OBC environment makes use of PPAs to manage some of the dependencies that are consumed in various workflows such as the development environment or chaincode docker images.  This document is a cheat sheet for an individual or group whom may be responsible for maintaining the PPA collection over time.

It is beyond the scope of this document to cover ubuntu packaging in depth, as there are plentiful sources available that do a much more thorough job than I ever could.  For background, please consider the following links:

- [Ubuntu Packaging Guide](http://packaging.ubuntu.com/html/)
- [Launchpadhelp: Building a Source Package](https://help.launchpad.net/Packaging/PPA/BuildingASourcePackage)
- [Launchpadhelp: Uploading a package to a PPA](https://help.launchpad.net/Packaging/PPA/Uploading)

## Our environment

Our PPA is maintained at https://launchpad.net/~openblockchain and is a "restricted membership" team (meaning, you need to be invited in to have permission to update packages).  If you feel you should be granted write access, please contact [Sheehan Anderson](mailto:sheehan@us.ibm.com).  Despite the tight access controls, the packages produced by the PPA team are publically available for any internet-connected ubuntu installation to consume.

For instance, we currently have a [third party](https://launchpad.net/~openblockchain/+archive/ubuntu/third-party) PPA which, as the name implies, hosts third party packages that are unavailable elsewhere yet useful to OBC.  Users may gain access to the packages simply by issuing the following directive:

```
add-apt-repository ppa:openblockchain/third-party
```

From there, any standard "apt-get" operations should work the same way that they do for official ubuntu repositories including update notifications, etc.

## Prerequisites

Ensure you have the following installed:
```
sudo apt-get install build-essential devscripts debhelper
```

## Packaging Software

You will often find yourself in one of two situations:
- You want to offer a package that currently does not have debian packaging available in the launchpad system
- You want to modify a package that is already in the system

### New Packages
For software that needs to be completely packaged from scratch, I find [this guide](http://packaging.ubuntu.com/html/packaging-new-software.html) helpful.

### Modifying Existing Packages
If the package is already in ubuntu (or a PPA, etc), an easy way to gain access to the package is to utilize the "apt-get source" function of apt.

Note: <apt-get source X> will only work if the "deb-src" source is enabled for a given repository.  It seems that add-apt-respository by default leaves the deb-src disabled.  You can fix this by editing the appropriate sources.list to remove the commented out source.  For instance:

```shell
vagrant@obc-devenv:v0.0.7-a3f379b:~ $ cat /etc/apt/sources.list.d/openblockchain-third-party-trusty.list
deb http://ppa.launchpad.net/openblockchain/third-party/ubuntu trusty main
#deb-src http://ppa.launchpad.net/openblockchain/third-party/ubuntu trusty main
```
From here, you are generally using a combination of locally editing the code/metadata, debuild -S, and dput to push the changes back out.  The links above offer much more detail.
