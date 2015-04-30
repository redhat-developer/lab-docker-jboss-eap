#!/bin/sh

# Create the store, and fix the SE Linux policy to allow the docker container to be able to access it
mkdir -p /home/vagrant/store/repositories && sudo chcon -Rt svirt_sandbox_file_t /home/vagrant/store/
/usr/bin/kubectl create -f /mnt/vagrant/registry.json

