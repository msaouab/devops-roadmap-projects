# Policy as Code and Supply-Chain Security

> **Level:** Advanced · **Topic:** Security · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [30](../../beginner/30-ci-build-test-scan-push) · [36](../../intermediate/36-argocd-app-of-apps)<br>
> **Reference:** [Kyverno](https://kyverno.io/docs/) · [Sigstore cosign](https://docs.sigstore.dev/) · [SLSA](https://slsa.dev/)

## 🎯 Goal
Make the cluster refuse anything that doesn't meet your rules, and prove that every running image was built by your pipeline.

## 📋 Requirements
- [ ] Install **Kyverno** via Argo CD
- [ ] Policies (start in `Audit`, then `Enforce`): no `:latest` tags, resource limits required, no privileged pods, run as non-root, approved registries only
- [ ] **cosign keyless signing** in GitHub Actions (OIDC, no keys to manage)
- [ ] Generate an **SBOM** (Syft) and attach it as an attestation
- [ ] Kyverno **verifyImages** policy: only signed images from your repo's workflow may run
- [ ] Prove it: an unsigned image and a `:latest` image are both rejected at admission
- [ ] Policy tests with the Kyverno CLI in CI (`kyverno test`)

## 🌟 Stretch goals
- [ ] SLSA provenance attestation and verify it
- [ ] Mutating policy that adds default labels/securityContext
- [ ] Policy reports dashboard in Grafana

## 🎓 What you'll learn
- Admission control and policy engines
- Software supply-chain threats and Sigstore
- Shift-left policies tested like code

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
