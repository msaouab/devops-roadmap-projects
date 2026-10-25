# Jenkins CI Pipeline

> **Level:** Intermediate · **Topic:** CI/CD · **Status:** ⬜ Not started<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** [10](../../beginner/10-basic-dockerfile) · compares with [15](../../beginner/15-ci-build-test-scan-push)<br>
> **Reference:** [Jenkins Pipeline](https://www.jenkins.io/doc/book/pipeline/) · [Jenkins with Docker](https://www.jenkins.io/doc/book/pipeline/docker/)

## 🎯 Goal
Implement project 15's CI pipeline in Jenkins so the same application can be tested, scanned, built and published using a self-managed automation server. Compare the Jenkins pipeline with GitHub Actions and document the operational trade-offs.

## 📋 Requirements
- [ ] Run Jenkins locally for learning, with its data stored in a named volume; do not expose the controller directly to the public internet
- [ ] Add a `Jenkinsfile` to the application repository using a Declarative Pipeline
- [ ] Configure a multibranch or pull-request workflow: checkout, install dependencies, lint, unit tests and build
- [ ] Build a multi-stage Docker image tagged with the commit SHA; do not publish images from untrusted pull-request builds
- [ ] Scan the image with Trivy and fail on the agreed severity threshold
- [ ] On an approved merge to `main`, authenticate to GHCR with a narrowly scoped credential and push the image
- [ ] Store credentials in Jenkins Credentials; never place secrets in the `Jenkinsfile` or repository
- [ ] Use an agent with Docker build capability; document how the agent receives that capability
- [ ] Record build logs and make failed stages clear; demonstrate a failed test blocking image publication
- [ ] Compare Jenkins and GitHub Actions for controller/runner management, plugins, credentials, pipeline definition and maintenance

## 🌟 Stretch goals
- [ ] Add a separate Jenkins agent and run a build on it
- [ ] Trigger builds from GitHub webhooks and verify branch protection uses the Jenkins result
- [ ] Use Jenkins Configuration as Code to provision the learning instance reproducibly
- [ ] Add a manual approval stage for publishing a release image
- [ ] Send build status notifications to a development channel

## 🎓 What you'll learn
- Declarative pipelines, stages, steps, agents and `Jenkinsfile`
- Jenkins controller versus build agent responsibilities
- Credentials handling and least-privilege registry access
- The operational trade-offs between Jenkins and a hosted CI service

---

## 🧰 Stack
- Jenkins
- Docker Buildx
- GitHub Container Registry (GHCR)
- Trivy

## 🚀 How to run
```bash
# Add local Jenkins setup and pipeline instructions here.
```

## 📝 Notes & lessons learned
-
