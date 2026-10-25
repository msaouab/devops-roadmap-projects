# Multi-Cluster GitOps Platform

> **Level:** Advanced · **Topic:** Platform · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [32](../../intermediate/32-argocd-app-of-apps) · [42](../42-terraform-k8s-gitops-bootstrap)<br>
> **Reference:** [ApplicationSet cluster generator](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Generators-Cluster/) · [Argo CD RBAC](https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac/)

## 🎯 Goal
Operate like a platform team: a management cluster runs Argo CD and fleets of workload clusters receive add-ons and apps based on labels.

## 📋 Requirements
- [ ] 3 clusters (kind locally is fine): `mgmt`, `dev`, `prod`; register `dev`/`prod` in Argo CD
- [ ] **Cluster generator** ApplicationSet: add-ons go to every cluster labelled `env`
- [ ] Apps target clusters by label (e.g. `env=prod`, `region=eu`)
- [ ] **AppProjects + RBAC**: team A can only deploy to its namespaces; read-only role for everyone else
- [ ] **Sync windows**: no automatic prod syncs outside working hours
- [ ] Add a 4th cluster by registering it with labels only — it receives everything automatically
- [ ] Architecture diagram + runbook: onboard a team, add a cluster, roll back a bad add-on

## 🌟 Stretch goals
- [ ] SSO with GitHub teams mapped to Argo CD roles
- [ ] Hub-and-spoke vs Argo CD per cluster: write up the trade-offs
- [ ] Cost / resource dashboard per team

## 🎓 What you'll learn
- Platform engineering patterns
- Fleet management with label selectors
- Multi-tenancy and guardrails

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
