# Nginx Log Analyser

> **Level:** Beginner · **Topic:** CLI · **Status:** ✅ Done<br>
> **Brief:** [roadmap.sh/projects/nginx-log-analyser](https://roadmap.sh/projects/nginx-log-analyser)

## 🎯 Goal
Write a shell script that parses an nginx access log (sample log linked from the brief) and reports the most common values. Each log line has the IP, timestamp, method and path, status code, response size, referrer and user agent.

## 📋 Requirements
- [x] Top 5 IP addresses by number of requests
- [x] Top 5 most requested paths
- [x] Top 5 response status codes
- [x] Top 5 user agents
- [x] Print each section with a heading and lines like `<value> - <N> requests`

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
- [x] Solve it more than one way, e.g. with `grep` + `sed` instead of `awk`

## 🎓 What you'll learn
- Text processing with `awk`, `sort`, `uniq`, `head`, `grep`, `sed`
- Turning raw logs into useful insight

---

## 🧰 Stack

- Bash + standard Unix text tools: `awk`, `grep`, `sed`, `cut`, `sort`, `uniq`, `head`
- Tested with GNU awk and mawk on Linux. Uses only POSIX features, so it also runs with macOS's BSD awk/sed/grep.

## 📁 Files

| File | What it is |
|---|---|
| `nginx-log-analyser.sh` | The analyser (awk and grep+sed modes) |
| `sample/access.log` | 500-line test log in nginx *combined* format |

## 🚀 How to run

```bash
chmod +x nginx-log-analyser.sh

./nginx-log-analyser.sh sample/access.log          # awk version (default)
./nginx-log-analyser.sh -m sed sample/access.log   # grep + sed version (stretch goal)
./nginx-log-analyser.sh -n 10 /var/log/nginx/access.log   # top 10 from a real server
```

To use the official sample log from the brief, download it from the project page and pass its path instead.

### Sample output

```
Top 5 IP addresses with the most requests:
45.76.135.253 - 152 requests
142.93.143.8 - 92 requests
178.128.94.113 - 63 requests
43.224.43.187 - 51 requests
185.220.101.5 - 34 requests

Top 5 most requested paths:
/api/v1/users - 174 requests
/v1-health - 89 requests
...

Top 5 response status codes:
200 - 342 requests
404 - 66 requests
...

Top 5 user agents:
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ... Chrome/129.0 Safari/537.36 - 181 requests
...
```

## 🔍 How it works

Every report is the same pipeline: pull one field out of each line, then count it.

```bash
<extract field> | sort | uniq -c | sort -rn | head -n 5
```

| Step | Does |
|---|---|
| extract | prints one value per log line (an IP, a path…) |
| `sort` | puts identical values next to each other |
| `uniq -c` | counts each group: `152 45.76.135.253` |
| `sort -rn` | biggest count first |
| `head -n 5` | keep the top 5 |
| `sed` | reformat to `45.76.135.253 - 152 requests` |

**Splitting on `"` is the key trick.** User agents contain spaces, so "take word #12" doesn't work. Split the line on double quotes instead:

```
45.76.135.253 - - [04/Oct/2024:00:00:08 +0000] "GET /api/v1/users HTTP/1.1" 200 1143 "-" "curl/8.4.0"
└──────────────── $1 ────────────────────────┘ └─────────── $2 ──────────┘ └ $3 ┘ $4    └── $6 ──┘
```

| Field | awk | grep + sed |
|---|---|---|
| IP | `awk '{print $1}'` | `cut -d' ' -f1` |
| Path | `awk -F'"' '{split($2,r," "); print r[2]}'` | `sed -E 's/^[^"]*"[A-Z]+ ([^ ]+) .*/\1/'` |
| Status | `awk -F'"' '{split($3,s," "); print s[1]}'` | `sed -nE 's/^[^"]*"[^"]*" ([0-9]{3}) .*/\1/p'` |
| User agent | `awk -F'"' '{print $6}'` | `sed -nE 's/.*"([^"]*)"[[:space:]]*$/\1/p'` |

### Tested cases

| Case | Result |
|---|---|
| Sample log, awk vs grep+sed | Identical output |
| GNU awk vs mawk | Identical output |
| Empty log | `Log file is empty.` |
| No argument / `-h` | Prints usage, exit 1 / 0 |
| Missing file | `Error: '/nope' is not a file` |
| `-m perl` | `Error: -m must be 'awk' or 'sed'` |
| `-n 2` | Top 2 per section |
| `shellcheck` | No warnings |

## 📝 Notes & lessons learned

- **`sort | uniq -c | sort -rn | head` is the classic "top N" recipe.** `uniq` only merges *adjacent* duplicates, which is why the first `sort` is needed.
- **Pick the right field separator.** Splitting on spaces breaks on user agents. Splitting on `"` makes every field easy to grab.
- **Portability:** `sed -E` (extended regex) works on both GNU and BSD sed; avoid GNU-only flags like `sed -r` or `grep -P`.
- **`-` means "unknown" in nginx logs** (e.g. no referrer or user agent). The script filters those out so they don't show up as a top value.
- **Real-world use:** this is how you spot a bot hammering your API (one IP way ahead), broken links (many `404`s on one path) or an outage (`500`s spiking).
