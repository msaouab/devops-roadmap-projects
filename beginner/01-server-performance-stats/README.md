# Server Performance Stats

> **Level:** Beginner · **Topic:** CLI · **Status:** ✅ Done  
>
> **Brief:** [roadmap.sh/projects/server-stats](https://roadmap.sh/projects/server-stats)

## 🎯 Goal

Write a `server-stats.sh` script that runs on any Linux server and prints a quick health snapshot, the kind of thing you'd check first when debugging a slow box.

## 📋 Requirements

- [x] Total CPU usage
- [x] Total memory usage: used vs. free, with percentages
- [x] Total disk usage: used vs. free, with percentages
- [x] Top 5 processes by CPU usage
- [x] Top 5 processes by memory usage

## 🌟 Stretch goals

- [x] OS version, uptime and load average
- [x] Logged-in users
- [x] Failed login attempts

## 🎓 What you'll learn

- Reading CPU, memory, disk and process data from the shell
- Using server stats to debug performance problems

---

## 🧰 Stack

- Bash (works with macOS's default Bash 3.2)
- Linux: `/proc/stat`, `/proc/meminfo`, `/proc/uptime`, `/etc/os-release`, `df`, `ps`
- macOS: `top`, `vm_stat`, `sysctl`, `sw_vers`, `df`, `ps`

## 🚀 How to run

```bash
chmod +x server-stats.sh
./server-stats.sh
sudo ./server-stats.sh   # also counts failed SSH logins on Linux
```

Run it on a remote server without copying it over:

```bash
ssh user@server 'bash -s' < server-stats.sh
```

### Sample output (Ubuntu 22.04)

```
=== CPU ===
Total usage:   24.9% (idle 75.1%)

=== Memory ===
Total:         3906 MB
Used:          266 MB (6.8%)
Free:          3640 MB (93.2%)

=== Disk ===
Mount:         /
Total:         9.5 GB
Used:          4.7 GB (49.7%)
Free:          4.8 GB (50.3%)
```

## 📝 Notes & lessons learned

- **The first CPU reading from `top` is misleading.** It averages usage since boot. The script reads `/proc/stat` twice, 1 second apart, and computes `100 - idle` from the difference. On macOS it uses the second sample from `top -l 2`.
- **"Free" memory should mean available memory.** Linux keeps unused RAM as cache, so `MemAvailable` is the right number, not `MemFree`. On macOS, available memory is free + inactive + speculative pages from `vm_stat`.
- **Check the right disk on macOS.** On APFS the system volume `/` is sealed and read-only, and user data lives on `/System/Volumes/Data`. That's the volume to check.
- **`top`'s `Disks:` line is the wrong metric.** It shows disk read/write activity, not space used. `df -kP` gives portable numbers that are easy to parse.
- **`ps` sorts differently per OS.** GNU `ps` uses `--sort=-pcpu`, while BSD/macOS `ps` uses `-r` (CPU) and `-m` (memory).
