FROM jboss-eap-6/eap:6.4

RUN $JBOSS_HOME/bin/add-user.sh -g admin -u admin -p admin-123 -s


ENV JAVA_OPTS -client -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Xverify:none -Xms64m -Xmx256m -Dorg.apache.tomcat.util.LOW_MEMORY=true -XX:+UseCompressedOops -XX:+AggressiveOpts -XX:+DisableExplicitGC -Djava.net.preferIPv4Stack=true

ENV PRESERVE_JAVA_OPTS true

CMD $JBOSS_HOME/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0

EXPOSE 8080 9990 9999
