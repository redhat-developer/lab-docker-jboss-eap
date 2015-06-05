FROM lab-base

# Clone TicketMonster from our git repo
RUN git clone http://classroom.example.com:5002/ticket-monster.git
WORKDIR ticket-monster

# Ask Maven to use the lab mirror, not the internet
RUN mkdir -p ~/.m2
RUN cp settings.xml ~/.m2/settings.xml

# Run the build
RUN /opt/rh/maven30/root/bin/mvn clean package -Ppostgresql 

# Mount the target directory where we'll place the prebuild binary.
VOLUME /target

# Deploy the application to a container when the docker container is run
CMD ["cp", "target/ticket-monster.war", "/target"]

