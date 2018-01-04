FROM debian:stable
MAINTAINER info+squid@webkult.de

ENV SQUID_VERSION=3.3.8 \
    SQUID_CACHE_DIR=/var/spool/squid3 \
    SQUID_LOG_DIR=/var/log/squid3 \
    SQUID_USER=proxy


RUN apt-get update && apt-get install -y --no-install-recommends squid3 squidguard wget

COPY config/squid/squid.conf /etc/squid3/squid.conf
COPY config/squid/squid.passwd /etc/squid3/passwd
COPY config/squid/entrypoint.sh /sbin/entrypoint.sh
COPY config/squid/squidGuard.conf /etc/squidguard/squidGuard.conf

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp

VOLUME ["${SQUID_CACHE_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
