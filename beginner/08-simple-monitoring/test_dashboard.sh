#!/usr/bin/env bash
# test_dashboard.sh - generate CPU, memory and disk load + demo app metrics
#                     so you can watch the charts move and the alert fire.
#
# Usage: ./test_dashboard.sh [seconds]     (default: 90 - long enough for the 1-minute CPU alert)

set -euo pipefail
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"

DURATION="${1:-90}"
case "$DURATION" in ''|*[!0-9]*) die "duration must be a number of seconds" ;; esac
CPUS="$(cpu_count)"
WORK="$(mktemp -d)"
PIDS=()

cleanup() {
  [ ${#PIDS[@]} -gt 0 ] && kill "${PIDS[@]}" 2>/dev/null || true
  rm -rf "$WORK"
}
trap cleanup EXIT INT TERM

netdata_up || echo "Warning: Netdata is not reachable at $NETDATA_URL (run ./setup.sh first). Generating load anyway."

step "Load test for ${DURATION}s - watch $NETDATA_URL"

# CPU: one busy loop per core
echo "  CPU:    $CPUS busy loops"
for _ in $(seq 1 "$CPUS"); do
  ( end=$((SECONDS + DURATION)); while [ $SECONDS -lt $end ]; do :; done ) &
  PIDS+=($!)
done

# Memory: hold ~25% of RAM (capped at 2 GB) in a tmpfs-free way
if [ "$OS" = "Darwin" ]; then total_mb=$(( $(sysctl -n hw.memsize) / 1048576 ))
else total_mb=$(awk '/MemTotal/ {print int($2/1024)}' /proc/meminfo); fi
mem_mb=$(( total_mb / 4 )); [ "$mem_mb" -gt 2048 ] && mem_mb=2048
echo "  Memory: holding ${mem_mb} MB"
python3 -c "import time; b=bytearray($mem_mb*1048576); time.sleep($DURATION)" 2>/dev/null &
PIDS+=($!)

# Disk: write and read back a 256 MB file in a loop
echo "  Disk:   writing/reading 256 MB repeatedly"
(
  end=$((SECONDS + DURATION))
  while [ $SECONDS -lt $end ]; do
    dd if=/dev/zero of="$WORK/io.bin" bs=1048576 count=256 2>/dev/null
    sync
    dd if="$WORK/io.bin" of=/dev/null bs=1048576 2>/dev/null
    rm -f "$WORK/io.bin"
  done
) &
PIDS+=($!)

# Demo app: fake requests/errors/latency via StatsD (UDP 8125)
echo "  App:    sending StatsD metrics to the 'Demo App' section"
(
  end=$((SECONDS + DURATION))
  while [ $SECONDS -lt $end ]; do
    req=$((RANDOM % 50 + 50)); err=$((RANDOM % 5)); lat=$((RANDOM % 200 + 20))
    if command -v nc >/dev/null; then
      printf 'demoapp.requests:%d|c\ndemoapp.errors:%d|c\ndemoapp.latency:%d|ms\n' "$req" "$err" "$lat" \
        | nc -u -w0 127.0.0.1 8125 2>/dev/null || true
    fi
    sleep 1
  done
) &
PIDS+=($!)

# Progress + alert status
start=$SECONDS
while [ $((SECONDS - start)) -lt "$DURATION" ]; do
  sleep "${TICK:-10}"
  printf '  %3ds elapsed   CPU alert: %-9s RAM alert: %s\n' $((SECONDS - start)) \
    "$(alert_status custom_cpu_usage_high || true)" "$(alert_status custom_ram_usage_high || true)"
done

step "Done - load stopped. The alert clears about a minute after CPU drops."
