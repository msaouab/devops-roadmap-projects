# App of Apps and ApplicationSets

> **Level:** Intermediate · **Topic:** GitOps · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [16](../../beginner/16-first-gitops-argocd) · [28](../28-kustomize-multi-env-gitops)<br>
> **Reference:** [Cluster bootstrapping](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/) · [ApplicationSet](https://argo-cd.readthedocs.io/en/stable/user-guide/application-set/)

## 🎯 Goal
Manage many applications declaratively: one `kubectl apply` of a root app recreates the whole cluster setup from Git.

## 📋 Requirements
- [ ] A **root Application** that manages child Applications (app-of-apps pattern)
- [ ] Cluster add-ons as children: cert-manager, gateway, sealed-secrets, metrics-server
- [ ] **Sync waves** so CRDs and operators install before the things that use them
- [ ] An **ApplicationSet** with a **Git directory generator**: every folder under `apps/` becomes an app automatically
- [ ] A second ApplicationSet with a **list or matrix generator** producing one app per environment
- [ ] **AppProjects** restricting which repos/namespaces each group can use
- [ ] Disaster recovery test: delete the kind cluster, recreate it, apply the root app, everything comes back

## 🌟 Stretch goals
- [ ] Manage Argo CD itself with Argo CD (self-managed)
- [ ] Pull request generator: a preview environment per open PR
- [ ] SSO login to Argo CD with GitHub OAuth (Dex) and RBAC per team

## 🎓 What you'll learn
- Scaling GitOps beyond a handful of apps
- Ordering with sync waves and hooks
- Cluster rebuilds as a routine, not a crisis

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
