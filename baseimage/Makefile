NAME="obc/baseimage"
VAGRANTIMAGE=packer_virtualbox-iso_virtualbox.box

all:
	packer build packer.json

$(VAGRANTIMAGE): packer.json
	packer build -only virtualbox-iso packer.json

docker:
	packer build -only docker packer.json

vagrant: $(VAGRANTIMAGE) remove
	vagrant box add -name $(NAME) $(VAGRANTIMAGE)

push:
	# You will need your ATLAS_TOKEN set for this to succeed
	packer push -name $(NAME) packer.json

remove:
	-vagrant box remove --box-version 0 $(NAME)

clean: remove
	-rm $(VAGRANTIMAGE)
