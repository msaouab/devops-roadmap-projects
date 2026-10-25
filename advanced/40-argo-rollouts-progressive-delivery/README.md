# Progressive Delivery with Argo Rollouts

> **Level:** Advanced · **Topic:** GitOps · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [29](../../intermediate/29-ci-to-gitops-pipeline) · [33](../../intermediate/33-k8s-observability-stack) · [36](../36-blue-green-deployment)<br>
> **Reference:** [Argo Rollouts](https://argoproj.github.io/argo-rollouts/)

## 🎯 Goal
Release safely: new versions get a small share of traffic first, and an automated analysis decides whether to continue or roll back, without a human watching dashboards.

## 📋 Requirements
- [ ] Replace the Deployment with an Argo Rollouts **Rollout** (managed by Argo CD)
- [ ] **Canary** steps: 10% → pause → 30% → 60% → 100%
- [ ] **AnalysisTemplate** querying Prometheus: error rate < 1% and p95 latency < 300 ms
- [ ] Ship a deliberately bad version (returns 500s) → analysis fails → **automatic rollback**
- [ ] Ship a good version → promoted to 100% automatically
- [ ] Traffic splitting via the Gateway API plugin (or replica-based for simplicity)
- [ ] Also implement **blue-green** with a preview Service and pre-promotion analysis; compare both

## 🌟 Stretch goals
- [ ] Header-based routing so testers hit the canary first
- [ ] Notifications on promotion/abort to Slack
- [ ] Run k6 smoke tests as a Job inside the analysis

## 🎓 What you'll learn
- Canary vs blue-green vs rolling updates
- Metric-driven, automated release decisions
- Limiting the blast radius of bad releases

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
