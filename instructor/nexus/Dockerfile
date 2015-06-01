FROM rhel7.1
MAINTAINER Thomas Qvarnstrom <tqvarnst@redhat.com>


USER root

##########################################################
# Install Java JDK, SSH and other useful cmdline utilities
##########################################################
RUN yum -y install java-1.7.0-openjdk-devel procps-ng unzip openssh-server iputils httpd-tools tar; yum clean all
ENV JAVA_HOME /usr/lib/jvm/jre

##########################################################
# Install Nexus
##########################################################
RUN mkdir -p /opt/sonatype-nexus /opt/sonatype-work; \
	curl -s -L http://www.sonatype.org/downloads/nexus-latest-bundle.tar.gz > /tmp/nexus-latest-bundle.tar.gz; \
	tar xzf /tmp/nexus-latest-bundle.tar.gz -C /opt/sonatype-nexus --strip-components=1; \
	rm -f /tmp/nexus-latest-bundle.tar*

RUN useradd --user-group --system --home-dir /opt/sonatype-nexus nexus

ADD nexus.xml /opt/sonatype-work/nexus/conf/nexus.xml

RUN chown -R nexus:nexus /opt/sonatype-work /opt/sonatype-nexus

USER nexus

ENV NEXUS_WEBAPP_CONTEXT_PATH /nexus

VOLUME /opt/sonatype-work/nexus/storage

CMD ["/opt/sonatype-nexus/bin/nexus","console"]
EXPOSE 8081
