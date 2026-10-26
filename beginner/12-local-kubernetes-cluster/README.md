# Local Kubernetes Cluster

> **Level:** Beginner · **Topic:** Kubernetes · **Status:** ✅ Done<br>
> **Track:** ☸️ Kubernetes, GitOps & CI/CD · **Builds on:** —<br>
> **Reference:** [kind](https://kind.sigs.k8s.io/) · [kubectl](https://kubernetes.io/docs/reference/kubectl/)

## 🎯 Goal
Get a real multi-node Kubernetes cluster running on your laptop (free, disposable) and learn the core `kubectl` workflow: create, inspect, expose, scale, debug and delete.

## 📋 Requirements
- [x] Install `kubectl` and `kind` (or `k3d`) on macOS/Linux
- [x] Create a cluster from a config file: **1 control-plane + 2 workers**
- [x] Run `nginx` as a **Deployment** with 2 replicas and expose it with a **Service**
- [x] Reach it from your browser with `kubectl port-forward`
- [x] Scale to 5 replicas and watch pods spread across nodes (`kubectl get pods -o wide`)
- [x] Delete a pod and watch the Deployment replace it (self-healing)
- [x] Debug with `kubectl describe`, `logs`, `exec`, `get events`
- [x] Write `up.sh` / `down.sh` scripts that create and destroy the cluster in one command

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

- **kind** v0.33 (Kubernetes IN Docker): each node is a Docker container
- **kubectl** v1.36
- Docker runtime: Docker Desktop or OrbStack (macOS), Docker Engine (Linux)
- Bash scripts that work on macOS (Bash 3.2) and Linux

## 📁 Files

```
12-local-kubernetes-cluster/
├── kind-config.yaml        # the cluster: 1 control-plane + 2 workers, named "roadmap"
├── k8s/
│   ├── namespace.yaml      # "web" namespace
│   ├── deployment.yaml     # nginx:1.27-alpine, 2 replicas, requests/limits
│   ├── service.yaml        # ClusterIP Service selecting app=nginx
│   └── broken/             # debugging lab: 3 pods broken on purpose
│       ├── bad-image.yaml  #   tag that doesn't exist
│       ├── crash.yaml      #   app exits with an error
│       └── memory-hog.yaml #   uses 4x its memory limit
├── up.sh                   # create cluster (if needed) + deploy + verify
├── down.sh                 # delete the cluster
├── demo.sh                 # scaling, self-healing, declarative vs imperative
├── debug-lab.sh            # deploy the broken pods; --answers / --clean
└── lib.sh                  # shared settings and helpers
```

## 🚀 How to run

Prerequisites (macOS): `brew install kind kubectl`, plus Docker Desktop or OrbStack running with **≥ 2 CPUs and 4 GB RAM**.

```bash
./up.sh            # create the cluster + deploy nginx (1-2 min the first time)
./up.sh --open     # same, then port-forward and open http://localhost:8080
./demo.sh          # guided: scale to 5, kill pods, watch them come back
./debug-lab.sh     # 3 broken pods to diagnose; then --answers, then --clean
./down.sh          # delete everything
```

`up.sh` is safe to re-run: it reuses an existing cluster and just re-applies the manifests. Every script targets the `kind-roadmap` context explicitly, so it can never touch another cluster you have configured.

### Doing it by hand (what the scripts automate)

```bash
kind create cluster --config kind-config.yaml       # 3 nodes = 3 Docker containers
kubectl get nodes -o wide                           # all Ready?
kubectl apply -f k8s/                               # namespace + deployment + service
kubectl get deployment,replicaset,pods -n web -o wide
kubectl get endpointslices -n web                   # pod IPs behind the Service
kubectl port-forward -n web service/nginx 8080:80   # http://localhost:8080

# call the Service by name from inside the cluster
kubectl run tmp --rm -i --restart=Never --image=busybox:1.36 -n web -- sh -c 'sleep 2; wget -qO- http://nginx'

kubectl scale deployment nginx -n web --replicas=5  # scale
kubectl delete pod -n web <pod-name>                # self-healing
kind delete cluster --name roadmap
```

## 🔍 How it works

```
┌──────────────────── kind cluster "roadmap" (Docker containers on your Mac) ───────────────────┐
│  roadmap-control-plane            roadmap-worker               roadmap-worker2                │
│  API server · scheduler · etcd    ┌────────────┐               ┌────────────┐                 │
│  taint: NoSchedule                │ nginx pod  │               │ nginx pod  │                 │
│                                   └─────▲──────┘               └─────▲──────┘                 │
│                                         └──── Service "nginx" ───────┘                        │
│                                            (stable IP + DNS name, selector app=nginx)         │
└───────────────────────────────────────────────────────▲────────────────────────────────────────┘
                     kubectl port-forward 8080:80 ───────┘  ← your browser: http://localhost:8080
```

| Concept | In this project |
|---|---|
| **Node** | 3 Docker containers. The control plane has a `NoSchedule` **taint**, so your pods only land on the 2 workers. |
| **Deployment → ReplicaSet → Pods** | You create the Deployment; it creates a ReplicaSet, which keeps exactly N pods alive. |
| **Labels + selectors** | `app: nginx` ties everything together: Deployment → its pods, Service → its backends. |
| **Service (ClusterIP)** | One stable IP and DNS name (`nginx`, or `nginx.web.svc.cluster.local`) in front of pods whose IPs keep changing. |
| **DaemonSet** | `kube-proxy` and `kindnet` run one pod per node: 3 nodes, 3 pods each. |
| **requests / limits** | Requests reserve room for scheduling; limits are a hard ceiling (exceed memory and you get OOMKilled). |
| **Declarative** | `kubectl apply -f k8s/` makes the cluster match the files; manual changes get overwritten. |

## 🩺 Debugging lab: diagnoses

`./debug-lab.sh` deploys three pods that fail in the three most common ways:

| Pod | STATUS | Root cause | Found with |
|---|---|---|---|
| `bad-image` | `ErrImagePull` → `ImagePullBackOff` | Image tag `nginx:9.99-doesnotexist` doesn't exist in the registry | `kubectl describe pod` → Events: *"Failed to pull image … not found"* |
| `crash` | `Error` → `CrashLoopBackOff` (RESTARTS climbing) | The app starts, then exits with code 1: *"ERROR: DATABASE_URL is not set"* | `kubectl logs crash -n web --previous` |
| `memory-hog` | `OOMKilled` → `CrashLoopBackOff` | Uses ~190 MB with a 50 MiB limit, so the kernel kills it | `kubectl describe pod` → Last State: `Reason: OOMKilled`, `Exit Code: 137` |

- **Why the waits get longer in CrashLoopBackOff:** the kubelet restarts with exponential back-off (10 s, 20 s, 40 s … capped at 5 min), so a broken app doesn't hammer the node.
- **Exit code 137** = 128 + 9 (SIGKILL). Any exit code above 128 means the process was killed by a signal.
- **Debug order that works:** `get` (symptom) → `describe` (events, last state) → `logs --previous` (what the app said) → `get events` (timeline) → `exec` (look inside a running container).

## 🧪 Tested cases

| Check | Result |
|---|---|
| `./up.sh` on macOS (Apple Silicon, kind v0.33, kubectl v1.36, nodes on **Kubernetes v1.37.0**) | 3 nodes Ready; re-run reuses the cluster, all manifests `unchanged`; control-plane tainted `NoSchedule` |
| nginx Deployment + Service | 2 pods spread across **both** workers (`10.244.2.x` / `10.244.1.x`, one subnet per node); Service ClusterIP `10.96.x` with exactly those 2 pod IPs as backends; Service reached via `port-forward` **and** from inside the cluster by DNS name (`wget http://nginx` → "Welcome to nginx!") |
| All 6 manifests | Pass the **strict** Kubernetes v1.33 JSON schemas (catches misspelled fields) |
| Cross-checks | Deployment selector ⊆ pod labels, Service selector matches the pods, `targetPort` = `containerPort`, one namespace |
| `FAST=1 ./demo.sh` on the Mac | 5 pods spread **3 / 2** across the workers; Service picked up all 5 IPs; one pod replaced in **1 s**, all 5 replaced (old ones fully gone) in **2 s**; `apply` took it back from 5 to **2** |
| `./debug-lab.sh --answers` on the Mac | `bad-image` → `ImagePullBackOff` (image NotFound) · `crash` → `Error`, exit code 1, 3 restarts in 45 s · `memory-hog` → `OOMKilled`, exit code **137** |
| memory-hog payload | Measured ~193 MB peak vs the 50 MiB limit, so it really gets OOMKilled |
| All scripts | `shellcheck` clean |

## 📝 Notes & lessons learned

- **Pods are cattle, not pets.** Their names and IPs change every time they're replaced. Always talk to a **Service**, never to a pod.
- **Labels are the glue.** If a Service has no endpoints (`kubectl get endpointslices`), the selector doesn't match the pod labels. That's the #1 Service bug.
- **Declarative beats imperative.** `kubectl scale` worked until the next `apply` silently undid it. Keep the files as the single source of truth; GitOps (project 16) enforces this automatically.
- **Pin image versions** (`nginx:1.27-alpine`, not `latest`) so every `apply` runs exactly the same thing.
- **Always set requests and limits.** Requests make scheduling realistic; limits stop one pod from starving the node, as memory-hog showed.
- **Containers that die in milliseconds can lose their logs.** containerd removes the finished container before `kubectl logs --previous` asks for it, and kubectl then prints *"unable to retrieve container logs"* as if it were a log line. Real apps usually run a moment before failing; for instant crashes, check `describe` → Last State, or ship logs to a central store (project 33).
- **Short-lived `kubectl run -it` pods lose their output** if the command finishes before the terminal attaches. Use `-i` with a short `sleep`, or open a shell (`-- sh`).
- **Scripts should pin the kube context** (`kubectl --context kind-roadmap`), so a forgotten context switch can't send commands to the wrong cluster.
- **kind vs real clusters:** nodes have no external IP and live on a private Docker network, so `port-forward` is how you reach apps. Gateway API (project 30) is the production way.
