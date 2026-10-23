# 🛠️ DevOps Roadmap Projects

> Hands-on DevOps projects from the [roadmap.sh DevOps track](https://roadmap.sh/devops/projects) — from shell scripts to service discovery, built and documented in one monorepo.

![Projects](https://img.shields.io/badge/projects-26-blue)
![Beginner](https://img.shields.io/badge/beginner-11-brightgreen)
![Intermediate](https://img.shields.io/badge/intermediate-11-yellow)
![Advanced](https://img.shields.io/badge/advanced-4-red)

## 📖 About

This repository tracks my journey through **26 practical DevOps projects**, covering Linux, Bash, networking, CI/CD, containers, Infrastructure as Code, configuration management, security and observability.

Each project lives in its own folder with its own `README.md` documenting the goal, stack, how to run it, and what I learned.

## 🗂️ Repository structure

```
devops-roadmap-projects/
├── beginner/        # CLI tools, SSH, Nginx, DNS, systemd, Docker, AWS basics
├── intermediate/    # Ansible, Terraform, GitHub Actions, Compose, backups, security
└── advanced/        # Blue-green, Prometheus/Grafana, multi-service, Consul
```

## 📌 Projects

### 🟢 Beginner

| # | Project | Topic | Description | Status | Brief |
|---|---|---|---|---|---|
| 01 | [Server Performance Stats](beginner/01-server-performance-stats) | `CLI` | Write a script to analyse basic server performance stats. | ⬜ | [brief](https://roadmap.sh/projects/server-stats) |
| 02 | [Log Archive Tool](beginner/02-log-archive-tool) | `CLI` | Build a tool to archive logs from the CLI with the date and time. | ⬜ | [brief](https://roadmap.sh/projects/log-archive-tool) |
| 03 | [Nginx Log Analyser](beginner/03-nginx-log-analyser) | `CLI` | Write a simple tool to analyze logs from the command line. | ⬜ | [brief](https://roadmap.sh/projects/nginx-log-analyser) |
| 04 | [GitHub Pages Deployment](beginner/04-github-pages-deployment) | `CI/CD` | Write a simple GitHub Actions workflow to deploy a static website to GitHub Pages. | ⬜ | [brief](https://roadmap.sh/projects/github-actions-deployment-workflow) |
| 05 | [SSH Remote Server Setup](beginner/05-ssh-remote-server-setup) | `SSH` | Set up a basic remote Linux server and configure it to allow SSH. | ⬜ | [brief](https://roadmap.sh/projects/ssh-remote-server-setup) |
| 06 | [Static Site Server](beginner/06-static-site-server) | `Nginx` | Set up a basic Linux server and configure it to serve a static site. | ⬜ | [brief](https://roadmap.sh/projects/static-site-server) |
| 07 | [Basic DNS Setup](beginner/07-basic-dns-setup) | `DNS` | Purchase a custom domain and set up basic DNS records. | ⬜ | [brief](https://roadmap.sh/projects/basic-dns) |
| 08 | [Simple Monitoring](beginner/08-simple-monitoring) | `Monitoring` | Set up a basic monitoring dashboard using Netdata. | ⬜ | [brief](https://roadmap.sh/projects/simple-monitoring-dashboard) |
| 09 | [Dummy Systemd Service](beginner/09-dummy-systemd-service) | `Systemd` | Create a long-running systemd service that logs to a file. | ⬜ | [brief](https://roadmap.sh/projects/dummy-systemd-service) |
| 10 | [Basic Dockerfile](beginner/10-basic-dockerfile) | `Docker` | Build a basic Dockerfile to create a Docker image. | ⬜ | [brief](https://roadmap.sh/projects/basic-dockerfile) |
| 11 | [EC2 Instance](beginner/11-ec2-instance) | `AWS` | Create an EC2 instance on AWS and connect to it using SSH. | ⬜ | [brief](https://roadmap.sh/projects/ec2-instance) |

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
| 21 | [Linux Server Setup](intermediate/21-linux-server-setup) | `Linux` | Learn to set up and secure a Linux server from scratch. | ⬜ | [brief](https://roadmap.sh/projects/linux-server-setup) |
| 22 | [VPN Server Setup](intermediate/22-vpn-server-setup) | `VPN` | Set up a WireGuard or OpenVPN server to secure remote access. | ⬜ | [brief](https://roadmap.sh/projects/vpn-server-setup) |

### 🔴 Advanced

| # | Project | Topic | Description | Status | Brief |
|---|---|---|---|---|---|
| 23 | [Blue-Green Deployment](advanced/23-blue-green-deployment) | `DevOps` | Set up a blue-green deployment strategy for your application. | ⬜ | [brief](https://roadmap.sh/projects/blue-green-deployment) |
| 24 | [Prometheus and Grafana](advanced/24-prometheus-and-grafana) | `Monitoring` | Set up monitoring using Prometheus and visualize metrics in Grafana. | ⬜ | [brief](https://roadmap.sh/projects/monitoring) |
| 25 | [Multi-Service Application](advanced/25-multi-service-application) | `Docker` | Set up an optimized multi-service Docker implementation. | ⬜ | [brief](https://roadmap.sh/projects/multiservice-docker) |
| 26 | [Service Discovery](advanced/26-service-discovery) | `DevOps` | Set up service discovery with dummy services and Consul. | ⬜ | [brief](https://roadmap.sh/projects/service-discovery) |

**Legend:** ⬜ Not started · 🟨 In progress · ✅ Done

## 🧰 Tech covered

`Bash` · `Linux` · `SSH` · `Nginx` · `DNS` · `systemd` · `Docker` · `Docker Compose` · `AWS EC2` · `DigitalOcean` · `Terraform` · `Ansible` · `GitHub Actions` · `WireGuard/OpenVPN` · `Netdata` · `Prometheus` · `Grafana` · `Consul`

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

[MIT](LICENSE)
