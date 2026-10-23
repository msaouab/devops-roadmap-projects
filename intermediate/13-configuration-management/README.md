# Configuration Management

> **Level:** Intermediate · **Topic:** Ansible · **Status:** ⬜ Not started<br>
> **Brief:** [roadmap.sh/projects/configuration-management](https://roadmap.sh/projects/configuration-management)

## 🎯 Goal
Write an Ansible playbook that configures a Linux server end to end.

## 📋 Requirements
- [ ] `setup.yml`: the main playbook
- [ ] `inventory.ini`: the target server
- [ ] Role `base`: update the server, install utilities and `fail2ban`
- [ ] Role `nginx`: install and configure nginx
- [ ] Role `app`: upload a tarball of a static site and extract it
- [ ] Role `ssh`: add a given public key to the server
- [ ] Roles run in order, and each role has a tag so it can run alone

```
ansible-playbook setup.yml              # run all roles
ansible-playbook setup.yml --tags "app"  # run only the app role
```

## 🌟 Stretch goals
- [ ] Have the `app` role pull the site from a GitHub repo instead of a tarball

## 🎓 What you'll learn
- How Ansible playbooks, inventories, roles and tags work
- Managing server configuration as code

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
