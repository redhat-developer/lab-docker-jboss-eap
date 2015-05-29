FROM rhel7.1
MAINTAINER Pete Muir <pmuir@redhat.com>

USER root

RUN yum update; yum clean all; yum -y install git; yum clean all
VOLUME /mnt/store
ADD clone.sh .

CMD ["./clone.sh"]

