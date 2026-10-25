# Deploy an App with Manifests

> **Level:** Beginner · **Topic:** Kubernetes · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [27](../27-local-kubernetes-cluster) · reuses the todo API idea from [17](../../intermediate/17-multi-container-application)<br>
> **Reference:** [Workloads](https://kubernetes.io/docs/concepts/workloads/) · [Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)

## 🎯 Goal
Move a two-tier app (Node.js/Express todo API + PostgreSQL) from Docker Compose to plain Kubernetes YAML, using the building blocks every real deployment needs. PostgreSQL replaces the MongoDB used by the original project 17 exercise so this track follows the Next.js + Express + PostgreSQL learning example.

## 📋 Requirements
- [ ] A dedicated **Namespace** for the app
- [ ] API as a **Deployment** (2+ replicas) with **resource requests/limits**
- [ ] **Readiness, liveness and startup probes** on the API (`/healthz`, `/readyz`)
- [ ] Config in a **ConfigMap**, DB password in a **Secret** (injected as env vars)
- [ ] PostgreSQL as a **StatefulSet** with a **PersistentVolumeClaim** — data survives pod deletion
- [ ] **ClusterIP** Service for PostgreSQL, Service for the API; reach the API via `port-forward`
- [ ] Zero-downtime update: change the image tag and watch `kubectl rollout status`; then `rollout undo`
- [ ] All YAML in `k8s/`, applied with one `kubectl apply -f k8s/`

## 🌟 Stretch goals
- [ ] Add a **Job** that seeds the database and a **CronJob** that cleans old todos
- [ ] Run as non-root with a `securityContext` and read-only root filesystem
- [ ] Add a **NetworkPolicy** so only the API can reach MongoDB

## 🎓 What you'll learn
- Deployment vs StatefulSet, Service types, ConfigMap vs Secret
- PostgreSQL container configuration, persistent storage and API-to-database connectivity
- Why probes and resource limits matter for stability
- Rolling updates and rollbacks

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
