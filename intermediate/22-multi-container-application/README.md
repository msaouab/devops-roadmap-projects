# Multi-Container Application

> **Level:** Intermediate · **Topic:** Docker Compose · **Status:** ⬜ Not started<br>
> **Brief:** [roadmap.sh/projects/multi-container-service](https://roadmap.sh/projects/multi-container-service)

## 🎯 Goal
Run a Node.js + MongoDB application in production with Docker Compose.

## 📋 Requirements
- [ ] Unauthenticated todo API: `GET /todos`, `POST /todos`, `GET /todos/:id`, `PUT /todos/:id`, `DELETE /todos/:id` (Express + Mongoose suggested, nodemon for dev)
- [ ] Dockerize the API; `docker-compose.yml` runs the API and MongoDB containers
- [ ] API at `http://localhost:3000`; data persists across restarts
- [ ] Provision a server with Terraform; configure it with Ansible (install Docker/Compose, pull the image from Docker Hub, run it)
- [ ] CI/CD pipeline (e.g. GitHub Actions) that deploys with `docker-compose`

## 🌟 Stretch goals
- [ ] Nginx reverse proxy in Compose, serving the app on a custom domain

## 🎓 What you'll learn
- Docker Compose and multi-container apps
- End-to-end CI/CD with provisioning and configuration management

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
