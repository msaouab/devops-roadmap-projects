# Automated DB Backups

> **Level:** Intermediate · **Topic:** Backups · **Status:** ⬜ Not started<br>
> **Brief:** [roadmap.sh/projects/automated-backups](https://roadmap.sh/projects/automated-backups)

## 🎯 Goal
Back up a database every 12 hours and upload the archive to Cloudflare R2 (free tier).

## 📋 Requirements
- [ ] A server running MongoDB with some seed data (or reuse project 22)
- [ ] Schedule every 12 h, via cron on the server or a scheduled GitHub Actions workflow
- [ ] Each run: dump the DB (`mongodump`), compress to a tarball, upload to an R2 bucket (AWS CLI with a custom R2 endpoint, since R2 is S3-compatible)

## 🌟 Stretch goals
- [ ] Script that downloads the latest backup from R2 and restores it

## 🎓 What you'll learn
- Scheduled backup workflows
- Restoring from backups and why disaster recovery matters

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
