FROM rhel7.1
MAINTAINER Pete Muir <pmuir@redhat.com> 

USER root

# Install Java JDK and Maven

RUN yum --enablerepo=rhel-server-rhscl-7-rpms -y install java-1.7.0-openjdk-devel maven30 git; yum clean all;
ENV JAVA_HOME /usr/lib/jvm/jre

ADD populate.sh .
CMD ["./populate.sh"]

