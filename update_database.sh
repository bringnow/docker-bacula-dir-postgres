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

./update_postgresql_tables ${PSQL_OPTS} || die "Failed to update database"
./grant_postgresql_privileges ${PSQL_OPTS} || die "Failed to grant privileges"

log "Database update completed without errors"
