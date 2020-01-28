FROM docker.io/fedora:31

MAINTAINER Andrew Cole <andrew.cole@illallangi.com>

RUN yum -y install vsftpd which; \
    yum -y update; \
    yum -y clean all

COPY contrib/confd-0.16.0-linux-amd64 /usr/local/bin/confd
COPY contrib/dumb-init_1.2.2_amd64 /usr/local/bin/dumb-init
COPY entrypoint.sh /entrypoint.sh
COPY confd/ /etc/confd/

RUN chmod +x \
        /entrypoint.sh \
        /usr/local/bin/confd \
        /usr/local/bin/dumb-init

EXPOSE 3000
VOLUME /var/www/html

ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/entrypoint.sh"]