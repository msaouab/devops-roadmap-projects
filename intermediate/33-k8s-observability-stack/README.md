# Kubernetes Observability Stack

> **Level:** Intermediate · **Topic:** Monitoring · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [32](../32-argocd-app-of-apps) · ideas from [37](../../advanced/37-prometheus-and-grafana)<br>
> **Reference:** [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) · [Grafana Loki](https://grafana.com/docs/loki/latest/)

## 🎯 Goal
Know what's happening inside the cluster: install a production-style monitoring stack through Argo CD and instrument your own app.

## 📋 Requirements
- [ ] Install **kube-prometheus-stack** (Prometheus, Alertmanager, Grafana, node-exporter, kube-state-metrics) via Argo CD
- [ ] Expose `/metrics` from the API (request count, latency histogram, errors)
- [ ] A **ServiceMonitor** so Prometheus scrapes the app automatically
- [ ] Grafana dashboard **as code** (ConfigMap) with the 4 golden signals: latency, traffic, errors, saturation
- [ ] **PrometheusRule** alerts: pod crash-looping, high error rate, high latency → Alertmanager → Slack/Discord/email
- [ ] **Loki + Alloy/Promtail** for logs; jump from a metric spike to the logs in Grafana
- [ ] Trigger each alert on purpose and capture screenshots

## 🌟 Stretch goals
- [ ] Define an **SLO** (e.g. 99% of requests < 300 ms) and a burn-rate alert
- [ ] Add tracing with OpenTelemetry + Tempo
- [ ] Persist Prometheus data and set retention

## 🎓 What you'll learn
- Pull-based metrics and the Prometheus Operator CRDs
- Golden signals, SLIs and SLOs
- Alerting that's actionable instead of noisy

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
