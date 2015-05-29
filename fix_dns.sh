#!/bin/sh
vagrant ssh -c "printf 'DNS1=10.5.30.160\nPEERDNS=no' | sudo tee --append /etc/sysconfig/network-scripts/ifcfg-eth0 > /dev/null"
vagrant ssh -c "sudo /etc/init.d/network restart"
