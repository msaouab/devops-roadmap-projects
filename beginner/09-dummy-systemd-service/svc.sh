#!/usr/bin/env bash
# svc.sh - install and manage the dummy service with ONE set of commands
#          on Linux (systemd) and macOS (launchd).
#
# Usage: ./svc.sh <command>
#   install     copy files into place, enable at boot and start
#   start | stop | restart
#   enable      start automatically at boot
#   disable     don't start at boot
#   status      is it running? (+ last log lines)
#   logs        follow the logs live (Ctrl-C to quit)
#   uninstall   stop, disable and remove everything
#
# Each command prints the native command it runs, so you learn those too.

set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"
BIN=/usr/local/bin/dummy.sh
LOG=/var/log/dummy-service.log
UNIT=/etc/systemd/system/dummy.service
LABEL=com.roadmap.dummy
PLIST=/Library/LaunchDaemons/$LABEL.plist

usage() { sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'; }
die()   { echo "Error: $*" >&2; exit 1; }
run()   { echo "+ $*"; "$@"; }
SUDO=""; [ "$(id -u)" -eq 0 ] || SUDO="sudo"

[ $# -eq 1 ] || { usage; exit 1; }
CMD="$1"

case "$OS" in
  Linux)
    command -v systemctl >/dev/null && [ -d /run/systemd/system ] \
      || die "systemd is not running on this machine (containers/WSL1 usually don't have it)"
    case "$CMD" in
      install)
        run $SUDO install -m 755 "$HERE/dummy.sh" "$BIN"
        run $SUDO install -m 644 "$HERE/dummy.service" "$UNIT"
        run $SUDO systemctl daemon-reload
        run $SUDO systemctl enable --now dummy ;;
      start|stop|restart|enable|disable)
        run $SUDO systemctl "$CMD" dummy ;;
      status)
        run systemctl status dummy --no-pager || true ;;
      logs)
        run journalctl -u dummy -f ;;
      uninstall)
        run $SUDO systemctl disable --now dummy || true
        run $SUDO rm -f "$UNIT" "$BIN"
        run $SUDO systemctl daemon-reload
        run $SUDO systemctl reset-failed dummy 2>/dev/null || true
        echo "Log file kept: $LOG (delete with: sudo rm $LOG)" ;;
      *) usage; exit 1 ;;
    esac ;;

  Darwin)
    loaded() { $SUDO launchctl print "system/$LABEL" >/dev/null 2>&1; }
    case "$CMD" in
      install)
        run $SUDO mkdir -p /usr/local/bin
        run $SUDO install -m 755 "$HERE/dummy.sh" "$BIN"
        run $SUDO install -m 644 -o root -g wheel "$HERE/macos/$LABEL.plist" "$PLIST"
        loaded && run $SUDO launchctl bootout "system/$LABEL" || true
        run $SUDO launchctl enable "system/$LABEL"
        run $SUDO launchctl bootstrap system "$PLIST" ;;
      start)
        loaded || run $SUDO launchctl bootstrap system "$PLIST"
        run $SUDO launchctl kickstart "system/$LABEL" ;;
      restart)
        run $SUDO launchctl kickstart -k "system/$LABEL" ;;
      stop)
        # KeepAlive would restart a killed process, so unload it instead
        run $SUDO launchctl bootout "system/$LABEL" ;;
      enable)
        run $SUDO launchctl enable "system/$LABEL" ;;
      disable)
        run $SUDO launchctl disable "system/$LABEL" ;;
      status)
        if loaded; then
          $SUDO launchctl print "system/$LABEL" | grep -E '^\s*(state|pid|last exit code|runs) ' || true
        else
          echo "not loaded (stopped)"
        fi
        echo "--- last log lines ($LOG)"
        tail -n 5 "$LOG" 2>/dev/null || echo "(no log yet)" ;;
      logs)
        run tail -f "$LOG" ;;
      uninstall)
        loaded && run $SUDO launchctl bootout "system/$LABEL" || true
        run $SUDO rm -f "$PLIST" "$BIN"
        echo "Log file kept: $LOG (delete with: sudo rm $LOG)" ;;
      *) usage; exit 1 ;;
    esac ;;

  *) die "unsupported OS: $OS" ;;
esac
