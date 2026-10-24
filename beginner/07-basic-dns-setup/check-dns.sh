#!/usr/bin/env bash
# check-dns.sh - verify a domain's DNS records point where they should.
# Runs on macOS and Linux (needs `dig`: built into macOS;
# Linux: apt install dnsutils / dnf install bind-utils).
#
# Usage:
#   ./check-dns.sh pages  <domain> <github-username>   # GitHub Pages setup
#   ./check-dns.sh server <domain> <server-ip>         # Droplet / VPS setup
#
# Examples:
#   ./check-dns.sh pages  example.com msaouab
#   ./check-dns.sh server example.com 203.0.113.10

set -uo pipefail

# GitHub Pages anycast IPs (docs.github.com, "Managing a custom domain")
GH_A="185.199.108.153 185.199.109.153 185.199.110.153 185.199.111.153"
RESOLVERS="1.1.1.1 8.8.8.8 9.9.9.9"   # Cloudflare, Google, Quad9

PASS=0; FAIL=0; WARN=0
ok()   { printf '  \033[32m✔\033[0m %s\n' "$*"; PASS=$((PASS+1)); }
bad()  { printf '  \033[31m✘\033[0m %s\n' "$*"; FAIL=$((FAIL+1)); }
warn() { printf '  \033[33m!\033[0m %s\n' "$*"; WARN=$((WARN+1)); }
head_() { printf '\n%s\n' "$*"; }
usage() { sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'; }

# lookup <type> <name> [resolver] -> sorted answers, one per line
lookup() {
  local server=""; [ -n "${3:-}" ] && server="@$3"
  # shellcheck disable=SC2086
  dig +short +time=3 +tries=1 $server "$1" "$2" 2>/dev/null \
    | grep -v '^;' | sed 's/\.$//' | sort
}

same_set() { [ "$(echo "$1" | tr ' ' '\n' | sort | grep -v '^$')" = "$(echo "$2" | tr ' ' '\n' | sort | grep -v '^$')" ]; }

[ $# -eq 3 ] || { usage; exit 1; }
MODE="$1"; DOMAIN="${2%.}"; TARGET="$3"
command -v dig >/dev/null || { echo "Error: dig not found (Linux: apt install dnsutils)" >&2; exit 1; }
case "$MODE" in pages|server) ;; *) usage; exit 1 ;; esac

if [ "$MODE" = pages ]; then want="$GH_A"; else want="$TARGET"; fi

echo "Checking $DOMAIN ($MODE mode)"

# --- Nameservers -------------------------------------------------------------
head_ "Nameservers (who answers for $DOMAIN)"
ns=$(lookup NS "$DOMAIN")
if [ -n "$ns" ]; then ok "NS: $(echo "$ns" | tr '\n' ' ')"
else bad "no NS records - is the domain registered and spelled right?"; fi

# --- Subdomain on GitHub Pages (e.g. pages.example.com CNAME user.github.io) --
if [ "$MODE" = pages ]; then
  self_cname=$(lookup CNAME "$DOMAIN")
  if [ -n "$self_cname" ]; then
    head_ "Subdomain: $DOMAIN"
    if [ "$self_cname" = "$TARGET.github.io" ]; then ok "CNAME -> $self_cname"
    else bad "CNAME -> $self_cname (want: $TARGET.github.io)"; fi
    SUBDOMAIN=1
  fi
fi

# --- Apex record -------------------------------------------------------------
if [ -z "${SUBDOMAIN:-}" ]; then
head_ "Apex: $DOMAIN"
a=$(lookup A "$DOMAIN")
if [ -z "$a" ]; then
  bad "no A record (want: $want)"
elif same_set "$a" "$want"; then
  ok "A -> $(echo "$a" | tr '\n' ' ')"
else
  # some of the right IPs is still better than none
  missing=""; for ip in $want; do echo "$a" | grep -qx "$ip" || missing="$missing $ip"; done
  extra="";   for ip in $a;    do echo " $want " | grep -q " $ip " || extra="$extra $ip"; done
  [ -n "$extra" ]   && bad  "unexpected A record(s):$extra"
  [ -n "$missing" ] && warn "missing A record(s):$missing"
fi

if [ "$MODE" = pages ]; then
  aaaa=$(lookup AAAA "$DOMAIN")
  if [ -n "$aaaa" ]; then ok "AAAA (IPv6) present"
  else warn "no AAAA records (optional: 2606:50c0:8000::153 … 8003::153)"; fi
fi

# --- www ---------------------------------------------------------------------
head_ "Subdomain: www.$DOMAIN"
cname=$(lookup CNAME "www.$DOMAIN")
if [ "$MODE" = pages ]; then
  want_cname="$TARGET.github.io"
  if [ "$cname" = "$want_cname" ]; then ok "CNAME -> $cname"
  elif [ -z "$cname" ]; then bad "no CNAME (want: www CNAME $want_cname)"
  else bad "CNAME -> $cname (want: $want_cname)"; fi
else
  wa=$(lookup A "www.$DOMAIN")
  if [ "$cname" = "$DOMAIN" ]; then ok "CNAME -> $DOMAIN"
  elif [ "$wa" = "$TARGET" ]; then ok "A -> $wa"
  elif [ -z "$cname$wa" ]; then warn "www not set (add: www CNAME $DOMAIN)"
  else bad "www points to ${cname:-$wa} (want $TARGET)"; fi
fi

fi  # end apex/www checks

# --- Propagation -------------------------------------------------------------
head_ "Propagation (same answer from public resolvers?)"
for r in $RESOLVERS; do
  ans=$(lookup A "$DOMAIN" "$r" | grep -E '^[0-9.]+$' | tr '\n' ' ')
  if [ -z "$ans" ]; then warn "$r: no answer yet (or resolver unreachable)"
  elif same_set "$ans" "$want"; then ok "$r: $ans"
  else warn "$r: $ans(still old? wait for the TTL to expire)"; fi
done

# --- HTTP --------------------------------------------------------------------
head_ "Website"
if command -v curl >/dev/null; then
  for url in "http://$DOMAIN/" "https://$DOMAIN/"; do
    code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 8 "$url" 2>/dev/null)
    case "$code" in
      2??|3??) ok "$url -> HTTP $code" ;;
      000|"")  warn "$url -> no response" ;;
      *)       bad "$url -> HTTP $code" ;;
    esac
  done
fi

# --- Summary -----------------------------------------------------------------
printf '\n%d passed, %d warnings, %d failed\n' "$PASS" "$WARN" "$FAIL"
[ "$FAIL" -eq 0 ]
