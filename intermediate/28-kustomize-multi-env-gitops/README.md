# Multi-Environment GitOps with Kustomize

> **Level:** Intermediate · **Topic:** GitOps · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [16](../../beginner/16-first-gitops-argocd)<br>
> **Reference:** [Kustomize](https://kubectl.docs.kubernetes.io/references/kustomize/) · [Argo CD + Kustomize](https://argo-cd.readthedocs.io/en/stable/user-guide/kustomize/)

## 🎯 Goal
Run the same app in dev, staging and prod with environment-specific differences, keeping config DRY and making every promotion a reviewed pull request.

## 📋 Requirements
- [ ] Separate **config repo** (or `gitops/` folder) with `base/` and `overlays/{dev,staging,prod}`
- [ ] Overlays change replicas, resources, image tag, ConfigMap values and namespace
- [ ] Each environment gets its own Argo CD Application (dev auto-syncs; prod requires manual sync)
- [ ] **Promotion:** a PR that bumps the image tag in `staging` → merge → then the same for `prod`
- [ ] Protect `prod` with branch protection / CODEOWNERS review
- [ ] `kustomize build` for every overlay runs in CI and must pass
- [ ] README diagram of the promotion flow

## 🌟 Stretch goals
- [ ] Render the diff of each PR (`argocd app diff` or kustomize build diff) as a PR comment
- [ ] Use **components** for optional features (e.g. debug sidecar in dev only)
- [ ] Compare with a Helm-values approach and write up trade-offs

## 🎓 What you'll learn
- Environment strategy: folders vs branches (and why folders win)
- Kustomize patches, components and image overrides
- Change management with PRs

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
