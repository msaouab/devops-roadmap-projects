# Kubernetes the Hard Way

> **Level:** Advanced · **Topic:** Kubernetes · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [21](../../intermediate/21-linux-server-setup) · [27](../../beginner/27-local-kubernetes-cluster)<br>
> **Reference:** [kelseyhightower/kubernetes-the-hard-way](https://github.com/kelseyhightower/kubernetes-the-hard-way)

## 🎯 Goal
The capstone for understanding: no installers. Build every component of a Kubernetes cluster yourself so nothing about it is magic any more.

## 📋 Requirements
- [ ] Follow Kelsey Hightower's guide on 3–4 VMs (local with Multipass/Vagrant, or cheap cloud VMs)
- [ ] Generate the **CA and TLS certificates** for every component
- [ ] Bootstrap **etcd**, the **API server, controller manager and scheduler**
- [ ] Configure **kubelet, kube-proxy, containerd** on the workers
- [ ] Set up pod networking routes and **CoreDNS**
- [ ] Smoke tests: encrypted Secrets at rest, Deployment, port-forward, logs, exec, NodePort
- [ ] Write your own notes per step: what each component does and what breaks without it

## 🌟 Stretch goals
- [ ] Automate your whole run with Ansible (project 13)
- [ ] Break things on purpose (stop etcd, expire a cert) and diagnose
- [ ] Compare with `kubeadm init` — what did it do for you?

## 🎓 What you'll learn
- How the control plane really works
- PKI and component authentication
- Debugging clusters from first principles

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
