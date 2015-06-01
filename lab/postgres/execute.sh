#!/bin/bash

# Usage: execute.sh [WildFly mode] [configuration file]
#
# The default mode is 'standalone' and default configuration is based on the
# mode. It can be 'standalone.xml' or 'domain.xml'.

JBOSS_HOME=/opt/jboss/wildfly
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=${1:-"standalone"}
JBOSS_CONFIG=${2:-"$JBOSS_MODE.xml"}

function wait_for_server() {
  until `$JBOSS_CLI -c "ls /deployment" &> /dev/null`; do
    sleep 1
  done
}

DRIVER_VERSION=9.4-1201.jdbc41
DRIVER_URL=http://classroom.example.com/postgresql-${DRIVER_VERSION}.jar

echo "Using Postgres Driver ${DRIVER_VERSION}"
curl -L $DRIVER_URL > postgresql.jar


echo "=> Starting WildFly server"
$JBOSS_HOME/bin/$JBOSS_MODE.sh -b 0.0.0.0 -c $JBOSS_CONFIG &

echo "=> Waiting for the server to boot"
wait_for_server

echo "=> Executing the commands"
echo "=> POSTGRES_HOST: " $POSTGRES_HOST
echo "=> POSTGRES_PORT: " $POSTGRES_PORT
echo "=> POSTGRES (docker host): " $DB_PORT_5432_TCP_ADDR
echo "=> POSTGRES (docker port): " $DB_PORT_5432_TCP_PORT
echo "=> POSTGRES (kubernetes host): " $POSTGRES_SERVICE_HOST
echo "=> POSTGRES (kubernetes port): " $POSTGRES_SERVICE_PORT
#$JBOSS_CLI -c --file=`dirname "$0"`/commands.cli
$JBOSS_CLI -c << EOF
batch

# Add Postgres module
module add --name=com.mysql --resources=postgresql.jar --dependencies=javax.api,javax.transaction.api

# Add MySQL driver
/subsystem=datasources/jdbc-driver=postgres:add(driver-name=postgres,driver-module-name=org.postgres,driver-class-name=org.postgresql.Driver)

# Add the datasource
/subsystem=datasources/data-source=PostgresDS:add(jndi-name=java:jboss/datasources/TicketMonsterPostgreSQLDS, driver-name=postgresql-jdbc4, connection-url=jdbc:postgresql://${POSTGRES_SERVICE_HOST:=$POSTGRES_HOST}:${POSTGRES_SERVIC_PORT:=$POSTGRES_PORT}:/postgres,user-name=postgres,password=UsW4fznqLmGRh6)

# Execute the batch
run-batch
EOF

echo "=> Shutting down WildFly"
if [ "$JBOSS_MODE" = "standalone" ]; then
  $JBOSS_CLI -c ":shutdown"
else
  $JBOSS_CLI -c "/host=*:shutdown"
fi

echo "=> Restarting WildFly"
$JBOSS_HOME/bin/$JBOSS_MODE.sh -b 0.0.0.0 -c $JBOSS_CONFIG
