#!/usr/bin/env bash
# deploy.sh - sync ./site to the server with rsync, then check it's live.
# Runs on your machine (macOS or Linux).
#
# Usage: ./deploy.sh [options] <host>
#   <host>      SSH alias (e.g. myserver from project 05) or user@ip
#   -p <port>   SSH port                     (default: 22 / from ~/.ssh/config)
#   -d <dir>    remote web root              (default: /var/www/static-site)
#   -u <url>    URL to check after deploying (default: http://<server host>/)
#   -n          dry run: show what would change, change nothing
#   -h          show this help

set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/site/"
REMOTE_DIR="/var/www/static-site"
PORT=""
URL=""
DRY=""

usage() { sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'; }
die()   { echo "Error: $*" >&2; exit 1; }

while getopts ":p:d:u:nh" opt; do
  case "$opt" in
    p) PORT="$OPTARG" ;;
    d) REMOTE_DIR="$OPTARG" ;;
    u) URL="$OPTARG" ;;
    n) DRY="--dry-run" ;;
    h) usage; exit 0 ;;
    :) die "option -$OPTARG needs a value" ;;
    *) die "unknown option -$OPTARG (see -h)" ;;
  esac
done
shift $((OPTIND - 1))
[ $# -eq 1 ] || { usage; exit 1; }
HOST="$1"

command -v rsync >/dev/null || die "rsync is not installed (macOS: brew install rsync / Linux: apt install rsync)"
[ -f "$SRC/index.html" ] || die "no index.html in $SRC"

SSH_CMD="ssh -o BatchMode=yes"
[ -n "$PORT" ] && SSH_CMD="$SSH_CMD -p $PORT"

echo "==> Syncing $SRC -> $HOST:$REMOTE_DIR ${DRY:+(dry run)}"
# -a  keep permissions/times   -z compress   --delete remove files deleted locally
# --exclude: never upload junk or secrets
rsync -az --delete --itemize-changes $DRY \
  --chmod=D755,F644 \
  --exclude '.DS_Store' --exclude '.git' --exclude '.env' \
  -e "$SSH_CMD" "$SRC" "$HOST:$REMOTE_DIR/"

[ -n "$DRY" ] && exit 0

# Work out a URL to check: -u, or the real hostname behind the SSH alias
if [ -z "$URL" ]; then
  real_host=$(ssh -G "$HOST" 2>/dev/null | awk '/^hostname /{print $2; exit}')
  URL="http://${real_host:-${HOST#*@}}/"
fi

echo "==> Checking $URL"
code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 "$URL" || true)
if [ "$code" = "200" ]; then
  echo "Live: $URL (HTTP 200)"
else
  [ "$code" = "000" ] && code="no response"
  echo "Warning: $URL returned HTTP ${code:-no response}. Is nginx running and port 80 open?" >&2
  exit 1
fi
