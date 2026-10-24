#!/usr/bin/env bash
# install-fail2ban.sh - stretch goal: protect SSH against brute force.
# Run ON THE SERVER (Linux: Debian/Ubuntu, Fedora/RHEL/Rocky, Alpine):
#   scp server/install-fail2ban.sh server/jail.local myserver:
#   ssh myserver 'sudo bash install-fail2ban.sh'

set -euo pipefail
[ "$(uname -s)" = "Linux" ] || { echo "Run this on the Linux server, not locally." >&2; exit 1; }
[ "$(id -u)" -eq 0 ] || { echo "Run with sudo." >&2; exit 1; }

HERE="$(cd "$(dirname "$0")" && pwd)"

echo "==> Installing fail2ban"
if   command -v apt-get >/dev/null; then apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq fail2ban
elif command -v dnf     >/dev/null; then dnf install -y -q epel-release 2>/dev/null || true; dnf install -y -q fail2ban
elif command -v yum     >/dev/null; then yum install -y -q epel-release; yum install -y -q fail2ban
elif command -v apk     >/dev/null; then apk add --quiet fail2ban
else echo "Unsupported distro: install fail2ban manually." >&2; exit 1; fi

echo "==> Writing /etc/fail2ban/jail.local"
if [ -f "$HERE/jail.local" ]; then
  cp "$HERE/jail.local" /etc/fail2ban/jail.local
else
  printf '[sshd]\nenabled = true\nmaxretry = 5\nfindtime = 10m\nbantime = 1h\n' > /etc/fail2ban/jail.local
fi
# Ubuntu 24.04+/Debian 12+ log SSH to journald instead of /var/log/auth.log
if [ ! -f /var/log/auth.log ] && [ ! -f /var/log/secure ]; then
  grep -q '^backend' /etc/fail2ban/jail.local || sed -i '/^\[sshd\]/a backend = systemd' /etc/fail2ban/jail.local
fi

echo "==> Starting fail2ban"
if command -v systemctl >/dev/null; then systemctl enable --now fail2ban; systemctl restart fail2ban
else rc-update add fail2ban default; rc-service fail2ban restart; fi

sleep 2
fail2ban-client status sshd
