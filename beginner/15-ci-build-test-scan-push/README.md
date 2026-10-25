# CI Pipeline: Build, Test, Scan, Push

> **Level:** Beginner · **Topic:** CI/CD · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [10](../10-basic-dockerfile) · [13](../13-kubernetes-app-manifests)<br>
> **Next:** [35 · Jenkins CI Pipeline](../../intermediate/35-jenkins-ci-pipeline) rebuilds this pipeline in Jenkins<br>
> **Reference:** [GitHub Actions](https://docs.github.com/en/actions) · [Trivy](https://trivy.dev/)

## 🎯 Goal
Build the Continuous Integration half of CI/CD: every pull request is tested, and every merge to `main` produces a scanned, uniquely tagged image in a registry.

## 📋 Requirements
- [ ] Workflow triggers: `pull_request` (test only) and `push` to `main` (test + build + push)
- [ ] Lint and unit tests run first; a failing test blocks the build
- [ ] **Multi-stage Dockerfile** producing a small, non-root image
- [ ] Build with Docker Buildx and **layer caching** (`cache-from/to: type=gha`)
- [ ] Tag images with the **git SHA** (and `latest` on main) via `docker/metadata-action`
- [ ] **Trivy** scan: fail the pipeline on `CRITICAL` vulnerabilities
- [ ] Push to **GitHub Container Registry** using `GITHUB_TOKEN` (no personal tokens)
- [ ] Path filters so the workflow only runs when this project changes

## 🌟 Stretch goals
- [ ] Matrix-test on 2 Node.js versions
- [ ] Build multi-arch images (`linux/amd64,linux/arm64`) for Apple Silicon
- [ ] Upload the Trivy report as SARIF to the GitHub **Security** tab

## 🎓 What you'll learn
- CI stages and fast feedback
- Image tagging strategies (why not only `latest`)
- Shifting security left with image scanning

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
