#! /bin/sh

die () {
    echo >&2 "[`date +'%Y-%m-%d %T'`] $@"
    exit 1
}

log () {
  if [[ "$@" ]]; then echo "[`date +'%Y-%m-%d %T'`] $@";
  else echo; fi
}

BACULA_DIR_CONFIG="/etc/bacula/bacula-dir.conf"
BACULA_DIR_PID_FILE="/var/run/bacula-dir.9101.pid"
BACULA_DIR_COMMAND="/usr/sbin/bacula-dir -c ${BACULA_DIR_CONFIG}"

/usr/local/bin/create_dhparam.sh || die "Failed to generate dhparam"

/etc/init.d/nullmailer start || die "Failed to start nullmailer daemon"

rm -fv ${BACULA_DIR_PID_FILE} || die "Failed to remove stale PID file"

# Test configuration file first
${BACULA_DIR_COMMAND} -t || die "Configuration test failed"

# Launch bacula-dir
${BACULA_DIR_COMMAND} || die "Failed to start bacula-dir"

log "Bacula Director started"

# Check if config or certificates were changed and restart if necessary
while inotifywait -q -r --exclude '\.git/' -e modify -e create -e delete $BACULA_DIR_CONFIG /etc/letsencrypt; do
  log "Reloading bacula-dir because of configuration/certificate changes..."
  echo "reload" | bconsole
done
