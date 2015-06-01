FROM rhel7.1
MAINTAINER Pete Muir <pmuir@redhat.com>

USER root

RUN yum -y install git; yum clean all
VOLUME /mnt/store
VOLUME /mnt/lab
ADD clone.sh .

CMD ["./clone.sh"]

