# Package an App with Helm

> **Level:** Beginner · **Topic:** Helm · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [13](../13-kubernetes-app-manifests)<br>
> **Reference:** [Helm docs](https://helm.sh/docs/) · [Chart best practices](https://helm.sh/docs/chart_best_practices/)

## 🎯 Goal
Package the app as a Helm chart so the same chart deploys to dev and prod with different values, and use a public chart instead of hand-writing the database.

## 📋 Requirements
- [ ] `helm create` a chart and template the Deployment, Service, ConfigMap and Secret
- [ ] Make image, replicas, resources and probes configurable in `values.yaml`
- [ ] `values-dev.yaml` (1 replica, small limits) and `values-prod.yaml` (3 replicas, bigger limits)
- [ ] Use a **dependency** chart for MongoDB (declared in `Chart.yaml`) instead of your own StatefulSet
- [ ] `helm lint` and `helm template` must pass with no errors
- [ ] Install, upgrade (change a value), `helm history` and `helm rollback`
- [ ] Add a `NOTES.txt` that prints how to reach the app after install

## 🌟 Stretch goals
- [ ] Write a `helm test` hook that calls `/healthz`
- [ ] Publish the chart as an **OCI artifact** to GitHub Container Registry
- [ ] Add a `values.schema.json` so bad values fail fast

## 🎓 What you'll learn
- Go templating, values and helpers (`_helpers.tpl`)
- Releases, revisions and rollbacks
- When to write your own chart vs use a community one

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
