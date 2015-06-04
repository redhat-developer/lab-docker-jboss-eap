#!/bin/bash

HTDOCS=/mnt/store/htdocs
REPO=$HTDOCS/ticket-monster.git
UPSTREAM=http://github.com/tqvarnst/docker-summit-lab-app.git

echo "Cloning TicketMonster repo from $UPSTREAM"
rm -rf $REPO
git clone --bare $UPSTREAM $REPO
cd $REPO
git update-server-info
mv hooks/post-update.sample hooks/post-update
chmod a+x hooks/post-update

REPO1=$HTDOCS/docker-jboss-eap.git
UPSTREAM1=/mnt/lab

echo "Cloning Lab repo from $UPSTREAM1"
rm -rf $REPO1
git clone --bare $UPSTREAM1 $REPO1
cd $REPO1
git update-server-info
mv hooks/post-update.sample hooks/post-update
chmod a+x hooks/post-update

curl -L https://jdbc.postgresql.org/download/postgresql-9.4-1201.jdbc41.jar > $HTDOCS/postgresql-9.4-1201.jdbc41.jar

REPO2=$HTDOCS/docker-jboss-eap
echo "Cloning Lab HEAD checkout from $UPSTREAM1"
rm -rf $REPO2
git clone $UPSTREAM1 $REPO2


