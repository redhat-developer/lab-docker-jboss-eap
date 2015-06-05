FROM pmuir/jboss-eap:1.0

RUN mkdir -p /opt/eap/customization
RUN curl -L http://classroom.example.com:5002/docker-jboss-eap/lab/postgres/execute.sh > /opt/eap/customization/execute.sh
RUN chmod u+x /opt/eap/customization/execute.sh

CMD ["/opt/eap/customization/execute.sh"]

