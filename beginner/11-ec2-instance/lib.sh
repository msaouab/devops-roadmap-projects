# shellcheck shell=bash
# Shared settings/helpers for launch.sh, deploy.sh, destroy.sh

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="$HERE/.ec2-state"     # created by launch.sh, git-ignored
export AWS_PAGER=""               # never open a pager for CLI output

step() { printf '\n==> %s\n' "$*"; }
die()  { echo "Error: $*" >&2; exit 1; }

need_aws() {
  command -v aws >/dev/null || die "AWS CLI not found. macOS: brew install awscli · Linux: https://aws.amazon.com/cli/"
  aws sts get-caller-identity >/dev/null 2>&1 || die "AWS CLI is not logged in. Run: aws configure"
}

load_state() {
  [ -f "$STATE_FILE" ] || die "no $STATE_FILE - run ./launch.sh first"
  # shellcheck disable=SC1090
  . "$STATE_FILE"
}

ssh_opts() {
  echo "-i $KEY_FILE -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5"
}
