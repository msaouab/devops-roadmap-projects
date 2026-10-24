# shellcheck shell=bash
# Shared helpers for setup.sh / test_dashboard.sh / cleanup.sh

OS="$(uname -s)"
NETDATA_URL="${NETDATA_URL:-http://localhost:19999}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export HERE

step() { printf '\n==> %s\n' "$*"; }
die()  { echo "Error: $*" >&2; exit 1; }

# Where netdata keeps its config (differs by install method)
netdata_conf_dir() {
  local d
  for d in /etc/netdata /opt/netdata/etc/netdata \
           "$( command -v brew >/dev/null && brew --prefix 2>/dev/null)/etc/netdata"; do
    [ -n "$d" ] && [ -d "$d" ] && { echo "$d"; return 0; }
  done
  return 1
}

# Run as root on Linux, as the user on macOS (Homebrew refuses root)
as_root() {
  if [ "$OS" = "Darwin" ] || [ "$(id -u)" -eq 0 ]; then "$@"; else sudo "$@"; fi
}

netdata_up() { curl -sf --max-time 3 "$NETDATA_URL/api/v1/info" >/dev/null; }

restart_netdata() {
  if [ "$OS" = "Darwin" ]; then
    brew services restart netdata >/dev/null
  elif command -v systemctl >/dev/null && [ -d /run/systemd/system ]; then
    as_root systemctl restart netdata
  elif command -v rc-service >/dev/null; then
    as_root rc-service netdata restart
  else
    as_root killall netdata 2>/dev/null; as_root netdata
  fi
}

wait_for_netdata() {
  for _ in $(seq 1 30); do netdata_up && return 0; sleep 1; done
  return 1
}

cpu_count() {
  if [ "$OS" = "Darwin" ]; then sysctl -n hw.ncpu; else nproc 2>/dev/null || getconf _NPROCESSORS_ONLN; fi
}

# alert_status <name> -> CLEAR / WARNING / CRITICAL / UNDEFINED (empty if not found)
alert_status() {
  curl -s --max-time 3 "$NETDATA_URL/api/v1/alarms?all" 2>/dev/null | python3 -c '
import json, sys
try:
    alarms = json.load(sys.stdin).get("alarms", {})
except Exception:
    sys.exit()
for key, a in alarms.items():
    if key.endswith("." + sys.argv[1]):
        print(a.get("status", "")); break
' "$1" 2>/dev/null
}
