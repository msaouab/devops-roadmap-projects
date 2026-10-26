#!/usr/bin/env bash
# debug-lab.sh - deploy 3 broken pods, then show the symptom of each.
# Usage: ./debug-lab.sh          deploy, wait, show status
#        ./debug-lab.sh --answers   also show the root cause found by describe/logs
#        ./debug-lab.sh --clean     delete the broken pods
set -euo pipefail
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
need_tools; need_cluster

if [ "${1:-}" = "--clean" ]; then
  k delete -f "$HERE/k8s/broken/" --ignore-not-found | sed 's/^/    /'
  exit 0
fi

if k get pod bad-image crash memory-hog -n "$NS" >/dev/null 2>&1; then
  step "Broken pods already deployed - reusing them"
else
  step "Deploying the broken pods"
  k apply -f "$HERE/k8s/namespace.yaml" >/dev/null
  k apply -f "$HERE/k8s/broken/" | sed 's/^/    /'
  info "waiting 45s so each failure shows its real symptom..."
  sleep 45
fi

step "Symptoms (kubectl get pods)"
k get pods -n "$NS" bad-image crash memory-hog | sed 's/^/    /'

cat <<'TRY'

    Your turn - find the root cause of each with:
      kubectl describe pod <name> -n web     (read Events + Last State)
      kubectl logs <name> -n web [--previous]
      kubectl get events -n web --sort-by=.lastTimestamp
    Then check yourself:  ./debug-lab.sh --answers
TRY

if [ "${1:-}" = "--answers" ]; then
  step "Answers"
  reason() { k get pod "$1" -n "$NS" -o jsonpath="{.status.containerStatuses[0].$2}"; }
  # A crashing container flips between waiting / running / terminated - check all of them
  why() { local r; for f in state.waiting.reason state.terminated.reason lastState.terminated.reason; do
            r="$(reason "$1" "$f")"; [ -n "$r" ] && { echo "$r"; return; }; done; echo "?"; }
  # The previous container may already be garbage-collected - fall back to the current one
  # kubectl prints "unable to retrieve container logs ..." on stdout when a container is gone - skip that
  said() {
    { k logs "$1" -n "$NS" --previous 2>/dev/null; k logs "$1" -n "$NS" 2>/dev/null; } \
      | grep -v 'unable to retrieve container logs' | grep -E 'ERROR|error' | tail -1 | grep . \
      || echo "(logs not available yet - try: kubectl logs $1 -n web --previous)"
  }
  echo "    bad-image : $(why bad-image) - $(reason bad-image state.waiting.message | cut -c1-110)"
  echo "    crash     : $(why crash), last exit code=$(reason crash lastState.terminated.exitCode), restarts=$(reason crash restartCount)"
  echo "                app said: $(said crash)"
  echo "    memory-hog: $(why memory-hog), last terminated reason=$(reason memory-hog lastState.terminated.reason), exit code=$(reason memory-hog lastState.terminated.exitCode) (137 = 128 + SIGKILL 9)"
fi
echo
echo "    Clean up with: ./debug-lab.sh --clean"
