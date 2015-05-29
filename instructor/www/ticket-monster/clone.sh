#!/bin/bash

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

