#! /bin/bash

die() {
    echo >&2 "[`date +'%Y-%m-%d %T'`] $@"
    exit 1
}

log() {
  if [[ "$@" ]]; then echo "[`date +'%Y-%m-%d %T'`] $@";
  else echo; fi
}

cd /usr/libexec/bacula/

PSQL_OPTS="-h ${DB_HOST} -U postgres"

createuser ${PSQL_OPTS} -d -R bacula || die "Failed to create user"
./create_bacula_database ${PSQL_OPTS} || die "Failed to create bacula database"
./make_bacula_tables  ${PSQL_OPTS} || die "Failed to make bacula tables"
./grant_bacula_privileges ${PSQL_OPTS} || die "Failed to grant bacula priviledges"

psql ${PSQL_OPTS} --command="alter user bacula with password '${BACULA_DB_PASSWORD}';" bacula || die "Failed to set database bacula user password"

log "Initialization completed without errors"
