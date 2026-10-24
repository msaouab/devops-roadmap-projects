#!/usr/bin/env bash
# nginx-log-analyser.sh - top 5 IPs, paths, status codes and user agents
#                          from an nginx access log (combined format)
#
# Usage: ./nginx-log-analyser.sh [-m awk|sed] [-n N] <access.log>
#   -m awk   parse with awk (default)
#   -m sed   parse with grep + sed (stretch goal: no awk for parsing)
#   -n N     show the top N instead of 5
#   -h       show this help
#
# Works with BSD (macOS) and GNU (Linux) tools.

set -euo pipefail

METHOD="awk"
TOP=5

usage() { sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'; }
die()   { echo "Error: $*" >&2; exit 1; }

while getopts ":m:n:h" opt; do
  case "$opt" in
    m) METHOD="$OPTARG" ;;
    n) TOP="$OPTARG" ;;
    h) usage; exit 0 ;;
    :) die "option -$OPTARG needs a value" ;;
    *) die "unknown option -$OPTARG (see -h)" ;;
  esac
done
shift $((OPTIND - 1))

[ $# -eq 1 ] || { usage; exit 1; }
LOG="$1"
[ -f "$LOG" ] || die "'$LOG' is not a file"
[ -r "$LOG" ] || die "cannot read '$LOG'"
case "$METHOD" in awk|sed) ;; *) die "-m must be 'awk' or 'sed'" ;; esac
case "$TOP" in ''|*[!0-9]*|0) die "-n needs a number greater than 0" ;; esac

# A combined-format line, split on double quotes ("):
#   $1 = 1.2.3.4 - - [04/Oct/2024:00:00:18 +0000]
#   $2 = GET /v1-health HTTP/1.1
#   $3 =  200 51
#   $4 = referrer
#   $6 = user agent

# --- Extractors: print one value per line -----------------------------------
ips()      { if [ "$METHOD" = awk ]; then awk '{print $1}' "$LOG"
             else cut -d' ' -f1 "$LOG"; fi; }

paths()    { if [ "$METHOD" = awk ]; then awk -F'"' '{split($2, r, " "); print r[2]}' "$LOG"
             else grep -E '"[A-Z]+ [^ ]+ ' "$LOG" | sed -E 's/^[^"]*"[A-Z]+ ([^ ]+) .*/\1/'; fi; }

statuses() { if [ "$METHOD" = awk ]; then awk -F'"' '{split($3, s, " "); print s[1]}' "$LOG"
             else sed -nE 's/^[^"]*"[^"]*" ([0-9]{3}) .*/\1/p' "$LOG"; fi; }

agents()   { if [ "$METHOD" = awk ]; then awk -F'"' '{print $6}' "$LOG"
             else sed -nE 's/.*"([^"]*)"[[:space:]]*$/\1/p' "$LOG"; fi; }

# --- Count, sort, keep the top N, print "<value> - <N> requests" ------------
top() {
  grep -v '^-\{0,1\}$' \
    | sort | uniq -c | sort -rn | head -n "$TOP" \
    | sed -E 's/^ *([0-9]+) (.*)$/\2 - \1 requests/'
}

section() { printf '\n%s\n' "$1"; }

[ -s "$LOG" ] || { echo "Log file is empty."; exit 0; }

section "Top $TOP IP addresses with the most requests:";  ips      | top
section "Top $TOP most requested paths:";                 paths    | top
section "Top $TOP response status codes:";                statuses | top
section "Top $TOP user agents:";                          agents   | top
