#!/bin/bash

set -e

HTDOCS=/mnt/store/htdocs
REPO=$HTDOCS/ticket-monster.git
UPSTREAM=http://github.com/tqvarnst/docker-summit-lab-app.git

if [ -d "$REPO" ]; then
  echo "Updating TicketMonster repo from $UPSTREAM"
  cd $REPO
  git fetch $UPSTREAM 
else
  echo "Cloning TicketMonster repo from $UPSTREAM"
  git clone --bare $UPSTREAM $REPO
  cd $REPO
  git update-server-info
  mv hooks/post-update.sample hooks/post-update
  chmod a+x hooks/post-update
fi

REPO1=$HTDOCS/docker-jboss-eap.git
UPSTREAM1=/mnt/lab

if [ -d "$REPO1" ]; then
  echo "Updating Lab repo from $UPSTREAM1"
  cd $REPO1
  git fetch $UPSTREAM1
else
  echo "Cloning Lab repo from $UPSTREAM1"
  git clone --bare $UPSTREAM1 $REPO1
  cd $REPO1
  git update-server-info
  mv hooks/post-update.sample hooks/post-update
  chmod a+x hooks/post-update
fi

