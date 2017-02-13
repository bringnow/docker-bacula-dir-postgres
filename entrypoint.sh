#! /bin/sh

die () {
    log_error $@
    exit 1
}

log () {
  echo "[`date +'%Y-%m-%d %T'`] $@";
}

log_error () {
  echo >&2 "[`date +'%Y-%m-%d %T'`] $@"
}

BACULA_DIR_CONFIG="/etc/bacula/bacula-dir.conf"
BACULA_DIR_PID_FILE="/var/run/bacula-dir.9101.pid"
BACULA_DIR_COMMAND="/usr/sbin/bacula-dir -c ${BACULA_DIR_CONFIG}"

/usr/local/bin/create_dhparam.sh || die "Failed to generate dhparam"

rm -fv ${BACULA_DIR_PID_FILE} || die "Failed to remove stale PID file"

# Test configuration file first
${BACULA_DIR_COMMAND} -t || die "Configuration test failed"

# Launch bacula-dir
${BACULA_DIR_COMMAND} || die "Failed to start bacula-dir"

log "Bacula Director started"

# Check if config or certificates were changed and restart if necessary
while inotifywait -q -r --exclude '\.git/' -e modify,create,delete,move,move_self /etc/bacula /etc/letsencrypt; do
  log "Configuration changes detected. Will restart bacula-dir in 60 seconds..."
  sleep 60
  pkill -F ${BACULA_DIR_PID_FILE} || log_error "Failed to kill bacula-dir"
  sleep 10
  ${BACULA_DIR_COMMAND} || die "Failed to restart bacula-dir"
  sleep 20
done
