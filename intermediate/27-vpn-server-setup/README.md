# VPN Server Setup

> **Level:** Intermediate · **Topic:** VPN · **Status:** ⬜ Not started<br>
> **Brief:** [roadmap.sh/projects/vpn-server-setup](https://roadmap.sh/projects/vpn-server-setup)

## 🎯 Goal
Run your own VPN server (WireGuard or OpenVPN) to secure traffic on untrusted networks and reach private resources remotely.

## 📋 Requirements
- [ ] Prereqs: Linux server with a public IP, a firewall (UFW/iptables), and networking basics
- [ ] **WireGuard (recommended):** install, generate server and client keys, configure `wg0.conf`, enable IP forwarding and NAT, open 51820/UDP, enable the service, create client configs
- [ ] **OpenVPN:** install with Easy-RSA, set up a CA and server certs, configure `server.conf`, enable forwarding and NAT, open 1194/UDP, generate client certs and `.ovpn` files
- [ ] Connect a client, confirm your public IP changes, and check for DNS leaks
- [ ] Create multiple client configs (phone, laptop, tablet)

## 🌟 Stretch goals
- [ ] Split tunneling
- [ ] Pi-hole or AdGuard for ad-blocking
- [ ] Auto-connect on untrusted networks
- [ ] Monitor clients and bandwidth

## 🎓 What you'll learn
- How tunneling, encryption and routing work
- Secure remote access to infrastructure

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
