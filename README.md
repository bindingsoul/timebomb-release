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
   - Delete in 1 Day
   - Delete in 7 Days
   - Delete in 1 Month
   - etc.

Once selected, Timebomb schedules the file for auto-deletion.  
Expired files will be removed the next time you run the cleaner.

---

## 🔁 How to Delete Expired Files

### Manual:

```bash
~/.timebomb/cleaner.sh
```

### Optional Automation:

Coming soon — launch agent setup to automatically clean every 10 minutes.

---

## 🔍 How It Works

### Step 1: Timebomb Workflow Scripts

Each `.workflow` file runs a `zsh` script like:

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

This stores file paths and their future deletion timestamps in `tracker.json`.

---

### Step 2: cleaner.sh

Periodically reads `tracker.json`, and deletes expired files:

```zsh
now=$(date +%s)
jq -c '.[]' "$JSON_FILE" | while read -r entry; do
  path=$(echo "$entry" | jq -r '.path')
  expire=$(echo "$entry" | jq -r '.delete_epoch')
  if [[ $expire -le $now ]]; then
    rm -rf "$path" && echo "🗑 Deleted: $path"
  fi
done
```

---

## 📦 Requirements

- macOS (tested on latest Sonoma)
- `jq` installed (`brew install jq`)

---

## 🛣️ Roadmap

- [ ] One-click Launch Agent installer to auto-run cleaner
- [ ] GUI front-end (menu bar app)
- [ ] Custom time duration input
- [ ] Stats: how many files deleted, when, space saved
- [ ] Uninstall script

---

## 🪪 License

MIT © 2025
```

