# File Integrity Checker

> **Level:** Intermediate · **Topic:** Security · **Status:** ⬜ Not started<br>
> **Brief:** [roadmap.sh/projects/file-integrity-checker](https://roadmap.sh/projects/file-integrity-checker)

## 🎯 Goal
Build a CLI that detects tampering in log files by comparing cryptographic hashes.

## 📋 Requirements
- [ ] Accept a directory or a single log file
- [ ] Compute a hash (e.g. SHA-256) for each file
- [ ] On first run, store the hashes somewhere secure
- [ ] On later runs, compare current hashes with the stored ones
- [ ] Clearly report mismatches as possible tampering
- [ ] Allow manually re-initializing a file's baseline

```
./integrity-check init /var/log          # Hashes stored successfully.
./integrity-check check /var/log/syslog  # Status: Modified (Hash mismatch)
./integrity-check check /var/log/auth.log # Status: Unmodified
./integrity-check update /var/log/syslog # Hash updated successfully.
```

## 🌟 Stretch goals
- [ ] List exactly which files had mismatched hashes

## 🎓 What you'll learn
- Hashing algorithms
- File integrity monitoring and security concepts

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
