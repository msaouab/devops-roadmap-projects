# 🛠️ DevOps Roadmap Projects

> Hands-on DevOps projects from the [roadmap.sh DevOps track](https://roadmap.sh/devops/projects) — from shell scripts to service discovery — plus a Kubernetes, GitOps & CI/CD track, built and documented in one monorepo.

![Projects](https://img.shields.io/badge/projects-44-blue) ![Beginner](https://img.shields.io/badge/beginner-16-brightgreen) ![Intermediate](https://img.shields.io/badge/intermediate-19-yellow) ![Advanced](https://img.shields.io/badge/advanced-9-red) ![Kubernetes track](https://img.shields.io/badge/k8s%20%26%20gitops%20track-18-326ce5)

## 📖 About

This repository tracks my journey through **44 practical DevOps projects**: the 26 from the roadmap.sh DevOps track (Linux, Bash, networking, CI/CD, containers, Infrastructure as Code, configuration management, security and observability), plus an **18-project Kubernetes, GitOps & CI/CD track** (Kubernetes, Helm, Argo CD, progressive delivery, policy as code, Jenkins and multi-cluster platforms).

Each project lives in its own folder with its own `README.md` documenting the goal, stack, how to run it, and what I learned.

## 🗂️ Repository structure

```
devops-roadmap-projects/
├── beginner/        # CLI tools, SSH, Nginx, DNS, systemd, Docker, AWS basics
│                    # + kind, kubectl, manifests, Helm, CI pipeline, first Argo CD app
├── intermediate/    # Ansible, Terraform, GitHub Actions, Compose, backups, security
│                    # + Kustomize envs, CI→GitOps, Gateway API/TLS, secrets, app-of-apps, observability, autoscaling, Jenkins CI
└── advanced/        # Blue-green, Prometheus/Grafana, multi-service, Consul
                     # + Argo Rollouts, Kyverno/cosign, Terraform+GitOps, multi-cluster, Kubernetes the Hard Way
```

## 📌 Projects

### 🟢 Beginner

| # | Project | Topic | Description | Status | Brief |
|---|---|---|---|---|---|
| 01 | [Server Performance Stats](beginner/01-server-performance-stats) | `CLI` | Write a script to analyse basic server performance stats. | ✅ | [brief](https://roadmap.sh/projects/server-stats) |
| 02 | [Log Archive Tool](beginner/02-log-archive-tool) | `CLI` | Build a tool to archive logs from the CLI with the date and time. | ✅ | [brief](https://roadmap.sh/projects/log-archive-tool) |
| 03 | [Nginx Log Analyser](beginner/03-nginx-log-analyser) | `CLI` | Write a simple tool to analyze logs from the command line. | ✅ | [brief](https://roadmap.sh/projects/nginx-log-analyser) |
| 04 | [GitHub Pages Deployment](beginner/04-github-pages-deployment) | `CI/CD` | Write a simple GitHub Actions workflow to deploy a static website to GitHub Pages. | ✅ | [brief](https://roadmap.sh/projects/github-actions-deployment-workflow) |
| 05 | [SSH Remote Server Setup](beginner/05-ssh-remote-server-setup) | `SSH` | Set up a basic remote Linux server and configure it to allow SSH. | 🟨 | [brief](https://roadmap.sh/projects/ssh-remote-server-setup) |
| 06 | [Static Site Server](beginner/06-static-site-server) | `Nginx` | Set up a basic Linux server and configure it to serve a static site. | 🟨 | [brief](https://roadmap.sh/projects/static-site-server) |
| 07 | [Basic DNS Setup](beginner/07-basic-dns-setup) | `DNS` | Purchase a custom domain and set up basic DNS records. | 🟨 | [brief](https://roadmap.sh/projects/basic-dns) |
| 08 | [Simple Monitoring](beginner/08-simple-monitoring) | `Monitoring` | Set up a basic monitoring dashboard using Netdata. | ✅ | [brief](https://roadmap.sh/projects/simple-monitoring-dashboard) |
| 09 | [Dummy Systemd Service](beginner/09-dummy-systemd-service) | `Systemd` | Create a long-running systemd service that logs to a file. | ✅ | [brief](https://roadmap.sh/projects/dummy-systemd-service) |
| 10 | [Basic Dockerfile](beginner/10-basic-dockerfile) | `Docker` | Build a basic Dockerfile to create a Docker image. | ✅ | [brief](https://roadmap.sh/projects/basic-dockerfile) |
| 11 | [EC2 Instance](beginner/11-ec2-instance) | `AWS` | Create an EC2 instance on AWS and connect to it using SSH. | 🟨 | [brief](https://roadmap.sh/projects/ec2-instance) |

### 🟡 Intermediate

| # | Project | Topic | Description | Status | Brief |
|---|---|---|---|---|---|
| 12 | [Pomodoro Timer](intermediate/12-pomodoro-timer) | `Frameworks` | Create a pomodoro tracker application for productivity. | ⬜ | [brief](https://roadmap.sh/projects/pomodoro-timer) |
| 13 | [Configuration Management](intermediate/13-configuration-management) | `Ansible` | Write an Ansible playbook to configure a Linux server. | ⬜ | [brief](https://roadmap.sh/projects/configuration-management) |
| 14 | [IaC on DigitalOcean](intermediate/14-iac-digitalocean) | `Terraform` | Write Terraform code to create a Droplet on DigitalOcean. | ⬜ | [brief](https://roadmap.sh/projects/iac-digitalocean) |
| 15 | [Node.js Service Deployment](intermediate/15-nodejs-service-deployment) | `CI/CD` | Use GitHub Actions to deploy a Node.js service to a remote server. | ⬜ | [brief](https://roadmap.sh/projects/nodejs-service-deployment) |
| 16 | [Dockerized Service](intermediate/16-dockerized-service) | `Docker` | Use GitHub Actions to deploy a Dockerized Node.js service. | ⬜ | [brief](https://roadmap.sh/projects/dockerized-service-deployment) |
| 17 | [Multi-Container Application](intermediate/17-multi-container-application) | `Docker Compose` | Use Docker Compose to run a multi-container application. | ⬜ | [brief](https://roadmap.sh/projects/multi-container-service) |
| 18 | [Automated DB Backups](intermediate/18-automated-db-backups) | `Backups` | Set up a scheduled workflow to back up a database every 12 hours. | ⬜ | [brief](https://roadmap.sh/projects/automated-backups) |
| 19 | [Bastion Host](intermediate/19-bastion-host) | `Networking` | Set up a bastion host for managing access to private infrastructure. | ⬜ | [brief](https://roadmap.sh/projects/bastion-host) |
| 20 | [File Integrity Checker](intermediate/20-file-integrity-checker) | `Security` | Verify the integrity of application log files to detect tampering. | ⬜ | [brief](https://roadmap.sh/projects/file-integrity-checker) |
| 21 | [Linux Server Setup](intermediate/21-linux-server-setup) | `Linux` | Learn to set up and secure a Linux server from scratch. | 🟨 | [brief](https://roadmap.sh/projects/linux-server-setup) |
| 22 | [VPN Server Setup](intermediate/22-vpn-server-setup) | `VPN` | Set up a WireGuard or OpenVPN server to secure remote access. | ⬜ | [brief](https://roadmap.sh/projects/vpn-server-setup) |

### 🔴 Advanced

| # | Project | Topic | Description | Status | Brief |
|---|---|---|---|---|---|
| 23 | [Blue-Green Deployment](advanced/23-blue-green-deployment) | `DevOps` | Set up a blue-green deployment strategy for your application. | ⬜ | [brief](https://roadmap.sh/projects/blue-green-deployment) |
| 24 | [Prometheus and Grafana](advanced/24-prometheus-and-grafana) | `Monitoring` | Set up monitoring using Prometheus and visualize metrics in Grafana. | ⬜ | [brief](https://roadmap.sh/projects/monitoring) |
| 25 | [Multi-Service Application](advanced/25-multi-service-application) | `Docker` | Set up an optimized multi-service Docker implementation. | ⬜ | [brief](https://roadmap.sh/projects/multiservice-docker) |
| 26 | [Service Discovery](advanced/26-service-discovery) | `DevOps` | Set up service discovery with dummy services and Consul. | ⬜ | [brief](https://roadmap.sh/projects/service-discovery) |

## ☸️ Kubernetes, GitOps & CI/CD track

A follow-up track (projects 27–44) going from a local cluster to a multi-cluster GitOps platform, including CI with both GitHub Actions (30) and Jenkins (44). roadmap.sh has no project list for this, so these briefs are my own, based on current practice and the official docs. They live in the same `beginner/`, `intermediate/` and `advanced/` folders and use the same README format. Kubernetes projects through project 40 are designed to run on a local kind cluster; cloud-based project 41 may incur charges.

### 🟢 Beginner

| # | Project | Topic | Description | Status | Reference |
|---|---|---|---|---|---|
| 27 | [Local Kubernetes Cluster](beginner/27-local-kubernetes-cluster) | `Kubernetes` | Run a local multi-node cluster with kind and learn the kubectl basics. | ⬜ | [docs](https://kind.sigs.k8s.io/) |
| 28 | [Deploy an App with Manifests](beginner/28-kubernetes-app-manifests) | `Kubernetes` | Deploy a real API + database with Deployments, Services, ConfigMaps, Secrets and probes. | ⬜ | [docs](https://kubernetes.io/docs/concepts/workloads/) |
| 29 | [Package an App with Helm](beginner/29-helm-chart) | `Helm` | Turn the manifests from project 28 into a reusable Helm chart with per-environment values. | ⬜ | [docs](https://helm.sh/docs/) |
| 30 | [CI Pipeline: Build, Test, Scan, Push](beginner/30-ci-build-test-scan-push) | `CI/CD` | A GitHub Actions pipeline that tests the app, builds an image, scans it and pushes it to GHCR. | ⬜ | [docs](https://docs.github.com/en/actions) |
| 31 | [First GitOps Deployment with Argo CD](beginner/31-first-gitops-argocd) | `GitOps` | Install Argo CD and let it deploy your app from Git — no more kubectl apply. | ⬜ | [docs](https://argo-cd.readthedocs.io/en/stable/getting_started/) |

### 🟡 Intermediate

| # | Project | Topic | Description | Status | Reference |
|---|---|---|---|---|---|
| 32 | [Multi-Environment GitOps with Kustomize](intermediate/32-kustomize-multi-env-gitops) | `GitOps` | One base, three overlays (dev/staging/prod) and promotion by pull request. | ⬜ | [docs](https://kubectl.docs.kubernetes.io/references/kustomize/) |
| 33 | [Full CI → GitOps CD Loop](intermediate/33-ci-to-gitops-pipeline) | `CI/CD` | Merge code → image built → config repo updated automatically → Argo CD deploys. | ⬜ | [docs](https://argocd-image-updater.readthedocs.io/) |
| 34 | [Gateway API, TLS and DNS on Kubernetes](intermediate/34-gateway-api-tls) | `Networking` | Expose apps with the Gateway API and automatic HTTPS certificates from cert-manager. | ⬜ | [docs](https://gateway-api.sigs.k8s.io/) |
| 35 | [GitOps Secrets Management](intermediate/35-gitops-secrets) | `Security` | Keep secrets out of Git (in plaintext) with Sealed Secrets or External Secrets Operator. | ⬜ | [docs](https://github.com/bitnami-labs/sealed-secrets) |
| 36 | [App of Apps and ApplicationSets](intermediate/36-argocd-app-of-apps) | `GitOps` | Bootstrap an entire cluster — add-ons and apps — from one root Application. | ⬜ | [docs](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/) |
| 37 | [Kubernetes Observability Stack](intermediate/37-k8s-observability-stack) | `Monitoring` | Metrics, logs and alerts for the cluster and your app — installed via GitOps. | ⬜ | [docs](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) |
| 38 | [Autoscaling and Resilience](intermediate/38-autoscaling-resilience) | `Kubernetes` | Make the app scale with load and survive failures — then prove it with load tests. | ⬜ | [docs](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) |
| 44 | [Jenkins CI Pipeline](intermediate/44-jenkins-ci-pipeline) | `CI/CD` | Rebuild project 30's test, scan and image-publish pipeline in Jenkins, then compare it with GitHub Actions. | ⬜ | [docs](https://www.jenkins.io/doc/book/pipeline/) |

### 🔴 Advanced

| # | Project | Topic | Description | Status | Reference |
|---|---|---|---|---|---|
| 39 | [Progressive Delivery with Argo Rollouts](advanced/39-argo-rollouts-progressive-delivery) | `GitOps` | Canary releases that analyse Prometheus metrics and roll back automatically. | ⬜ | [docs](https://argoproj.github.io/argo-rollouts/) |
| 40 | [Policy as Code and Supply-Chain Security](advanced/40-policy-supply-chain-security) | `Security` | Sign images in CI, generate SBOMs and let Kyverno block anything unsigned or unsafe. | ⬜ | [docs](https://kyverno.io/docs/) |
| 41 | [Production Cluster: Terraform + GitOps Bootstrap](advanced/41-terraform-k8s-gitops-bootstrap) | `IaC` | Provision a managed Kubernetes cluster with Terraform and hand it to Argo CD on day one. | ⬜ | [docs](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/kubernetes_cluster) |
| 42 | [Multi-Cluster GitOps Platform](advanced/42-multi-cluster-gitops-platform) | `Platform` | One Argo CD managing several clusters with ApplicationSets, RBAC and sync windows. | ⬜ | [docs](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Generators-Cluster/) |
| 43 | [Kubernetes the Hard Way](advanced/43-kubernetes-the-hard-way) | `Kubernetes` | Bootstrap a cluster by hand — certificates, etcd, control plane, kubelets — to truly understand it. | ⬜ | [docs](https://github.com/kelseyhightower/kubernetes-the-hard-way) |


**Legend:** ⬜ Not started · 🟨 Built — needs your server / domain / cloud account to run · ✅ Done

## 🧰 Tech covered

![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnubash&logoColor=white) ![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat&logo=linux&logoColor=white) ![SSH](https://img.shields.io/badge/SSH-231F20?style=flat&logo=openssh&logoColor=white) ![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat&logo=nginx&logoColor=white) ![DNS](https://img.shields.io/badge/DNS-F38020?style=flat&logo=cloudflare&logoColor=white) ![systemd](https://img.shields.io/badge/systemd-30D475?style=flat&logo=systemd&logoColor=white) ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white) ![Docker Compose](https://img.shields.io/badge/Docker%20Compose-1D63ED?style=flat&logo=docker&logoColor=white) ![AWS EC2](https://img.shields.io/badge/AWS%20EC2-FF9900?style=flat&logo=amazonec2&logoColor=white) ![DigitalOcean](https://img.shields.io/badge/DigitalOcean-0080FF?style=flat&logo=digitalocean&logoColor=white) ![Terraform](https://img.shields.io/badge/Terraform-844FBA?style=flat&logo=terraform&logoColor=white) ![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=flat&logo=ansible&logoColor=white) ![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?style=flat&logo=githubactions&logoColor=white) ![WireGuard](https://img.shields.io/badge/WireGuard-88171A?style=flat&logo=wireguard&logoColor=white) ![OpenVPN](https://img.shields.io/badge/OpenVPN-EA7E20?style=flat&logo=openvpn&logoColor=white) ![Netdata](https://img.shields.io/badge/Netdata-00AB44?style=flat&logo=netdata&logoColor=white) ![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=flat&logo=prometheus&logoColor=white) ![Grafana](https://img.shields.io/badge/Grafana-F46800?style=flat&logo=grafana&logoColor=white) ![Consul](https://img.shields.io/badge/Consul-F24C53?style=flat&logo=consul&logoColor=white)

**Kubernetes, GitOps & CI/CD track**

![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat&logo=kubernetes&logoColor=white) ![kind](https://img.shields.io/badge/kind-326CE5?style=flat&logo=kubernetes&logoColor=white) ![kubectl](https://img.shields.io/badge/kubectl-326CE5?style=flat&logo=kubernetes&logoColor=white) ![Helm](https://img.shields.io/badge/Helm-0F1689?style=flat&logo=helm&logoColor=white) ![Kustomize](https://img.shields.io/badge/Kustomize-326CE5?style=flat&logo=kubernetes&logoColor=white) ![Argo CD](https://img.shields.io/badge/Argo%20CD-EF7B4D?style=flat&logo=argo&logoColor=white) ![ApplicationSets](https://img.shields.io/badge/ApplicationSets-EF7B4D?style=flat&logo=argo&logoColor=white) ![Argo Rollouts](https://img.shields.io/badge/Argo%20Rollouts-EF7B4D?style=flat&logo=argo&logoColor=white) ![Gateway API](https://img.shields.io/badge/Gateway%20API-326CE5?style=flat&logo=kubernetes&logoColor=white) ![cert-manager](https://img.shields.io/badge/cert--manager-003A70?style=flat&logo=letsencrypt&logoColor=white) ![Sealed Secrets](https://img.shields.io/badge/Sealed%20Secrets-5A6B7D?style=flat) ![External Secrets](https://img.shields.io/badge/External%20Secrets-1E88E5?style=flat) ![kube-prometheus-stack](https://img.shields.io/badge/kube--prometheus--stack-E6522C?style=flat&logo=prometheus&logoColor=white) ![Loki](https://img.shields.io/badge/Loki-F46800?style=flat&logo=grafana&logoColor=white) ![HPA](https://img.shields.io/badge/HPA-326CE5?style=flat&logo=kubernetes&logoColor=white) ![k6](https://img.shields.io/badge/k6-7D64FF?style=flat&logo=k6&logoColor=white) ![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=flat&logo=jenkins&logoColor=white) ![Trivy](https://img.shields.io/badge/Trivy-1904DA?style=flat&logo=trivy&logoColor=white) ![Kyverno](https://img.shields.io/badge/Kyverno-FF6F00?style=flat) ![cosign](https://img.shields.io/badge/cosign-2E3440?style=flat&logo=sigstore&logoColor=white) ![Terraform](https://img.shields.io/badge/Terraform-844FBA?style=flat&logo=terraform&logoColor=white) ![DOKS / EKS](https://img.shields.io/badge/DOKS%20%2F%20EKS-0080FF?style=flat&logo=digitalocean&logoColor=white)

## 🔁 Workflow

1. Pick the next project in the table.
2. Work in its folder on a branch: `git checkout -b feat/<project-name>`.
3. Fill in its README (goal, stack, how to run, lessons learned).
4. Update the status in this table and merge.

## ⚠️ Security

Never commit secrets, keys, `.tfstate` or `.env` files — they are ignored via `.gitignore`. Use environment variables or a secrets manager instead.

## 👤 Author

**Mohammed Saouab** — [@msaouab](https://github.com/msaouab)

## 📄 License

All rights reserved to Mohamed Saouab [MIT](LICENSE)
