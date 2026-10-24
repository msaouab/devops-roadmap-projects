# Tutorial: pointing a custom domain at GitHub Pages and at a server

This walks through connecting one domain (`example.com` below; use yours) to:

- **Part A:** the GitHub Pages site from [project 04](../04-github-pages-deployment)
- **Part B:** the Nginx server from [project 06](../06-static-site-server)

After each part, run `./check-dns.sh` to confirm it worked.

---

## 0. The 2-minute DNS primer

DNS is the internet's phone book: it turns `example.com` into an IP address like `203.0.113.10`.

| Term | Meaning |
|---|---|
| **Registrar** | Where you *bought* the domain (Namecheap, Cloudflare, GoDaddy…) |
| **DNS host / nameservers** | Who *answers* questions about the domain. Usually the registrar, but you can delegate to Cloudflare, DigitalOcean, etc. |
| **A record** | name → IPv4 address (`example.com → 203.0.113.10`) |
| **AAAA record** | name → IPv6 address |
| **CNAME record** | name → *another name* (`www.example.com → example.com`) |
| **`@`** | Shorthand for the bare domain itself (the "apex") |
| **TTL** | How many seconds resolvers may cache an answer. Lower it (e.g. 300) before making changes. |

> **One domain can't point to two places.** Use the apex (`example.com` + `www`) for one target and a subdomain (e.g. `pages.example.com`) for the other. This tutorial puts **Pages on `pages.example.com`** and **the server on `example.com`**. Swap them if you prefer.

---

## Part A: GitHub Pages

### A1. Add the DNS record

In your DNS provider's dashboard, add:

| Type | Name | Value | TTL |
|---|---|---|---|
| CNAME | `pages` | `msaouab.github.io` | 300 |

<details>
<summary>Using the apex domain for Pages instead</summary>

| Type | Name | Value |
|---|---|---|
| A | `@` | `185.199.108.153` |
| A | `@` | `185.199.109.153` |
| A | `@` | `185.199.110.153` |
| A | `@` | `185.199.111.153` |
| AAAA (optional) | `@` | `2606:50c0:8000::153`, `…8001::153`, `…8002::153`, `…8003::153` |
| CNAME | `www` | `msaouab.github.io` |

These are GitHub's Pages IPs, listed in GitHub's docs under "Managing a custom domain for your GitHub Pages site". Use all four for redundancy.
</details>

> Never point an apex `A` record at `msaouab.github.io`. A records only take IPs, and a CNAME on the apex breaks email and other records.

### A2. Tell GitHub about the domain

1. Repo → **Settings → Pages → Custom domain** → enter `pages.example.com` → **Save**.
2. Wait for the DNS check to pass, then tick **Enforce HTTPS**. GitHub issues a free Let's Encrypt certificate, which can take up to ~15 minutes.

With a GitHub Actions deployment (like project 04) the domain is stored in the settings, so **no `CNAME` file is needed** in the repo.

**Recommended:** verify the domain for your account (**profile Settings → Pages → Add a domain**). It adds a TXT record that stops anyone else from claiming your domain on GitHub.

### A3. Check it

```bash
./check-dns.sh pages pages.example.com msaouab
```

```
Subdomain: pages.example.com
  ✔ CNAME -> msaouab.github.io
Propagation (same answer from public resolvers?)
  ✔ 1.1.1.1: 185.199.108.153 185.199.109.153 185.199.110.153 185.199.111.153
  ...
Website
  ✔ https://pages.example.com/ -> HTTP 200
```

---

## Part B: the Droplet / server

### B1. Add the DNS records

| Type | Name | Value | TTL |
|---|---|---|---|
| A | `@` | `203.0.113.10` (your server's IP) | 300 |
| CNAME | `www` | `example.com` | 300 |

<details>
<summary>Optional: let DigitalOcean host the DNS</summary>

1. At your registrar, change the nameservers to `ns1.digitalocean.com`, `ns2.digitalocean.com` and `ns3.digitalocean.com`.
2. In DigitalOcean: **Networking → Domains → Add domain**, then add the same A and CNAME records there. Or use the CLI:

```bash
doctl compute domain create example.com --ip-address 203.0.113.10
doctl compute domain records create example.com --record-type CNAME --record-name www --record-data example.com.
```

Nameserver changes can take a few hours to propagate. Record changes after that are fast.
</details>

### B2. Tell Nginx about the domain

Re-run the project 06 setup with your domain so Nginx answers for it:

```bash
ssh myserver 'sudo bash setup-server.sh example.com'
```

### B3. Add HTTPS (free)

```bash
ssh myserver
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d example.com -d www.example.com --redirect
```

Certbot edits the Nginx config, gets the certificate, and sets up automatic renewal.

### B4. Check it

```bash
./check-dns.sh server example.com 203.0.113.10
```

---

## Troubleshooting

| Symptom | Likely cause / fix |
|---|---|
| `no NS records` | Typo in the domain, or the domain has expired |
| Different resolvers give different answers | Old answer still cached. Wait for the old TTL to expire (that's why you lower TTLs first). |
| Works for `example.com` but not `www` | Missing `www` CNAME |
| GitHub says "DNS check unsuccessful" | Record not propagated yet, or an apex CNAME instead of A records |
| Browser shows a certificate warning | HTTPS not issued yet: GitHub → *Enforce HTTPS* / server → run certbot |
| Your server shows the nginx welcome page | Nginx `server_name` not set: re-run `setup-server.sh example.com` |

Handy manual checks (macOS/Linux):

```bash
dig +short A example.com
dig +short CNAME www.example.com
dig +short A example.com @1.1.1.1      # ask a specific resolver
dig +trace example.com                 # follow the lookup from the root servers
```
