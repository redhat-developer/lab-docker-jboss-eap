#!/bin/sh
git clone https://github.com/dpw/selinux-dockersock.git
cd selinux-dockersock
make dockersock.pp
cp dockersock.pp /output
