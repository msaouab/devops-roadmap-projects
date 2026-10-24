#!/usr/bin/env bash
# destroy.sh - delete everything launch.sh created (instance, security group,
#              key pair) so nothing keeps costing money.
# Usage: ./destroy.sh [-y]
set -euo pipefail
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"
load_state
need_aws
export AWS_DEFAULT_REGION="$REGION"

if [ "${1:-}" != "-y" ]; then
  printf 'Terminate %s and delete %s and key pair %s in %s? [y/N] ' "$INSTANCE_ID" "$SG_ID" "$NAME" "$REGION"
  read -r answer; case "$answer" in y|Y|yes) ;; *) echo "Aborted."; exit 0 ;; esac
fi

step "Terminating $INSTANCE_ID"
aws ec2 terminate-instances --instance-ids "$INSTANCE_ID" >/dev/null 2>&1 || echo "  (already gone)"
aws ec2 wait instance-terminated --instance-ids "$INSTANCE_ID" 2>/dev/null || true
echo "  terminated"

step "Deleting security group $SG_ID"
# the SG can only be deleted once no instance uses it
for _ in $(seq 1 12); do
  aws ec2 delete-security-group --group-id "$SG_ID" 2>/dev/null && { echo "  deleted"; break; }
  sleep 5
done

step "Deleting key pair $NAME"
aws ec2 delete-key-pair --key-name "$NAME" >/dev/null 2>&1 || true
rm -f "$KEY_FILE"
echo "  deleted (and $KEY_FILE)"

rm -f "$STATE_FILE"
echo
echo "✅ Everything removed. Check the console if you want to be sure: EC2 → Instances."
