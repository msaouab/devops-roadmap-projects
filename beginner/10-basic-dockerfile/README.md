# Basic Dockerfile

> **Level:** Beginner · **Topic:** Docker · **Status:** ✅ Done<br>
> **Brief:** [roadmap.sh/projects/basic-dockerfile](https://roadmap.sh/projects/basic-dockerfile)

## 🎯 Goal
Write a minimal Dockerfile whose container prints `Hello, Captain!` and exits.

## 📋 Requirements
- [x] File named `Dockerfile` in the project root
- [x] Base image `alpine:latest`
- [x] A single instruction that prints `Hello, Captain!`

## 🌟 Stretch goals
- [x] Take a name as a build argument and print `Hello, <name>!`

## 🎓 What you'll learn
- Dockerfile basics: base images and instructions
- Building and running images
- Build arguments

---

## 🧰 Stack

- Docker. Same commands on **macOS** (Docker Desktop, OrbStack or Colima) and **Linux** (Docker Engine).
- Base image: `alpine:latest` (~8 MB)

## 📁 Files

| File | What it is |
|---|---|
| `Dockerfile` | Prints `Hello, Captain!`, with the name configurable at build time (stretch goal) |
| `Dockerfile.minimal` | The bare requirement: `FROM` + one `CMD` |
| `.dockerignore` | Keeps the build context to just the Dockerfile |
| `test.sh` | Builds all variants and checks their output |

## 🚀 How to run

```bash
# the requirement
docker build -t hello-captain .
docker run --rm hello-captain
# Hello, Captain!

# stretch goal: name set at build time
docker build --build-arg NAME=Mohammed -t hello-mohammed .
docker run --rm hello-mohammed
# Hello, Mohammed!

# bonus: override at run time, no rebuild
docker run --rm -e NAME=Ops hello-captain
# Hello, Ops!

# run all checks
./test.sh
```

## 🔍 How it works

```dockerfile
FROM alpine:latest                               # tiny Linux base image
ARG NAME=Captain                                 # build-time variable (--build-arg)
ENV NAME=${NAME}                                 # keep it for run time
CMD ["sh", "-c", "echo \"Hello, ${NAME}!\""]     # what runs when the container starts
```

| Instruction | When it applies | Can override with |
|---|---|---|
| `ARG` | only while **building** | `docker build --build-arg NAME=…` |
| `ENV` | build **and** in the running container | `docker run -e NAME=…` |
| `CMD` | default command when the container starts | `docker run hello-captain <other command>` |

### Tested cases

| Check | Result |
|---|---|
| `Dockerfile.minimal` | `Hello, Captain!` |
| `Dockerfile`, default | `Hello, Captain!` |
| `--build-arg NAME=Mohammed` | `Hello, Mohammed!` |
| `-e NAME=Ops` at run time | `Hello, Ops!` |
| `shellcheck test.sh` | No warnings |

The test machine couldn't download images from Docker Hub, so these ran against a stand-in `alpine:latest` (busybox `sh` + `echo`). Run `./test.sh` once on your machine to confirm with the real Alpine image.

## 📝 Notes & lessons learned

- **`ARG` disappears after the build.** `CMD ["echo", "Hello, $NAME"]` would print the literal text `$NAME`. Copy the ARG into an `ENV` and run through `sh -c` so the variable is expanded when the container starts.
- **Exec form vs shell form:** `CMD ["echo", "hi"]` runs `echo` directly (no shell, clean signal handling). `CMD echo hi` wraps it in `/bin/sh -c`. Use exec form unless you need shell features like variable expansion.
- **`docker run --rm`** deletes the container once it exits; without it, every run leaves a stopped container behind (`docker ps -a`).
- **Alpine is ~8 MB** vs ~75 MB for Ubuntu: faster pulls and a smaller attack surface. The catch is that it uses `musl` instead of `glibc`, which occasionally matters for compiled software.
- **Pin versions in real projects** (`alpine:3.20` instead of `latest`) so builds are reproducible.
- **`.dockerignore`** keeps the build context small. In bigger projects it stops `node_modules`, `.git` and `.env` from being sent to Docker or ending up in the image.
