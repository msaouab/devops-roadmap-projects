# Gateway API, TLS and DNS on Kubernetes

> **Level:** Intermediate · **Topic:** Networking · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [13](../../beginner/13-kubernetes-app-manifests) · [07](../../beginner/07-basic-dns-setup)<br>
> **Reference:** [Gateway API](https://gateway-api.sigs.k8s.io/) · [cert-manager](https://cert-manager.io/docs/) · [Ingress NGINX retirement](https://kubernetes.io/blog/2025/11/11/ingress-nginx-retirement/)

## 🎯 Goal
Route real traffic into the cluster with the **Gateway API** and a maintained implementation. The Kubernetes project retired the **Ingress NGINX controller** in March 2026; this does not mean that the Kubernetes Ingress API or all Ingress controllers were retired. The Ingress API remains supported but is frozen, while Gateway API is the actively developed alternative recommended for new work.

## 📋 Requirements
- [ ] Install a Gateway API implementation (e.g. **Envoy Gateway** or **Traefik**) via Argo CD
- [ ] Create a **Gateway** and **HTTPRoutes**: `/api` → API, `/` → a static frontend
- [ ] Host-based routing for two hostnames (e.g. `app.` and `grafana.`)
- [ ] Install **cert-manager**; issue certificates with Let's Encrypt **staging** first, then production
- [ ] Force HTTP → HTTPS redirect
- [ ] Locally: use a self-signed **ClusterIssuer** + `/etc/hosts`; on a cloud cluster: a real domain
- [ ] Write a short note distinguishing the retired Ingress NGINX controller from the still-supported, frozen Ingress API, and explain how Gateway API differs

## 🌟 Stretch goals
- [ ] **external-dns** creates DNS records automatically from routes
- [ ] Traffic splitting 90/10 between two versions with HTTPRoute weights
- [ ] Rate limiting or basic auth at the gateway

## 🎓 What you'll learn
- North-south traffic: Service types vs Ingress vs Gateway API
- TLS automation with ACME
- Role separation: infra owns Gateways, app teams own Routes

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
