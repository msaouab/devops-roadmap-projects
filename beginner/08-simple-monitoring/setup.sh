#!/usr/bin/env bash
# setup.sh - install Netdata, add custom alerts + a custom dashboard section,
#            start it and open the dashboard. macOS (Homebrew) and Linux.
#
# Usage: ./setup.sh

set -euo pipefail
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"

# --- 1. Install --------------------------------------------------------------
if netdata_up; then
  step "Netdata is already running at $NETDATA_URL - skipping install"
elif [ "$OS" = "Darwin" ]; then
  command -v brew >/dev/null || die "Homebrew is required: https://brew.sh"
  step "Installing Netdata with Homebrew"
  brew list netdata >/dev/null 2>&1 || brew install netdata
  brew services start netdata
elif [ "$OS" = "Linux" ]; then
  step "Installing Netdata with the official kickstart script"
  tmp="$(mktemp)"
  curl -fsSL https://get.netdata.cloud/kickstart.sh -o "$tmp"
  as_root sh "$tmp" --non-interactive --stable-channel --disable-telemetry
  rm -f "$tmp"
else
  die "unsupported OS: $OS"
fi

# --- 2. Custom config --------------------------------------------------------
CONF="$(netdata_conf_dir)" || die "could not find netdata's config directory"
step "Installing custom alerts and dashboard section into $CONF"
as_root mkdir -p "$CONF/health.d" "$CONF/statsd.d"
as_root cp "$HERE/config/health.d/custom-alerts.conf" "$CONF/health.d/"
as_root cp "$HERE/config/statsd.d/demo-app.conf"      "$CONF/statsd.d/"
echo "  + health.d/custom-alerts.conf  (CPU > 80%, RAM > 80%)"
echo "  + statsd.d/demo-app.conf       (Demo App charts)"

# --- 3. Restart and verify ---------------------------------------------------
step "Restarting Netdata"
restart_netdata
wait_for_netdata || die "Netdata did not come up on $NETDATA_URL"

version=$(curl -s "$NETDATA_URL/api/v1/info" | sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' | head -1)
echo "  running: Netdata ${version:-?}"

# collectors register their charts a few seconds after a restart
IO_CHART=system.io; [ "$OS" = "Darwin" ] && IO_CHART=disk.io   # macOS names it differently
for c in system.cpu system.ram "$IO_CHART"; do
  found=""
  for _ in $(seq 1 20); do
    curl -sf "$NETDATA_URL/api/v1/chart?chart=$c" >/dev/null && { found=1; break; }
    sleep 1
  done
  if [ -n "$found" ]; then echo "  chart OK: $c"; else echo "  chart missing: $c"; fi
done

# the health engine starts a few seconds after the API
for a in custom_cpu_usage_high custom_ram_usage_high; do
  st=""
  for _ in $(seq 1 30); do st="$(alert_status "$a")"; [ -n "$st" ] && break; sleep 1; done
  if [ -n "$st" ]; then echo "  alert OK: $a ($st)"
  else echo "  warning: alert $a not loaded - check $CONF/health.d/custom-alerts.conf"; fi
done

step "Dashboard: $NETDATA_URL"
if [ "$OS" = "Darwin" ]; then open "$NETDATA_URL" 2>/dev/null || true
elif command -v xdg-open >/dev/null && [ -n "${DISPLAY:-}" ]; then xdg-open "$NETDATA_URL" >/dev/null 2>&1 || true
else echo "  On a remote server, tunnel it:  ssh -L 19999:localhost:19999 myserver  then open http://localhost:19999"
fi
echo "Next: ./test_dashboard.sh to put some load on the system."
