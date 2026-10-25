# Autoscaling and Resilience

> **Level:** Intermediate · **Topic:** Kubernetes · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [28](../../beginner/28-kubernetes-app-manifests) · [37](../37-k8s-observability-stack)<br>
> **Reference:** [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) · [k6](https://grafana.com/docs/k6/latest/)

## 🎯 Goal
Turn a working deployment into a resilient one: right-sized, autoscaled, spread across nodes and protected during maintenance.

## 📋 Requirements
- [ ] Install **metrics-server**; set realistic CPU/memory **requests and limits** based on measurements
- [ ] **HPA** on CPU (min 2, max 10); show it scaling during a **k6** load test
- [ ] **PodDisruptionBudget** so a node drain never takes all replicas down
- [ ] **Topology spread constraints / anti-affinity** so replicas land on different nodes
- [ ] Graceful shutdown: handle SIGTERM + `preStopHook` so no requests fail during rollouts
- [ ] Chaos test: delete pods and drain a node during load — error rate stays ~0%
- [ ] Before/after report with Grafana screenshots (latency, replicas, errors)

## 🌟 Stretch goals
- [ ] Scale on a custom metric (requests/sec) with the Prometheus adapter or **KEDA**
- [ ] Vertical Pod Autoscaler in recommendation mode to tune requests
- [ ] Cluster Autoscaler / Karpenter on a cloud cluster

## 🎓 What you'll learn
- Requests vs limits, QoS classes and OOMKills
- HPA mechanics and its limits
- Designing for failure

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
