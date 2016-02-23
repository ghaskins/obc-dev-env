# Baseimage Introduction
This directory contains the infrastructure for creating a new baseimage used as the basis for various functions within the openblockchain workflow such as our Vagrant based development environment, chaincode compilation/execution, unit-testing, and even cluster simulation. It is based on ubuntu-14.04 with various opensource projects added such as golang, rocksdb, grpc, and node.js. The actual openblockchain code is injected just-in-time before deployment.  The resulting images are published to public repositories such as [atlas.hashicorp.com](https://atlas.hashicorp.com/obc/boxes/baseimage) for consumption by Vagrant/developers and [hub.docker.com](https://hub.docker.com/r/openblockchain/baseimage/) for consumption by docker-based workflows.

The purpose of this baseimage is to act as a bridge between a raw ubuntu/trust64 configuration and the customizations required for supporting an openchain environment.  Some of the FOSS components that need to be added to Ubuntu do not have convenient native packages.  Therefore, they are built from source.  However, the build process is generally expensive (often taking in excess of 30 minutes) so it is fairly inefficient to JIT assemble these components on demand.

Therefore, the expensive FOSS components are built into this baseimage once and subsequently cached on the public repositories so that workflows may simply consume the objects without requiring a local build cycle.

# Intended Audience
This is only intended for release managers curating the base images on atlas and docker-hub.  Typical developers may safely ignore this directory completely.

Anyone wishing to customize their image is encouraged to do so via downstream means, such as the vagrant infrastructure in the root directory of this project or the Dockerfile.

## Exceptions

If a component is found to be both broadly applicable and expensive to build JIT, it may be a candidate for inclusion in a future baseimage.

# Usage

Note: Most variants of make will attempt to upload one or more artifacts at the conclusion of a successful build.  You need to have certain tokens set in your environment to establish credentials with the repositories.  Also note that you can prohibit the upload by purposely _not_ setting the tokens for cases where you only want to test locally.  See section below regarding Uploading Permissions for more details. 

* "make" will generate both a vagrant and docker image locally.
* "make vagrant" will build just the vagrant image and install it into the local environment as "obc/baseimage:v0", making it suitable to local testing.
  * To utilize the new base image in your local tests, run `vagrant destroy` then `USE_LOCAL_OBC_BASEIMAGE=true vagrant up`, also preface `vagrant ssh` as `USE_LOCAL_OBC_BASEIMAGE=true vagrant ssh` or simply export that variable, or Vagrant will fail to find the ssh key.
* "make docker" will build just the docker image and commit it to your local environment as "openblockchain/baseimage"
* "make push" will push the build configuration to atlas for cloud-hosted building of the images

## Uploading Permissions

The system relies on several environment variables to establish credentials with the hosting repositories:

* ATLAS_TOKEN - used to push both vagrant images and packer templates to atlas.hashicorp.com
* DOCKERHUB_[EMAIL|USERNAME|PASSWORD] - used to push docker images to hub.docker.com

Note that if you only plan on pushing the build to the atlas packer build service, you only need the ATLAS_TOKEN set as the dockerhub interaction will occur from the atlas side of the process where the docker credentials are presumably already configured.

## Versioning

Vagrant boxes are only versioned when they are submitted to a repository.  Vagrant does not support applying a version to a vagrant box via the `vagrant box add` command.  Adding the box gives it an implicit version of 0.  Setting `USE_LOCAL_OBC_BASEIMAGE=true` in the `vagrant up` command causes the Vagrant file in the the parent directory to pick version 0, instead of the default.
