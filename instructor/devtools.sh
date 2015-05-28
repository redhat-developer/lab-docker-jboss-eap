#!/bin/bash

repo="localhost:5000"
tag=1.0

BUILD_IMAGES='www nexus'

kubectl get pods | grep -q ^tools && echo "Tools are allready installed, Aborting";  exit || echo "Tools are not installed, building it may take a while"

for IMAGE in ${BUILD_IMAGES}; do
  docker build -t instructor/${IMAGE} /mnt/vagrant/${IMAGE}/
#  docker tag -f instructor/${IMAGE} $repo/instructor/${IMAGE}:$tag
#  docker push $repo/instructor/${IMAGE}:$tag
done

kubectl create -f tools.json
