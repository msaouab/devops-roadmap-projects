#!/usr/bin/env bash
# up.sh - create the kind cluster (if needed) and deploy nginx. Safe to re-run.
# Usage: ./up.sh [--open]     --open: start port-forward and open http://localhost:8080
set -euo pipefail
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"

need_tools

step "Cluster '$CLUSTER'"
if cluster_exists; then
  info "already exists - reusing it"
else
  kind create cluster --config "$HERE/kind-config.yaml"
fi

step "Waiting for all nodes to be Ready"
k wait --for=condition=Ready nodes --all --timeout=180s >/dev/null
k get nodes -o wide | sed 's/^/    /'

step "Deploying k8s/ (namespace, deployment, service)"
k apply -f "$HERE/k8s/" | sed 's/^/    /'
k rollout status deployment/nginx -n "$NS" --timeout=120s | sed 's/^/    /'

step "What's running"
k get deployment,pods,service -n "$NS" -o wide | sed 's/^/    /'
echo
info "Pods behind the Service: $(k get endpointslices -n "$NS" -l kubernetes.io/service-name=nginx \
  -o jsonpath='{range .items[*].endpoints[*]}{.addresses[0]} {end}')"

step "In-cluster check (a temporary pod calls http://nginx)"
if k run "check-$$" --rm -i --restart=Never --image=busybox:1.36 -n "$NS" --quiet -- \
     sh -c 'sleep 2; wget -qO- http://nginx' 2>/dev/null | grep -q "Welcome to nginx"; then
  info "OK - Service DNS + load balancing work"
else
  info "WARNING - could not reach the Service from inside the cluster"
fi

if [ "${1:-}" = "--open" ]; then
  step "Port-forward localhost:8080 -> service/nginx (Ctrl-C to stop)"
  (sleep 2; open "http://localhost:8080" 2>/dev/null || xdg-open "http://localhost:8080" 2>/dev/null || true) &
  k port-forward -n "$NS" service/nginx 8080:80
else
  cat <<NEXT

✅ Ready.
   Browser:   kubectl port-forward -n $NS service/nginx 8080:80   then open http://localhost:8080
              (or: ./up.sh --open)
   Explore:   ./demo.sh        scaling + self-healing + declarative vs imperative
              ./debug-lab.sh   3 broken pods to diagnose
   Remove:    ./down.sh
NEXT
fi
