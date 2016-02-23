# Baseimage Introduction
This directory contains the infrastructure for creating a new baseimage used as the basis for various functions within the openblockchain workflow such as our Vagrant based development environment, chaincode compilation/execution, unit-testing, and even cluster simulation. It is based on ubuntu-14.04 with various opensource projects added such as golang, rocksdb, grpc, and node.js. The actual openblockchain code is injected just-in-time before deployment.  The resulting images are published to public repositories such as atlas.hashicorp.com for consumption by Vagrant/developers and hub.docker.com for consumption by docker-based workflows.

The purpose of this baseimage is to act as a bridge between a raw ubuntu/trust64 configuration and the customizations required for supporting an openchain environment.  Some of the FOSS components that need to be added to Ubuntu do not have convenient native packages.  Therefore, they are built from source.  However, the build process is generally expensive (often taking in excess of 30 minutes) so it is fairly inefficient to JIT assemble these components on demand.

Therefore, the expensive FOSS components are built into this baseimage once and subsequently cached on the public repositories so that workflows may simply consume the objects without requiring a local build cycle.

# Intended Audience
This is only intended for release managers curating the base images on atlas and docker-hub.  Typical developers may safely ignore this directory completely.

Anyone wishing to customize their image is encouraged to do so via downstream means, such as the vagrant infrastructure in the root directory of this project or the Dockerfile.

## Exceptions

If a component is found to be both broadly applicable and expensive to build JIT, it may be a candidate for inclusion in a future baseimage.

# Usage

* "make" will generate a new .box resource in the CWD, suitable for submission to atlas.
* "make install" will also install the .box into the local vagrant environment, making it suitable to local testing.
* To utilize the new base image in your local tests, run `vagrant destroy` then `USE_LOCAL_OBC_BASEIMAGE=true vagrant up`, also preface `vagrant ssh` as `USE_LOCAL_OBC_BASEIMAGE=true vagrant ssh` or simply export that variable, or Vagrant will fail to find the ssh key.

## Versioning

Vagrant boxes are only versioned when they are submitted to a repository.  Vagrant does not support applying a version to a vagrant box via the `vagrant box add` command.  Adding the box gives it an implicit version of 0.  Setting `USE_LOCAL_OBC_BASEIMAGE=true` in the `vagrant up` command causes the Vagrant file in the the parent directory to pick version 0, instead of the default.
