# GitOps Secrets Management

> **Level:** Intermediate · **Topic:** Security · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [31](../../beginner/31-first-gitops-argocd)<br>
> **Reference:** [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) · [External Secrets Operator](https://external-secrets.io/)

## 🎯 Goal
Solve GitOps' classic problem: everything lives in Git, but secrets must not. Implement two approaches and compare them.

## 📋 Requirements
- [ ] **Approach A — Sealed Secrets:** encrypt the DB password with `kubeseal`; only the cluster can decrypt it
- [ ] **Approach B — External Secrets Operator:** sync the same secret from an external store (HashiCorp Vault in dev mode, or a cloud secret manager)
- [ ] Both deployed via Argo CD; the app consumes a normal Kubernetes Secret either way
- [ ] **Rotation:** change the secret at the source and show the app picks it up (rolling restart)
- [ ] CI check (e.g. `gitleaks`) that fails if a plaintext secret is ever committed
- [ ] Back up the Sealed Secrets controller key and document disaster recovery
- [ ] Comparison table: security, ops effort, rotation, multi-cluster

## 🌟 Stretch goals
- [ ] Use **SOPS + age** as a third approach
- [ ] Use **Reloader** to restart pods automatically when a secret changes
- [ ] Short-lived **dynamic database credentials** from Vault

## 🎓 What you'll learn
- Threat model of secrets in Git
- Encryption-at-rest in Git vs references to an external store
- Secret rotation and recovery

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
