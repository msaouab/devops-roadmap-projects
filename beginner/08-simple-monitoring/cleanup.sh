#!/usr/bin/env bash
# cleanup.sh - stop and remove Netdata and everything setup.sh added.
#
# Usage: ./cleanup.sh [-y]     (-y: don't ask for confirmation)

set -euo pipefail
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"

if [ "${1:-}" != "-y" ]; then
  printf 'This uninstalls Netdata and deletes its config and data. Continue? [y/N] '
  read -r answer
  case "$answer" in y|Y|yes) ;; *) echo "Aborted."; exit 0 ;; esac
fi

CONF="$(netdata_conf_dir || true)"
if [ -n "$CONF" ]; then
  step "Removing custom config from $CONF"
  as_root rm -f "$CONF/health.d/custom-alerts.conf" "$CONF/statsd.d/demo-app.conf"
fi

if [ "$OS" = "Darwin" ]; then
  step "Uninstalling Netdata (Homebrew)"
  brew services stop netdata 2>/dev/null || true
  brew uninstall --force netdata 2>/dev/null || true
  prefix="$(brew --prefix)"
  rm -rf "$prefix/etc/netdata" "$prefix/var/lib/netdata" "$prefix/var/cache/netdata" "$prefix/var/log/netdata"
else
  step "Uninstalling Netdata"
  uninstaller=""
  for u in /usr/libexec/netdata/netdata-uninstaller.sh /opt/netdata/usr/libexec/netdata/netdata-uninstaller.sh; do
    [ -x "$u" ] && uninstaller="$u" && break
  done
  if [ -n "$uninstaller" ]; then                      # kickstart install
    as_root "$uninstaller" --yes --force
  elif command -v dpkg >/dev/null && dpkg -s netdata >/dev/null 2>&1; then   # apt install netdata
    as_root systemctl stop netdata 2>/dev/null || as_root pkill -x netdata || true
    as_root env DEBIAN_FRONTEND=noninteractive apt-get purge -y -qq netdata netdata-core netdata-plugins-bash netdata-plugins-python netdata-web >/dev/null 2>&1 \
      || as_root env DEBIAN_FRONTEND=noninteractive apt-get purge -y -qq netdata
  elif command -v rpm >/dev/null && rpm -q netdata >/dev/null 2>&1; then     # dnf/yum install netdata
    as_root systemctl stop netdata 2>/dev/null || true
    if command -v dnf >/dev/null; then as_root dnf remove -y -q netdata; else as_root yum remove -y -q netdata; fi
  else
    tmp="$(mktemp)"
    curl -fsSL https://get.netdata.cloud/kickstart.sh -o "$tmp"
    as_root sh "$tmp" --uninstall --non-interactive
    rm -f "$tmp"
  fi
  as_root pkill -x netdata 2>/dev/null || true
  as_root rm -rf /etc/netdata /var/lib/netdata /var/cache/netdata /var/log/netdata /opt/netdata
fi

step "Checking"
sleep 2
if netdata_up; then echo "  Netdata still answers on $NETDATA_URL - check manually"; exit 1; fi
echo "  Netdata is gone. System cleaned up."
