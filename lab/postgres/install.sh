#!/bin/bash
DRIVER_VERSION=9.4-1201.jdbc41
DRIVER_URL=http://classroom.example.com/postgresql-${DRIVER_VERSION}.jar
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
MAIN_DIR=$DIR/main

# Make the main dir
mkdir -p $MAIN_DIR

# Place the driver in the main dir
echo "Using Postgres Driver ${DRIVER_VERSION}"
curl -L $DRIVER_URL > $MAIN_DIR/postgresql.jar

$EAP_HOME/bin/jboss-cli.sh --connect --file=configure-postgresql.cli

