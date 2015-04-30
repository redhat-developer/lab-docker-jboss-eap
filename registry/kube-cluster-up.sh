#!/bin/sh

for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler docker kube-proxy.service kubelet.service; do 
    sudo systemctl restart $SERVICES
    sudo systemctl enable $SERVICES
    sudo systemctl status $SERVICES 
done

