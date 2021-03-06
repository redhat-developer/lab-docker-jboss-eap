#!/bin/bash

set -e
regex='^([^\/]*)/(.*):(.*)$'
remote_repo="${REGISTRYSERVER_SERVICE_HOST}:${REGISTRYSERVER_SERVICE_PORT}"
repo=localhost:5000

PULL_IMAGES='registry.access.redhat.com/rhel7.1:latest ce-registry.usersys.redhat.com/jboss-eap-6/eap:6.4 ce-registry.usersys.redhat.com/jboss-webserver-3/httpd:3.0 docker.io/postgres:9.4'
PUSH_IMAGES="${PULL_IMAGES} lab/lab-base:latest"

# Pull all the images first
for IMAGE in ${PULL_IMAGES}; do
    if [[ $IMAGE =~ $regex ]]; then
        server=${BASH_REMATCH[1]}
        name=${BASH_REMATCH[2]}
        tag=${BASH_REMATCH[3]}
    fi

    #Only pull if the images doesn't exists locally
    if [ $(docker images | grep $server/$name | grep $tag | wc -l) -lt 1 ]; then
        docker pull $IMAGE
    fi
done

# Now build custom images

cd /lab/base
docker build -t lab/lab-base:latest .

# Wait for the registry to be available

echo "Checking for registry on http://$remote_repo/v1/_ping."
curl --output /dev/null --silent --head --fail http://$remote_repo/v1/_ping
echo "Registry is available."

# Then push the images 
for IMAGE in ${PUSH_IMAGES}; do
    if [[ $IMAGE =~ $regex ]]; then
        server=${BASH_REMATCH[1]}
        name=${BASH_REMATCH[2]}
        tag=${BASH_REMATCH[3]}
    fi

    id_str=`docker inspect $IMAGE | grep Id`
    id=${id_str:11:-2}

    t=$repo/$name:$tag

    echo "Attempting to push $t"
    docker tag -f $id $t
    docker push $t
done


