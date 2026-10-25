# Bastion Host

> **Level:** Intermediate · **Topic:** Networking · **Status:** ⬜ Not started<br>
> **Brief:** [roadmap.sh/projects/bastion-host](https://roadmap.sh/projects/bastion-host)

## 🎯 Goal
Set up a bastion host: the single public gateway to private servers, which shrinks the attack surface.

## 📋 Requirements
- [ ] Two servers on any cloud: a public **bastion** and a **private server** reachable only from the bastion's IP
- [ ] SSH config that jumps through the bastion (see below)
- [ ] `ssh bastion` works; from the bastion, `ssh private-server` works; from your laptop, `ssh private-server` works directly via ProxyJump
- [ ] Optional: monitor SSH attempts with `fail2ban`
- [ ] Document steps here; **don't publish keys or IPs**

```
Host bastion
    HostName <bastion-ip>
    User <bastion-user>
    IdentityFile <path-to-bastion-private-key>

Host private-server
    HostName <private-server-ip>
    User <private-server-user>
    ProxyJump bastion
    IdentityFile <path-to-private-server-private-key>
```

## 🌟 Stretch goals
- [ ] MFA on the bastion
- [ ] Fine-grained filtering with `iptables`
- [ ] Automate both servers with Terraform or Ansible

## 🎓 What you'll learn
- Bastion host architecture
- Securely managing access to private infrastructure

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
