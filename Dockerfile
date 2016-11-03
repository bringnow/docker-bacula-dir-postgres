FROM ubuntu:16.10
MAINTAINER Fabian Köster <mail@fabian-koester.com>

RUN echo "bacula-director-pgsql bacula-director-pgsql/dbconfig-install boolean false\n" \
      "nullmailer shared/mailname string foo\n" \
      "nullmailer nullmailer/relayhost string bar" | debconf-set-selections
RUN apt-get update && apt-get install -y --no-install-recommends \
    bacula-director-pgsql \
    inotify-tools \
    nullmailer \
    openssl \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

VOLUME /etc/bacula
VOLUME /var/lib/bacula
VOLUME /etc/dhparam

COPY create_dhparam.sh first_run.sh mail_wrapper.sh entrypoint.sh update_database.sh /usr/local/bin/

ENTRYPOINT /usr/local/bin/entrypoint.sh

EXPOSE 9101
