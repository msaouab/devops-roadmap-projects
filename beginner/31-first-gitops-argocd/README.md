# First GitOps Deployment with Argo CD

> **Level:** Beginner · **Topic:** GitOps · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [27](../27-local-kubernetes-cluster) · [28](../28-kubernetes-app-manifests) or [29](../29-helm-chart)<br>
> **Reference:** [Argo CD getting started](https://argo-cd.readthedocs.io/en/stable/getting_started/) · [OpenGitOps principles](https://opengitops.dev/)

## 🎯 Goal
Experience GitOps: Git is the single source of truth, and a controller in the cluster continuously makes the cluster match it.

## 📋 Requirements
- [ ] Install Argo CD in the kind cluster and log in to the UI and the `argocd` CLI
- [ ] Create an **Application** (as YAML, committed to Git) that points at your manifests or Helm chart
- [ ] Enable **automated sync** with **prune** and **self-heal**
- [ ] Change replicas in Git → Argo CD applies it; no `kubectl apply`
- [ ] **Drift test:** `kubectl scale` by hand → Argo CD reverts it
- [ ] **Rollback test:** break the app in a commit, then fix it with `git revert`
- [ ] Document the 4 GitOps principles and how your setup meets each one

## 🌟 Stretch goals
- [ ] Add a sync **wave** so the database is ready before the API
- [ ] Configure **notifications** to Slack/Discord on sync failures
- [ ] Create an Argo CD **Project** that limits which repos/namespaces the app may use

## 🎓 What you'll learn
- Push-based CD vs pull-based GitOps
- Sync, health, drift and self-healing
- Rollback = `git revert`

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
