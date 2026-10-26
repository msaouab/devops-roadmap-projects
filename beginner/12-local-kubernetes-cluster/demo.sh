#!/usr/bin/env bash
# demo.sh - scaling, self-healing and declarative vs imperative, step by step.
# Usage: ./demo.sh          (pauses between steps; set FAST=1 to skip pauses)
set -euo pipefail
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
need_tools; need_cluster

pause() { [ -n "${FAST:-}" ] || { printf '\n    [Enter] to continue '; read -r _; }; }
ready() { k get deployment nginx -n "$NS" -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true; }
pod_names() { k get pods -n "$NS" -l app=nginx -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'; }
# Running pods that are NOT being deleted (Terminating pods still say Running in the API)
live_pods() {
  k get pods -n "$NS" -l app=nginx \
    -o jsonpath='{range .items[?(@.status.phase=="Running")]}{.metadata.name} {.metadata.deletionTimestamp}{"\n"}{end}' \
    | awk 'NF==1 {print $1}'
}
wait_ready() {   # wait_ready <n> [old-pod-names] -> prints seconds until n NEW pods are live and old ones are gone
  local want="$1" old="${2:-}" start=$SECONDS live n_new
  while :; do
    live="$(live_pods)"
    if [ -n "$old" ]; then n_new=$(echo "$live" | grep -cvxF "$old" || true); else n_new=$(echo "$live" | grep -c . || true); fi
    total=$(pod_names | grep -c . || true)
    [ "$n_new" = "$want" ] && [ "$(ready)" = "$want" ] && [ "$total" = "$want" ] && break
    [ $((SECONDS - start)) -gt 120 ] && die "timed out waiting for $want new ready pods"
    sleep 1
  done
  echo $((SECONDS - start))
}
spread() {
  k get pods -n "$NS" -l app=nginx -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' \
    | sort | uniq -c | awk '{printf "    %s pod(s) on %s\n", $1, $2}'
}
FILE_REPLICAS=$(awk '/replicas:/ {print $2; exit}' "$HERE/k8s/deployment.yaml")

step "Start: the file says replicas=$FILE_REPLICAS"
k apply -f "$HERE/k8s/" >/dev/null; wait_ready "$FILE_REPLICAS" >/dev/null
spread; pause

step "1. Scale to 5 (kubectl scale) - watch the scheduler spread them"
k scale deployment nginx -n "$NS" --replicas=5 >/dev/null
info "all 5 Running after $(wait_ready 5)s"
spread
info "Service now load-balances across: $(k get endpointslices -n "$NS" -l kubernetes.io/service-name=nginx \
  -o jsonpath='{range .items[*].endpoints[*]}{.addresses[0]} {end}')"
pause

step "2. Self-healing: delete ONE pod"
victim=$(k get pods -n "$NS" -l app=nginx -o jsonpath='{.items[0].metadata.name}')
start=$SECONDS
k delete pod "$victim" -n "$NS" --wait=false >/dev/null
until ! pod_names | grep -qxF "$victim" && [ "$(live_pods | grep -c .)" = 5 ]; do sleep 1; done
info "deleted $victim -> replacement Running and old pod gone after $((SECONDS - start))s"
pause

step "3. Self-healing: delete ALL pods at once"
old="$(pod_names)"
k delete pods -n "$NS" -l app=nginx --wait=false >/dev/null
info "deleted 5 pods -> 5 brand-new pods Running (old ones fully gone) after $(wait_ready 5 "$old")s"
pause

step "4. Declarative wins: re-apply the files"
info "cluster has 5 replicas (changed by hand), the file says $FILE_REPLICAS"
k apply -f "$HERE/k8s/" >/dev/null
info "after kubectl apply: $(wait_ready "$FILE_REPLICAS" >/dev/null; ready) replicas - the manual change is gone"
info "Lesson: the files are the source of truth. GitOps (project 16) automates exactly this."

step "Done"
k get pods -n "$NS" -o wide | sed 's/^/    /'
