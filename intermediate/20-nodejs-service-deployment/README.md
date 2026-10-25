# Node.js Service Deployment

> **Level:** Intermediate · **Topic:** CI/CD · **Status:** ⬜ Not started<br>
> **Brief:** [roadmap.sh/projects/nodejs-service-deployment](https://roadmap.sh/projects/nodejs-service-deployment)

## 🎯 Goal
Deploy a Node.js service to a remote server via GitHub Actions, reusing Terraform and Ansible from projects 18–19.

## 📋 Requirements
- [ ] Provision a Droplet with Terraform
- [ ] Configure it with Ansible, including Node.js and npm
- [ ] Build a Node.js service with one route, `/`, returning `Hello, world!`
- [ ] Push the code to GitHub
- [ ] **Task 1:** an Ansible role `app` that clones the repo, installs dependencies, builds and starts the app; run `ansible-playbook node_service.yml --tags app`; the app serves on port 80 at the server IP
- [ ] **Task 2:** automate deployment with GitHub Actions, either by running the playbook in the workflow or by deploying over SSH (e.g. `rsync`, `webfactory/ssh-agent`, `appleboy/ssh-action`)

## 🎓 What you'll learn
- GitHub Actions secrets and environment variables
- Automating both server setup and app deployment

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
