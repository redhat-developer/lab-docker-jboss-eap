#!/bin/bash

regex='^([^\/]*)/(.*):(.*)$'
repo="localhost:5000"

PULL_IMAGES='registry.access.redhat.com/rhel7.1:latest ce-registry.usersys.redhat.com/jboss-eap-6/eap:6.4 ce-registry.usersys.redhat.com/jboss-webserver-3/httpd:3.0'

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

# Wait for the registry to be available

echo "Checking for registry on http://$repo. Press Ctrl-C to abort at any time."
until $(curl --output /dev/null --silent --head --fail http://$repo); do printf '.'; sleep 5; done
echo "Registry is available."

# Then push the images 
for IMAGE in ${PULL_IMAGES}; do
    if [[ $IMAGE =~ $regex ]]; then
        server=${BASH_REMATCH[1]}
        name=${BASH_REMATCH[2]}
        tag=${BASH_REMATCH[3]}
    fi

    id_str=`docker inspect $IMAGE | grep Id`
    id=${id_str:11:-2}

    docker tag -f $id $repo/$name:$tag
    docker push $repo/$name:$tag
done

