# Nginx Log Analyser

> **Level:** Beginner · **Topic:** CLI · **Status:** ⬜ Not started<br>
> **Brief:** [roadmap.sh/projects/nginx-log-analyser](https://roadmap.sh/projects/nginx-log-analyser)

## 🎯 Goal
Write a shell script that parses an nginx access log (sample log linked from the brief) and reports the most common values. Each log line has the IP, timestamp, method and path, status code, response size, referrer and user agent.

## 📋 Requirements
- [ ] Top 5 IP addresses by number of requests
- [ ] Top 5 most requested paths
- [ ] Top 5 response status codes
- [ ] Top 5 user agents
- [ ] Print each section with a heading and lines like `<value> - <N> requests`

**Expected output format:**

```
Top 5 IP addresses with the most requests:
45.76.135.253 - 1000 requests
...

Top 5 most requested paths:
/api/v1/users - 1000 requests
...
```

## 🌟 Stretch goals
- [ ] Solve it more than one way, e.g. with `grep` + `sed` instead of `awk`

## 🎓 What you'll learn
- Text processing with `awk`, `sort`, `uniq`, `head`, `grep`, `sed`
- Turning raw logs into useful insight

---

## 🧰 Stack
- 

## 🚀 How to run
```bash
# steps to reproduce
```

## 📝 Notes & lessons learned
- 
