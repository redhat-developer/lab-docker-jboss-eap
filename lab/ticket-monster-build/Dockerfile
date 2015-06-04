FROM rhel7.1

USER root

# Install Java JDK and Maven

RUN yum --enablerepo=rhel-server-rhscl-7-rpms -y install java-1.7.0-openjdk-devel maven30 git; yum clean all;
ENV JAVA_HOME /usr/lib/jvm/jre

# Clone TicketMonster from our git repo
RUN git clone http://classroom.example.com:5002/ticket-monster.git
WORKDIR ticket-monster

# Ask Maven to use the lab mirror, not the internet
RUN mkdir -p ~/.m2
RUN cp settings.xml ~/.m2/settings.xml

# Use Maven from Red Hat Software Collections
RUN source /opt/rh/maven30/enable

# Run the build
RUN mvn clean package -Ppostgresql 

# Deploy the application to a container when the docker container is run
CMD ["mvn", "jboss-as:deploy"]

