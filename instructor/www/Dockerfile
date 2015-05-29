FROM rhel7.1
MAINTAINER Thomas Qvarnstrom <tqvarnst@redhat.com>

USER root
RUN yum update; yum clean all; yum -y install httpd; ; yum clean all
VOLUME /var/www/html

CMD ["httpd","-DFOREGROUND"]

EXPOSE 80
