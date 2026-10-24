# SSH Remote Server Setup

> **Level:** Beginner · **Topic:** SSH · **Status:** 🟨 Ready to run (needs your server)<br>
> **Brief:** [roadmap.sh/projects/ssh-remote-server-setup](https://roadmap.sh/projects/ssh-remote-server-setup)

## 🎯 Goal
Provision a remote Linux server and configure key-based SSH access to it.

## 📋 Requirements
- [ ] Create a Linux server on any provider (DigitalOcean, AWS, …)
- [x] Generate two new SSH key pairs and add both to the server
- [x] Connect with each key: `ssh -i <path-to-private-key> user@server-ip`
- [x] Add a `~/.ssh/config` entry so `ssh <alias>` works
- [x] Document the steps in this README; **never commit private keys**

## 🌟 Stretch goals
- [x] Install and configure `fail2ban` against brute-force attacks

## 🎓 What you'll learn
- Generating and managing SSH keys
- Configuring SSH client aliases
- Basic remote server access

---

## 🧰 Stack

- OpenSSH (`ssh`, `ssh-keygen`), Ed25519 keys
- Bash. The client script runs on **macOS and Linux**; the server script runs on the **Linux server**.
- `fail2ban` on the server (stretch goal)

## 📁 Files

| File | Runs on | What it does |
|---|---|---|
| `setup-ssh.sh` | your Mac / Linux machine | Creates 2 key pairs, installs them on the server, adds a `~/.ssh/config` alias, tests all 3 ways in |
| `server/install-fail2ban.sh` | the server | Installs and enables fail2ban for SSH (apt / dnf / yum / apk) |
| `server/jail.local` | the server | fail2ban rules: 5 failures in 10 min → banned 1 h |

## 🚀 How to run

**1. Create a server.** For example a DigitalOcean droplet (Ubuntu, cheapest size). When creating it, add your existing public key (`~/.ssh/id_ed25519.pub`) or set a root password.

**2. Set up the keys and alias:**

```bash
chmod +x setup-ssh.sh

# with the key you gave the cloud provider
./setup-ssh.sh -b ~/.ssh/id_ed25519 root@203.0.113.10 myserver

# or, with a root password (asked once per key)
./setup-ssh.sh root@203.0.113.10 myserver
```

```
==> Generating key pairs
  created: ~/.ssh/myserver_key1
  created: ~/.ssh/myserver_key2
==> Copying public keys to root@203.0.113.10 (port 22)
  installed: myserver_key1.pub
  installed: myserver_key2.pub
==> Adding 'Host myserver' to ~/.ssh/config
  added
==> Testing
  OK   ssh -i ~/.ssh/myserver_key1 root@203.0.113.10
  OK   ssh -i ~/.ssh/myserver_key2 root@203.0.113.10
  OK   ssh myserver

All good. Connect with:  ssh myserver
```

**3. Connect** any of the three ways the brief asks for:

```bash
ssh -i ~/.ssh/myserver_key1 root@203.0.113.10
ssh -i ~/.ssh/myserver_key2 root@203.0.113.10
ssh myserver
```

**4. (Stretch) Install fail2ban on the server:**

```bash
scp server/install-fail2ban.sh server/jail.local myserver:
ssh myserver 'sudo bash install-fail2ban.sh'
ssh myserver 'sudo fail2ban-client status sshd'   # see banned IPs
```

The alias block it writes to `~/.ssh/config`:

```
Host myserver
    HostName 203.0.113.10
    User root
    Port 22
    IdentityFile ~/.ssh/myserver_key1
    IdentityFile ~/.ssh/myserver_key2
    IdentitiesOnly yes
    AddKeysToAgent yes
```

### Tested cases

Tested end to end against a real `sshd` on port 2222:

| Case | Result |
|---|---|
| First run with `-b` bootstrap key | 2 keys created + installed, alias added, 3/3 checks OK |
| Second run | Keys reused, config unchanged, no duplicate lines in `authorized_keys` |
| `foo bar` | `Error: target must look like user@host` |
| `-p x` | `Error: port must be a number` |
| alias with a space | `Error: alias may only contain letters, digits, . _ -` |
| `shellcheck` | No warnings |

## 🔐 Security

- **Private keys never leave your machine.** Only the `.pub` files are copied, and `*.pem`, `*.key` and `id_*` are in `.gitignore`.
- **Don't commit your real server IP or `~/.ssh/config`.** The examples use `203.0.113.10`, an address reserved for documentation.
- Once key login works, the next step is to **disable password login**. That's covered in project 21 (Linux Server Setup).

## 📝 Notes & lessons learned

- **Ed25519 > RSA** for new keys: shorter, faster and secure by default. `-a 100` makes a stolen passphrase-protected key much harder to crack.
- **Copy keys with plain `ssh`, not `ssh-copy-id`.** `ssh-copy-id` isn't on every system. Piping the key into `ssh` with a `grep -qxF … || echo …` guard works everywhere and never adds a key twice.
- **`IdentitiesOnly yes` matters.** Without it ssh offers *every* key in your agent first, and servers often disconnect after 6 failed keys ("Too many authentication failures").
- **`StrictHostKeyChecking=accept-new`** trusts a brand-new server on first connect but still refuses if a known server's host key changes, which is the right balance for automation.
- **Permissions:** `~/.ssh` must be `700` and `authorized_keys` `600`, or sshd silently ignores your keys.
- **fail2ban:** newer Ubuntu/Debian log SSH to journald, not `/var/log/auth.log`, so the jail needs `backend = systemd`. The script detects this.
