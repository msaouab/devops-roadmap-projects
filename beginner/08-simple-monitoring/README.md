# Simple Monitoring

> **Level:** Beginner · **Topic:** Monitoring · **Status:** ✅ Done<br>
> **Brief:** [roadmap.sh/projects/simple-monitoring-dashboard](https://roadmap.sh/projects/simple-monitoring-dashboard)

## 🎯 Goal
Set up a real-time monitoring dashboard on a Linux system with Netdata.

## 📋 Requirements
- [x] Install Netdata on a Linux system
- [x] Monitor CPU, memory usage and disk I/O
- [x] Open the dashboard in a browser
- [x] Customize at least one dashboard element (add or change a chart)
- [x] Create an alert, e.g. CPU usage above 80%
- [x] Automate it: `setup.sh` (install), `test_dashboard.sh` (generate load), `cleanup.sh` (uninstall and clean up)

## 🎓 What you'll learn
- System monitoring basics
- Configuring alerts
- Scripting repeatable setup and teardown

---

## 🧰 Stack

- **Netdata**: real-time monitoring agent + web dashboard on port `19999`
- **macOS:** installed with Homebrew (`brew services`). **Linux:** the official kickstart script, or the distro package.
- Netdata **health alerts** (`health.d/`) and **StatsD** charts (`statsd.d/`)
- Bash + Python 3 (to read the alerts API)

## 📁 Files

| File | What it does |
|---|---|
| `setup.sh` | Installs Netdata, adds the custom alerts + dashboard section, restarts, and verifies charts and alerts are live |
| `test_dashboard.sh [seconds]` | Loads CPU (all cores), RAM (~25%), disk I/O and the demo app, printing alert status every 10 s |
| `cleanup.sh [-y]` | Uninstalls Netdata and removes all its config and data (asks first unless `-y`) |
| `lib.sh` | Shared helpers: OS detection, config paths, restart, alert status |
| `config/health.d/custom-alerts.conf` | **Alerts:** CPU > 80% (warn) / 95% (crit) over 1 min; RAM > 80% / 95% |
| `config/statsd.d/demo-app.conf` | **Dashboard customization:** a new "Demo App" section with *requests/errors* and *latency* charts |

## 🚀 How to run

```bash
chmod +x *.sh
./setup.sh            # install + configure (asks for sudo on Linux)
./test_dashboard.sh   # 90 s of load; watch the dashboard
./cleanup.sh          # remove everything
```

Open **http://localhost:19999** (`setup.sh` opens it for you on macOS). On a remote server, use an SSH tunnel instead of opening port 19999 to the internet:

```bash
ssh -L 19999:localhost:19999 myserver    # then browse http://localhost:19999
```

### What you'll see

```
$ ./setup.sh
==> Installing custom alerts and dashboard section into /etc/netdata
  + health.d/custom-alerts.conf  (CPU > 80%, RAM > 80%)
  + statsd.d/demo-app.conf       (Demo App charts)
==> Restarting Netdata
  running: Netdata v1.43.2
  chart OK: system.cpu
  chart OK: system.ram
  chart OK: system.io
  alert OK: custom_cpu_usage_high (CLEAR)
  alert OK: custom_ram_usage_high (CLEAR)

$ ./test_dashboard.sh
==> Load test for 90s - watch http://localhost:19999
  CPU:    2 busy loops
  Memory: holding 976 MB
  Disk:   writing/reading 256 MB repeatedly
  App:    sending StatsD metrics to the 'Demo App' section
   15s elapsed   CPU alert: CLEAR     RAM alert: CLEAR
   46s elapsed   CPU alert: CLEAR     RAM alert: CLEAR
   61s elapsed   CPU alert: CRITICAL  RAM alert: CLEAR
   92s elapsed   CPU alert: CRITICAL  RAM alert: CLEAR
```

The CPU alert takes about a minute to fire because it averages the **last minute** (`lookup: average -1m`). That's deliberate, so a short spike doesn't page anyone.

## 🔍 How it works

**The alert** (`config/health.d/custom-alerts.conf`):

```
 alarm: custom_cpu_usage_high
    on: system.cpu                     # which chart to watch
lookup: average -1m unaligned of user,system,softirq,irq,guest
  warn: $this > 80                     # WARNING above 80%
  crit: $this > 95                     # CRITICAL above 95%
 delay: down 1m                        # wait 1 min before clearing (no flapping)
```

**The custom chart:** Netdata listens for StatsD metrics on UDP `8125`. `demo-app.conf` groups `demoapp.*` metrics into a new dashboard section. Any app can send them; the test script does it with `nc`:

```bash
echo "demoapp.requests:42|c" | nc -u -w0 127.0.0.1 8125
```

**Where config lives** (`setup.sh` detects it):

| Install | Config dir |
|---|---|
| Linux kickstart / apt / dnf | `/etc/netdata` |
| Linux static build | `/opt/netdata/etc/netdata` |
| macOS Homebrew | `$(brew --prefix)/etc/netdata` |

### Tested cases

Tested on Ubuntu 24.04 with a real Netdata (v1.43.2):

| Check | Result |
|---|---|
| `setup.sh` | Custom config installed; `system.cpu`, `system.ram`, `system.io` live; both custom alerts loaded |
| `test_dashboard.sh 90` | CPU alert **CLEAR → CRITICAL** after ~60 s; RAM alert stays CLEAR (only 25% used) |
| Custom dashboard section | `demo_app.requests` and `demo_app.latency` charts created from the StatsD data |
| Load processes after the test | None left running (cleaned up via `trap`) |
| `cleanup.sh` → answer `n` | Aborted, nothing removed |
| `cleanup.sh -y` | Package purged, `/etc/netdata` gone, no process left |
| `shellcheck` | No warnings |

The macOS path (Homebrew install, `brew services`, `disk.io` chart) wasn't run here; try it once on your Mac.

## 📝 Notes & lessons learned

- **Alert on averages, not instant values.** `average -1m` plus `delay: down 1m` avoids alerts that flap on every short spike.
- **Netdata starts in stages.** The API answers first, then collectors register charts, then the health engine loads alerts. Scripts must *poll* for each instead of checking once.
- **Never edit the stock config files.** Add your own files in `health.d/` and `statsd.d/`, so upgrades don't overwrite them and cleanup is just deleting your files.
- **Don't expose port 19999 publicly.** The dashboard has no login by default, so use an SSH tunnel (or Netdata Cloud).
- **`trap cleanup EXIT INT TERM`** guarantees the load generators stop even if you press Ctrl-C mid-test.
- **Portable load generation:** CPU = busy loops per core (`nproc` / `sysctl hw.ncpu`), RAM = a Python bytearray, disk = `dd` with a numeric `bs` (`1048576` instead of `1M` or `1m`, which differ between GNU and BSD).
- **Next step:** Netdata is great for a single machine. For a fleet, use Prometheus + Grafana (project 37).
