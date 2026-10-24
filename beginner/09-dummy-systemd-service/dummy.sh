#!/usr/bin/env bash
# dummy.sh - a fake background app: writes a log line every 10 seconds, forever.
# Started by systemd (Linux) or launchd (macOS); see dummy.service / macos/.

LOG_FILE="${DUMMY_LOG_FILE:-/var/log/dummy-service.log}"
INTERVAL="${DUMMY_INTERVAL:-10}"

mkdir -p "$(dirname "$LOG_FILE")"

log() {
  local line
  line="$(date '+%Y-%m-%d %H:%M:%S') [pid $$] $*"
  echo "$line" >> "$LOG_FILE"
  echo "$line"            # stdout -> journald (journalctl -u dummy) on Linux
}

trap 'log "Received stop signal, shutting down."; exit 0' TERM INT
log "Dummy service started (logging to $LOG_FILE every ${INTERVAL}s)"

n=0
while true; do
  n=$((n + 1))
  log "Dummy service is running... (heartbeat #$n)"
  sleep "$INTERVAL" &
  wait $!                 # wait on sleep so a stop signal is handled immediately
done
