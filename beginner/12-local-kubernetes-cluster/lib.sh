# shellcheck shell=bash
# Shared settings for up.sh / down.sh / demo.sh / debug-lab.sh

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLUSTER="roadmap"            # must match "name:" in kind-config.yaml
CONTEXT="kind-$CLUSTER"
NS="web"
export HERE CLUSTER CONTEXT NS

step() { printf '\n\033[1m==> %s\033[0m\n' "$*"; }
info() { echo "    $*"; }
die()  { echo "Error: $*" >&2; exit 1; }

# kubectl always pointed at OUR cluster, never at whatever context is active
k() { kubectl --context "$CONTEXT" "$@"; }

need_tools() {
  local t
  for t in docker kind kubectl; do
    command -v "$t" >/dev/null || die "$t is not installed (macOS: brew install $t)"
  done
  docker info >/dev/null 2>&1 || die "Docker is not running - start Docker Desktop / OrbStack first"
}

cluster_exists() { kind get clusters 2>/dev/null | grep -qx "$CLUSTER"; }
need_cluster()   { cluster_exists || die "cluster '$CLUSTER' not found - run ./up.sh first"; }
