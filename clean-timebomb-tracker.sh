#!/bin/zsh
# clean-timebomb-tracker.sh
# Removes entries from tracker.json if the file/folder no longer exists

TRACKER_DIR="$HOME/.timebomb"
JSON_FILE="$TRACKER_DIR/tracker.json"
TMP_FILE="$JSON_FILE.tmp"
LOG_FILE="$TRACKER_DIR/log.txt"

# Ensure tracker.json exists and is valid
if ! [ -s "$JSON_FILE" ] || ! jq empty "$JSON_FILE" >/dev/null 2>&1; then
  echo '[]' > "$JSON_FILE"
fi

# Start logging
exec >> "$LOG_FILE" 2>&1
echo "[$(date)] 🧹 Cleaning tracker.json of non-existent files/folders"

JQ_PATH="$(command -v jq)"
if [[ -z "$JQ_PATH" ]]; then
  echo "❌ jq not found. Please install with: brew install jq"
  exit 1
fi


# Safely filter out non-existent files/folders (handles spaces/newlines)
EXISTING_ENTRIES=""
jq -c '.[]' "$JSON_FILE" | while read -r row; do
  path=$(echo "$row" | jq -r '.path')
  [[ "$path" == ~* ]] && path="$HOME${path:1}"
  if [ -e "$path" ]; then
    EXISTING_ENTRIES="${EXISTING_ENTRIES}${row}\n"
  else
    echo "🗑 Removing tracker entry for missing: $path"
  fi
done

# Write filtered entries back to tracker.json
printf '%s' "$EXISTING_ENTRIES" | jq -s '.' > "$TMP_FILE"
if [ -s "$TMP_FILE" ] && jq empty "$TMP_FILE" >/dev/null 2>&1; then
  mv "$TMP_FILE" "$JSON_FILE"
  echo "✅ tracker.json cleaned."
else
  echo "⚠️ Failed to clean tracker.json."
  rm -f "$TMP_FILE"
fi
