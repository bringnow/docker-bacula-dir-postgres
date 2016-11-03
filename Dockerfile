FROM alpine:3.4
MAINTAINER Fabian Köster <mail@fabian-koester.com>

RUN apk add --no-cache bacula-pgsql inotify-tools openssl

VOLUME /etc/bacula
VOLUME /var/lib/bacula
VOLUME /etc/dhparam

COPY create_dhparam.sh first_run.sh mail_wrapper.sh entrypoint.sh update_database.sh /usr/local/bin/

ENTRYPOINT /usr/local/bin/entrypoint.sh

EXPOSE 9101
