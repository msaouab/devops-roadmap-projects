#!/usr/bin/env bash
# deploy.sh - upload ./site to the instance created by launch.sh and check it.
set -euo pipefail
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
load_state

step "Deploying site/ to $PUBLIC_IP"
rsync -az --delete --chmod=D755,F644 --exclude '.DS_Store' \
  -e "ssh $(ssh_opts)" "$HERE/site/" "ubuntu@$PUBLIC_IP:/var/www/html/"

code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 "http://$PUBLIC_IP/" || true)
if [ "$code" = "200" ]; then echo "  live: http://$PUBLIC_IP/ (HTTP 200)"
else die "http://$PUBLIC_IP/ returned ${code:-nothing} - check: ssh -i $KEY_FILE ubuntu@$PUBLIC_IP 'systemctl status nginx'"; fi
