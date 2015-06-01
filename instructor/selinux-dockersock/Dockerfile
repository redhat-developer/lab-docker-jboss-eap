FROM rhel7.1
MAINTAINER Pete Muir <pmuir@redhat.com>

USER root

RUN yum -y install git policycoreutils policycoreutils-python checkpolicy make; yum clean all
VOLUME /output
ADD make.sh /make.sh
CMD ["./make.sh"]

