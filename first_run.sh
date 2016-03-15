#! /bin/bash

cd /usr/libexec/bacula/

PSQL_OPTS="-h ${DB_PORT_5432_TCP_ADDR} -U postgres"

./create_postgresql_database ${PSQL_OPTS}
./make_postgresql_tables ${PSQL_OPTS}
./grant_postgresql_privileges ${PSQL_OPTS}
