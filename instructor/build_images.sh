#!/bin/bash

repo="localhost:5000"
tag=1.0

BUILD_IMAGES='www nexus'

for IMAGE in ${BUILD_IMAGES}; do
  docker build -t instructor/${IMAGE} /mnt/vagrant/${IMAGE}/
  docker tag -f instructor/${IMAGE} $repo/instructor/${IMAGE}:$tag
  docker push $repo/instructor/${IMAGE}:$tag
done
