# Basic DNS Setup

> **Level:** Beginner · **Topic:** DNS · **Status:** 🟨 Ready to run (needs a domain)<br>
> **Brief:** [roadmap.sh/projects/basic-dns](https://roadmap.sh/projects/basic-dns)

## 🎯 Goal
Buy (or reuse) a custom domain and configure DNS records to point it at two kinds of hosting.

## 📋 Requirements
- [ ] Get a domain from a registrar such as Cloudflare, Namecheap or GoDaddy
- [ ] **GitHub Pages:** point the domain at the site from project 04
- [ ] **Droplet:** point DNS records at the static site server from project 06
- [x] Write a markdown tutorial of the steps for both (screenshots encouraged)

## 🎓 What you'll learn
- How DNS records (A, CNAME, …) work
- Connecting a custom domain to GitHub Pages and to a VM

---

## 🧰 Stack

- DNS records: A, AAAA, CNAME (and TXT for GitHub domain verification)
- `dig` + `curl` for checking, on **macOS and Linux**
- GitHub Pages (project 04) and Nginx on a server (project 06)

## 📁 Files

| File | What it is |
|---|---|
| [`TUTORIAL.md`](TUTORIAL.md) | **The deliverable:** step-by-step tutorial for GitHub Pages *and* a Droplet, with HTTPS and troubleshooting |
| `check-dns.sh` | Checks your records, propagation across 3 public resolvers, and HTTP/HTTPS |

## 🚀 How to run

1. Get a domain (e.g. from Cloudflare or Namecheap).
2. Follow **[TUTORIAL.md](TUTORIAL.md)**: Part A for GitHub Pages, Part B for your server.
3. Check each part:

```bash
chmod +x check-dns.sh

./check-dns.sh pages  pages.example.com msaouab        # Pages on a subdomain
./check-dns.sh pages  example.com       msaouab        # Pages on the apex
./check-dns.sh server example.com       203.0.113.10   # your server
```

`dig` comes with macOS. On Linux: `sudo apt install dnsutils` (or `dnf install bind-utils`).

### What the checker verifies

| Section | Checks |
|---|---|
| Nameservers | The domain exists and has NS records |
| Apex | `A` records equal GitHub's 4 Pages IPs, or your server IP. Flags wrong or missing ones. |
| Subdomain / www | `CNAME` → `<user>.github.io`, or `www` → apex / server IP |
| Propagation | Cloudflare `1.1.1.1`, Google `8.8.8.8` and Quad9 `9.9.9.9` all return the right IPs |
| Website | `http://` and `https://` answer 2xx/3xx |

Exits `0` when nothing failed, so you can use it in scripts or CI.

### Tested cases

The test environment has no outbound DNS, so `dig` and `curl` were replaced by stubs returning controlled answers:

| Scenario | Result |
|---|---|
| Pages on the apex, all 4 IPs + www CNAME | 8 passed, 1 warning (no AAAA, which is optional), exit 0 |
| Pages on a subdomain (`pages.example.com`) | 7 passed, exit 0 |
| Server: A → IP, www → apex | 8 passed, exit 0 |
| Wrong IP + wrong www CNAME | Flags the unexpected IP, lists the 3 missing ones and the wrong CNAME, exit 1 |
| Unknown mode | Prints usage, exit 1 |
| `shellcheck` | No warnings |

## 📝 Notes & lessons learned

- **A vs CNAME:** an A record points to an IP; a CNAME points to another name. The apex (`@`) can't be a CNAME, which is why GitHub publishes 4 IPs for apex domains.
- **One name, one destination.** To use both GitHub Pages and a server, split them: apex for one, a subdomain for the other.
- **Lower the TTL before changing records,** then wait out the *old* TTL. That waiting period is "DNS propagation".
- **Always check against several public resolvers,** not just your own machine, which may have a cached answer.
- **Verify your domain on GitHub.** Otherwise, if your Pages site is ever deleted, someone else could attach your domain to *their* repo (a "subdomain takeover").
- **HTTPS is free on both:** GitHub issues certificates automatically; on a server, `certbot --nginx` does it in one command and renews it automatically.
