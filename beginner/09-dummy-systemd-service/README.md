# Dummy Systemd Service

> **Level:** Beginner · **Topic:** Systemd · **Status:** ✅ Done<br>
> **Brief:** [roadmap.sh/projects/dummy-systemd-service](https://roadmap.sh/projects/dummy-systemd-service)

## 🎯 Goal
Create, enable and manage a custom systemd service, and read its logs.

## 📋 Requirements
- [x] Write `dummy.sh`: loops forever, appending a message to `/var/log/dummy-service.log` every 10 seconds
- [x] Write `dummy.service`: runs the script in the background, starts on boot, restarts on failure
- [x] Manage it with `systemctl start | stop | enable | disable | status dummy`
- [x] Follow its logs with `journalctl -u dummy -f`

## 🎓 What you'll learn
- Writing systemd unit files
- Managing services with `systemctl`
- Debugging with `journalctl`

---

## 🧰 Stack

- **Linux:** systemd (`systemctl`, `journalctl`), as the brief asks
- **macOS:** launchd, the macOS equivalent of systemd (`launchctl`)
- Bash

## 📁 Files

| File | What it is |
|---|---|
| `dummy.sh` | The "app": logs a heartbeat to `/var/log/dummy-service.log` every 10 s and stops cleanly on a stop signal |
| `dummy.service` | systemd unit: starts at boot, restarts on failure, logs to the journal |
| `macos/com.roadmap.dummy.plist` | launchd equivalent for macOS (`RunAtLoad` + `KeepAlive`) |
| `svc.sh` | One command set for both OSes. It prints the native command it runs, so you learn those too. |

## 🚀 How to run

```bash
./svc.sh install     # copy files, enable at boot, start
./svc.sh status
./svc.sh logs        # follow logs live (Ctrl-C to quit)
./svc.sh stop | start | restart | enable | disable
./svc.sh uninstall
```

### The native commands (Linux)

What the brief asks you to practise, which `svc.sh` runs for you on Linux:

```bash
sudo cp dummy.sh /usr/local/bin/ && sudo chmod +x /usr/local/bin/dummy.sh
sudo cp dummy.service /etc/systemd/system/
sudo systemctl daemon-reload          # make systemd re-read unit files

sudo systemctl start dummy            # start now
sudo systemctl stop dummy             # stop
sudo systemctl enable dummy           # start at boot
sudo systemctl disable dummy          # don't start at boot
systemctl status dummy                # running? PID? last log lines

journalctl -u dummy -f                # follow the logs
tail -f /var/log/dummy-service.log    # or read the file directly
```

### macOS equivalents (launchd)

| systemd (Linux) | launchd (macOS) |
|---|---|
| `/etc/systemd/system/dummy.service` | `/Library/LaunchDaemons/com.roadmap.dummy.plist` |
| `WantedBy=multi-user.target` | `RunAtLoad` = true |
| `Restart=always` | `KeepAlive` = true |
| `systemctl start dummy` | `sudo launchctl bootstrap system <plist>` |
| `systemctl stop dummy` | `sudo launchctl bootout system/com.roadmap.dummy` |
| `systemctl restart dummy` | `sudo launchctl kickstart -k system/com.roadmap.dummy` |
| `systemctl enable/disable` | `sudo launchctl enable/disable system/com.roadmap.dummy` |
| `systemctl status dummy` | `sudo launchctl print system/com.roadmap.dummy` |
| `journalctl -u dummy -f` | `tail -f /var/log/dummy-service.log` |

### Sample output

```
$ ./svc.sh status
● dummy.service - Dummy background service (roadmap.sh project 09)
     Loaded: loaded (/etc/systemd/system/dummy.service; enabled; preset: enabled)
     Active: active (running) since Sat 2026-10-24 14:06:06 UTC; 12s ago
   Main PID: 149 (bash)
dummy[149]: 2026-10-24 14:06:06 [pid 149] Dummy service is running... (heartbeat #1)
dummy[149]: 2026-10-24 14:06:16 [pid 149] Dummy service is running... (heartbeat #2)
```

### Tested cases

Tested under real **systemd** (Ubuntu 24.04 with systemd as PID 1, in a privileged container):

| Check | Result |
|---|---|
| `systemd-analyze verify dummy.service` | Clean. It caught `StartLimit*` placed in the wrong section, now fixed. |
| `./svc.sh install` | Enabled + active; heartbeats in the log file **and** the journal |
| `kill -9` the process | systemd restarted it 5 s later with a new PID (`NRestarts=1`) |
| `stop` | Inactive; log shows `Received stop signal, shutting down.` |
| `disable` / `enable` | Boot symlink removed / recreated |
| `start`, `restart` | Active |
| `uninstall` | Unit and binary removed, `Unit dummy.service could not be found` |
| `dummy.sh` alone | Logs every interval, exits 0 on SIGTERM |
| plist | Valid property list; `shellcheck` clean on both scripts |

The macOS launchd path wasn't run here; try `./svc.sh install && ./svc.sh status` once on your Mac.

## 📝 Notes & lessons learned

- **`daemon-reload` after every unit file change,** or systemd keeps using the old version.
- **`enable` ≠ `start`.** `enable` means "start at boot", `start` means "start now". `enable --now` does both.
- **Put `StartLimitIntervalSec`/`StartLimitBurst` in `[Unit]`.** In `[Service]` systemd just logs a warning and ignores them, so a crash-looping service would restart forever. `systemd-analyze verify` catches this.
- **Write logs to stdout too.** systemd sends stdout to the journal, so `journalctl -u dummy` works with no extra setup and gets timestamps, filtering and rotation for free.
- **Handle SIGTERM.** `systemctl stop` sends SIGTERM. Using `sleep & wait` instead of a plain `sleep` lets the script react immediately instead of after up to 10 s.
- **On macOS, `stop` = `bootout`.** With `KeepAlive`, launchd immediately restarts a killed job, so stopping means unloading it.
- **Containers usually have no systemd.** `svc.sh` checks for `/run/systemd/system` and says so instead of failing strangely.
