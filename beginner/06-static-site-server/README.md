# Static Site Server

> **Level:** Beginner · **Topic:** Nginx · **Status:** 🟨 Ready to run (needs your server)<br>
> **Brief:** [roadmap.sh/projects/static-site-server](https://roadmap.sh/projects/static-site-server)

## 🎯 Goal
Serve a static site from a Linux server with Nginx, and deploy updates with `rsync`.

## 📋 Requirements
- [ ] Create a remote Linux server (DigitalOcean, AWS, …) and connect over SSH
- [x] Install and configure Nginx to serve a static site
- [x] Build a simple page with HTML, CSS and an image
- [x] Use `rsync` to push the local site to the server
- [x] Serve it on a domain if you have one, otherwise on the server IP
- [x] Write a `deploy.sh` script that runs the sync in one step

## 🎓 What you'll learn
- Setting up an Nginx web server
- Deploying static files with `rsync`

---

## 🧰 Stack

- **Nginx** on a Linux server (Ubuntu/Debian, Fedora/RHEL, Alpine)
- **rsync over SSH** for deploys, from **macOS or Linux**
- HTML + CSS + an SVG image, with no build step

## 📁 Files

| File | Runs on | What it is |
|---|---|---|
| `site/` | — | The website: `index.html`, `style.css`, `images/server.svg`, `404.html` |
| `nginx/static-site.conf` | server | Nginx site config: caching, gzip, security headers, custom 404 |
| `server/setup-server.sh` | server | Installs nginx + rsync, creates `/var/www/static-site`, installs the config, opens the firewall, starts nginx |
| `deploy.sh` | your Mac / Linux | Syncs `site/` to the server with rsync, then checks the site returns HTTP 200 |

## 🚀 How to run

You need a Linux server you can SSH into. Project 05 gives you the `myserver` alias.

**1. Set up nginx on the server (once):**

```bash
scp server/setup-server.sh nginx/static-site.conf myserver:
ssh myserver 'sudo bash setup-server.sh'               # serve on the server's IP
ssh myserver 'sudo bash setup-server.sh example.com'   # or on your domain
```

**2. Deploy from your machine:**

```bash
./deploy.sh -n myserver   # dry run: show what would change
./deploy.sh myserver      # deploy for real
```

```
==> Syncing site/ -> myserver:/var/www/static-site
<f+++++++++ index.html
<f+++++++++ style.css
cd+++++++++ images/
<f+++++++++ images/server.svg
==> Checking http://203.0.113.10/
Live: http://203.0.113.10/ (HTTP 200)
```

Edit anything in `site/` and run `./deploy.sh myserver` again: only the changed files are sent, and files you deleted locally are removed from the server too.

| `deploy.sh` option | What it does |
|---|---|
| `-n` | Dry run |
| `-p <port>` | SSH port |
| `-d <dir>` | Remote web root (default `/var/www/static-site`) |
| `-u <url>` | URL to check after deploy (e.g. `https://example.com/`) |

**Preview locally** (macOS/Linux): `cd site && python3 -m http.server 8000`

## 🔍 How it works

```
your laptop                         server
───────────                         ──────
site/  ──rsync over SSH──►  /var/www/static-site/  ◄── nginx :80 ◄── browser
```

- **`rsync -az --delete`** compares files and only sends what changed. `--delete` keeps the server an exact mirror of `site/`.
- **`--chmod=D755,F644`** makes uploaded files readable by nginx, whatever your local permissions are.
- **`--exclude .git .env .DS_Store`** means secrets and macOS junk never get uploaded.
- **`try_files $uri $uri/ =404`** serves the file, else a folder's `index.html`, else the custom 404 page.

### Tested cases

`setup-server.sh` was run on a fresh Ubuntu 24.04 with a real nginx, and `deploy.sh` was tested against a real SSH server:

| Check | Result |
|---|---|
| `GET /` | `200 text/html` |
| `GET /style.css` | `200`, cached 7 days, gzip-compressed |
| `GET /images/server.svg` | `200 image/svg+xml` |
| `GET /nope` | `404` with the custom page |
| `GET /.env` (hidden file) | `403`, blocked |
| Security headers | `nosniff`, `X-Frame-Options: DENY`, `Referrer-Policy`; nginx version hidden |
| Server without IPv6 | Detected; listens on IPv4 only |
| Setup run twice | Same result, nothing broken |
| `deploy.sh -n` | Lists changes, uploads nothing |
| Redeploy with no changes | Nothing transferred |
| Stale file on server | Removed (`*deleting stale.html`) |
| Site unreachable | Clear warning, exit 1 |
| `shellcheck` | No warnings |

## 📝 Notes & lessons learned

- **rsync beats scp for deploys.** It only sends differences, can delete removed files, and `-n` lets you preview a deploy safely.
- **Always `nginx -t` before reloading,** so a typo in the config never takes the site down. `reload` (not `restart`) applies changes without dropping connections.
- **Remove the default site.** Ubuntu ships `sites-enabled/default` with its own `default_server`, which would show the nginx welcome page instead of yours.
- **The web root is owned by the deploy user,** so `deploy.sh` never needs `sudo`.
- **Not every server has IPv6.** `listen [::]:80` makes nginx refuse to start when IPv6 is disabled. The setup script checks `/proc/net/if_inet6` first.
- **Distro differences:** Debian uses `sites-available`/`sites-enabled`, RHEL uses `conf.d/` (plus SELinux labels), Alpine uses `http.d/`. One script handles all three.
- **macOS:** recent macOS ships `openrsync`. If an rsync option misbehaves, `brew install rsync` gets the full GNU version.
- **Next step:** HTTPS with Let's Encrypt (`sudo apt install certbot python3-certbot-nginx && sudo certbot --nginx -d example.com`) once you have a domain (project 07).
