# Full CI → GitOps CD Loop

> **Level:** Intermediate · **Topic:** CI/CD · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [15](../../beginner/15-ci-build-test-scan-push) · [28](../28-kustomize-multi-env-gitops)<br>
> **Reference:** [Argo CD Image Updater](https://argocd-image-updater.readthedocs.io/) · [GitHub Actions](https://docs.github.com/en/actions)

## 🎯 Goal
Connect CI and GitOps CD into one automated flow, without CI ever touching the cluster directly.

## 📋 Requirements
- [ ] App repo CI builds and pushes an image tagged with the git SHA (project 15)
- [ ] CI then **commits the new tag** to the config repo's `dev` overlay (`kustomize edit set image`)
- [ ] Use a **deploy key / GitHub App** with write access to the config repo only — CI has **no cluster credentials**
- [ ] Argo CD picks up the commit and deploys to dev automatically
- [ ] Promotion to staging/prod stays a **pull request** created by the pipeline
- [ ] Commit messages link back to the app commit (traceability)
- [ ] Show the end-to-end time from merge to running pod

## 🌟 Stretch goals
- [ ] Replace the commit step with **Argo CD Image Updater** and compare both approaches
- [ ] Post the deployment status back to the original PR
- [ ] Add a smoke test job that runs after Argo CD reports `Healthy`

## 🎓 What you'll learn
- Separating CI (build) from CD (deploy)
- Least-privilege credentials in pipelines
- Image promotion patterns

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
