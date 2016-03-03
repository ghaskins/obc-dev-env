# Working with the Ubuntu Personal Package Archive (PPA) for OBC

## Introduction
The OBC environment makes use of PPAs to manage some of the dependencies that are consumed in various workflows such as the development environment or chaincode docker images.  This document is a cheat sheet for an individual or group whom may be responsible for maintaining the PPA collection over time.

It is beyond the scope of this document to cover ubuntu packaging in depth, as there are plentiful sources available that do a much more thorough job than I ever could.  For background, please consider the following links:

- [Ubuntu Packaging Guide](http://packaging.ubuntu.com/html/)
- [Launchpadhelp: Building a Source Package](https://help.launchpad.net/Packaging/PPA/BuildingASourcePackage)
- [Launchpadhelp: Uploading a package to a PPA](https://help.launchpad.net/Packaging/PPA/Uploading)

## Our environment

Our PPA is maintained at https://launchpad.net/~openblockchain and is a "restricted membership" team (meaning, you need to be invited in to have permission to update packages).  If you feel you should be granted write access, please contant [Sheehan Anderson](mailto:sheehan@us.ibm.com).  Despite the tight access controls, the packages produced by the PPA team are publically available for any internet-connected ubuntu installation to consume.

For instance, we currently have a [third party](https://launchpad.net/~openblockchain/+archive/ubuntu/third-party) PPA which, as the name implies, hosts third party packages that are unavailable elsewhere yet useful to OBC.  Users may gain access to the packages simply by issuing the following directive:

```
add-apt-repository ppa:openblockchain/third-party
```

From there, any standard "apt-get" operations should work the same way that they do for official ubuntu repositories including update notifications, etc.
