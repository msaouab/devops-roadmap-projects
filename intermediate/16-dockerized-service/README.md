# Dockerized Service

> **Level:** Intermediate · **Topic:** Docker · **Status:** ⬜ Not started<br>
> **Brief:** [roadmap.sh/projects/dockerized-service-deployment](https://roadmap.sh/projects/dockerized-service-deployment)

## 🎯 Goal
Containerize a Node.js service and deploy it to a remote server through a GitHub Actions pipeline, with proper secrets handling.

## 📋 Requirements
- [ ] Node.js service with `/` → `Hello, world!` and `/secret` protected by Basic Auth (correct creds → secret message, otherwise error)
- [ ] `.env` with `SECRET_MESSAGE`, `USERNAME`, `PASSWORD`
- [ ] A `Dockerfile` that builds and runs locally; the `.env` must **not** be baked into the image
- [ ] Provision a remote Linux server (manually, or with Terraform/Ansible)
- [ ] GitHub Actions workflow: build the image, push to a container registry, deploy to the server

## 🎓 What you'll learn
- Dockerizing applications
- CI/CD with container registries
- Secrets management

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
