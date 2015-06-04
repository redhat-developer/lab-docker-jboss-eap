#!/bin/bash

# Usage: execute.sh [EAP mode] [configuration file]
#
# The default mode is 'standalone' and default configuration is based on the
# mode. It can be 'standalone.xml' or 'domain.xml'.

JBOSS_HOME=/opt/eap
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=${1:-"standalone"}
JBOSS_CONFIG=${2:-"$JBOSS_MODE.xml"}

function wait_for_server() {
  until `$JBOSS_CLI -c ":read-attribute(name=server-state)" 2> /dev/null | grep -q running`; do
    sleep 1
  done
}

DRIVER_VERSION=9.4-1201.jdbc41
DRIVER_URL=http://classroom.example.com:5002/postgresql-${DRIVER_VERSION}.jar

echo "Using Postgres Driver ${DRIVER_VERSION}"
curl -L $DRIVER_URL > postgresql.jar


echo "=> Starting JBoss EAP"
$JBOSS_HOME/bin/$JBOSS_MODE.sh -b 0.0.0.0 -c $JBOSS_CONFIG &

echo "=> Waiting for the server to boot"
wait_for_server

echo "=> Executing the commands"
echo "=> POSTGRES_HOST: " $POSTGRES_HOST
echo "=> POSTGRES_PORT: " $POSTGRES_PORT
echo "=> POSTGRES (docker host): " $POSTGRES_PORT_5432_TCP_ADDR
echo "=> POSTGRES (docker port): " $POSTGRES_PORT_5432_TCP_PORT
echo "=> POSTGRES (kubernetes host): " $POSTGRES_SERVICE_HOST
echo "=> POSTGRES (kubernetes port): " $POSTGRES_SERVICE_PORT

CONNECTION_URL="jdbc:postgresql://${POSTGRES_SERVICE_HOST:=$POSTGRES_PORT_5432_TCP_ADDR}:${POSTGRES_SERVIC_PORT:=$POSTGRES_PORT_5432_TCP_PORT}/postgres"

echo "=> POSTGRES Connection URL: " $CONNECTION_URL

#$JBOSS_CLI -c --file=`dirname "$0"`/commands.cli
$JBOSS_CLI -c << EOF
# Add PostgreSQL module
module add --name=org.postgresql --resources=postgresql.jar --dependencies=javax.api,javax.transaction.api

/subsystem=datasources/jdbc-driver=postgresql-jdbc4:add(driver-name=postgresql-jdbc4,driver-module-name=org.postgresql,driver-xa-datasource-class-name=org.postgresql.xa.PGXADataSource)

data-source add --name=PostgresDS --driver-name=postgresql-jdbc4 --connection-url=$CONNECTION_URL --jndi-name=java:jboss/datasources/TicketMonsterPostgreSQLDS --user-name=postgres --password=UsW4fznqLmGRh6 --max-pool-size=100 --enabled=true

EOF

echo "=> Shutting down JBoss EAP"
if [ "$JBOSS_MODE" = "standalone" ]; then
  $JBOSS_CLI -c ":shutdown"
else
  $JBOSS_CLI -c "/host=*:shutdown"
fi

echo "=> Restarting JBoss EAP"
$JBOSS_HOME/bin/$JBOSS_MODE.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -c $JBOSS_CONFIG

