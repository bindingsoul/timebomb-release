# 🧨 Timebomb — Auto-Delete Files After Set Duration (macOS)

**Timebomb** lets you right-click any file or folder on macOS and schedule it for automatic deletion in:
- 5 minutes
- 1 day
- 7 days
- 1 month
- 6 months
- 1 year

No more clutter from temporary files! 🧹

---

## 💡 Problem

While working on projects, we often download or create temporary files that are only needed for a short while. These files:
- Stay forgotten in Downloads or scattered folders
- Eat up disk space
- Reduce productivity due to digital clutter

---

## ✅ Solution

Timebomb attaches a **self-destruction timer** to any file/folder via right-click **Quick Actions** in Finder.  
Once the timer expires, the file is deleted *automatically* — no need for manual cleanup.

---

### 🔍 How Timebomb Stacks Up

| Feature              | Self-Destruct | autoExpire | Hazel | Timebomb |
|----------------------|:-------------:|:----------:|:-----:|:--------:|
| Right-click install  | ✅            | ❌         | ❌    | ✅       |
| Free/Open-source     | ✅            | ❌         | ❌    | ✅       |
| Time-based delete    | ✅            | ✅         | ✅    | ✅       |
| GUI setup            | CLI/tagging   | GUI        | GUI + rules | Quick Actions |

---

## 📁 What's Included

```
timebomb-release/
├── workflows/                 # Automator workflows (right-click delete options)
│   ├── dlt-1-day.workflow
│   ├── dlt-7-day.workflow
│   ├── dlt-1-mnth.workflow
│   ├── dlt-6-mnth.workflow
│   ├── dlt-1-year.workflow
│   └── Timebomb-Delete-in-5-Minutes.workflow
├── cleaner-epoch.sh                 # Script that deletes expired files
├── install-timebomb.sh       # One-click installer
├── README.md                  # You're reading this
└── LICENSE                    # MIT License
```

---

## ⚙️ Installation
### Step 0: Create a snapshot
for mac before executing any new scripts make it a habit to have a snapshot. 
Note: Snapshot are auto deleted my macOS after 24 hours, to manage space. Thus if on your system this scripts clash with your other user built scripts, you could simply go back to the snapshot. Below command create a local snapshot on mac.
```bash
tmutil localsnapshot
```

### 🧾 Step 1: Clone the Repo

```bash
git clone https://github.com/bindingsoul/timebomb-release.git
cd timebomb-release
```

### 💣 Step 2: Run the Installer

```bash
chmod +x install-timebomb.sh
./install-timebomb.sh
```

This will:
- Copy all workflows to `~/Library/Services` (so they appear in Finder's right-click menu)
- Create the `~/.timebomb` directory and add the tracking file
- Ensure the cleaner script is set up

---

## 🧽 How to Use

1. **Right-click any file or folder** in Finder  
2. Hover over **Quick Actions**  
3. Select one of the options:
   - Delete in 5 Minutes
   - Delete in 1 Day
   - Delete in 7 Days
   - Delete in 1 Month
   - Delete in 6 Months
   - Delete in 1 Year

⏳ Timebomb will now schedule the file/folder for automatic deletion.

---

## 🧹 How to Clean Expired Files

### Manual method

Just run the cleaner script:

```bash
~/.timebomb/cleaner-epoch.sh
```

This will remove all files whose deletion time has passed.

---

## 🧠 Code Explained

### 🧨 Workflow Scripts (`*.workflow`)

Each Automator Quick Action wraps a `zsh` script like this:

```zsh
DELETE_EPOCH=$(date -v+7d +%s)
JSON_FILE="$HOME/.timebomb/tracker.json"
mkdir -p "$HOME/.timebomb"

for f in "$@"; do
  jq --arg f "$f" --argjson e "$DELETE_EPOCH" \
    'if . == [] then [{"path": $f, "delete_epoch": $e}] else . + [{"path": $f, "delete_epoch": $e}] end' \
    "$JSON_FILE" 2>/dev/null > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"
done
```

✅ This:
- Converts chosen time to epoch format
- Records file paths with deletion time in `tracker.json`
- Allows multiple file selection at once

---

### 🧼 cleaner-epoch.sh

This is the engine that runs cleanup:

```zsh
#!/bin/zsh

JSON_FILE="$HOME/.timebomb/tracker.json"
NOW=$(date +%s)

mkdir -p "$HOME/.timebomb"
[ ! -f "$JSON_FILE" ] && echo "[]" > "$JSON_FILE"

jq -c '.[]' "$JSON_FILE" | while read -r entry; do
  path=$(echo "$entry" | jq -r '.path')
  expiry=$(echo "$entry" | jq -r '.delete_epoch')

  if [[ "$NOW" -ge "$expiry" ]]; then
    echo "🧹 Deleting expired: $path"
    rm -rf "$path"
  fi
done

# Keep only non-expired entries
jq --argjson now "$NOW" '[.[] | select(.delete_epoch > $now)]' "$JSON_FILE" > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"
```

✅ It:
- Reads all scheduled paths
- Checks whether each has expired
- Deletes expired ones and updates `tracker.json`

---

## 📦 Requirements

- macOS (tested on macOS Sonoma)
- [`jq`](https://stedolan.github.io/jq/) — lightweight JSON processor  
Install it using:

```bash
brew install jq
```

---

## 🛣️ Roadmap

- [ ] Add LaunchAgent to run `cleaner-epoch.sh` automatically every few minutes
- [ ] Create menu bar app for GUI control
- [ ] Add support for custom time durations
- [ ] Track total number of deletions and space saved
- [ ] Add uninstall script

---

## 🪪 License

MIT © 2025 — Free to use, modify, distribute. Give credit where due.

---

## 👨‍💻 Author

Crafted with ☕️, 🧠, and 💣 by [@bindingsoul](https://github.com/bindingsoul)
