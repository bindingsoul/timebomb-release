```markdown
# 🧨 Timebomb — Auto-Delete Files After Set Duration (macOS)

**Timebomb** lets you right-click any file or folder on macOS and schedule it for automatic deletion in:
- 5 minutes
- 1 day
- 7 days
- 1 month
- 6 months
- 1 year.

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
### How Timebomb Stacks Up
| Feature              | Self-Destruct | autoExpire | Hazel | Timebomb |
|----------------------|:-------------:|:----------:|:-----:|:--------:|
| Right-click install  | ✅            | ❌         | ❌    | ✅       |
| Free/Open-source     | ✅            | ❌         | ❌    | ✅       |
| Time-based delete    | ✅            | ✅         | ✅    | ✅       |
| GUI setup            | CLI/tagging   | GUI        | GUI + rules | Quick Actions |


## 📁 What's Included

```
timebomb/
├── workflows/           # Automator workflows (right-click delete options)
│   ├── dlt-1-day.workflow
│   ├── dlt-7-day.workflow
│   ├── dlt-1-mnth.workflow
│   ├── dlt-6-mnth.workflow
│   ├── dlt-1-year.workflow
│   └── Timebomb-Delete-in-5-Minutes.workflow
├── cleaner.sh           # Script that deletes expired files
├── timebomb.sh          # One-click installer
├── README.md            # You're reading this
└── LICENSE              # MIT License
```

---

## ⚙️ Installation

### 🧾 Step 1: Clone the Repo

```bash
git clone https://github.com/your-username/timebomb.git
cd timebomb
```

### 💣 Step 2: Run the Installer

```bash
chmod +x timebomb.sh
./timebomb.sh
```

---

## 🧽 How to Use

1. Right-click **any file or folder** in Finder  
2. Hover over **Quick Actions**  
3. Select a timebomb option:
   - Delete in 5 Minutes
   - Delete in 1 Day
   - Delete in 7 Days
   - Delete in 1 Month
   - Delete in 6 Months
   - Delete in 1 Year

Once selected, Timebomb schedules the file for auto-deletion.  
Expired files will be removed the next time you run the cleaner.

---

## 🔁 How to Delete Expired Files

### Manual:

```bash
bash ~/.timebomb/cleaner.sh
```

### Optional Automation:

Coming soon — launch agent setup to automatically clean every 10 minutes.

---

## 🧠 Code Explained

### 🧨 Workflow Scripts (`.workflow`)

Each Automator Quick Action runs a `zsh` script:

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

✅ What it does:
- Gets the future deletion time
- Appends the file path + deletion time to a tracker JSON file at `~/.timebomb/tracker.json`
- Works even if multiple files are selected

---

### 🧹 Cleaner Script (`cleaner.sh`)

This reads the tracker and deletes expired files:

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

# Clean up tracker file to keep only non-expired items
jq --argjson now "$NOW" '[.[] | select(.delete_epoch > $now)]' "$JSON_FILE" > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"
```

✅ What it does:
- Deletes files whose time has expired
- Cleans up the tracker
- Keeps everything modular and fast

---

## 📦 Requirements

- macOS (tested on macOS Sonoma)
- `jq` installed → install with:

```bash
brew install jq
```

---

## 🛣️ Roadmap

- [ ] Launch Agent to auto-run `cleaner.sh`
- [ ] Menu bar mini-app for timebomb control
- [ ] Drag & drop GUI for custom duration
- [ ] Usage stats: how many files deleted, space saved
- [ ] Easy uninstall script

---

## 🪪 License

MIT © 2025 — Do what you want, but give credit. And don’t sue.

---

## 👨‍💻 Author

Built with chai, code, and chaos by [@bindingsoul](https://github.com/bindingsoul)
```
