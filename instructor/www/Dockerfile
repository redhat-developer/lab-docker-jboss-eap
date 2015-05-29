FROM rhel7.1
MAINTAINER Thomas Qvarnstrom <tqvarnst@redhat.com>


USER root

RUN yum -y install git httpd

RUN git clone --bare https://github.com/tqvarnst/docker-summit-lab-app.git /var/www/html/ticket-monster.git
WORKDIR /var/www/html/ticket-monster.git
RUN git update-server-info
RUN mv hooks/post-update.sample hooks/post-update
RUN chmod a+x hooks/post-update
RUN chown -R apache:apache .

ADD index.html /var/www/html/



CMD ["httpd","-DFOREGROUND"]

EXPOSE 80
