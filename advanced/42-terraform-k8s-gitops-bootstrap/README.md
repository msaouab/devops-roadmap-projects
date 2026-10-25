# Production Cluster: Terraform + GitOps Bootstrap

> **Level:** Advanced · **Topic:** IaC · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [19](../../intermediate/19-iac-digitalocean) · [32](../../intermediate/32-argocd-app-of-apps)<br>
> **Reference:** [DigitalOcean Kubernetes (Terraform)](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/kubernetes_cluster) · [AWS EKS module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)

## 🎯 Goal
Go from zero to a production-style cluster with two commands: Terraform builds the infrastructure, Argo CD builds everything inside it.

## 📋 Requirements
- [ ] Terraform for a managed cluster (**DOKS** for low cost, or **EKS**): VPC, node pool(s), autoscaling
- [ ] **Remote state** with locking (S3-compatible bucket); no state in Git
- [ ] Terraform installs only Argo CD + the root Application (Helm provider); **everything else comes from Git**
- [ ] Separate `dev` and `prod` with workspaces or directories
- [ ] CI: `terraform fmt`, `validate`, `tflint`, `plan` on PR, posted as a comment; `apply` only after approval
- [ ] `make up` / `make down` with a cost estimate (e.g. Infracost) in the README
- [ ] Prove reproducibility: destroy and recreate; the apps come back on their own

## 🌟 Stretch goals
- [ ] Workload identity (IRSA / DO tokens) instead of static cloud keys
- [ ] Cluster upgrades: bump the version and roll node pools safely
- [ ] Drift detection: scheduled `terraform plan` that alerts on changes

## 🎓 What you'll learn
- The IaC / GitOps boundary: who owns what
- Remote state, locking and safe applies
- Reproducible infrastructure

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
