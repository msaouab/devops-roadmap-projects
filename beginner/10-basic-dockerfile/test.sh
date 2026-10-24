#!/usr/bin/env bash
# test.sh - build the images and check what they print (macOS & Linux, needs Docker)
set -euo pipefail
cd "$(dirname "$0")"

command -v docker >/dev/null || { echo "Docker is not installed (macOS: Docker Desktop / OrbStack, Linux: docker.io)"; exit 1; }
docker info >/dev/null 2>&1 || { echo "Docker daemon is not running (start Docker Desktop / sudo systemctl start docker)"; exit 1; }

pass=0; fail=0
check() {   # check <description> <expected> <command...>
  local desc="$1" want="$2"; shift 2
  local got; got="$("$@" 2>&1)"
  if [ "$got" = "$want" ]; then echo "  PASS  $desc -> $got"; pass=$((pass+1))
  else echo "  FAIL  $desc -> got '$got', want '$want'"; fail=$((fail+1)); fi
}

echo "==> Building"
docker build -q -f Dockerfile.minimal -t hello-captain-minimal . >/dev/null
docker build -q -t hello-captain . >/dev/null
docker build -q --build-arg NAME=Mohammed -t hello-mohammed . >/dev/null

echo "==> Running"
check "minimal Dockerfile"          "Hello, Captain!"  docker run --rm hello-captain-minimal
check "default build"               "Hello, Captain!"  docker run --rm hello-captain
check "--build-arg NAME=Mohammed"   "Hello, Mohammed!" docker run --rm hello-mohammed
check "runtime override -e NAME=Ops" "Hello, Ops!"     docker run --rm -e NAME=Ops hello-captain

echo "==> Image size: $(docker image inspect hello-captain --format '{{.Size}}' | awk '{printf "%.1f MB", $1/1048576}')"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
