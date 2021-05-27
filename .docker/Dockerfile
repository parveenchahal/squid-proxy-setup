FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN dpkg-reconfigure apt-utils
RUN apt-get install -y libssl-dev pkg-config build-essential autoconf wget jq curl vim cron
RUN apt-get upgrade -y

RUN groupadd -g 456 squid
RUN useradd -g squid squid

RUN wget http://www.squid-cache.org/Versions/v4/squid-4.14.tar.gz
RUN tar -xvzf squid-4.14.tar.gz
RUN rm squid-4.14.tar.gz

WORKDIR /squid-4.14
RUN ./configure --with-openssl --enable-ssl-crtd --disable-arch-native
RUN make
RUN make install

RUN chmod 777 /usr/local/squid/var/logs
RUN /usr/local/squid/libexec/security_file_certgen -c -s /usr/local/squid/var/cache/squid/ssl_db -M 4MB

WORKDIR /
RUN rm -r /squid-4.14

COPY startup.sh .
RUN chmod +x startup.sh

COPY rotate_access_logs_and_cleanup.sh .
RUN chmod +x rotate_access_logs_and_cleanup.sh

EXPOSE 3128 3129
CMD ["bash", "startup.sh"]