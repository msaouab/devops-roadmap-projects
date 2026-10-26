#!/usr/bin/env bash
# down.sh - delete the kind cluster and everything in it. Safe to re-run.
set -euo pipefail
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"

command -v kind >/dev/null || die "kind is not installed"
if cluster_exists; then
  step "Deleting cluster '$CLUSTER'"
  kind delete cluster --name "$CLUSTER"
  echo "✅ Gone. Recreate any time with ./up.sh"
else
  echo "Cluster '$CLUSTER' does not exist - nothing to do."
fi
