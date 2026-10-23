# Log Archive Tool

> **Level:** Beginner · **Topic:** CLI · **Status:** ✅ Done<br>
> **Brief:** [roadmap.sh/projects/log-archive-tool](https://roadmap.sh/projects/log-archive-tool)

## 🎯 Goal
Build a CLI tool that compresses a log directory into a dated archive, keeping the system clean while old logs stay available. On Unix systems logs usually live in `/var/log`.

## 📋 Requirements
- [x] Usage: `log-archive <log-directory>`
- [x] Compress the logs into a `tar.gz` file stored in a new archive directory
- [x] Name archives with a timestamp, e.g. `logs_archive_20240816_100648.tar.gz`
- [x] Record the date and time of every archive run in a log file

## 🌟 Stretch goals
- [ ] Email the user when an archive is created
- [x] Ship archives to a remote server or cloud storage
- [x] Run it on a schedule (cron)

## 🎓 What you'll learn
- Working with files and directories from the shell
- Building a small, reusable CLI tool
- Using `tar` for compression

---

## 🧰 Stack

- Bash (works on Linux and on macOS's default Bash 3.2)
- `tar` + gzip for compression, `date` for timestamps, `getopts` for options
- `rsync` for the optional remote copy, `cron` for scheduling

## 🚀 How to run

```bash
chmod +x log-archive

# archive /var/log (sudo so root-only logs are included)
sudo ./log-archive /var/log
# -> Archived /var/log (35M) -> /home/you/projects/log-archives/logs_archive_20261023_195301.tar.gz (2.1M)
```

Archives are saved in a `log-archives/` folder **inside the directory you run the command from**. Use `-d` (or `$LOG_ARCHIVE_DIR`) to choose another place:

```bash
sudo ./log-archive -d /var/log-archives /var/log
```

**Options**

| Option | What it does | Default |
|---|---|---|
| `-d <dir>` | Where to store archives | `./log-archives` in the current directory (or `$LOG_ARCHIVE_DIR`) |
| `-k <n>` | Keep only the newest *n* archives | keep all |
| `-r <target>` | Also copy to a server with rsync, e.g. `user@host:/backups/` | off |
| `-h` | Show help | |

**Install it as a real command**, so you can type `log-archive` from anywhere:

```bash
sudo cp log-archive /usr/local/bin/
log-archive -h
```

**Run it automatically every night at 2am** (`sudo crontab -e`):

```cron
0 2 * * * /usr/local/bin/log-archive -d /var/log-archives -k 14 /var/log
```

This keeps two weeks of archives, and older ones are deleted automatically. Always pass `-d` in cron: cron jobs start in the user's home directory, so without it the archives would land in `~/log-archives` (or `/root/log-archives` for root).

### What you get

```
./log-archives/
├── archive_log.txt
├── logs_archive_20261023_195257.tar.gz
└── logs_archive_20261023_195258.tar.gz
```

`archive_log.txt` is the history of every run:

```
2026-10-23 19:52:57 | /var/log (35M) -> logs_archive_20261023_195257.tar.gz (2.1M)
2026-10-23 19:52:58 | removed logs_archive_20261023_195255.tar.gz (keep=2)
```

To look inside or restore an archive:

```bash
tar -tzf logs_archive_20261023_195257.tar.gz          # list files
tar -xzf logs_archive_20261023_195257.tar.gz -C /tmp  # extract to /tmp
```

### Tested cases

| Case | Result |
|---|---|
| Normal folder (with a trailing `/`) | Archive created, 260K → 12K |
| No argument / `-h` | Prints usage |
| Folder doesn't exist | `Error: '/nope' is not a directory`, exit 1 |
| Archive dir inside the log dir | Refused, so it never archives its own archives |
| `-k 2` after 4 runs | Only the newest 2 kept; removals written to the history |
| A file it can't read | Warning shown, the rest still archived |
| `-k x` | `Error: -k needs a number greater than 0` |

## 📝 Notes & lessons learned

- **`tar -C` keeps the paths inside the archive clean.** `tar -czf out.tar.gz /var/log` stores full paths (`var/log/syslog`). `tar -C /var log` stores `log/syslog`, which is easier to extract anywhere.
- **Timestamp format matters.** `YYYYMMDD_HHMMSS` makes the names sort in date order, so "oldest first" is just `sort`, and it's how `-k` works out what to delete.
- **Never put archives inside the folder you archive,** or every run includes all the previous archives and grows forever. The script refuses to do that. Because the default is `./log-archives`, running it from inside `/var/log` triggers this check, so run it from another folder or pass `-d`.
- **`tar`'s exit codes mean different things.** 1 = some files changed while being read. 2 = fatal, e.g. permission denied. Without `sudo`, `/var/log` has root-only files, so the script warns but keeps the partial archive instead of failing.
- **Logs compress very well.** Repetitive text shrinks by around 95%: a 260K folder became 12K.
- **`head -n -N` is GNU-only** and breaks on macOS. Counting files and using `head -n $((total - keep))` works on both.
