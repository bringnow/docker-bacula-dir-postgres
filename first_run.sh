#! /bin/bash

cd /usr/libexec/bacula/

PSQL_OPTS="-h ${DB_HOST} -U postgres"

createuser ${PSQL_OPTS} -d -R bacula
./create_bacula_database ${PSQL_OPTS}
./make_bacula_tables  ${PSQL_OPTS}
./grant_bacula_privileges ${PSQL_OPTS}

psql ${PSQL_OPTS} --command="alter user bacula with password '${BACULA_DB_PASSWORD}';" bacula
