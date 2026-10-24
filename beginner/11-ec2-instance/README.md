# EC2 Instance

> **Level:** Beginner · **Topic:** AWS · **Status:** 🟨 Ready to run (needs an AWS account)<br>
> **Brief:** [roadmap.sh/projects/ec2-instance](https://roadmap.sh/projects/ec2-instance)

## 🎯 Goal
Launch a Linux server on AWS EC2, connect over SSH, and host a simple static site on it.

## 📋 Requirements
- [ ] Create an AWS account and get familiar with the console
- [x] Launch an instance: Ubuntu AMI, `t2.micro` (Free Tier), default VPC/subnet, security group allowing 22 (SSH) and 80 (HTTP), a key pair, a public IP
- [x] SSH in with the private key
- [x] Update packages and install a web server (e.g. Nginx)
- [x] Create and deploy a simple HTML page
- [ ] Verify it loads from the instance's public IP

## 🌟 Stretch goals
- [ ] Custom domain with Route 53
- [ ] HTTPS with a Let's Encrypt certificate
- [ ] Auto-deploy with AWS CodePipeline

## 🎓 What you'll learn
- Creating basic AWS resources
- EC2 instance types and security groups
- Deploying to cloud infrastructure

---

## 🧰 Stack

- **AWS EC2**: Ubuntu 24.04 LTS on `t2.micro`, in the default VPC
- **AWS CLI v2**, scripted in Bash. Runs on **macOS and Linux**.
- **cloud-init** user data to install Nginx on first boot
- `ssh` + `rsync` to deploy the site

## 📁 Files

| File | What it does |
|---|---|
| `launch.sh` | Creates the key pair, security group and instance, waits for it, deploys the site |
| `deploy.sh` | Re-uploads `site/` after you edit it and checks for HTTP 200 |
| `destroy.sh [-y]` | Terminates the instance and deletes the security group and key pair, so there are **no further charges** |
| `user-data.sh` | Runs once as root on first boot: `apt upgrade`, install Nginx |
| `site/index.html` | The static page |
| `lib.sh` | Shared helpers |
| `.ec2-state` | Created by `launch.sh` (IDs, IP, region) and used by the other two scripts. Git-ignored. |

## 🚀 How to run

**One-time setup**

1. Create an AWS account and an IAM user with EC2 access. Avoid using the root account day to day.
2. Install the CLI: `brew install awscli` (macOS), or see [AWS's install guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) (Linux).
3. Log in: `aws configure` (access key, secret, region e.g. `eu-west-3`).

**Launch, update, destroy**

```bash
./launch.sh                 # ~3-5 min the first time
#   options: -r <region>  -t <instance-type>  -n <name>

vim site/index.html && ./deploy.sh

./destroy.sh                # when you're done!
```

```
==> Finding the latest Ubuntu 24.04 AMI
  ami-0abc...
==> Key pair 'roadmap-ec2'
  created, private key saved to ~/.ssh/roadmap-ec2.pem
==> Security group 'roadmap-ec2-sg'
  created sg-...: 22 from 203.0.113.50/32, 80 from 0.0.0.0/0
==> Launching t2.micro instance
  i-0... - waiting until it's running...
  running at 198.51.100.7
==> Waiting for SSH and first-boot setup (2-4 minutes)
==> Deploying site/ to 198.51.100.7
  live: http://198.51.100.7/ (HTTP 200)

✅ All set
   Website:  http://198.51.100.7/
   SSH:      ssh -i ~/.ssh/roadmap-ec2.pem ubuntu@198.51.100.7
```

## 🔍 How it maps to the brief

| Brief requirement | How |
|---|---|
| Ubuntu Server AMI | Latest Ubuntu 24.04, looked up from AWS's public SSM parameter (no hard-coded AMI ID that differs per region) |
| `t2.micro` | Default. Use `-t t3.micro` in regions or accounts where that's the free-tier type. |
| Default VPC + subnet | `describe-vpcs --filters is-default=true` |
| Security group: 22 + 80 | **22 only from your current IP** (`/32`), 80 from anywhere |
| Key pair | Created by AWS as ed25519; private key saved to `~/.ssh/<name>.pem` with `chmod 400` |
| Public IP | `--associate-public-ip-address` |
| SSH in | `ssh -i ~/.ssh/roadmap-ec2.pem ubuntu@<ip>` (the default user on Ubuntu AMIs is `ubuntu`) |
| Update packages + install Nginx | `user-data.sh`, run by cloud-init on first boot |
| Deploy + verify the site | `rsync` over SSH, then `curl` expects HTTP 200 |

### Tested cases

No AWS account was available here, so the scripts were run against a **mocked** `aws`/`ssh`/`rsync`/`curl` that record every call. This checks the flow, not AWS itself:

| Check | Result |
|---|---|
| `launch.sh` full flow | AMI → VPC → key (saved with `chmod 400`) → SG with 22 from `/32` and 80 from anywhere → `run-instances` with user data and IMDSv2 → wait → SSH → deploy → HTTP 200 |
| State file | Region, instance, SG, key and IP recorded |
| `launch.sh` a second time | Refuses: "an instance is already running" |
| `destroy.sh -y` | Terminate → delete SG → delete key pair + local `.pem` → remove state |
| `shellcheck` | No warnings |

**First real run:** use it on your account and run `./destroy.sh` afterwards. The scripts print every resource they create.

## 💸 Cost and safety

- AWS's free tier covers a small instance, but how it works varies by account age and has changed over time. Check **Billing → Free tier** and set a **budget alert** (Billing → Budgets) before launching.
- **Always run `./destroy.sh`** when finished. A stopped instance still pays for its disk; only terminating stops all charges.
- If your IP changes (new Wi-Fi), SSH will time out because port 22 only allows your old IP. Run `./destroy.sh && ./launch.sh`, or add your new IP in **EC2 → Security Groups**.

## 📝 Notes & lessons learned

- **Never hard-code AMI IDs.** They differ per region and change with every Ubuntu update. AWS publishes the current ones as SSM parameters.
- **Lock SSH down to your IP.** `0.0.0.0/0` on port 22 means bots start guessing within minutes. HTTP can be public.
- **Save state as soon as a resource exists.** `launch.sh` writes `.ec2-state` right after `run-instances`, so `destroy.sh` can still clean up if a later step fails.
- **`aws ec2 wait …`** replaces fragile "sleep and hope" loops; it polls until the instance is running or terminated.
- **`cloud-init status --wait`** is how you know the user-data script has finished. SSH is usually up before Nginx is installed.
- **IMDSv2 (`HttpTokens=required`)** protects the instance's metadata and credentials endpoint from SSRF attacks. It's AWS's recommended default.
- **A security group can't be deleted while an instance still uses it,** so `destroy.sh` waits for termination and then retries.
- **Stretch ideas:** Route 53 for a domain, `certbot --nginx` for HTTPS, or the same thing in Terraform (project 14).
