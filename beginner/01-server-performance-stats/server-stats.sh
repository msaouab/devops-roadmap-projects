#!/usr/bin/env bash
# server-stats.sh - basic server performance stats (Linux & macOS)
# Usage: ./server-stats.sh

OS="$(uname -s)"

header() { printf '\n=== %s ===\n' "$1"; }

# --- Stretch: system info ---------------------------------------------------
get_system_info() {
  header "System"
  if [ "$OS" = "Darwin" ]; then
    echo "OS:            $(sw_vers -productName) $(sw_vers -productVersion)"
    boot=$(sysctl -n kern.boottime | awk -F'[ ,]' '{print $4}')
    up=$(( $(date +%s) - boot ))
    load=$(sysctl -n vm.loadavg | awk '{print $2, $3, $4}')
  else
    if [ -r /etc/os-release ]; then
      . /etc/os-release; echo "OS:            ${PRETTY_NAME:-$NAME}"
    else
      echo "OS:            $(uname -sr)"
    fi
    up=$(cut -d. -f1 /proc/uptime)
    load=$(cut -d' ' -f1-3 /proc/loadavg)
  fi
  printf 'Uptime:        %dd %dh %dm\n' $((up/86400)) $((up%86400/3600)) $((up%3600/60))
  echo "Load average:  $load (1m 5m 15m)"
  echo "Logged-in:     $(who | awk '{print $1}' | sort -u | tr '\n' ' ')($(who | wc -l | tr -d ' ') sessions)"
}

# --- CPU ---------------------------------------------------------------------
get_cpu_usage() {
  header "CPU"
  if [ "$OS" = "Darwin" ]; then
    # 2nd sample is the real current value (1st is since boot)
    idle=$(top -l 2 -n 0 | grep 'CPU usage' | tail -1 | awk '{gsub("%","",$7); print $7}')
  else
    # sample /proc/stat twice, 1s apart
    read -r _ u1 n1 s1 i1 w1 q1 sq1 st1 _ < /proc/stat
    sleep 1
    read -r _ u2 n2 s2 i2 w2 q2 sq2 st2 _ < /proc/stat
    t1=$((u1+n1+s1+i1+w1+q1+sq1+st1)); t2=$((u2+n2+s2+i2+w2+q2+sq2+st2))
    idle=$(awk -v i=$(( (i2+w2)-(i1+w1) )) -v t=$((t2-t1)) 'BEGIN{printf "%.1f", i*100/t}')
  fi
  awk -v idle="$idle" 'BEGIN{printf "Total usage:   %.1f%% (idle %.1f%%)\n", 100-idle, idle}'
}

# --- Memory ------------------------------------------------------------------
get_memory_usage() {
  header "Memory"
  if [ "$OS" = "Darwin" ]; then
    total=$(sysctl -n hw.memsize)
    page=$(sysctl -n hw.pagesize)
    avail_pages=$(vm_stat | awk '/Pages free|Pages inactive|Pages speculative/ {gsub("\\.","",$NF); s+=$NF} END{print s}')
    total_mb=$(( total / 1024 / 1024 ))
    free_mb=$(( avail_pages * page / 1024 / 1024 ))
  else
    total_mb=$(awk '/^MemTotal/ {print int($2/1024)}' /proc/meminfo)
    free_mb=$(awk '/^MemAvailable/ {print int($2/1024)}' /proc/meminfo)
  fi
  used_mb=$(( total_mb - free_mb ))
  awk -v t="$total_mb" -v u="$used_mb" -v f="$free_mb" 'BEGIN{
    printf "Total:         %d MB\n", t
    printf "Used:          %d MB (%.1f%%)\n", u, u*100/t
    printf "Free:          %d MB (%.1f%%)\n", f, f*100/t }'
}

# --- Disk --------------------------------------------------------------------
get_disk_usage() {
  header "Disk"
  # On macOS (APFS) user data lives on the Data volume, not the sealed "/"
  mount="/"
  [ "$OS" = "Darwin" ] && [ -d /System/Volumes/Data ] && mount="/System/Volumes/Data"
  df -kP "$mount" | awk -v m="$mount" 'NR==2{
    t=$2/1048576; u=$3/1048576; f=$4/1048576
    printf "Mount:         %s\n", m
    printf "Total:         %.1f GB\n", t
    printf "Used:          %.1f GB (%.1f%%)\n", u, u*100/(u+f)
    printf "Free:          %.1f GB (%.1f%%)\n", f, f*100/(u+f) }'
}

# --- Top processes -----------------------------------------------------------
get_top_processes() {
  header "Top 5 processes by $1"
  if [ "$OS" = "Darwin" ]; then
    flag=$([ "$1" = "CPU" ] && echo -r || echo -m)
    ps -Ao pid,pcpu,pmem,comm "$flag" | head -6
  else
    key=$([ "$1" = "CPU" ] && echo -pcpu || echo -pmem)
    ps -eo pid,pcpu,pmem,comm --sort="$key" | head -6
  fi
}

# --- Stretch: failed logins --------------------------------------------------
get_failed_logins() {
  header "Failed login attempts"
  if [ "$OS" = "Darwin" ]; then
    echo "n/a on macOS"
  elif [ -r /var/log/auth.log ]; then
    echo "$(grep -c 'Failed password' /var/log/auth.log) (from /var/log/auth.log)"
  elif [ -r /var/log/secure ]; then
    echo "$(grep -c 'Failed password' /var/log/secure) (from /var/log/secure)"
  elif command -v journalctl >/dev/null && journalctl -q -n1 >/dev/null 2>&1; then
    echo "$(journalctl -q _COMM=sshd 2>/dev/null | grep -c 'Failed password') (from journald)"
  else
    echo "n/a (run with sudo to read auth logs)"
  fi
}

get_system_info
get_cpu_usage
get_memory_usage
get_disk_usage
get_top_processes CPU
get_top_processes Memory
get_failed_logins
