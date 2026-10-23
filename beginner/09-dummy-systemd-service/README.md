# Dummy Systemd Service

> **Level:** Beginner · **Topic:** Systemd · **Status:** ⬜ Not started<br>
> **Brief:** [roadmap.sh/projects/dummy-systemd-service](https://roadmap.sh/projects/dummy-systemd-service)

## 🎯 Goal
Create, enable and manage a custom systemd service, and read its logs.

## 📋 Requirements
- [ ] Write `dummy.sh`: loops forever, appending a message to `/var/log/dummy-service.log` every 10 seconds
- [ ] Write `dummy.service`: runs the script in the background, starts on boot, restarts on failure
- [ ] Manage it with `systemctl start | stop | enable | disable | status dummy`
- [ ] Follow its logs with `journalctl -u dummy -f`

## 🎓 What you'll learn
- Writing systemd unit files
- Managing services with `systemctl`
- Debugging with `journalctl`

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
