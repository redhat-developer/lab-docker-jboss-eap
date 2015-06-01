#!/bin/sh

set -e

repo=${NEXUS_SERVICE_HOST}:${NEXUS_SERVICE_PORT}
nexus="http://$repo/nexus/"
git="http://${WWW_SERVICE_HOST}:${WWW_SERVICE_PORT}/ticket-monster.git"

echo "Checking for git on $git. Press Ctrl-C twice to abort at any time."
curl --output /dev/null --silent --head --fail $git
echo "Git is available."

cd /tmp
rm -rf ticket-monster
git clone $git 
cd ticket-monster
mkdir -p ~/.m2
sed s/classroom\.example\.com:8081/$repo/ < settings.xml > ~/.m2/settings.xml

# Wait for Nexus to be available

echo "Checking for Nexus on $nexus."
curl --output /dev/null --silent --head --fail $nexus
echo "Nexus is available."

source /opt/rh/maven30/enable
mvn clean package
mvn clean package -Parq-jbossas-remote -Dmaven.test.failure.ignore=true
! mvn clean package jboss-as:deploy
echo "Nexus cache should now be primed"
exit 0

