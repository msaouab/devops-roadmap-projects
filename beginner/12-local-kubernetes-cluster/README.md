# Local Kubernetes Cluster

> **Level:** Beginner · **Topic:** Kubernetes · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** —<br>
> **Reference:** [kind](https://kind.sigs.k8s.io/) · [kubectl](https://kubernetes.io/docs/reference/kubectl/)

## 🎯 Goal
Get a real multi-node Kubernetes cluster running on your laptop (free, disposable) and learn the core `kubectl` workflow: create, inspect, expose, scale, debug and delete.

## 📋 Requirements
- [ ] Install `kubectl` and `kind` (or `k3d`) on macOS/Linux
- [ ] Create a cluster from a config file: **1 control-plane + 2 workers**
- [ ] Run `nginx` as a **Deployment** with 2 replicas and expose it with a **Service**
- [ ] Reach it from your browser with `kubectl port-forward`
- [ ] Scale to 5 replicas and watch pods spread across nodes (`kubectl get pods -o wide`)
- [ ] Delete a pod and watch the Deployment replace it (self-healing)
- [ ] Debug with `kubectl describe`, `logs`, `exec`, `get events`
- [ ] Write `up.sh` / `down.sh` scripts that create and destroy the cluster in one command

## 🌟 Stretch goals
- [ ] Same cluster with `k3d` or `minikube`; note the differences
- [ ] Install `k9s` and do everything above from its TUI
- [ ] Load a locally built image into kind without a registry (`kind load docker-image`)

## 🎓 What you'll learn
- Cluster anatomy: control plane, nodes, kubelet, pods
- Declarative (`apply -f`) vs imperative (`kubectl run`) usage
- The everyday kubectl debugging loop

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
