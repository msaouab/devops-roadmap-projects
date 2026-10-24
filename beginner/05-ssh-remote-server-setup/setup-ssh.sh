#!/usr/bin/env bash
# setup-ssh.sh - create 2 SSH key pairs, install them on a server,
#                add a ~/.ssh/config alias and test every key.
# Runs on your machine (macOS or Linux).
#
# Usage: ./setup-ssh.sh [options] <user@host> <alias>
#   -p <port>   SSH port of the server            (default: 22)
#   -b <key>    existing private key to log in with for the first copy
#               (e.g. the key you gave DigitalOcean/AWS). Without it,
#               you'll be asked for the server password once per key.
#   -h          show this help
#
# Example: ./setup-ssh.sh -b ~/.ssh/id_ed25519 root@203.0.113.10 myserver
#          ssh myserver

set -euo pipefail

PORT=22
BOOTSTRAP=""
SSH_DIR="${SSH_DIR:-$HOME/.ssh}"   # override only for testing
CONFIG="$SSH_DIR/config"

usage() { sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'; }
die()   { echo "Error: $*" >&2; exit 1; }
step()  { printf '\n==> %s\n' "$*"; }

while getopts ":p:b:h" opt; do
  case "$opt" in
    p) PORT="$OPTARG" ;;
    b) BOOTSTRAP="$OPTARG" ;;
    h) usage; exit 0 ;;
    :) die "option -$OPTARG needs a value" ;;
    *) die "unknown option -$OPTARG (see -h)" ;;
  esac
done
shift $((OPTIND - 1))
[ $# -eq 2 ] || { usage; exit 1; }

TARGET="$1"; ALIAS="$2"
case "$TARGET" in *@*) ;; *) die "target must look like user@host" ;; esac
USER_PART="${TARGET%@*}"; HOST_PART="${TARGET#*@}"
case "$ALIAS" in *[!A-Za-z0-9._-]*|"") die "alias may only contain letters, digits, . _ -" ;; esac
case "$PORT" in *[!0-9]*|"") die "port must be a number" ;; esac
[ -z "$BOOTSTRAP" ] || [ -r "$BOOTSTRAP" ] || die "cannot read bootstrap key '$BOOTSTRAP'"

mkdir -p "$SSH_DIR" && chmod 700 "$SSH_DIR"
touch "$CONFIG" && chmod 600 "$CONFIG"

# Base ssh options for the bootstrap login
BASE_OPTS=(-p "$PORT" -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile="$SSH_DIR/known_hosts")
[ -n "$BOOTSTRAP" ] && BASE_OPTS+=(-i "$BOOTSTRAP" -o IdentitiesOnly=yes)

# --- 1. Generate two key pairs ----------------------------------------------
step "Generating key pairs"
KEYS=()
for n in 1 2; do
  key="$SSH_DIR/${ALIAS}_key${n}"
  if [ -f "$key" ]; then
    echo "  exists:  $key (reusing)"
  else
    ssh-keygen -q -t ed25519 -a 100 -N "" -C "${ALIAS}-key${n}@$(hostname -s 2>/dev/null || hostname)" -f "$key"
    echo "  created: $key"
  fi
  KEYS+=("$key")
done

# --- 2. Install the public keys on the server --------------------------------
step "Copying public keys to $TARGET (port $PORT)"
for key in "${KEYS[@]}"; do
  # Works without ssh-copy-id and never adds the same key twice
  ssh "${BASE_OPTS[@]}" "$TARGET" \
    'umask 077; mkdir -p ~/.ssh; touch ~/.ssh/authorized_keys;
     k=$(cat); grep -qxF "$k" ~/.ssh/authorized_keys || echo "$k" >> ~/.ssh/authorized_keys' \
    < "$key.pub"
  echo "  installed: $(basename "$key").pub"
done

# --- 3. Add the alias to ~/.ssh/config --------------------------------------
step "Adding 'Host $ALIAS' to $CONFIG"
if grep -qE "^Host[[:space:]]+$ALIAS([[:space:]]|$)" "$CONFIG"; then
  echo "  already present, leaving it unchanged"
else
  {
    printf '\n# added by setup-ssh.sh on %s\n' "$(date '+%Y-%m-%d')"
    printf 'Host %s\n' "$ALIAS"
    printf '    HostName %s\n' "$HOST_PART"
    printf '    User %s\n' "$USER_PART"
    printf '    Port %s\n' "$PORT"
    printf '    IdentityFile %s\n' "${KEYS[0]}"
    printf '    IdentityFile %s\n' "${KEYS[1]}"
    printf '    IdentitiesOnly yes\n'
    printf '    AddKeysToAgent yes\n'
  } >> "$CONFIG"
  echo "  added"
fi

# --- 4. Test every way in ---------------------------------------------------
step "Testing"
ok=0
for key in "${KEYS[@]}"; do
  if ssh -F /dev/null -p "$PORT" -i "$key" -o IdentitiesOnly=yes -o BatchMode=yes \
       -o UserKnownHostsFile="$SSH_DIR/known_hosts" "$TARGET" true 2>/dev/null; then
    echo "  OK   ssh -i $key $TARGET"; ok=$((ok+1))
  else
    echo "  FAIL ssh -i $key $TARGET"
  fi
done
if ssh -F "$CONFIG" -o BatchMode=yes -o UserKnownHostsFile="$SSH_DIR/known_hosts" "$ALIAS" true 2>/dev/null; then
  echo "  OK   ssh $ALIAS"; ok=$((ok+1))
else
  echo "  FAIL ssh $ALIAS"
fi

[ "$ok" -eq 3 ] || die "$((3-ok)) check(s) failed"
printf '\nAll good. Connect with:  ssh %s\n' "$ALIAS"
