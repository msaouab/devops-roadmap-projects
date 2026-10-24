# GitHub Pages Deployment

> **Level:** Beginner · **Topic:** CI/CD · **Status:** ✅ Done · **Live:** [msaouab.github.io/devops-roadmap-projects](https://msaouab.github.io/devops-roadmap-projects/)<br>
> **Brief:** [roadmap.sh/projects/github-actions-deployment-workflow](https://roadmap.sh/projects/github-actions-deployment-workflow)

## 🎯 Goal
Write a GitHub Actions workflow that deploys a static site to GitHub Pages: an intro to CI/CD.

## 📋 Requirements
- [x] Create a repo (e.g. `gh-deployment-workflow`)
- [x] Add an `index.html` with a "Hello, GitHub Actions!" message
- [x] Add a `README.md` explaining the project
- [x] Add `.github/workflows/deploy.yml`
- [x] Deploy only on pushes to `main`, and only when `index.html` changes
- [x] Site is live at `https://<username>.github.io/<repository-name>/` and updates on each change

## 🌟 Stretch goals
- [ ] Build a richer site (e.g. a portfolio) with a static site generator such as Hugo, Jekyll or Astro

## 🎓 What you'll learn
- GitHub Actions and GitHub Pages
- Writing CI/CD workflows with path and branch filters

---

## 🧰 Stack

- GitHub Actions + GitHub Pages
- Official actions: `checkout`, `configure-pages`, `upload-pages-artifact`, `deploy-pages`
- Plain HTML/CSS (no build step)

## 📁 Files

| File | What it is |
|---|---|
| `site/index.html` | The page ("Hello, GitHub Actions!") |
| [`/.github/workflows/gh-pages-deploy.yml`](../../.github/workflows/gh-pages-deploy.yml) | **The workflow this repo uses.** It lives at the repo root because GitHub only runs workflows from there. |
| `deploy.yml` | Standalone version for a repo with `index.html` at its root, as described in the brief |

## 🚀 How to run

**One-time setup** (in the GitHub repo):

1. Go to **Settings → Pages**.
2. Under **Build and deployment → Source**, choose **GitHub Actions**.

**Deploy:**

```bash
# edit the page, then push to main
vim beginner/04-github-pages-deployment/site/index.html
git commit -am "Update page" && git push origin main
```

The site goes live at **https://msaouab.github.io/devops-roadmap-projects/** about a minute later. You can follow the run in the **Actions** tab, or start one by hand there with **Run workflow**.

**Preview locally** (macOS and Linux):

```bash
cd beginner/04-github-pages-deployment/site && python3 -m http.server 8000
# open http://localhost:8000
```

## 🔍 How it works

```
push to main ──► path filter: did site/index.html change? ──no──► nothing runs
                                    │ yes
                                    ▼
      checkout → stamp commit/time → configure-pages → upload artifact → deploy
```

- **`on.push.branches: [main]` + `paths:`** is what makes it deploy *only* when `index.html` changes on `main`. Pushes that touch other projects in this repo don't trigger it.
- **`permissions: pages: write, id-token: write`:** the deploy action uses a short-lived OIDC token instead of a stored secret.
- **`concurrency: pages`:** if you push twice quickly, the older deploy is cancelled.
- **The stamp step** replaces `{{COMMIT}}` and `{{BUILD_TIME}}` in the page, so you can see on the live site exactly which commit is deployed.

## 📝 Notes & lessons learned

- **Workflows must live in `.github/workflows/` at the repo root.** In a monorepo, scope each workflow to its project with `paths:` filters.
- **Pages "Source" must be set to *GitHub Actions*,** otherwise GitHub tries to serve the branch directly and ignores the workflow's artifact.
- **`workflow_dispatch`** adds a manual "Run workflow" button, which is handy for the first deploy or a redeploy without changing the file.
- **Stamping the commit SHA into the output** is a simple way to answer "what version is live right now?", a habit worth keeping for every deployment.
- **Next step (stretch):** swap the plain HTML for a static site generator (Hugo, Jekyll, Astro) and add a build step before `upload-pages-artifact`.
