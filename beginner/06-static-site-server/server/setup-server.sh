#!/usr/bin/env bash
# setup-server.sh - install and configure nginx to serve the static site.
# Run ON THE SERVER (Debian/Ubuntu, Fedora/RHEL/Rocky, Alpine):
#   scp server/setup-server.sh nginx/static-site.conf myserver:
#   ssh myserver 'sudo bash setup-server.sh [domain] [deploy-user]'
#
#   domain       e.g. example.com (default: "_" = serve on the server IP)
#   deploy-user  user that deploy.sh connects as (default: the sudo user)

set -euo pipefail
[ "$(uname -s)" = "Linux" ] || { echo "Run this on the Linux server, not locally." >&2; exit 1; }
[ "$(id -u)" -eq 0 ] || { echo "Run with sudo." >&2; exit 1; }

DOMAIN="${1:-_}"
DEPLOY_USER="${2:-${SUDO_USER:-root}}"
WEBROOT=/var/www/static-site
HERE="$(cd "$(dirname "$0")" && pwd)"
CONF_SRC="$HERE/static-site.conf"
[ -f "$CONF_SRC" ] || CONF_SRC="$HERE/../nginx/static-site.conf"
[ -f "$CONF_SRC" ] || { echo "static-site.conf not found next to this script." >&2; exit 1; }

echo "==> Installing nginx and rsync"
if   command -v apt-get >/dev/null; then apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq nginx rsync
elif command -v dnf     >/dev/null; then dnf install -y -q nginx rsync
elif command -v yum     >/dev/null; then yum install -y -q nginx rsync
elif command -v apk     >/dev/null; then apk add --quiet nginx rsync
else echo "Unsupported distro." >&2; exit 1; fi

echo "==> Creating $WEBROOT (owned by $DEPLOY_USER)"
mkdir -p "$WEBROOT"
id "$DEPLOY_USER" >/dev/null 2>&1 || { echo "User '$DEPLOY_USER' does not exist." >&2; exit 1; }
chown -R "$DEPLOY_USER": "$WEBROOT"
chmod 755 "$WEBROOT"
[ -f "$WEBROOT/index.html" ] || echo "<h1>nginx is up - now run deploy.sh</h1>" > "$WEBROOT/index.html"

echo "==> Installing the nginx site (server_name $DOMAIN)"
if [ -d /etc/nginx/sites-available ]; then
  DEST=/etc/nginx/sites-available/static-site
  sed "s/server_name _;/server_name $DOMAIN;/" "$CONF_SRC" > "$DEST"
  ln -sf "$DEST" /etc/nginx/sites-enabled/static-site
  rm -f /etc/nginx/sites-enabled/default        # remove the welcome page
else
  mkdir -p /etc/nginx/conf.d /etc/nginx/http.d
  DIR=/etc/nginx/conf.d; [ -f /etc/alpine-release ] && DIR=/etc/nginx/http.d
  sed "s/server_name _;/server_name $DOMAIN;/" "$CONF_SRC" > "$DIR/static-site.conf"
  # RHEL's default nginx.conf also has a default_server on :80 -> drop ours
  if grep -q 'default_server' /etc/nginx/nginx.conf 2>/dev/null; then
    sed -i 's/ default_server//' "$DIR/static-site.conf"
  fi
  rm -f "$DIR/default.conf"
fi

# No IPv6 on this server? Drop the [::]:80 listener or nginx won't start
if [ ! -f /proc/net/if_inet6 ]; then
  for f in /etc/nginx/sites-available/static-site /etc/nginx/conf.d/static-site.conf /etc/nginx/http.d/static-site.conf; do
    [ -f "$f" ] && sed -i '/listen \[::\]:80/d' "$f"
  done
  echo "    (IPv6 is disabled here: listening on IPv4 only)"
fi

# SELinux (Fedora/RHEL): let nginx read the web root
command -v restorecon >/dev/null && restorecon -R "$WEBROOT" || true

echo "==> Opening the firewall (if one is active)"
if command -v ufw >/dev/null && ufw status | grep -q active; then
  ufw allow 'Nginx Full' || ufw allow 80/tcp
elif command -v firewall-cmd >/dev/null && firewall-cmd --state >/dev/null 2>&1; then
  firewall-cmd --permanent --add-service=http && firewall-cmd --reload
fi

echo "==> Testing config and (re)starting nginx"
nginx -t
if [ -d /run/systemd/system ]; then          # normal server with systemd
  systemctl enable --now nginx
  systemctl reload nginx
elif command -v rc-service >/dev/null; then   # Alpine (OpenRC)
  rc-update add nginx default
  rc-service nginx restart
else                                          # containers without an init system
  if pgrep -x nginx >/dev/null; then nginx -s reload; else nginx; fi
fi

sleep 1
if ! curl -s -o /dev/null --max-time 5 http://127.0.0.1/ 2>/dev/null && ! pgrep -x nginx >/dev/null; then
  echo "nginx is not running - check: journalctl -u nginx" >&2
  exit 1
fi

echo
echo "Done. Visit http://$( [ "$DOMAIN" = "_" ] && hostname -I 2>/dev/null | awk '{print $1}' || echo "$DOMAIN" )/"
echo "Then deploy your site from your machine with ./deploy.sh"
