#!/usr/bin/env bash
# launch.sh - create an Ubuntu EC2 instance with nginx and deploy ./site to it.
# Runs on macOS and Linux. Needs the AWS CLI v2, logged in (aws configure).
#
# Usage: ./launch.sh [options]
#   -r <region>   AWS region              (default: your aws config, else us-east-1)
#   -t <type>     instance type           (default: t2.micro; use t3.micro where t2 isn't free-tier)
#   -n <name>     name for all resources  (default: roadmap-ec2)
#   -h            show this help
#
# Creates: a key pair (saved to ~/.ssh/<name>.pem), a security group
# (SSH from YOUR IP only, HTTP from anywhere) and one instance.
# Remove everything again with ./destroy.sh

set -euo pipefail
# shellcheck source=lib.sh
. "$(dirname "$0")/lib.sh"

REGION="$(aws configure get region 2>/dev/null || true)"; REGION="${REGION:-us-east-1}"
TYPE="t2.micro"
NAME="roadmap-ec2"

usage() { sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'; }
while getopts ":r:t:n:h" opt; do
  case "$opt" in
    r) REGION="$OPTARG" ;;
    t) TYPE="$OPTARG" ;;
    n) NAME="$OPTARG" ;;
    h) usage; exit 0 ;;
    *) usage; exit 1 ;;
  esac
done
[ -f "$STATE_FILE" ] && die "$STATE_FILE exists - an instance is already running. Use ./deploy.sh, or ./destroy.sh first."
need_aws
export AWS_DEFAULT_REGION="$REGION"
KEY_FILE="$HOME/.ssh/$NAME.pem"

step "Account $(aws sts get-caller-identity --query Account --output text), region $REGION"

# --- AMI: latest Ubuntu 24.04 LTS, looked up from AWS's public SSM parameter ---
step "Finding the latest Ubuntu 24.04 AMI"
AMI=$(aws ssm get-parameter \
  --name /aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id \
  --query Parameter.Value --output text)
echo "  $AMI"

# --- Default VPC + subnet ---------------------------------------------------
step "Using the default VPC"
VPC=$(aws ec2 describe-vpcs --filters Name=is-default,Values=true --query 'Vpcs[0].VpcId' --output text)
[ "$VPC" != "None" ] || die "no default VPC in $REGION (create one: aws ec2 create-default-vpc)"
SUBNET=$(aws ec2 describe-subnets --filters Name=vpc-id,Values="$VPC" Name=default-for-az,Values=true \
  --query 'Subnets[0].SubnetId' --output text)
echo "  VPC $VPC, subnet $SUBNET"

# --- Key pair ---------------------------------------------------------------
step "Key pair '$NAME'"
if aws ec2 describe-key-pairs --key-names "$NAME" >/dev/null 2>&1; then
  [ -f "$KEY_FILE" ] || die "key pair '$NAME' exists in AWS but $KEY_FILE is missing - delete it in the console or use -n"
  echo "  reusing $KEY_FILE"
else
  mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
  aws ec2 create-key-pair --key-name "$NAME" --key-type ed25519 \
    --query KeyMaterial --output text > "$KEY_FILE"
  chmod 400 "$KEY_FILE"
  echo "  created, private key saved to $KEY_FILE"
fi

# --- Security group: SSH from my IP only, HTTP from anywhere -----------------
step "Security group '$NAME-sg'"
MY_IP=$(curl -s --max-time 5 https://checkip.amazonaws.com | tr -d '[:space:]')
[ -n "$MY_IP" ] || die "could not detect your public IP"
SG=$(aws ec2 describe-security-groups --filters Name=group-name,Values="$NAME-sg" Name=vpc-id,Values="$VPC" \
  --query 'SecurityGroups[0].GroupId' --output text)
if [ "$SG" = "None" ]; then
  SG=$(aws ec2 create-security-group --group-name "$NAME-sg" --vpc-id "$VPC" \
    --description "roadmap.sh project 11: SSH from owner, HTTP from anywhere" --query GroupId --output text)
  aws ec2 authorize-security-group-ingress --group-id "$SG" --protocol tcp --port 22 --cidr "$MY_IP/32" >/dev/null
  aws ec2 authorize-security-group-ingress --group-id "$SG" --protocol tcp --port 80 --cidr 0.0.0.0/0 >/dev/null
  echo "  created $SG: 22 from $MY_IP/32, 80 from 0.0.0.0/0"
else
  echo "  reusing $SG"
fi

# --- Instance ---------------------------------------------------------------
step "Launching $TYPE instance"
IID=$(aws ec2 run-instances \
  --image-id "$AMI" --instance-type "$TYPE" --key-name "$NAME" \
  --subnet-id "$SUBNET" --security-group-ids "$SG" --associate-public-ip-address \
  --user-data "file://$HERE/user-data.sh" \
  --metadata-options HttpTokens=required \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$NAME},{Key=Project,Value=roadmap-11}]" \
  --query 'Instances[0].InstanceId' --output text)
echo "  $IID - waiting until it's running..."

# save state right away so destroy.sh works even if a later step fails
cat > "$STATE_FILE" <<STATE
REGION=$REGION
NAME=$NAME
INSTANCE_ID=$IID
SG_ID=$SG
KEY_FILE=$KEY_FILE
STATE

aws ec2 wait instance-running --instance-ids "$IID"
IP=$(aws ec2 describe-instances --instance-ids "$IID" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
echo "PUBLIC_IP=$IP" >> "$STATE_FILE"
echo "  running at $IP"

# --- Wait for SSH and for cloud-init (nginx install) ------------------------
step "Waiting for SSH and first-boot setup (2-4 minutes)"
# shellcheck disable=SC2046
for i in $(seq 1 60); do
  ssh $(ssh_opts) -o BatchMode=yes "ubuntu@$IP" true 2>/dev/null && break
  [ "$i" -eq 60 ] && die "SSH did not come up - see ./destroy.sh to clean up"
  sleep 5
done
# shellcheck disable=SC2046
ssh $(ssh_opts) "ubuntu@$IP" 'cloud-init status --wait >/dev/null; systemctl is-active nginx'

# --- Deploy the site --------------------------------------------------------
"$HERE/deploy.sh"

cat <<DONE

✅ All set
   Website:  http://$IP/
   SSH:      ssh -i $KEY_FILE ubuntu@$IP
   Update:   edit site/ then ./deploy.sh
   Remove:   ./destroy.sh   (stops all charges)
DONE
