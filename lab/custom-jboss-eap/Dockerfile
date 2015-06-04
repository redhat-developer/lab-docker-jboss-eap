FROM jboss-eap-6/eap:6.4

RUN $JBOSS_HOME/bin/add-user.sh -g admin -u admin -p admin-123 -s

CMD $JBOSS_HOME/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0

EXPOSE 8080 9990 9999
